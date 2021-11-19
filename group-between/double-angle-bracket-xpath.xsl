<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- ===============================================================  -->
    <!-- Identity transformation                                          -->
    <!-- ===============================================================  -->
    <xsl:mode on-no-match="shallow-copy"/>
    <!-- ===============================================================  -->
    <!-- Dimitre Novatchev, xml.com Slack, 2021-11-17                     -->
    <!-- for $start in //start,                                           -->
    <!--     $end in $start/(following::end | descendant::end)[1]         -->
    <!-- return                                                           -->
    <!-- ($start, $start/(following::w | descendant::w)[. << $end], $end) -->
    <!-- ===============================================================  -->
    <xsl:function name="djb:extract-insult" as="element()+">
        <xsl:param name="start" as="element(insultStart)"/>
        <xsl:variable name="end" as="element(insultEnd)"
            select="(following::insultEnd | descendant::insultEnd)[1]"/>
        <xsl:sequence select="
                $start,
                $start/(following::w | descendant::w)[. &lt;&lt; $end],
                $end"/>
    </xsl:function>
    <xsl:template match="front">
        <!-- ============================================================ -->
        <!-- Copy the cast list and create new <div> for insults          -->
        <!-- ============================================================ -->
        <xsl:copy>
            <xsl:copy-of select="@* | node()"/>
            <insults>
                <!-- ==================================================== -->
                <!-- Find insults by start delimiter                      -->
                <!-- ==================================================== -->
                <xsl:apply-templates select="//insultStart" mode="insult"/>
            </insults>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="insultStart" mode="insult">
        <insult>
            <xsl:sequence select="djb:extract-insult(.)"/>
        </insult>
    </xsl:template>
</xsl:stylesheet>
