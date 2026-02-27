<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/mp/9.3.0/payload/2.0.0-rc.2/all_profiles.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.12; 2026-02-27T13:57:54.56+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:nm="http://www.nictiz.nl/mappings"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <!-- MP9 3.0.0-rc.1 uses fhir nl-core 0.11.0-beta.1 https://simplifier.net/packages/nictiz.fhir.nl.r4.nl-core/0.11.0-beta.1 -->
   <xsl:import href="all_zibs-d614e175.xsl"/>
   <xsl:import href="mp-functions.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-rc.2/mp-AdministrationAgreement.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.6/mp-DispenseRequest.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.5/mp-InstructionsForUse.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.6/mp-MedicationAdministration2.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-rc.2/mp-MedicationAgreement.xsl"/>
   <xsl:import href="mp-MedicationDispense.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.2/mp-MedicationUse2.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.5/mp-VariableDosingRegimen.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.2/mp-PharmaceuticalProduct.xsl"/>
   <xsl:import href="ext-AsAgreedIndicator.xsl"/>
   <xsl:import href="ext-PharmaceuticalTreatmentIdentifier.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.5/ext-RegistrationDateTime.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-rc.2/ext-PeriodOfUseCondition.xsl"/>
   <xsl:import href="../../ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-rc.2/ext-mp-TimeIntervalPeriod.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc scope="stylesheet">
      <xd:desc>This document imports common and mp specific functions and templates to convert mp ada instances to FHIR.</xd:desc>
   </xd:doc>
</xsl:stylesheet>