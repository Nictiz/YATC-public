<?xml version="1.0" encoding="UTF-8"?>

<!-- == Flattened from: C:/xdata/Nictiz/HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/all_zibs.xsl == -->
<!--
Copyright (c) Nictiz

This program is free software; you can redistribute it and/or modify it under the terms of the
GNU Lesser General Public License as published by the Free Software Foundation; either version
2.1 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU Lesser General Public License for more details.

The full text of the license is available at http://www.gnu.org/copyleft/lesser.html
-->
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
   <xsl:import href="fhir_2_ada_fhir_include-d4e24.xsl"/>
   <xsl:import href="mp-functions.xsl"/>
   <xsl:import href="contextContactEpisodeOfCare.xsl"/>
   <xsl:import href="ext-CopyIndicator-d4e29.xsl"/>
   <xsl:import href="ext-MedicationAgreementPeriodOfUseCondition-d4e30.xsl"/>
   <xsl:import href="ext-TimeInterval-Duration.xsl"/>
   <xsl:import href="ext-TimeInterval-period.xsl"/>
   <xsl:import href="nl-core-AddressInformation-d4e33.xsl"/>
   <xsl:import href="nl-core-AdministrationAgreement.xsl"/>
   <xsl:import href="nl-core-BodyHeight-d4e35.xsl"/>
   <xsl:import href="nl-core-BodyWeight-d4e36.xsl"/>
   <xsl:import href="nl-core-ContactInformation-d4e37.xsl"/>
   <xsl:import href="nl-core-ContactPerson-d4e38.xsl"/>
   <xsl:import href="nl-core-DispenseRequest.xsl"/>
   <xsl:import href="nl-core-ext-StopType.xsl"/>
   <xsl:import href="nl-core-HealthcareProvider-Organization.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-Practitioner.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-PractitionerRole.xsl"/>
   <xsl:import href="nl-core-InstructionsForUse.xsl"/>
   <xsl:import href="nl-core-LaboratoryTestResult-d4e46.xsl"/>
   <xsl:import href="nl-core-MedicationAdministration.xsl"/>
   <xsl:import href="nl-core-MedicationAgreement.xsl"/>
   <xsl:import href="nl-core-MedicationDispense.xsl"/>
   <xsl:import href="nl-core-MedicationUse2.xsl"/>
   <xsl:import href="nl-core-NameInformation-d4e51.xsl"/>
   <xsl:import href="nl-core-Note.xsl"/>
   <xsl:import href="nl-core-Patient-d4e54.xsl"/>
   <xsl:import href="nl-core-PharmaceuticalProduct-d4e55.xsl"/>
   <xsl:import href="nl-core-Problem-d4e56.xsl"/>
   <xsl:import href="nl-core-VariableDosingRegimen.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="fhirVersion">R4</xsl:param>
   <xd:doc scope="stylesheet">
      <xd:desc>This document import common and zib- and nl-core specific functions and templates to convert FHIR zib instances to ada.</xd:desc>
   </xd:doc>
</xsl:stylesheet>