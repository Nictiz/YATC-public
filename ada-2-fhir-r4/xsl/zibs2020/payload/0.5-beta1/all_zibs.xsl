<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="urn:fhir:stu3:functions" xmlns:nm="http://www.nictiz.nl/mappings">
    <!-- ================================================================== -->
    <!--
        This document import common and zib- and nl-core specific functions and templates to convert zib2020 ada instances to FHIR.
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

    <xsl:import href="../../../fhir/2_fhir_fhir_include.xsl"/>

    <!-- If a file imported here exists in a different folder (meaning a different 'package'), this means the profile and 
        therefore its ada2fhir mapping is the same in the current and the imported package version (and all versions in between). 
        If a bug is found and fixed, this fix should apply to the mapping in all versions of the package that use this mapping.
        If a profile is edited in a non-backwards compatible way, a new version of the ada2fhir mapping should be made for that profile. -->
    <xsl:import href="nl-core-AddressInformation.xsl"/>
    <xsl:import href="nl-core-AdvanceDirective.xsl"/>
    <xsl:import href="nl-core-AlcoholUse.xsl"/>
    <xsl:import href="nl-core-Alert.xsl"/>
    <xsl:import href="nl-core-AllergyIntolerance.xsl"/>
    <xsl:import href="nl-core-AnatomicalLocation.xsl"/>
    <xsl:import href="nl-core-BloodPressure.xsl"/>
    <xsl:import href="nl-core-BodyHeight.xsl"/>
    <xsl:import href="nl-core-BodyWeight.xsl"/>
    <xsl:import href="nl-core-BodyTemperature.xsl"/>
    <xsl:import href="nl-core-CareTeam.xsl"/>
    <xsl:import href="nl-core-ContactInformation.xsl"/>
    <xsl:import href="nl-core-ContactPerson.xsl"/>
    <xsl:import href="nl-core-DrugUse.xsl"/>
    <xsl:import href="nl-core-Encounter.xsl"/>
    <xsl:import href="nl-core-EpisodeOfcare.xsl"/>
    <xsl:import href="nl-core-FunctionalOrMentalStatus.xsl"/>
    <xsl:import href="nl-core-HeadCircumference.xsl"/>
    <xsl:import href="nl-core-HealthProfessional.xsl"/>
    <xsl:import href="nl-core-HealthcareProvider.xsl"/>
    <xsl:import href="nl-core-HearingFunction.xsl"/>
    <xsl:import href="nl-core-HeartRate.xsl"/>
    <xsl:import href="nl-core-LivingSituation.xsl"/>
    <xsl:import href="nl-core-MedicalDevice.xsl"/>
    <xsl:import href="nl-core-Mobility.xsl"/>
    <xsl:import href="nl-core-NameInformation.xsl"/>
    <xsl:import href="nl-core-O2Saturation.xsl"/>
    <xsl:import href="nl-core-Patient.xsl"/>
    <xsl:import href="nl-core-PharmaceuticalProduct.xsl"/>
    <xsl:import href="nl-core-Problem.xsl"/>
    <xsl:import href="nl-core-Procedure.xsl"/>
    <xsl:import href="nl-core-TextResult.xsl"/>
    <xsl:import href="nl-core-TobaccoUse.xsl"/>
    <xsl:import href="nl-core-Vaccination.xsl"/>
    <xsl:import href="nl-core-VisualFunction.xsl"/>

    <xsl:import href="ext-CodeSpecification.xsl"/>
    <xsl:import href="ext-Comment.xsl"/>
    <xsl:import href="ext-CopyIndicator.xsl"/>
    <xsl:import href="ext-TimeInterval.xsl"/>

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- ================================================================== -->
</xsl:stylesheet>
