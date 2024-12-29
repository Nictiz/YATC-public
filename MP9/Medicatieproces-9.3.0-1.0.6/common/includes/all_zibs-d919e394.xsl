<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/all_zibs.xsl == -->
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
   <!-- moved import of util here to prevent duplicate import warnings due to fhir use in ada-hl7v3 conversions (dosageInstructions in FHIR) -->
   <xsl:import href="constants.xsl"/>
   <xsl:import href="datetime.xsl"/>
   <xsl:import href="units.xsl"/>
   <xsl:import href="utilities.xsl"/>
   <xsl:import href="fhir_2_ada_fhir_include-d919e391.xsl"/>
   <xsl:import href="mp-functions.xsl"/>
   <xsl:import href="contextContactEpisodeOfCare.xsl"/>
   <xsl:import href="ext-CopyIndicator-d919e396.xsl"/>
   <xsl:import href="ext-StopType.xsl"/>
   <xsl:import href="ext-TimeInterval-Duration.xsl"/>
   <xsl:import href="ext-TimeInterval-Period.xsl"/>
   <xsl:import href="nl-core-AddressInformation-d919e400.xsl"/>
   <xsl:import href="nl-core-BodyHeight-d919e401.xsl"/>
   <xsl:import href="nl-core-BodyWeight-d919e402.xsl"/>
   <xsl:import href="nl-core-ContactInformation-d919e403.xsl"/>
   <xsl:import href="nl-core-ContactPerson-d919e405.xsl"/>
   <xsl:import href="nl-core-HealthcareProvider-Organization.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-Practitioner.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-PractitionerRole.xsl"/>
   <xsl:import href="nl-core-LaboratoryTestResult-d919e409.xsl"/>
   <xsl:import href="nl-core-NameInformation-d919e410.xsl"/>
   <xsl:import href="nl-core-Note.xsl"/>
   <xsl:import href="nl-core-Patient-d919e412.xsl"/>
   <xsl:import href="nl-core-PharmaceuticalProduct-d919e413.xsl"/>
   <xsl:import href="nl-core-Problem-d919e414.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="fhirVersion">R4</xsl:param>
   <xd:doc scope="stylesheet">
      <xd:desc>This document import common and zib- and nl-core specific functions and templates to convert FHIR zib instances to ada.</xd:desc>
   </xd:doc>
</xsl:stylesheet>