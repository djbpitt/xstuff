<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    exclude-result-prefixes="#all" version="3.0" xmlns="http://www.w3.org/2000/svg">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="letters" select="collection('../xml/?select=*.xml')"/>
    
    <!-- ================================================================ -->
    <!-- Establish label dimensions                                       -->
    <!-- ================================================================ -->
    <xsl:variable name="locs" select="$letters//location"/>
    <xsl:variable name="max-loc-str" as="xs:double" select="
        max(for $loc in $locs
        return djb:get-text-length(
        $loc  || ' (' || $loc/following-sibling::date/year || ')'))"/>
    <xsl:variable name="label-pos" as="xs:double"
        select="$half_height + $max-loc-str + ($font-size * 2)"/>
    
    <!-- ================================================================ -->
    <!-- Standardize axis label positions and calculate shift             -->
    <!-- ================================================================ -->
    <xsl:variable name="line-end" as="xs:double" select="-10"/>
    <xsl:variable name="num-pos" as="xs:double" select="$line-end - 10"/>
    <xsl:variable name="health-pos" as="xs:double" select="$num-pos - 20"/>
    <xsl:variable name="title-pos" as="xs:double" select="-$half_height - 30"/>
    <xsl:variable name="horiz-shift" as="xs:double" select="-$health-pos + $font-size"/>
    <xsl:variable name="vert-shift" as="xs:double" select="-$title-pos + $font-size"/>
    
    <!-- ================================================================ -->
    <!-- General graph dimensions                                         -->
    <!-- ================================================================ -->
    <xsl:variable name="bar_width" as="xs:double" select="18"/>
    <xsl:variable name="spacing" as="xs:double" select="$bar_width div 2"/>
    <xsl:variable name="max_width" as="xs:double"
        select="($bar_width + $spacing) * count(distinct-values($locs)) + $spacing"/>
    <xsl:variable name="half_height" as="xs:double" select="160"/>
    <xsl:variable name="max_height" as="xs:double" select="$half_height * 2"/>
    <xsl:variable name="yscale" as="xs:double" select="10"/>

    <!-- ================================================================ -->
    <!-- Read in mapping and make accessible in key (one per font/size)   -->
    <!-- ================================================================ -->
    <xsl:variable name="times-new-roman-16-mapping" as="document-node()"
        select="doc('../times-new-roman-16.xml')"/>
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

    <xsl:template name="xsl:initial-template">
        <svg height="{$label-pos + (-$title-pos) + ($font-size * 2)}" width="{$max_width + $horiz-shift + ($font-size * 2)}">
            <g transform="translate({$horiz-shift}, {$vert-shift})">

                <!-- ================================================================ -->
                <!-- Ruling lines and labels for "positive," good health values       -->
                <!-- ================================================================ -->
                <xsl:for-each select="0 to 4">
                    <xsl:variable name="pos" as="xs:double" select=". * ($half_height div 4)"/>
                    <text x="{$num-pos}" y="{$pos + 2}" font-size="16" font-family="Times New Roman" text-anchor="middle">
                        <xsl:value-of select="$pos div $yscale"/>
                    </text>
                    <line x1="0" x2="{$line-end}" y1="{$pos}" y2="{$pos}" stroke="black"/>
                    <line x1="0" x2="{$max_width}" y1="{$pos}" y2="{$pos}" stroke="black"
                        opacity=".5"/>
                </xsl:for-each>

                <!-- ================================================================ -->
                <!-- Ruling lines and labels for "negative," bad health values        -->
                <!-- ================================================================ -->
                <xsl:for-each select="-4 to -1">
                    <xsl:variable name="pos" as="xs:double" select=". * ($half_height div 4)"/>
                    <text x="{$num-pos}" y="{$pos + 2}" font-size="16" font-family="Times New Roman" text-anchor="middle">
                        <xsl:value-of select="(-$pos) div $yscale"/>
                    </text>
                    <line x1="{$line-end}" x2="0" y1="{$pos}" y2="{$pos}" stroke="black"/>
                    <line x1="0" x2="{$max_width}" y1="{$pos}" y2="{$pos}" stroke="black"
                        opacity=".5"/>
                </xsl:for-each>

                <!-- ================================================================ -->
                <!-- for-each-group to draw ruling lines, bars, bar labels            -->
                <!-- ================================================================ -->
                <xsl:for-each-group select="$letters//location" group-by=".">
                    <xsl:sort select="./following-sibling::date/year"/>
                    <xsl:variable name="xpos" as="xs:double"
                        select="$spacing + (position() - 1) * ($bar_width + $spacing)"/>
                    <line x1="{$xpos + $spacing}" x2="{$xpos + $spacing}" y1="-{$half_height}"
                        y2="{$half_height}" stroke="black" opacity=".5" stroke-dasharray="5,5"/>

                    <!-- ================================================================ -->
                    <!-- Generate "positive," good health bars                            -->
                    <!-- ================================================================ -->
                    <xsl:variable name="good_length" as="xs:double"
                        select="sum(ancestor::letter/descendant::unstress/count(.)) + sum(ancestor::letter/descendant::good_health/count(.))"/>
                    <rect x="{$xpos}" width="{$bar_width}" y="-{$good_length * $yscale}"
                        height="{$good_length * $yscale}" fill="#88c5db" stroke-width=".5"
                        stroke="black"/>

                    <!-- ================================================================ -->
                    <!-- Generate "negative," bad health bars                             -->
                    <!-- ================================================================ -->
                    <xsl:variable name="bad_length" as="xs:double"
                        select="sum(ancestor::letter/descendant::stress/count(.)) + sum(ancestor::letter/descendant::bad_health/count(.))"/>
                    <rect x="{$xpos}" width="{$bar_width}" y="0" height="{$bad_length * $yscale}"
                        fill="#f0d946" stroke-width=".5" stroke="black"/>

                    <!-- ================================================================ -->
                    <!-- Location labels                                                  -->
                    <!-- ================================================================ -->
                    <text x="{$xpos + $spacing + ($font-size * .5)}" y="{$half_height + ($font-size)}" text-anchor="start"
                        font-size="16" font-family="Times New Roman" writing-mode="tb">
                        <xsl:value-of select="translate(., '_', ' ')"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="./following-sibling::date/year"/>
                        <xsl:text>)</xsl:text>
                    </text>
                </xsl:for-each-group>

                <!-- ================================================================ -->
                <!-- Y Axis labels                                                    -->
                <!-- ================================================================ -->
                <text x="{$health-pos}" y="-{$half_height div 2}" font-size="16"
                    text-anchor="middle" font-family="Times New Roman" font-weight="300" writing-mode="tb">
                    <xsl:text>Good Health</xsl:text>
                </text>
                <text x="{$health-pos}" y="{$half_height div 2}" font-size="16"
                    text-anchor="middle" font-family="Times New Roman" font-weight="300" writing-mode="tb">
                    <xsl:text>Bad Health</xsl:text>
                </text>

                <!-- ================================================================ -->
                <!-- X Axis labels                                                    -->
                <!-- ================================================================ -->
                <text x="{$max_width div 2}" y="{$label-pos}"
                    text-anchor="middle" font-family="Times New Roman" font-size="16">Location at time of writing</text>
                <text x="{$max_width div 2}" y="{$title-pos}" font-size="16"
                    text-anchor="middle" font-family="Times New Roman" font-weight="300">
                    <xsl:text>Mentions of Mental Health/Stress Factors</xsl:text>
                </text>

                <!-- ================================================================ -->
                <!-- General axes                                                     -->
                <!-- ================================================================ -->
                <line x1="0" x2="0" y1="-{$half_height}" y2="{$half_height}" stroke="black"/>
                <line x1="0" x2="{$max_width}" y1="0" y2="0" stroke="black"/>
            </g>
        </svg>
    </xsl:template>

</xsl:stylesheet>
