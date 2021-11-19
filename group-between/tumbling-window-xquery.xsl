<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- ===============================================================  -->
    <!-- Requires Saxon EE                                                -->
    <!-- ===============================================================  -->
    <!-- Identity transformation                                          -->
    <!-- ===============================================================  -->
    <xsl:mode on-no-match="shallow-copy"/>
    <!-- ===============================================================  -->
    <!-- Tumbling window implementation based on Martin Honnen's:         -->
    <!--   https://www.mhonarc.org/archive/html/xsl-list/2019-09/msg00017.html -->
    <!-- ===============================================================  -->
    <xsl:variable name="functions" select="
            load-xquery-module(
            'http://www.obdurodon.org',
            map {
                'location-hints':
                'tumbling-window-xquery.xqm'
            }
            )"/>
    <xsl:variable name="root" as="document-node()" select="/"/>
    <!-- ===============================================================  -->
    <xsl:template match="front">
        <!-- ============================================================ -->
        <!-- Copy the cast list and create new <div> for insults          -->
        <!-- ============================================================ -->
        <xsl:copy>
            <xsl:copy-of select="@* | node()"/>
            <insults>
                <!-- ==================================================== -->
                <!-- Find insults by start delimiter                      -->
                <!--                                                      -->
                <!-- ===================================================  -->
                <!-- Martin Honnen, xml.com Slack, 2021-11-17             -->
                <!-- for tumbling window $word in play/speech/line/*
                    start $s when $s instance of element(start)
                    end $e when $e instance of element(end)
                    return
                        <group>{
                            $word[position() gt 1 and position() lt last()]
                            ! 
                            <word number="{string-join(ancestor-or-self::*/@n, '.')}">{.}</word> 
                    }</group>                                            -->
                <xsl:sequence select="$functions?functions(xs:QName('djb:process-insults'))?1(/)"/>
            </insults>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
