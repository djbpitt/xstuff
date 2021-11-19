<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
  version="3.0">
  <!-- https://www.mhonarc.org/archive/html/xsl-list/2019-09/msg00017.html -->
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="functions" select="
      load-xquery-module(
      'http://www.obdurodon.org',
      map {
        'location-hints':
        'xquery-import-test.xqm'
      }
      )"/>
  <xsl:template match="/">
    <output>
      <greeting>
        <xsl:sequence select="$functions?functions(xs:QName('djb:greet'))?0()"/>
      </greeting>
      <gis>
        <xsl:sequence select="$functions?functions(xs:QName('djb:gis'))?1(/)"/>
      </gis>
    </output>
  </xsl:template>
</xsl:stylesheet>
