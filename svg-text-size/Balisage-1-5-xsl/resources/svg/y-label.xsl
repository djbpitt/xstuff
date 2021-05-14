<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0"
    xmlns="http://www.w3.org/2000/svg">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="letters" select="collection('../xml/?select=*.xml')"/>
    <xsl:variable name="locs" select="$letters//location => distinct-values()"/>
    <xsl:variable name="loc-count" as="xs:integer" select="count($locs)"/>
    <xsl:variable name="bar_height" as="xs:double" select="18"/>
    <xsl:variable name="spacing" as="xs:double" select="$bar_height div 2"/>
    <xsl:variable name="max_height" as="xs:double"
        select="($bar_height + $spacing) * $loc-count + $spacing"/>
    <xsl:variable name="half_width" as="xs:double" select="160"/>
    <xsl:variable name="max_width" as="xs:double" select="$half_width * 2"/>
    <xsl:variable name="xscale" as="xs:double" select="10"/>
    
    <xsl:template name="xsl:initial-template">
        <svg height="{$max_height + 200}" width="{$max_width + 250}">
            <g transform="translate({$half_width + 50}, 100)">
                <line x1="-{$half_width}" x2="{$half_width}" y1="0" y2="0" stroke="black"/>
                <line x1="0" x2="0" y1="0" y2="{$max_height}" stroke="black"/>
                
                <!-- Ruling lines and labels for "positive," good health values -->
                <xsl:for-each select="0 to 4">
                    <xsl:variable name="pos" as="xs:double"
                        select=". * ($half_width div 4)"/>
                    <text y="-20" x="{$pos}" font-size="13" text-anchor="middle">
                        <xsl:value-of select="$pos div $xscale"/>
                    </text>
                    <line y1="-15" y2="0" x1="{$pos}" x2="{$pos}" stroke="black"/>
                    <line y1="0" y2="{$max_height}" x1="{$pos}" x2="{$pos}" stroke="black"
                        opacity=".5"/>
                </xsl:for-each>
                
                <!-- Ruling lines and labels for "negative," bad health values -->
                <xsl:for-each select="-4 to -1">
                    <xsl:variable name="pos" as="xs:double"
                        select=". * ($half_width div 4)"/>
                    <text y="-20" x="{$pos}" font-size="13" text-anchor="middle">
                        <xsl:value-of select="(-$pos) div $xscale"/>
                    </text>
                    <line y1="-15" y2="0" x1="{$pos}" x2="{$pos}" stroke="black"/>
                    <line y1="0" y2="{$max_height}" x1="{$pos}" x2="{$pos}" stroke="black"
                        opacity=".5"/>
                </xsl:for-each>
                
                <!-- X Axis labels -->
                <text x="{$half_width div 2}" y="-50" font-size="14" text-anchor="middle"
                    font-weight="300">
                    <xsl:text>"Unstress"/Good Health</xsl:text>
                </text>
                <text x="-{$half_width div 2}" y="-50" font-size="14" text-anchor="middle"
                    font-weight="300">
                    <xsl:text>"Stress"/Bad Health</xsl:text>
                </text>
                <text x="0" y="{$max_height + 50}" font-size="16" text-anchor="middle"
                    font-weight="300">
                    <xsl:text>Mentions of Mental Health/Stress Factors</xsl:text>
                </text>
                
                <!-- Y Axis label -->
                <text x="{$half_width + 115}" y="{$max_height div 2}" text-anchor="middle"
                    font-size="16" writing-mode="tb">Location at time of writing</text>
                
                <!-- Generate bars -->
                <xsl:for-each-group select="$letters//location" group-by=".">
                    <xsl:variable name="ypos" as="xs:double"
                        select="$spacing + (position() - 1) * ($bar_height + $spacing)"/>
                    <line x1="-{$half_width}" x2="{$half_width}" y1="{$ypos + $spacing}"
                        y2="{$ypos + $spacing}" stroke="black" opacity=".5" stroke-dasharray="5,5"/>
                    
                    <!-- Generate "positive," good health bars -->
                    <xsl:variable name="good_length" as="xs:double"
                        select="sum(ancestor::letter/descendant::unstress/count(.)) + sum(ancestor::letter/descendant::good_health/count(.))"/>
                    <rect x="0" width="{$good_length * $xscale}" y="{$ypos}" height="{$bar_height}"
                        fill="#88c5db" stroke-width=".5" stroke="black"/>
                    
                    <!-- Generate "negative," bad health bars -->
                    <xsl:variable name="bad_length" as="xs:double"
                        select="sum(ancestor::letter/descendant::stress/count(.)) + sum(ancestor::letter/descendant::bad_health/count(.))"/>
                    <rect x="-{$bad_length * $xscale}" width="{$bad_length * $xscale}" y="{$ypos}"
                        height="{$bar_height}" fill="#f0d946" stroke-width=".5" stroke="black"/>
                    
                    <text x="{$half_width + 10}" y="{$ypos + $spacing + 3}" text-anchor="start"
                        font-size="10">
                        <xsl:value-of select="translate(., '_', ' ')"/>
                    </text>
                </xsl:for-each-group>
                
                <line x1="-{$half_width}" x2="{$half_width}" y1="0" y2="0" stroke="black"/>
                <line x1="0" x2="0" y1="0" y2="{$max_height}" stroke="black"/>
            </g>
        </svg>
    </xsl:template>
    
</xsl:stylesheet>