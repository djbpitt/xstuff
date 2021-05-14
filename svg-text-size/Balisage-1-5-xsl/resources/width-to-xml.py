#!/usr/bin/env python
# https://stackoverflow.com/questions/4190667/how-to-get-width-of-a-truetype-font-character-in-1200ths-of-an-inch-with-python
# https://fonttools.readthedocs.io/en/latest/index.html
# https://www.geeksforgeeks.org/create-xml-documents-using-python/
# https://stackoverflow.com/questions/678236/how-to-get-the-filename-without-the-extension-from-a-path-in-python
from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._c_m_a_p import CmapSubtable
from xml.dom import minidom
from matplotlib import font_manager
from pathlib import Path
import pprint
pp = pprint.PrettyPrinter(indent=2)


# TODO: be flexible about .ttf filename extension
# Validate fontname
# https://stackoverflow.com/questions/15203829/python-argparse-file-extension-checking
def validateFont(fontName):
    installed_fonts = {Path(item).stem: item for item in font_manager.findSystemFonts()}
    return installed_fonts.get(fontName) # returns None on KeyError

def allInstalledFonts():
    installed_fonts = {Path(item).stem: item for item in font_manager.findSystemFonts()}
    return sorted(installed_fonts.keys())


import argparse
parser = argparse.ArgumentParser()
parser.add_argument("ttf", help="TrueType font name without extension (quote names with spaces)")
parser.add_argument("size", help="size in points (defaults to 16pt)", type=int, nargs="?", default=16)
args = parser.parse_args()
fontName = args.ttf
size = args.size
fontPath = validateFont(fontName)

if not fontPath: # bail out if font not found
    print(f"Font '{fontName}' not found. Legal fontnames are:")
    pp.pprint(allInstalledFonts())
    quit()

font = TTFont(fontPath, fontNumber=0) # breaks on ttc, even with fontNumber; table is different?
cmap = font['cmap']
t = cmap.getcmap(3,1).cmap # map of decimal values to glyph names
s = font.getGlyphSet()
units_per_em = font['head'].unitsPerEm

def getTextWidth(text,pointSize):
    total = 0
    for c in text:
        if ord(c) in t and t[ord(c)] in s:
            total += s[t[ord(c)]].width
        else:
            total += s['.notdef'].width
    total = total*float(pointSize)/units_per_em;
    return total

# from minidom documentation
root = minidom.Document()
xml = root.createElement('root')
root.appendChild(xml)
metadata = root.createElement('metadata')
metadata.setAttribute('fontName', fontName)
metadata.setAttribute('fontPath', fontPath)
xml.appendChild(metadata)

c_dict = dict()
for num_dec in range(65535): # entire BMP; decimal Unicode value
    char = chr(num_dec) # character as string
    c_dict[char]= getTextWidth(char, size) # default SVG font-size is 16 (medium)

for item in c_dict.items(): # string-value : width
    char = item[0] # string value of character
    num_dec = ord(char) # Unicode value (decimal)
    num_hex = hex(num_dec) # Unicode value (hex)
    width = item[1] # glyph width
    if num_dec in t: # not all values are present in font
        name = t[num_dec] # look up name by decimal value
        e = root.createElement('character')
        e.setAttribute('str', str(char)) # attribute have to be set as strings
        e.setAttribute('dec', str(num_dec))
        e.setAttribute('hex', str(num_hex))
        e.setAttribute('width', str(width))
        e.setAttribute('name', name)
        xml.appendChild(e)

xml_str = root.toprettyxml(indent="  ")
print(xml_str)
