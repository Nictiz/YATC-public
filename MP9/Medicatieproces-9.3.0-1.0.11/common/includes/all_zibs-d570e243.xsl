<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/zibs/2020/payload/0.8.0-beta.1/all_zibs.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-05T16:01:14.01+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:nm="http://www.nictiz.nl/mappings"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <!-- ================================================================== -->
   <!--
        This document import common and zib- and nl-core specific functions and templates to convert FHIR zib instances to ada.
    -->
   <!-- ================================================================== -->
   <!--
        Copyright © Nictiz
        
        This program is free software; you can redistribute it and/or modify it under the terms of the
        GNU Lesser General Public License as published by the Free Software Foundation; either version
        2.1 of the License, or (at your option) any later version.
        
        This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
        without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
        See the GNU Lesser General Public License for more details.
        
        The full text of the license is available at http://www.gnu.org/copyleft/lesser.html
    -->
   <!-- ================================================================== -->
   <!-- moved import of util here to prevent duplicate import warnings due to fhir use in ada-hl7v3 conversions (dosageInstructions in FHIR) -->
   <xsl:import href="constants.xsl"/>
   <xsl:import href="datetime.xsl"/>
   <xsl:import href="units.xsl"/>
   <xsl:import href="utilities.xsl"/>
   <xsl:import href="fhir_2_ada_fhir_include-d570e240.xsl"/>
   <xsl:import href="mp-functions.xsl"/>
   <xsl:import href="contextContactEpisodeOfCare.xsl"/>
   <xsl:import href="ext-CopyIndicator-d570e245.xsl"/>
   <xsl:import href="ext-StopType.xsl"/>
   <xsl:import href="ext-TimeInterval-Duration.xsl"/>
   <xsl:import href="ext-TimeInterval-Period.xsl"/>
   <xsl:import href="nl-core-AddressInformation-d570e249.xsl"/>
   <xsl:import href="nl-core-BodyHeight-d570e250.xsl"/>
   <xsl:import href="nl-core-BodyWeight-d570e251.xsl"/>
   <xsl:import href="nl-core-ContactInformation-d570e252.xsl"/>
   <xsl:import href="nl-core-ContactPerson-d570e253.xsl"/>
   <xsl:import href="nl-core-HealthcareProvider-Organization.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-Practitioner.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-PractitionerRole.xsl"/>
   <xsl:import href="nl-core-LaboratoryTestResult-d570e258.xsl"/>
   <xsl:import href="nl-core-NameInformation-d570e259.xsl"/>
   <xsl:import href="nl-core-Note.xsl"/>
   <xsl:import href="nl-core-Patient-d570e261.xsl"/>
   <xsl:import href="nl-core-PharmaceuticalProduct-d570e262.xsl"/>
   <xsl:import href="nl-core-Problem-d570e263.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="fhirVersion">R4</xsl:param>
   <!-- ================================================================== -->
</xsl:stylesheet>