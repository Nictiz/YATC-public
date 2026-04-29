<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/hl7-2-ada/env/zibs/2020/payload/uni-toelichting.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.16; 2026-04-29T11:02:12.55+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:template name="uni-toelichting">
      <!-- Helper template for the toelichting -->
      <xsl:param name="in"
                 select=".">
         <!-- The hl7 element which has the handled item in entryRelationship. Defaults to context.-->
      </xsl:param>
      <xsl:param name="adaElemName"
                 as="xs:string"
                 select="'toelichting'">
         <!-- the ada element name in which to output the toelichting, defaults to 'toelichting' -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:call-template name="handleST">
            <xsl:with-param name="in"
                            select="hl7:entryRelationship/hl7:act[hl7:code[@code = '48767-8'][@codeSystem = $oidLOINC]]/hl7:text"/>
            <xsl:with-param name="elemName"
                            select="$adaElemName"/>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>