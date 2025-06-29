<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/hl7-2-ada/env/zibs/2020/payload/uni-stoptype.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:variable name="templateId-stoptype"
                 as="xs:string*"
                 select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9414', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9372', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9067'"/>
   <xd:doc>
      <xd:desc>Helper template for the stoptype</xd:desc>
      <xd:param name="in">The hl7 building block which has the relations in entryRelationships. Defaults to context.</xd:param>
      <xd:param name="adaElementName">The ada element name to be outputted. Required Defaults to stop_type.</xd:param>
   </xd:doc>
   <xsl:template name="uni-stoptype">
      <xsl:param name="in"
                 select="."/>
      <xsl:param name="adaElementName"
                 as="xs:string">stop_type</xsl:param>
      <!-- stoptype -->
      <xsl:for-each select="$in">
         <xsl:call-template name="handleCV">
            <xsl:with-param name="in"
                            select="hl7:entryRelationship/*[hl7:templateId/@root = $templateId-stoptype or hl7:code[@code = '274512008'][@codeSystem=$oidSNOMEDCT]]/hl7:value"/>
            <xsl:with-param name="elemName"
                            select="$adaElementName"/>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>