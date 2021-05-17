<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- the tested stylesheet -->
   <xsl:import href="file:/Users/charlie/Desktop/xstuff/svg-text-size/Balisage-1-5-xsl/resources/svg/rotate-relative.xsl"/>
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/Users/charlie/Library/Preferences/com.oxygenxml/extensions/v23.1/frameworks/https_www.oxygenxml.com_InstData_Addons_community_updateSite.xml/xspec.support-2.0.0/src/common/runtime-utils.xsl"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/Users/charlie/Desktop/xstuff/svg-text-size/Balisage-1-5-xsl/resources/svg/rotate-relative.xspec</xsl:variable>
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
            <xsl:attribute name="xspec" namespace="">file:/Users/charlie/Desktop/xstuff/svg-text-size/Balisage-1-5-xsl/resources/svg/rotate-relative.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/Users/charlie/Desktop/xstuff/svg-text-size/Balisage-1-5-xsl/resources/svg/rotate-relative.xsl</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}x09058d3e-cf42-38d2-abd1-8e818c6a7833"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}x6ae3905f-0ad2-36a3-b215-3ae4bc0b96ec"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}x79c8bd17-6940-31f9-bc3c-0834d9df7908"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}xf315ad82-f7e3-3617-8aa6-8dd59039807c"/>
            <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}x928fa32a-8840-388d-95dc-d797b967cb30"/>
         </xsl:element>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}x09058d3e-cf42-38d2-abd1-8e818c6a7833"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>When degrees = 30</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">x09058d3e-cf42-38d2-abd1-8e818c6a7833</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/charlie/Desktop/xstuff/svg-text-size/Balisage-1-5-xsl/resources/svg/rotate-relative.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>When degrees = 30</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:call" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
               <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
               <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
               <xsl:attribute name="function" namespace="">djb:deg-to-rad</xsl:attribute>
               <xsl:element name="x:param" namespace="http://www.jenitennison.com/xslt/xspec">
                  <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
                  <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
                  <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
                  <xsl:attribute name="name" namespace="">deg</xsl:attribute>
                  <xsl:attribute name="select" namespace="">30</xsl:attribute>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                          xmlns:djb="http://www.obdurodon.org"
                          xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                          name="Q{}deg"
                          select="30"/>
            <xsl:sequence select="Q{http://www.obdurodon.org}deg-to-rad($Q{}deg)"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}x09058d3e-cf42-38d2-abd1-8e818c6a7833-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}x09058d3e-cf42-38d2-abd1-8e818c6a7833-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>radians = pi/6 (approx. value)</xsl:message>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    xmlns:djb="http://www.obdurodon.org"
                    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                    name="Q{urn:x-xspec:compile:impl}expect-d51e5"
                    select="math:pi() div 6"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d51e5, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">x09058d3e-cf42-38d2-abd1-8e818c6a7833-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>radians = pi/6 (approx. value)</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d51e5"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}x6ae3905f-0ad2-36a3-b215-3ae4bc0b96ec"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>When degrees = 45</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">x6ae3905f-0ad2-36a3-b215-3ae4bc0b96ec</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/charlie/Desktop/xstuff/svg-text-size/Balisage-1-5-xsl/resources/svg/rotate-relative.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>When degrees = 45</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:call" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
               <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
               <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
               <xsl:attribute name="function" namespace="">djb:deg-to-rad</xsl:attribute>
               <xsl:element name="x:param" namespace="http://www.jenitennison.com/xslt/xspec">
                  <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
                  <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
                  <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
                  <xsl:attribute name="name" namespace="">deg</xsl:attribute>
                  <xsl:attribute name="select" namespace="">45</xsl:attribute>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                          xmlns:djb="http://www.obdurodon.org"
                          xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                          name="Q{}deg"
                          select="45"/>
            <xsl:sequence select="Q{http://www.obdurodon.org}deg-to-rad($Q{}deg)"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}x6ae3905f-0ad2-36a3-b215-3ae4bc0b96ec-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}x6ae3905f-0ad2-36a3-b215-3ae4bc0b96ec-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>radians = pi/4</xsl:message>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    xmlns:djb="http://www.obdurodon.org"
                    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                    name="Q{urn:x-xspec:compile:impl}expect-d51e9"
                    select="math:pi() div 4"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d51e9, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">x6ae3905f-0ad2-36a3-b215-3ae4bc0b96ec-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>radians = pi/4</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d51e9"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}x79c8bd17-6940-31f9-bc3c-0834d9df7908"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>When degrees = 60</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">x79c8bd17-6940-31f9-bc3c-0834d9df7908</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/charlie/Desktop/xstuff/svg-text-size/Balisage-1-5-xsl/resources/svg/rotate-relative.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>When degrees = 60</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:call" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
               <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
               <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
               <xsl:attribute name="function" namespace="">djb:deg-to-rad</xsl:attribute>
               <xsl:element name="x:param" namespace="http://www.jenitennison.com/xslt/xspec">
                  <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
                  <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
                  <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
                  <xsl:attribute name="name" namespace="">deg</xsl:attribute>
                  <xsl:attribute name="select" namespace="">60</xsl:attribute>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                          xmlns:djb="http://www.obdurodon.org"
                          xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                          name="Q{}deg"
                          select="60"/>
            <xsl:sequence select="Q{http://www.obdurodon.org}deg-to-rad($Q{}deg)"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}x79c8bd17-6940-31f9-bc3c-0834d9df7908-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}x79c8bd17-6940-31f9-bc3c-0834d9df7908-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>radians = pi/3</xsl:message>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    xmlns:djb="http://www.obdurodon.org"
                    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                    name="Q{urn:x-xspec:compile:impl}expect-d51e13"
                    select="math:pi() div 3"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d51e13, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">x79c8bd17-6940-31f9-bc3c-0834d9df7908-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>radians = pi/3</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d51e13"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}xf315ad82-f7e3-3617-8aa6-8dd59039807c"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>Text size for Nieuw-Amsterdam</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">xf315ad82-f7e3-3617-8aa6-8dd59039807c</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/charlie/Desktop/xstuff/svg-text-size/Balisage-1-5-xsl/resources/svg/rotate-relative.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Text size for Nieuw-Amsterdam</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:call" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
               <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
               <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
               <xsl:attribute name="function" namespace="">djb:get-text-length</xsl:attribute>
               <xsl:element name="x:param" namespace="http://www.jenitennison.com/xslt/xspec">
                  <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
                  <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
                  <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
                  <xsl:attribute name="name" namespace="">in</xsl:attribute>
                  <xsl:attribute name="select" namespace="">'Nieuw-Amsterdam'</xsl:attribute>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                          xmlns:djb="http://www.obdurodon.org"
                          xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                          name="Q{}in"
                          select="'Nieuw-Amsterdam'"/>
            <xsl:sequence select="Q{http://www.obdurodon.org}get-text-length($Q{}in)"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}xf315ad82-f7e3-3617-8aa6-8dd59039807c-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}xf315ad82-f7e3-3617-8aa6-8dd59039807c-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>= about 122.6</xsl:message>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    xmlns:djb="http://www.obdurodon.org"
                    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                    name="Q{urn:x-xspec:compile:impl}expect-d51e17"
                    select="1.226328125e2"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d51e17, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">xf315ad82-f7e3-3617-8aa6-8dd59039807c-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>= about 122.6</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d51e17"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}x928fa32a-8840-388d-95dc-d797b967cb30"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>When rad = pi/6 and hyp = 122.6</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">x928fa32a-8840-388d-95dc-d797b967cb30</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/Users/charlie/Desktop/xstuff/svg-text-size/Balisage-1-5-xsl/resources/svg/rotate-relative.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>When rad = pi/6 and hyp = 122.6</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="x:call" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
               <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
               <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
               <xsl:attribute name="function" namespace="">djb:tri-adj</xsl:attribute>
               <xsl:element name="x:param" namespace="http://www.jenitennison.com/xslt/xspec">
                  <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
                  <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
                  <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
                  <xsl:attribute name="name" namespace="">hyp</xsl:attribute>
                  <xsl:attribute name="select" namespace="">1.226328125e2</xsl:attribute>
               </xsl:element>
               <xsl:element name="x:param" namespace="http://www.jenitennison.com/xslt/xspec">
                  <xsl:namespace name="djb">http://www.obdurodon.org</xsl:namespace>
                  <xsl:namespace name="math">http://www.w3.org/2005/xpath-functions/math</xsl:namespace>
                  <xsl:namespace name="xsl">http://www.w3.org/1999/XSL/Transform</xsl:namespace>
                  <xsl:attribute name="name" namespace="">deg</xsl:attribute>
                  <xsl:attribute name="select" namespace="">30</xsl:attribute>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                          xmlns:djb="http://www.obdurodon.org"
                          xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                          name="Q{}hyp"
                          select="1.226328125e2"/>
            <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                          xmlns:djb="http://www.obdurodon.org"
                          xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                          name="Q{}deg"
                          select="30"/>
            <xsl:sequence select="Q{http://www.obdurodon.org}tri-adj($Q{}hyp, $Q{}deg)"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}x928fa32a-8840-388d-95dc-d797b967cb30-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}x928fa32a-8840-388d-95dc-d797b967cb30-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result" required="yes"/>
      <xsl:message>height = about 106.2</xsl:message>
      <xsl:variable xmlns:x="http://www.jenitennison.com/xslt/xspec"
                    xmlns:djb="http://www.obdurodon.org"
                    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
                    name="Q{urn:x-xspec:compile:impl}expect-d51e22"
                    select="1.0620313096253386e2"><!--expected result--></xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="Q{urn:x-xspec:common:deep-equal}deep-equal($Q{urn:x-xspec:compile:impl}expect-d51e22, $Q{http://www.jenitennison.com/xslt/xspec}result, '')"/>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">x928fa32a-8840-388d-95dc-d797b967cb30-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>height = about 106.2</xsl:text>
         </xsl:element>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d51e22"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
