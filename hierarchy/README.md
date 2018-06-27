# Flattening and raising XML hierarchies

David J. Birnbaum (<http://www.obdurodon.org>)

## Abstract

This report describes two different situations where we use XSLT to _flatten_ or _raise_ XML hierarchies. In Case #1 we have overlapping hierarchies, one of which is initially encoded with regular XML start- and end-tags and the other with empty milestone tags. In Case #2, we flatten all markup and then raise it again (completely or selectively); in this case there is no overlap, since the starting point is well-formed XML.

## Terminology

The terms we use in this dicussion are the following:

* *Flatten:* Convert hierarchical XML into a form where the root element contains only `text()` nodes and empty elements, that is, where it contains no elements that themselves have content. We can flatten XML without loss of information by replacing all start- and end-tags with empty elements, as long as we include in those elements information about 1) which were originally start-tags and which were originally end-tags, and 2) which of the new flattened (pseudo-)start-tags should be paired with which of the new flattened (pseudo-)end-tags.
* *Raise:* Reconstruct the original hierarchical XML from the flattened version described above. In practice, we may want to convert some flattened markup to real start- and end-tags, with content, while leaving others flattened. This may be considered *partial raising*.
* *Empty element:* An element that has no content. This is not the same as *milestone* (q.v.). An element may be empty by design (that is, its content may be declared as empty in a schema), or it may be empty by accident (that is, the element type may be permitted to have content, but a particular instance of it happens to be empty).
* *Milestone:* A type of empty element that, like a traditional roadway milestone, simultaneously marks the end of one unit of measurement (a numbered mile on a roadway, a numbered page in a book) and the beginning of the next unit of the same type. The first and last milestones may be special, since no unit precedes the first or follows the last. In the case of TEI `<pb/>` (‘page beginning’), `<lb/>` (‘line beginning’), `<gb/>` (gathering beginning), and `<cb/>` (‘column beginning’), however, there is no final milestone, which is understood to coincide implicitly with the end of the text (cf. [TEI P5, Milestone elements](http://www.tei-c.org/release/doc/tei-p5-doc/en/html/CO.html#CORS5)). Milestones are normally *tesselated* (q.v.).
* *Tesselate:* Fully cover a domain with units of the same type, without gaps or overlap, where the end of one unit serves, seamlessly, as the beginning of the next. See *milestone*.
* *Container:* A _container_ element is a non-empty element, that is, one that wraps start- and end-tags around content. 

## Flattening and raising situations

### Case #1

**TODO: At the moment there is just the description here, with no code.**

Flattening and raising are often used to deal with overlapping tesselated structures. A common use case involves converting between a chapter/paragraph view of a prose text and a page/line view. In this situation it is impossible to tag both the intellectual hierarchy (chapters, paragraphs) and the physical one (pages, lines) with container tags because the two hierarchies may overlap. We typically represent one hierarchy with hierarchical markup (e.g., TEI `<div>` and `<p>` to represent chapters and paragraphs) and flatten the other by using milestone elements (e.g., TEI `<pb/>` and `<lb>` to represent page- and line-beginnings). This is a common use case, and the method described here for dealing with it in XSLT is already well known.

### Case #2

**TODO: Describe (the code is there, but the use case is not). Flattening and selective raising all markup, and different from the use of milestones to represent overlap. Use case might be flattening in order to create well-balanced (not necessarily well-formed) XML fragments for non-XML processing, where XML needs to be reconstructed from the output. For example, CollateX XML processing; use _PVL_ as example. Paired pseudo-start- and end-tags are raised; unpaired ones and other empty elements are not. Mention regex replacement of flattened tags with real ones.**

This is a less common use case, perhaps because it involves transitions between two perspectives on an XML document: 1) as a stream of information to be parsed in order to construct a tree, and 2) as a string of characters that is not to be parsed, where markup and content are not differentiated. This second perspective is useful in types of processing that treat XML as a string because they are not able to parse it and engage with it as a tree, but where the document must nonetheless be parsable as XML both before and after that stage in the processing. For example, we may need to divide what was originally a well-formed XML document into well-balanced (not necessarily well-formed) XML fragments, where empty elements are used to replace logical start- and end-tags that have no matching counterpart in the fragment.

### Differences between Case #1 and Case #2

There are two principal differences between these two cases:

* In Case #1, the original document already contains a combination of container and milestone elements, where the milestones have been used to avoid overlapping markup. In Case #2, the starting point is well-formed XML, which by definition has no overlap. 
* In Case #1, the flattened hierarchy uses empty elements as milestones, which mark simultaneously the end of one unit of a particular the beginning of the next unit of the same type (e.g., a page or a line). In Case #2, empty elements in the flattened view are used not as milestones, but as surrogates for real start- and end-tags, where the end of one unit does not necessarily coincide with the beginning of another unit of the same type.

## Files

* `original.xml`: the original XML test file
* `flatten.xsl`: converts `original.xml` to `flattened.xml` by flattening all elements except the root
* `flattened.xml`: the result of the flattening operation
* `raise.xsl`: converts the flattened markup of `flattened.xml` to `raised.xml`, which has regular hierarchical markup, with container elements
* `raised.xml`: the result of the raising operation

## How it works

### Original input

`original.xml` is a sample XML file with four levels of element hierarchy. At its deepest, `<root>` contains `<p>`, which contains `<phrase>`, which contains `<word>`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<root>
    <p>This is a <word>paragraph</word> that contains some stuff.</p>
    <p>This is another paragraph <phrase><word>that</word>
            <word>contains</word>
            <word>more</word></phrase> stuff.</p>
</root>
```

### Flattening the XML

Generate a flattened version of `original.xml` with:

```bash
saxon -xsl:flatten.xsl -s:original.xml -o:flattened.xml
```

The flattening process involves converting all start-tags and end-tags (except those for the root element) to empty elements with two new attributes:

* `@n` is a unique identifier associated with the original input element. The new empty elements that replace start- and end-tags for the same original input element have the same `@n` value. The raising routine matches the `@n` values in order to pair up the flattened start- and end-tags correctly.
* `@type` has the value `'start'` for original start-tags and `'end'` for original end tags. The raising routine uses the presence or absence of `@type` attributes to tell when all flattened elements have been raised. This means that your XML cannot use a `@type` attribute for any other purpose. (If that’s a concern, you can, of course, modify the XSLT to use an attribute name other than `@type` to control flattening and raising.)

The `flatten.xsl` stylesheet looks as follows:

```xslt
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="no"/>
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:attribute name="n" select="generate-id()"/>
            <xsl:attribute name="type" select="'start'"/>
        </xsl:element>
        <xsl:apply-templates/>
        <xsl:element name="{name()}">
            <xsl:attribute name="n" select="generate-id()"/>
            <xsl:attribute name="type" select="'end'"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
```

We turn off indentation (line 6, `<xsl:output method="xml" indent="no">`) to ensure that flattening and raising do not impose whitespace changes. We let the built-in templates take care of the document node and `text()` nodes. In this demo we ignore attribute nodes; in Real Life you’ll want to copy them. 

The only two templates are for element nodes. The first (lines 7–11) matches the root node and returns it without flattening; this is necessary to ensure that the output XML is well formed, that is, that it has a single element that wraps the entire content. The other template (lines 12–22) matches all other elements; creates the new empty elements, with their `@n` and `@type` attributes, as replacements for the original start- and end-tags; and, between those new empty elements, applies templates to the children of the input element.

The output (`flattened.xml`) looks like the following (newline characters have been introduced manually in this report for legibility):

```xml
<?xml version="1.0" encoding="UTF-8"?><root>
    <p n="d1e3" type="start"/>This is a <word n="d1e5" type="start"/>paragraph<word n="d1e5" 
    	type="end"/> that contains some stuff.<p n="d1e3" type="end"/>
    <p n="d1e9" type="start"/>This is another paragraph <phrase n="d1e11" type="start"/><word n="d1e12" 
    	type="start"/>that<word n="d1e12" type="end"/> <word n="d1e15" type="start"/>contains<word n="d1e15" 
    	type="end"/> <word n="d1e18" type="start"/>more<word n="d1e18" type="end"/><phrase 
    	n="d1e11" type="end"/> stuff.<p n="d1e9" type="end"/></root>
```

### Raising a hierarchy

Raise a real hierarchy from the flattened file with:

```bash
saxon -xsl:raise.xsl -s:flattened.xml -o:raised.xml
```

The result of raising looks identical to the original (`original.xml`) input, except for insignificant whitespace. The raising process works from the inside out, that is, it first finds pairs of corresponding flattened start- and end-tags that do not contain any other flattened start- and end-tags, and it reforms them into a container element with real start- and end-tags. The process is then applied recursively to the result of that first transformation, and again until there are no more elements with `@type` attributes.

The `raise.xsl` file looks as follows:

```xslt
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    exclude-result-prefixes="#all">
    <xsl:output method="xml" indent="no"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:mode on-no-match="shallow-copy" name="loop"/>
    <xsl:function name="djb:raise">
        <xsl:param name="input" as="document-node()"/>
        <xsl:choose>
            <xsl:when test="exists($input//@type)">
                <xsl:variable name="result" as="document-node()">
                    <xsl:document>
                        <xsl:apply-templates select="$input" mode="loop"/>
                    </xsl:document>
                </xsl:variable>
                <xsl:sequence select="djb:raise($result)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:template match="/">
        <xsl:sequence select="djb:raise(.)"/>
    </xsl:template>
    <xsl:template match="/" mode="loop">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="*[@type eq 'start'][@n eq following-sibling::*[@type eq 'end'][1]/@n]">
        <!-- innermost start-tag -->
        <xsl:element name="{name()}">
            <!-- textual content of raised element-->
            <xsl:copy-of
                select="following-sibling::node()[. &lt;&lt; following-sibling::*[@n eq current()/@n]]"
            />
        </xsl:element>
    </xsl:template>
    <!-- nodes inside new wrapper -->
    <xsl:template
        match="node()[preceding-sibling::*[@type eq 'start'][1]/@n eq following-sibling::*[@type eq 'end'][1]/@n]"/>
    <!-- end-tag for new wrapper -->
    <xsl:template
        match="*[@type eq 'end'][preceding-sibling::*[@type eq 'start'][1]/@n eq current()/@n]"/>
</xsl:stylesheet>
```

We turn off indentation (line 4) to avoid deforming the whitespace. Our recursive raising operation (the `djb:raise()` function, lines 7–22) operates on document nodes, and we need to process the original document node of the input file differently from the new document nodes that we create on each pass through the recursive function. For that reason, we match the original document node in no mode (`<xsl:template match="/">`, lines 23–25) and pass it into the raising function (`<xsl:sequence select="djb:raise(.)"/>`, line 24).

The raising function checks for the presence of `@type` attributes in the input (`<xsl:when test="exists($input//@type)">`, line 10). If there aren’t any (`<xsl:otherwise>`, lines 18–20), the recursion is finished, and the function returns the result (`<xsl:sequence select="$input"/>`, line 19). If there are still `@type` attributes in the text, we create a variable `$result` (lines 11–15) of type `document` and apply templates inside the newly created document node (line 13). After the application of templates is finished, we recurse and pass the result into another invocation of `djb:raise()` (`<xsl:sequence select="djb:raise($result)"/>`, line 16).

The application of templates within the recursive function begins by applying templates to the (newly created) document node in `loop` mode (`<xsl:apply-templates select="$input" mode="loop"/>`, line 13). The matching template (lines 26–28) simply applies templates to its children, unlike the template that matches the original document node (in no mode, lines 23–25), which passes the document into the `djb:raise()` function (line 24). Only the final output requires a document node, and the difference in mode is needed to avoid an endless loop. All other processing is the same for both the original document and the interim documents created inside `djb:raise()`, so `<xsl:template match="/" mode="loop">` (lines 26–28) is the only modal template, and it applies templates to its children in no mode.

There are three templates that do the actual processing of the innermost elements to be raised on each recursion: one that processes the start-tag, one that processes the content of the newly raised element, and one that processes the corresponding end-tag:

* **start-tag:** We match elements with a `@type` value of `'start'` that have an `@n` value equal to the `@n` value of their first following sibling element that has a `@type` value of `'end'` (line 29). This, then, matches only start-tags that contain nothing but `text()` nodes and elements that have already been raised (from which the `@type` attributes that were present in the input have been discarded). In other words, it matches only the innermost flattened elements, those that do not contain any other empty flattened elements. We process these hits by creating a container element with the same generic identifier as the start-tag and copying all following-sibling nodes that precede the end-tag that matches the start-tag we’re processing at the moment (lines 31–36). In other words, we copy the content of the newly raised element into it.
* **nodes inside the new container:** Since we have already copied the content of the newly raised element inside it, we don’t want to process those nodes again, since that would create duplicates. For that reason, we match all nodes between the start- and end-tags that we’re processing at the moment and suppress them by matching them inside an empty `<xsl:template>` element (lines 39–40).
* **end-tag:** Since we create real start- and end-tags when we match the flattened start-tag, we have no more use for the flattened end-tag, so we suppress it by matching it, too, inside an empty `<xsl:template>` element (lines 42–43).

____
This document is part of <https://github.com/djbpitt/xstuff/tree/master/hierarchy>.
