<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/ext-TimeInterval-Duration.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.1; 2024-03-12T15:03:10.81+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <xd:doc>
      <xd:desc>Template to convert f:extension urlExtTimeInterval-Duration to tijdsduur element.</xd:desc>
   </xd:doc>
   <xsl:template match="f:extension[@url = ($urlExtTimeInterval-Duration, $urlExtTimeIntervalDuration)]"
                 mode="urlExtTimeInterval-Duration">
      <xsl:call-template name="Duration-to-hoeveelheid">
         <xsl:with-param name="in"
                         select="f:valueDuration"/>
         <xsl:with-param name="adaElementName">tijds_duur</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
</xsl:stylesheet>