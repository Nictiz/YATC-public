<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/mp/9.3.0/payload/2.0.0-beta.2/all_profiles.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-04-07T14:39:48.07+02:00 == -->
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
   <xsl:import href="../../../../../../common/includes/all_zibs-d539e143.xsl"/>
   <xsl:import href="_ada2resourceType.xsl"/>
   <!-- Override the generic ada2resourceType variable with a version that used mp-PharmaceuticalProduct -->
   <xsl:import href="../../../../../../common/includes/mp-functions.xsl"/>
   <xsl:import href="mp-AdministrationAgreement.xsl"/>
   <xsl:import href="../../../../../../common/includes/mp-DispenseRequest.xsl"/>
   <xsl:import href="mp-InstructionsForUse.xsl"/>
   <xsl:import href="mp-MedicationAdministration2.xsl"/>
   <xsl:import href="mp-MedicationAgreement.xsl"/>
   <xsl:import href="../../../../../../common/includes/mp-MedicationDispense.xsl"/>
   <xsl:import href="mp-MedicationUse2.xsl"/>
   <xsl:import href="mp-VariableDosingRegimen.xsl"/>
   <xsl:import href="mp-PharmaceuticalProduct.xsl"/>
   <xsl:import href="../../../../../../common/includes/ext-AsAgreedIndicator.xsl"/>
   <xsl:import href="../../../../../../common/includes/ext-PharmaceuticalTreatmentIdentifier.xsl"/>
   <xsl:import href="../../../../../../common/includes/ext-MedicationAgreementPeriodOfUseCondition.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <!-- ================================================================== -->
</xsl:stylesheet>