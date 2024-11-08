<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/all_zibs.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.3; 2024-07-23T09:24:32.82+02:00 == -->
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
   <xsl:import href="constants-d821e266.xsl"/>
   <xsl:import href="datetime-d821e267.xsl"/>
   <xsl:import href="units-d821e268.xsl"/>
   <xsl:import href="utilities-d821e269.xsl"/>
   <xsl:import href="fhir_2_ada_fhir_include-d821e299.xsl"/>
   <xsl:import href="mp-functions-d821e262.xsl"/>
   <xsl:import href="contextContactEpisodeOfCare.xsl"/>
   <xsl:import href="ext-CopyIndicator-d821e301.xsl"/>
   <xsl:import href="ext-StopType.xsl"/>
   <xsl:import href="ext-TimeInterval-Duration.xsl"/>
   <xsl:import href="ext-TimeInterval-Period.xsl"/>
   <xsl:import href="nl-core-AddressInformation-d821e305.xsl"/>
   <xsl:import href="nl-core-BodyHeight-d821e306.xsl"/>
   <xsl:import href="nl-core-BodyWeight-d821e307.xsl"/>
   <xsl:import href="nl-core-ContactInformation-d821e309.xsl"/>
   <xsl:import href="nl-core-ContactPerson-d821e310.xsl"/>
   <xsl:import href="nl-core-HealthcareProvider-Organization.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-Practitioner.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-PractitionerRole.xsl"/>
   <xsl:import href="nl-core-LaboratoryTestResult-d821e314.xsl"/>
   <xsl:import href="nl-core-NameInformation-d821e315.xsl"/>
   <xsl:import href="nl-core-Note.xsl"/>
   <xsl:import href="nl-core-Patient-d821e317.xsl"/>
   <xsl:import href="nl-core-PharmaceuticalProduct-d821e318.xsl"/>
   <xsl:import href="nl-core-Problem-d821e319.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="fhirVersion">R4</xsl:param>
   <xd:doc scope="stylesheet">
      <xd:desc>This document import common and zib- and nl-core specific functions and templates to convert FHIR zib instances to ada.</xd:desc>
   </xd:doc>
</xsl:stylesheet>