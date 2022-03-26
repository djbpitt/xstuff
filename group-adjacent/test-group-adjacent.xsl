<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
  version="3.0">
  <!-- ================================================================== -->
  <!-- xsl:for-each-group @group-adjacent example                         -->
  <!--                                                                    -->
  <!-- Goal: merge <q> elements inside a paragraph if they are either     -->
  <!--   adjacent or separately only by a whitespace-only text node       -->
  <!--                                                                    -->
  <!-- Group all nodes with a boolean grouping key, where True means      -->
  <!--   sequence that either includes <q> or is a single whitespace-only -->
  <!--   text node                                                        -->
  <!-- Requires special handling to avoid creating spurious quote when    -->
  <!--   entire content is just a single whitespace-only text node        -->
  <!-- ================================================================== -->
  <xsl:output method="xml" indent="yes"/>
  <xsl:mode on-no-match="shallow-copy"/>
  <xsl:template match="p">
    <p>
      <xsl:for-each-group select="node()"
        group-adjacent="self::q or self::text()[normalize-space(.) = '']">
        <xsl:choose>
          <!-- ========================================================== -->
          <!-- If the grouping key is True, it's some combination of <q>  -->
          <!--   and whitespace-only text nodes.                          -->
          <!-- If there is more than one item, at least one is a quote.   -->
          <!-- If there is ionly one item and it's an instance of <q>,    -->
          <!--   it's a quote.                                            -->
          <!-- Otherwise it's just a single whitespace-only text node, so -->
          <!--   no <q>.                                                  -->
          <!-- ========================================================== -->
          <xsl:when
            test="current-grouping-key() and (. instance of element(q) or count(current-group()) gt 1)">
            <q>
              <xsl:for-each select="current-group()">
                <xsl:if test="position() gt 1">
                  <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:sequence select="node()"/>
              </xsl:for-each>
            </q>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="current-group()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </p>
  </xsl:template>
</xsl:stylesheet>
