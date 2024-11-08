<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/ext-MedicationAgreementPeriodOfUseCondition.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.2; 2024-05-02T14:16:32.98+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <xd:doc>
      <xd:desc>Template to convert f:extension $urlExtMedicationAgreementPeriodOfUseCondition to criterium element.</xd:desc>
   </xd:doc>
   <xsl:template match="f:extension[@url = $urlExtMedicationAgreementPeriodOfUseCondition]"
                 mode="urlExtMedicationAgreementPeriodOfUseCondition">
      <criterium value="{f:valueString/@value}"/>
   </xsl:template>
</xsl:stylesheet>