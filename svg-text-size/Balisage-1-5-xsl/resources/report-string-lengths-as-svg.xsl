<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
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
        <input>AVAVAV</input>
        <input/>
        <input>The quick brown fox jumps over the lazy dog!</input>
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
            <xsl:result-document href="horizontal-samples.svg" method="xml" indent="yes">
                <svg>
                    <xsl:apply-templates select="$inputs" mode="horizontal"/>
                </svg>
            </xsl:result-document>
            <xsl:result-document href="vertical-samples.svg" method="xml" indent="yes">
                <svg>
                    <xsl:apply-templates select="$inputs" mode="vertical"/>
                </svg>
            </xsl:result-document>
            <xsl:result-document href="diagonal-samples.svg" method="xml" indent="yes">
                <svg>
                    <xsl:apply-templates select="$inputs" mode="diagonal"/>
                </svg>
            </xsl:result-document>
        </svg>
    </xsl:template>
    <xsl:template match="input" mode="horizontal">
        <xsl:variable name="offset" as="xs:integer" select="position()"/>
        <g transform="translate(10, 10)">
            <!-- ======================================================== -->
            <!-- Horizontal                                               -->
            <!-- ======================================================== -->
            <xsl:variable name="length" as="xs:double" select="djb:get-text-length(.)"/>
            <xsl:variable name="y-pos" as="xs:double"
                select="($offset - 1) * 3 * $font-size + $font-size"/>
            <text x="0" y="{$y-pos}" font-family="Times New Roman" font-size="16">
                <xsl:value-of select="'Length: ' || $length"/>
            </text>
            <text x="0" y="{$y-pos + 16}" font-family="Times New Roman" font-size="16" kerning="0">
                <xsl:value-of select="."/>
            </text>
            <line x1="0" y1="{$y-pos + 20}" x2="{$length}" y2="{$y-pos + 20}" stroke="black"
                stroke-width="1"/>
        </g>
    </xsl:template>
    <xsl:template match="input" mode="vertical">
        <xsl:variable name="offset" as="xs:integer" select="position()"/>
        <g transform="translate(10, 10)">
            <!-- ======================================================== -->
            <!-- Vertical                                                 -->
            <!-- ======================================================== -->
            <xsl:variable name="length" as="xs:double" select="djb:get-text-length(.)"/>
            <xsl:variable name="x-pos" as="xs:double"
                select="($offset - 1) * 3 * $font-size + $font-size"/>
            <text x="{$x-pos}" y="0" font-family="Times New Roman" font-size="16" writing-mode="tb">
                <xsl:value-of select="."/>
            </text>
            <line x1="{$x-pos - $font-size div 2}" y1="0" x2="{$x-pos - $font-size div 2}"
                y2="{$length}" stroke="black" stroke-width="1"/>
        </g>
    </xsl:template>
    <xsl:template match="input" mode="diagonal">
        <xsl:variable name="offset" as="xs:integer" select="position()"/>
        <g transform="translate(10, 10)">
            <!-- ======================================================== -->
            <!-- Diagonal                                                 -->
            <!--                                                          -->
            <!-- adjacent = hypotenuse * cosθ (height)                    -->
            <!-- opposite = hypotenuse * sinθ (width)                     -->
            <!-- angle in degrees for rotate() but radians for math:cos() -->
            <!-- radians = degrees * π/180                                -->
            <!-- ======================================================== -->
            <xsl:variable name="x-pos" as="xs:double"
                select="($offset - 1) * 3 * $font-size + $font-size"/>
            <xsl:variable name="hypotenuse" as="xs:double" select="djb:get-text-length(.)"/>
            <xsl:variable name="angle-degrees" as="xs:double" select="30"/>
            <xsl:variable name="angle-radians" as="xs:double"
                select="$angle-degrees * math:pi() div 180"/>
            <xsl:variable name="height" as="xs:double"
                select="$hypotenuse * math:cos($angle-radians)"/>
            <xsl:variable name="width" as="xs:double"
                select="$hypotenuse * math:sin($angle-radians)"/>
            <text x="{$x-pos}" y="0" font-family="Times New Roman" font-size="16" writing-mode="tb"
                transform="rotate(-{$angle-degrees}, {$x-pos}, 0)">
                <xsl:value-of select="."/>
            </text>
            <rect x="{$x-pos}" y="0" width="{$width}" height="{$height}" stroke="black"
                stroke-width="1" fill="none"/>
        </g>
    </xsl:template>
</xsl:stylesheet>
