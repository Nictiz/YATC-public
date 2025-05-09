<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/ext-CopyIndicator.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.6; 2024-12-29T15:47:03.74+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <xd:doc>
      <xd:desc>Template to convert f:extension zib-Medication-CopyIndicator to kopie_indicator element.</xd:desc>
   </xd:doc>
   <xsl:template match="f:extension[@url = $urlExtCopyIndicator]"
                 mode="ext-CopyIndicator">
      <kopie_indicator>
         <xsl:attribute name="value"
                        select="f:valueBoolean/@value"/>
      </kopie_indicator>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:extension zib-Medication-CopyIndicator to kopie_indicator element.</xd:desc>
   </xd:doc>
   <xsl:template match="f:reportedBoolean"
                 mode="ext-CopyIndicator">
      <kopie_indicator>
         <xsl:attribute name="value"
                        select="@value"/>
      </kopie_indicator>
   </xsl:template>
</xsl:stylesheet>