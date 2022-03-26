To serialize HTML5 correctly from eXist-db:

```xquery
xquery version "3.1";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xhtml";
declare option output:media-type "application/xhtml+xml";
declare option output:omit-xml-declaration "no";
declare option output:html-version "5.0";
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>Test</title></head>
<body>
    <h1>Test page</h1>
    <p>This is<br/>a test.</p>
</body>
</html>
```