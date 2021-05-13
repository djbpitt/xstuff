# SVG text dimensions

## Pre-abstract

A longstanding challenge with SVG rendering is that although it's easy to know the size (bounding box height and width) of many objects (rectangles, circles, lines) it's challenging for text because text doesn't know its own size. Developers can specify a font-size, but the length of string of character text depends on the widths of the individual characters, and those width are not exposed in any convenient, accessible way. This means that, for example, if we label the bars on a bar graph along the X axis with text that we choose to render from top to bottom, we cannot know that length of the longest such label and therefore cannot position anything below it (such as a general label for the X axis) with precision. If you are like me, you combine guesswork with trial and error and then hard-code a magic number, which—predicatably—breaks as soon as you try to reuse the code with new input.


This presentation explores two strategies for working around this limitation:

1. Create a mapping between characters and their widths by extracting font metrics, import that mapping into XSLT, and use the mapping to compute the length of text strings. If the text strings are vertical, the length is one of the dimensions of the bounding box. If the text is rotated, we can use the length combined with the angle of rotation to compute the dimensions of the bounding box.
2. Output SVG components that must be stacked vertically as separate <svg> elements with no height specified. These wind up with a default height in the browser which will be wrong. Use CSS Flexbox to stack the <svg> elements vertically, and use the JavaScript element.getBBox() functions to compute the dimensions of the bounding box for each <svg> elements and write the necessary values into those elements in the DOM, effectively assigning a height after loading the SVG, instead of when creating it.

## Notes

1. Python code to compute character width at point size: <https://stackoverflow.com/questions/4190667/how-to-get-width-of-a-truetype-font-character-in-1200ths-of-an-inch-with-python>
1. Default `font-size` value is 16: <http://xahlee.info/js/svg_font_size.html>
1. JavaScript methods:
    1. <https://developer.mozilla.org/en-US/docs/Web/API/Element/getBoundingClientRect>
    1. <https://developer.mozilla.org/en-US/docs/Web/API/SVGGraphicsElement/getBBox>
    1. <https://www.w3.org/Graphics/SVG/IG/resources/svgprimer.html#getBBox>
    1. <https://www.w3.org/Graphics/SVG/IG/resources/svgprimer.html#getCTM>

