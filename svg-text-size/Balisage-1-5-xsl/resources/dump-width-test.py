from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._c_m_a_p import CmapSubtable

font = TTFont('/Users/djb/Library/Fonts/RomanCyrillic_Std.ttf')
cmap = font['cmap']
t = cmap.getcmap(3,1).cmap
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

text = 'This is a test'

width = getTextWidth(text,12)

print ('Text: "%s"' % text)
print ('Width in points: %f' % width)
print ('Width in inches: %f' % (width/72))
print ('Width in cm: %f' % (width*2.54/72))
print ('Width in WP Units: %f' % (width*1200/72))
print()

c_dict = dict()
for c in range(64000):
    c_dict[chr(c)] = getTextWidth(chr(c), 12)
for index, item in enumerate(c_dict.items()):
    char = item[0]
    num_dec = ord(char)
    num_hex = hex(num_dec)
    width = item[1]
    if num_dec in t:
        name = t[num_dec]
        print(f"Width of {char} ({num_dec}, {num_hex}, {name}) is {width} points")

