<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <!-- ================================================================ -->
    <!-- Demonstrates function to compute text length                     -->
    <!-- ================================================================ -->
    <xsl:output method="xml" indent="yes"/>
    <!-- ================================================================ -->
    <!-- Test strings                                                     -->
    <!-- ================================================================ -->
    <xsl:variable name="inputs" as="element(input)+">
        <input>Test string</input>
        <input/>
        <input>m</input>
        <input>mm</input>
    </xsl:variable>
    <!-- ================================================================ -->
    <!-- Read in mapping and make accessible in key (one per font/size)   -->
    <!-- ================================================================ -->
    <xsl:variable name="times-new-roman-16-mapping" as="document-node()"
        select="doc('times-new-roman-16.xml')"/>
    <xsl:key name="lengthByChar" match="character" use="@str"/>
    <!-- ================================================================ -->
    <!-- Return length of string in SVG units                             -->
    <!-- ================================================================ -->
    <xsl:function name="djb:get-text-length" as="xs:double">
        <xsl:param name="in" as="xs:string"/>
        <xsl:sequence select="
                string-to-codepoints($in)
                ! codepoints-to-string(.)
                ! key('lengthByChar', ., $times-new-roman-16-mapping)/@width
                => sum()"/>
    </xsl:function>
    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <outputs>
            <xsl:apply-templates select="$inputs"/>
        </outputs>
    </xsl:template>
    <xsl:template match="input">
        <output>
            <xsl:text>The string "</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>" is of length </xsl:text>
            <xsl:value-of select="djb:get-text-length(.)"/>
        </output>
    </xsl:template>
</xsl:stylesheet>
