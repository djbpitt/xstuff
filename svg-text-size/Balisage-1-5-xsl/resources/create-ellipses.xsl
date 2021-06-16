<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- ================================================================ -->
    <!-- Variables: data                                                  -->
    <!-- ================================================================ -->
    <!-- Data                                                             -->
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
        <!-- Returns: length of string as xs:double                       -->
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
        <!--   $x-padding as xs:integer : padding on both sides of string -->
        <!--   $inter-ellipse as xs:integer : space between ellipses      -->
        <!--                                                              -->
        <!-- Returns: x position for center of ellipse and text           -->
        <!-- ============================================================ -->
        <xsl:param name="_in" as="xs:integer"/>
        <xsl:param name="_text-x-padding" as="xs:integer"/>
        <xsl:param name="_inter-ellipse-spacing" as="xs:integer"/>
        <xsl:message select="$_in"/>
        <xsl:sequence select="
                $texts[position() lt $_in] ! djb:get-text-length(.) => sum() +
                $_inter-ellipse-spacing * $_in +
                $_text-x-padding * $_in * 2"/>
    </xsl:function>
    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template name="xsl:initial-template">
        <svg viewBox="40 0 620 50">
            <g>
                <xsl:for-each select="$texts">
                    <xsl:variable name="text-offset" as="xs:integer" select="position()"/>
                    <xsl:variable name="x-pos" as="xs:double" select="
                            djb:x-pos($text-offset, $text-x-padding, $inter-ellipse-spacing) +
                            $inter-ellipse-spacing +
                            0.5 * $text-lengths[$text-offset]"/>
                    <ellipse cx="{$x-pos}" cy="10"
                        rx="{$text-lengths[$text-offset] div 2 + $text-x-padding}" ry="{$font-size}"
                        fill="none" stroke="black" stroke-width="1"/>
                    <text x="{$x-pos}" y="10" dominant-baseline="middle" text-anchor="middle"
                        font-family="Times New Roman" font-size="{$font-size}">
                        <xsl:value-of select="."/>
                    </text>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
