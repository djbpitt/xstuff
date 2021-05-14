<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0"
    xmlns="http://www.w3.org/2000/svg">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="letters" select="collection('./XML/?select=*.xml')"/>
    <xsl:variable name="locs" select="$letters//location => distinct-values()"/>
    <xsl:variable name="loc-count" as="xs:integer" select="count($locs)"/>
    <xsl:variable name="bar_width" as="xs:double" select="18"/>
    <xsl:variable name="spacing" as="xs:double" select="$bar_width div 2"/>
    <xsl:variable name="max_width" as="xs:double"
        select="($bar_width + $spacing) * $loc-count + $spacing"/>
    <xsl:variable name="half_height" as="xs:double" select="160"/>
    <xsl:variable name="max_height" as="xs:double" select="$half_height * 2"/>
    <xsl:variable name="yscale" as="xs:double" select="10"/>

    <xsl:template name="xsl:initial-template">
        <svg height="{$max_height + 300}" width="{$max_width + 250}">
            <g transform="translate(100, {$half_height + 125})">

                <!-- Ruling lines and labels for "positive," good health values -->
                <xsl:for-each select="0 to 4">
                    <xsl:variable name="pos" as="xs:double" select=". * ($half_height div 4 )"/>
                    <text y="{$pos + 2}" x="-30" font-size="10" text-anchor="middle">
                        <xsl:value-of select="$pos div $yscale"/>
                    </text>
                    <line x1="0" x2="-15" y1="{$pos}" y2="{$pos}" stroke="black"/>
                    <line x1="0" x2="{$max_width}" y1="{$pos}" y2="{$pos}" stroke="black"
                        opacity=".5"/>
                </xsl:for-each>

                <!-- Ruling lines and labels for "negative," bad health values -->
                <xsl:for-each select="-4 to -1">
                    <xsl:variable name="pos" as="xs:double" select=". * ($half_height div 4)"/>
                    <text x="-30" y="{$pos + 2}" font-size="10" text-anchor="middle">
                        <xsl:value-of select="(-$pos) div $yscale"/>
                    </text>
                    <line x1="-15" x2="0" y1="{$pos}" y2="{$pos}" stroke="black"/>
                    <line x1="0" x2="{$max_width}" y1="{$pos}" y2="{$pos}" stroke="black"
                        opacity=".5"/>
                </xsl:for-each>

                <!-- Y Axis labels -->
                <text y="{$half_height div 2}" x="-50" font-size="14" text-anchor="middle"
                    font-weight="300" transform="rotate(270, -50, {$half_height div 2})">
                    <xsl:text>"Unstress"/Good Health</xsl:text>
                </text>
                <text y="-{$half_height div 2}" x="-50" font-size="14" text-anchor="middle"
                    font-weight="300" transform="rotate(270, -50, -{$half_height div 2})">
                    <xsl:text>"Stress"/Bad Health</xsl:text>
                </text>
                <text x="{$max_width div 2}" y="{-$half_height - 25}" font-size="16" text-anchor="middle"
                    font-weight="300">
                    <xsl:text>Mentions of Mental Health/Stress Factors</xsl:text>
                </text>

                <!-- X Axis label -->
                <text y="{$half_height + 100}" x="{$max_width div 2}" text-anchor="middle"
                    font-size="16">Location (at time of writing)</text>

                <!-- Generate bars -->
                <xsl:for-each-group select="$letters//location" group-by=".">
                    <xsl:variable name="xpos" as="xs:double"
                        select="$spacing + (position() - 1) * ($bar_width + $spacing)"/>
                    <line y1="-{$half_height}" y2="{$half_height}" x1="{$xpos + $spacing}"
                        x2="{$xpos + $spacing}" stroke="black" opacity=".5" stroke-dasharray="5,5"/>

                    <!-- Generate "positive," good health bars -->
                    <xsl:variable name="good_length" as="xs:double"
                        select="sum(ancestor::letter/descendant::unstress/count(.)) + sum(ancestor::letter/descendant::good_health/count(.))"/>
                    <rect y="0" height="{$good_length * $yscale}" x="{$xpos}" width="{$bar_width}"
                        fill="#88c5db" stroke-width=".5" stroke="black"/>

                    <!-- Generate "negative," bad health bars -->
                    <xsl:variable name="bad_length" as="xs:double"
                        select="sum(ancestor::letter/descendant::stress/count(.)) + sum(ancestor::letter/descendant::bad_health/count(.))"/>
                    <rect y="-{$bad_length * $yscale}" height="{$bad_length * $yscale}" x="{$xpos}"
                        width="{$bar_width}" fill="#f0d946" stroke-width=".5" stroke="black"/>

                    <text y="{$half_height + 10}" x="{$xpos + $spacing + 3}" text-anchor="end"
                        font-size="10" transform="rotate(315, {$xpos + $spacing + 3}, {$half_height + 10})">
                        <xsl:value-of select="translate(., '_', ' ')"/>
                    </text>
                </xsl:for-each-group>
                
                <line y1="-{$half_height}" y2="{$half_height}" x1="0" x2="0" stroke="black"/>
                <line y1="0" y2="0" x1="0" x2="{$max_width}" stroke="black"/>
            </g>
        </svg>
    </xsl:template>

</xsl:stylesheet>
