<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.5/all_profiles.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.6; 2024-12-29T15:47:03.74+01:00 == -->
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
   <xsl:import href="../../../../../common/includes/all_zibs-d919e309.xsl"/>
   <xsl:import href="../2.0.0-beta.2/_ada2resourceType.xsl"/>
   <!-- Override the generic ada2resourceType variable with a version that used mp-PharmaceuticalProduct -->
   <xsl:import href="mp-AdministrationAgreement.xsl"/>
   <xsl:import href="../../../../../common/includes/mp-DispenseRequest-d919e384.xsl"/>
   <xsl:import href="mp-InstructionsForUse.xsl"/>
   <xsl:import href="mp-MedicationAdministration2.xsl"/>
   <xsl:import href="mp-MedicationAgreement.xsl"/>
   <xsl:import href="../../../../../common/includes/mp-MedicationDispense-d919e385.xsl"/>
   <xsl:import href="../2.0.0-beta.2/mp-MedicationUse2.xsl"/>
   <xsl:import href="mp-VariableDosingRegimen.xsl"/>
   <xsl:import href="../2.0.0-beta.2/mp-PharmaceuticalProduct.xsl"/>
   <xsl:import href="../../../../../common/includes/ext-AsAgreedIndicator-d919e386.xsl"/>
   <xsl:import href="../../../../../common/includes/ext-PharmaceuticalTreatmentIdentifier-d919e387.xsl"/>
   <xsl:import href="../../../../../common/includes/ext-MedicationAgreementPeriodOfUseCondition-d919e388.xsl"/>
   <xsl:import href="ext-RegistrationDateTime.xsl"/>
   <xsl:import href="../../../../../common/includes/mp-functions.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc scope="stylesheet">
      <xd:desc>This document imports common and mp specific functions and templates to convert mp ada instances to FHIR.</xd:desc>
   </xd:doc>
</xsl:stylesheet>