<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- ===============================================================  -->
    <!-- Identity transformation                                          -->
    <!-- ===============================================================  -->
    <xsl:mode on-no-match="shallow-copy"/>
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
        <!-- ============================================================ -->
        <!-- End delimiter is first following <insultEnd>                 -->
        <!-- ============================================================ -->
        <xsl:variable name="myEnd" as="element(insultEnd)"
            select="(descendant::insultEnd | following::insultEnd)[1]"/>
        <xsl:variable name="myInsult"
            select="., (following::w | following::punc)[. &lt;&lt; $myEnd]"/>
        <insult>
            <xsl:copy-of select="$myInsult"/>
            <!-- Uncomment message for debugging -->
            <!--<xsl:message select="string-join($myInsult)"/>-->
        </insult>
    </xsl:template>
</xsl:stylesheet>
