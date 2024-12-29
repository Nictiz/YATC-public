<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/mp/9.3.0/payload/2.0.0-beta.5/all_profiles.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.6; 2024-12-29T15:47:03.74+01:00 == -->
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
        This document imports common and mp specific functions and templates to convert mp ada instances to FHIR.
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
   <xsl:import href="all_zibs-d919e447.xsl"/>
   <xsl:import href="_ada2resourceType.xsl"/>
   <xsl:import href="mp-AdministrationAgreement.xsl"/>
   <xsl:import href="mp-DispenseRequest-d919e522.xsl"/>
   <xsl:import href="mp-InstructionsForUse.xsl"/>
   <xsl:import href="mp-MedicationAdministration2.xsl"/>
   <xsl:import href="mp-MedicationAgreement.xsl"/>
   <xsl:import href="mp-MedicationDispense-d919e527.xsl"/>
   <xsl:import href="mp-MedicationUse2.xsl"/>
   <xsl:import href="mp-VariableDosingRegimen.xsl"/>
   <xsl:import href="mp-functions.xsl"/>
   <xsl:import href="mp-PharmaceuticalProduct.xsl"/>
   <xsl:import href="ext-AsAgreedIndicator-d919e531.xsl"/>
   <xsl:import href="ext-PharmaceuticalTreatmentIdentifier-d919e532.xsl"/>
   <xsl:import href="ext-MedicationAgreementPeriodOfUseCondition-d919e533.xsl"/>
   <xsl:import href="ext-RegistrationDateTime.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <!-- ================================================================== -->
</xsl:stylesheet>