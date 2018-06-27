<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="no"/>
    <xsl:template match="novel">
        <xsl:copy>
            <xsl:for-each-group select="node()" group-starting-with="pb">
                <page>
                    <xsl:copy-of select="current-group() except ."/>
                </page>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
