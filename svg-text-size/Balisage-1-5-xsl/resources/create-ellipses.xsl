<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- ================================================================ -->
    <!-- Variables: data                                                  -->
    <!-- ================================================================ -->
    <xsl:variable name="texts" as="xs:string+"
        select="('There', 'is', 'nothing', 'so', 'practical', 'as', 'a', 'good', 'theory')"/>
    <xsl:variable name="text-lengths" as="xs:double+" select="$texts ! djb:get-text-length(.)"/>
    <!-- ================================================================ -->
    <!-- Variables: font                                                  -->
    <!-- ================================================================ -->
    <xsl:variable name="times-new-roman-16-mapping" as="document-node()"
        select="doc('times-new-roman-16.xml')"/>
    <xsl:key name="lengthByChar" match="character" use="@str"/>
    <xsl:variable name="font-size" as="xs:double"
        select="$times-new-roman-16-mapping/descendant::metadata/@fontSize"/>
    <!-- ================================================================ -->
    <!-- Constants                                                        -->
    <!-- ================================================================ -->
    <xsl:variable name="inter-ellipse-spacing" as="xs:integer" select="20"/>
    <xsl:variable name="text-x-padding" as="xs:integer" select="10"/>
    <xsl:variable name="y-pos" as="xs:double" select="$font-size div 2"/>
    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:get-text-length" as="xs:double" cache="yes">
        <!-- ============================================================ -->
        <!-- djb:get-text-length                                          -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $in as xs:string : input text string                       -->
        <!--                                                              -->
        <!-- Returns: length of text string as xs:double                  -->
        <!-- ============================================================ -->
        <xsl:param name="in" as="xs:string"/>
        <xsl:sequence select="
                string-to-codepoints($in)
                ! codepoints-to-string(.)
                ! key('lengthByChar', ., $times-new-roman-16-mapping)/@width
                => sum()"/>
    </xsl:function>
    <xsl:function name="djb:x-pos" as="xs:double">
        <!-- ============================================================ -->
        <!-- djb:x-pos                                                    -->
        <!--                                                              -->
        <!-- Parameters:                                                  -->
        <!--   $text-offset as xs:integer : offset of string in sequence  -->
        <!--                                                              -->
        <!-- Stylesheet variables used:                                   -->
        <!--   $inter-ellipse-spacing as xs:integer : between edges       -->
        <!--   $text-x-padding as xs:integer : padding on each side       -->
        <!--                                                              -->
        <!-- Returns: x position for center of ellipse and text           -->
        <!--   sum of: all preceding string widths                        -->
        <!--           2 * padding for all preceding                      -->
        <!--           inter-ellipse-spacing for all preceding            -->
        <!--           half width of current                              -->
        <!--           padding left of current                            -->
        <!-- ============================================================ -->
        <xsl:param name="in" as="xs:integer"/>
        <xsl:sequence select="
                $text-lengths[position() lt $in] => sum() +
                $inter-ellipse-spacing * ($in - 1) +
                $text-x-padding * ($in - 1) * 2 +
                $text-lengths[$in] div 2 +
                $text-x-padding"/>
    </xsl:function>
    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <!-- ============================================================ -->
        <!-- Compute X values for @viewBox                                -->
        <!-- ============================================================ -->
        <xsl:variable name="text-count" as="xs:integer" select="count($texts)"/>
        <xsl:variable name="left-edge" as="xs:double" select="
                djb:get-text-length($texts[1]) div 2 +
                $text-x-padding +
                $inter-ellipse-spacing (: extra padding at start :)"/>
        <xsl:variable name="total-width" as="xs:double" select="
                sum($text-lengths) +
                $text-x-padding * 2 * $text-count +
                $inter-ellipse-spacing * ($text-count - 1) +
                $left-edge"/>
        <xsl:variable name="padding" as="xs:integer" select="$inter-ellipse-spacing div 2"/>
        <!-- ============================================================ -->
        <!-- Create SVG                                                   -->
        <!-- ============================================================ -->
        <svg viewBox="
            -{$left-edge + $padding} 
            -{$font-size + $padding} 
            {$total-width + 2 * $padding} 
            {($font-size + $padding) * 2}">
            <defs>
                <marker id="arrow" markerWidth="10" markerHeight="10" refX="6" refY="3"
                    orient="auto" markerUnits="strokeWidth">
                    <!--
                    arrowhead is 9 x 6
                    refy = 3 centers short side on center of line
                    refx = 6 backs up from contact point
                    set line length 2 x 3 short of contact point
                -->
                    <path d="M0,0 L0,6 L9,3 z" fill="black"/>
                </marker>
            </defs>
            <g>
                <xsl:for-each select="$texts">
                    <xsl:variable name="text-offset" as="xs:integer" select="position()"/>
                    <xsl:variable name="x-pos" as="xs:double" select="
                            djb:x-pos($text-offset) (: x center of ellipse :)"/>
                    <!-- draw arrow from left center to right edge -->
                    <xsl:if test="position() ne last()">
                        <xsl:variable name="x2" as="xs:double"
                            select="djb:x-pos($text-offset + 1) - $text-lengths[$text-offset + 1] div 2 - $text-x-padding - 3"/>
                        <line x1="{$x-pos}" y1="{$y-pos}" x2="{$x2}" y2="{$y-pos}" stroke="black"
                            stroke-width="1" marker-end="url(#arrow)"/>
                    </xsl:if>
                    <!-- draw ellipse -->
                    <ellipse cx="{$x-pos}" cy="{$y-pos}"
                        rx="{$text-lengths[$text-offset] div 2 + $text-x-padding}" ry="{$font-size}"
                        fill="white" stroke="black" stroke-width="1"/>
                    <text x="{$x-pos}" y="{$y-pos}" dominant-baseline="middle" text-anchor="middle"
                        font-family="Times New Roman" font-size="{$font-size}">
                        <xsl:value-of select="."/>
                    </text>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
