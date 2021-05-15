<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- the tested stylesheet -->
   <xsl:import href="file:/Users/djb/repos/xstuff/svg-text-size/Balisage-1-5-xsl/resources/report-string-lengths-as-text.xsl"/>
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/djb/Library/Preferences/com.oxygenxml/extensions/v23.1/frameworks/https_www.oxygenxml.com_InstData_Addons_community_updateSite.xml/xspec.support-2.0.0/src/common/runtime-utils.xsl"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/djb/repos/xstuff/svg-text-size/Balisage-1-5-xsl/resources/report-string-lengths-as-svg.xspec</xsl:variable>
   <!-- the main template to run the suite -->
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}main"
                 as="empty-sequence()">
      <xsl:context-item use="absent"/>
      <!-- info message -->
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('Q{http://www.w3.org/1999/XSL/Transform}product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('Q{http://www.w3.org/1999/XSL/Transform}product-version')"/>
      </xsl:message>
      <!-- set up the result document (the report) -->
      <xsl:result-document format="Q{{http://www.jenitennison.com/xslt/xspec}}xml-report-serialization-parameters">
         <xsl:element name="report" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:attribute name="xspec" namespace="">file:/Users/djb/repos/xstuff/svg-text-size/Balisage-1-5-xsl/resources/report-string-lengths-as-svg.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/djb/repos/xstuff/svg-text-size/Balisage-1-5-xsl/resources/report-string-lengths-as-text.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}xaf5a622c-709b-3083-8214-e2ae921f9eec"/>
         </xsl:element>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}xaf5a622c-709b-3083-8214-e2ae921f9eec"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Scenario for testing function get-text-length</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">xaf5a622c-709b-3083-8214-e2ae921f9eec</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/djb/repos/xstuff/svg-text-size/Balisage-1-5-xsl/resources/report-string-lengths-as-svg.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Scenario for testing function get-text-length</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:call" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
               <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
               <xsl:attribute name="function" namespace="">djb:get-text-length</xsl:attribute>
               <xsl:element name="x:param" namespace="http://www.jenitennison.com/xslt/xspec">
                  <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
                  <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
                  <xsl:attribute name="name" namespace="">in</xsl:attribute>
                  <xsl:attribute name="select" namespace="">'The quick brown fox jumps over the lazy dog!'</xsl:attribute>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                          xmlns:djb="http://www.obdurodon.org"
                          name="Q{}in"
                          select="'The quick brown fox jumps over the lazy dog!'"/>
            <xsl:sequence select="Q{http://www.obdurodon.org}get-text-length($Q{}in)"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}xaf5a622c-709b-3083-8214-e2ae921f9eec-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}xaf5a622c-709b-3083-8214-e2ae921f9eec-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>Computes length of input text</xsl:message>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    xmlns:djb="http://www.obdurodon.org"
                    name="Q{urn:x-xspec:compile:impl}expect-d47e5"
                    select="2.97703125e2"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d47e5, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">xaf5a622c-709b-3083-8214-e2ae921f9eec-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Computes length of input text</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d47e5"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
