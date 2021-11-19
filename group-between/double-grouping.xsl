<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- ===============================================================  -->
    <!-- Identity transformation                                          -->
    <!-- ===============================================================  -->
    <xsl:mode on-no-match="shallow-copy"/>
    <!-- ===============================================================  -->
    <!-- Stylesheet variables                                             -->
    <!--                                                                  -->
    <!-- $all_speech                                                      -->
    <!--    Flat sequence of all words, punctuation, insult delimiters    -->
    <!-- ===============================================================  -->
    <xsl:variable name="all_speech" as="element()+"
        select="//w | //punc | //insultStart | //insultEnd"/>
    <xsl:template match="front">
        <!-- ============================================================ -->
        <!-- Copy the cast list and create new <div> for insults          -->
        <!-- ============================================================ -->
        <xsl:copy>
            <xsl:copy-of select="@* | node()"/>
            <insults>
                <!-- ==================================================== -->
                <!-- Tesselated groups demarcated by insult delimiters    -->
                <!-- ==================================================== -->
                <xsl:for-each-group select="$all_speech" group-starting-with="insultStart">
                    <xsl:variable name="base-group-number" as="xs:integer">
                        <!-- ============================================ -->
                        <!-- First group probably isn't an insult, but    -->
                        <!--   adjust baseline for count if it is         -->
                        <!-- ============================================ -->
                        <xsl:choose>
                            <xsl:when test="$all_speech[1][self::insultStart]">0</xsl:when>
                            <xsl:otherwise>-1</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test=".[self::insultStart]">
                        <!-- ============================================ -->
                        <!-- First and last groups may not be insults; if -->
                        <!-- the group starts as an insult, it's okay     -->
                        <!-- ============================================ -->
                        <insult
                            xml:id="insult_{format-number($base-group-number + position(), '0000')}">
                            <xsl:for-each-group select="current-group()"
                                group-ending-with="insultEnd">
                                <xsl:if test="position() eq 1">
                                    <!-- ================================ -->
                                    <!-- The first subgroup is our insult -->
                                    <xsl:sequence
                                        select="current-group()"/>
                                    <!-- ================================ -->
                                    <!-- Uncomment message for debugging  -->
                                    <xsl:message select="data(current-group())"/>
                                </xsl:if>
                            </xsl:for-each-group>
                        </insult>
                    </xsl:if>
                </xsl:for-each-group>
            </insults>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
