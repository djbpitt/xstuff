<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- ================================================================ -->
    <!-- Variables                                                        -->
    <!-- ================================================================ -->
    <xsl:variable name="texts" as="xs:string+"
        select="('There', 'is', 'nothing', 'so', 'practical', 'as', 'a', 'good', 'theory')"/>
    <xsl:variable name="times-new-roman-16-mapping" as="document-node()"
        select="doc('times-new-roman-16.xml')"/>
    <xsl:key name="lengthByChar" match="character" use="@str"/>
    <xsl:variable name="font-size" as="xs:double"
        select="$times-new-roman-16-mapping/descendant::metadata/@fontSize"/>
    <!-- ================================================================ -->
    <!-- Functions                                                        -->
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
        <svg>
            <g> </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
