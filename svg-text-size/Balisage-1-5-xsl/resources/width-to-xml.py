# https://stackoverflow.com/questions/4190667/how-to-get-width-of-a-truetype-font-character-in-1200ths-of-an-inch-with-python
# https://fonttools.readthedocs.io/en/latest/index.html
# https://www.geeksforgeeks.org/create-xml-documents-using-python/
from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._c_m_a_p import CmapSubtable
from xml.dom import minidom

# from StackOverflow
font = TTFont('/Users/djb/Library/Fonts/RomanCyrillic_Std.ttf')
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

c_dict = dict()
for num_dec in range(65535): # entire BMP; decimal Unicode value
    char = chr(num_dec) # character as string
    c_dict[char]= getTextWidth(char, 16) # default SVG font-size is 16 (medium)

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
