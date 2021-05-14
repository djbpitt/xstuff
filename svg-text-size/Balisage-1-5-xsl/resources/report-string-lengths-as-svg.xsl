<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg"
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
    <xsl:variable name="inputs" as="element(input)+" xmlns="">
        <input>Test string</input>
        <input/>
        <input>m</input>
        <input>mm</input>
        <input>The quick brown fox jumps over the lazy dog … and the lazier wombat!</input>
    </xsl:variable>
    <!-- ================================================================ -->
    <!-- Read in mapping and make accessible in key (one per font/size)   -->
    <!-- ================================================================ -->
    <xsl:variable name="times-new-roman-16-mapping" as="document-node()"
        select="doc('times-new-roman-16.xml')"/>
    <xsl:key name="lengthByChar" match="character" use="@str"/>
    <xsl:variable name="font-size" as="xs:double"
        select="$times-new-roman-16-mapping/descendant::metadata/@fontSize"/>
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
    <!--                                                                  -->
    <!-- Creates SVG output with, for each test string:                   -->
    <!--   String, followed by parenthesized length                       -->
    <!--   <line> of same length, for visual comparison                   -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg>
            <xsl:apply-templates select="$inputs"/>
        </svg>
    </xsl:template>
    <xsl:template match="input">
        <xsl:variable name="length" as="xs:double" select="djb:get-text-length(.)"/>
        <xsl:variable name="y-pos" as="xs:double"
            select="(position() - 1) * 3 * $font-size + $font-size"/>
        <text x="10" y="{$y-pos}" font-family="Times New Roman" font-size="16">
            <xsl:value-of select="'Length: ' || $length"/>
        </text>
        <text x="10" y="{$y-pos + 16}" font-family="Times New Roman" font-size="16">
            <xsl:value-of select="."/>
        </text>
        <line x1="10" y1="{$y-pos + 20}" x2="{10 + $length}" y2="{$y-pos + 20}" stroke="black"
            stroke-width="2"/>
    </xsl:template>
</xsl:stylesheet>
