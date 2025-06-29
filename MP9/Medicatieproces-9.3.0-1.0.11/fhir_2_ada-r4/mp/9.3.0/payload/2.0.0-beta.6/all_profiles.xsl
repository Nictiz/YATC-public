<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/mp/9.3.0/payload/2.0.0-beta.6/all_profiles.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
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
   <xsl:import href="../../../../../common/includes/all_zibs-d570e243.xsl"/>
   <xsl:import href="../2.0.0-beta.5/ext-MedicationAgreementPeriodOfUseCondition.xsl"/>
   <xsl:import href="../2.0.0-beta.5/ext-RegistrationDateTime.xsl"/>
   <xsl:import href="../2.0.0-beta.5/mp-AdministrationAgreement.xsl"/>
   <xsl:import href="mp-DispenseRequest.xsl"/>
   <xsl:import href="../2.0.0-beta.5/mp-InstructionsForUse.xsl"/>
   <xsl:import href="mp-MedicationAdministration.xsl"/>
   <xsl:import href="../2.0.0-beta.5/mp-MedicationAgreement.xsl"/>
   <xsl:import href="../2.0.0-beta.5/mp-MedicationDispense.xsl"/>
   <xsl:import href="../2.0.0-beta.5/mp-MedicationUse2.xsl"/>
   <xsl:import href="../2.0.0-beta.5/mp-VariableDosingRegimen.xsl"/>
   <xsl:import href="../2.0.0-beta.1/mp-voorstel.xsl"/>
   <xsl:import href="../2.0.0-beta.1/mp-antwoord.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc scope="stylesheet">
      <xd:desc>This document imports common and mp specific functions and templates to convert mp ada instances to FHIR.</xd:desc>
   </xd:doc>
</xsl:stylesheet>