<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/all_zibs.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.3.0; 2024-04-09T18:20:47.77+02:00 == -->
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
   <!-- moved import of util here to prevent duplicate import warnings due to fhir use in ada-hl7v3 conversions (dosageInstructions in FHIR) -->
   <xsl:import href="constants-d788e243.xsl"/>
   <xsl:import href="datetime-d788e244.xsl"/>
   <xsl:import href="units-d788e245.xsl"/>
   <xsl:import href="utilities-d788e246.xsl"/>
   <xsl:import href="fhir_2_ada_fhir_include-d788e279.xsl"/>
   <xsl:import href="mp-functions-d788e275.xsl"/>
   <xsl:import href="contextContactEpisodeOfCare.xsl"/>
   <xsl:import href="ext-CopyIndicator-d788e281.xsl"/>
   <xsl:import href="ext-MedicationAgreementPeriodOfUseCondition-d788e282.xsl"/>
   <xsl:import href="ext-StopType.xsl"/>
   <xsl:import href="ext-TimeInterval-Duration.xsl"/>
   <xsl:import href="ext-TimeInterval-Period.xsl"/>
   <xsl:import href="nl-core-AddressInformation-d788e286.xsl"/>
   <xsl:import href="nl-core-AdministrationAgreement.xsl"/>
   <xsl:import href="nl-core-BodyHeight-d788e289.xsl"/>
   <xsl:import href="nl-core-BodyWeight-d788e290.xsl"/>
   <xsl:import href="nl-core-ContactInformation-d788e291.xsl"/>
   <xsl:import href="nl-core-ContactPerson-d788e292.xsl"/>
   <xsl:import href="nl-core-DispenseRequest.xsl"/>
   <xsl:import href="nl-core-HealthcareProvider-Organization.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-Practitioner.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-PractitionerRole.xsl"/>
   <xsl:import href="nl-core-InstructionsForUse.xsl"/>
   <xsl:import href="nl-core-LaboratoryTestResult-d788e298.xsl"/>
   <xsl:import href="nl-core-MedicationAdministration.xsl"/>
   <xsl:import href="nl-core-MedicationAgreement.xsl"/>
   <xsl:import href="nl-core-MedicationDispense.xsl"/>
   <xsl:import href="nl-core-MedicationUse2.xsl"/>
   <xsl:import href="nl-core-NameInformation-d788e304.xsl"/>
   <xsl:import href="nl-core-Note.xsl"/>
   <xsl:import href="nl-core-Patient-d788e306.xsl"/>
   <xsl:import href="nl-core-PharmaceuticalProduct-d788e307.xsl"/>
   <xsl:import href="nl-core-Problem-d788e308.xsl"/>
   <xsl:import href="nl-core-VariableDosingRegimen.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="fhirVersion">R4</xsl:param>
   <xd:doc scope="stylesheet">
      <xd:desc>This document import common and zib- and nl-core specific functions and templates to convert FHIR zib instances to ada.</xd:desc>
   </xd:doc>
</xsl:stylesheet>