<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.8.0-beta.1/all_zibs.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
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
        This document imports common and zib and nl-core specific functions and templates to convert zib2020 ada instances to FHIR.
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
   <xsl:import href="2_fhir_fhir_include-d570e161.xsl"/>
   <!-- If a file imported here exists in a different folder (meaning a different 'package'), this means the profile and therefore its ada2fhir mapping is the same in the current and the imported package version (and all versions in between). 
        If a bug is found and fixed, this fix should apply to the mapping in all versions of the package that use this mapping.
        If a profile is edited in a non-backwards compatible way, a new version of the ada2fhir mapping should be made for that profile. -->
   <xsl:import href="nl-core-AbilityToDressOneself.xsl"/>
   <xsl:import href="nl-core-AbilityToDrink.xsl"/>
   <xsl:import href="nl-core-AbilityToEat.xsl"/>
   <xsl:import href="nl-core-AbilityToGroom.xsl"/>
   <xsl:import href="nl-core-AbilityToUseToilet.xsl"/>
   <xsl:import href="nl-core-AbilityToWashOneself.xsl"/>
   <xsl:import href="nl-core-AddressInformation-d570e171.xsl"/>
   <xsl:import href="nl-core-AdvanceDirective.xsl"/>
   <xsl:import href="nl-core-AlcoholUse.xsl"/>
   <xsl:import href="nl-core-Alert.xsl"/>
   <xsl:import href="nl-core-AllergyIntolerance.xsl"/>
   <xsl:import href="nl-core-AnatomicalLocation.xsl"/>
   <xsl:import href="nl-core-ApgarScore.xsl"/>
   <xsl:import href="nl-core-BloodPressure.xsl"/>
   <xsl:import href="nl-core-BodyHeight-d570e179.xsl"/>
   <xsl:import href="nl-core-BodyWeight-d570e180.xsl"/>
   <xsl:import href="nl-core-BodyTemperature.xsl"/>
   <xsl:import href="nl-core-CareTeam.xsl"/>
   <xsl:import href="nl-core-ComfortScale.xsl"/>
   <xsl:import href="nl-core-ContactInformation-d570e185.xsl"/>
   <xsl:import href="nl-core-ContactPerson-d570e186.xsl"/>
   <xsl:import href="nl-core-DOSScore.xsl"/>
   <xsl:import href="nl-core-DrugUse.xsl"/>
   <xsl:import href="nl-core-Education.xsl"/>
   <xsl:import href="nl-core-Encounter.xsl"/>
   <xsl:import href="nl-core-EpisodeOfCare.xsl"/>
   <xsl:import href="nl-core-FLACCpainScale.xsl"/>
   <xsl:import href="nl-core-FluidBalance.xsl"/>
   <xsl:import href="nl-core-FreedomRestrictingIntervention.xsl"/>
   <xsl:import href="nl-core-FunctionalOrMentalStatus.xsl"/>
   <xsl:import href="nl-core-HeadCircumference.xsl"/>
   <xsl:import href="nl-core-HealthProfessional.xsl"/>
   <xsl:import href="nl-core-HealthcareProvider.xsl"/>
   <xsl:import href="nl-core-HearingFunction.xsl"/>
   <xsl:import href="nl-core-HeartRate.xsl"/>
   <xsl:import href="nl-core-HelpFromOthers.xsl"/>
   <xsl:import href="nl-core-LaboratoryTestResult-d570e203.xsl"/>
   <xsl:import href="nl-core-LegalSituation.xsl"/>
   <xsl:import href="nl-core-LivingSituation.xsl"/>
   <xsl:import href="nl-core-MedicalDevice.xsl"/>
   <xsl:import href="nl-core-MedicationContraIndication.xsl"/>
   <xsl:import href="nl-core-Mobility.xsl"/>
   <xsl:import href="nl-core-MUSTScore.xsl"/>
   <xsl:import href="nl-core-NameInformation-d570e211.xsl"/>
   <xsl:import href="nl-core-NutritionAdvice.xsl"/>
   <xsl:import href="nl-core-O2Saturation.xsl"/>
   <xsl:import href="nl-core-ParticipationInSociety.xsl"/>
   <xsl:import href="nl-core-Patient-d570e215.xsl"/>
   <xsl:import href="nl-core-Payer.xsl"/>
   <xsl:import href="nl-core-PharmaceuticalProduct-d570e217.xsl"/>
   <xsl:import href="nl-core-Problem-d570e219.xsl"/>
   <xsl:import href="nl-core-Procedure.xsl"/>
   <xsl:import href="nl-core-Refraction.xsl"/>
   <xsl:import href="nl-core-SOAPReport.xsl"/>
   <xsl:import href="nl-core-Stoma.xsl"/>
   <xsl:import href="nl-core-TextResult.xsl"/>
   <xsl:import href="nl-core-TobaccoUse.xsl"/>
   <xsl:import href="nl-core-TreatmentDirective2.xsl"/>
   <xsl:import href="nl-core-Vaccination.xsl"/>
   <xsl:import href="nl-core-VisualAcuity.xsl"/>
   <xsl:import href="nl-core-VisualFunction.xsl"/>
   <xsl:import href="ext-CodeSpecification.xsl"/>
   <xsl:import href="ext-Comment.xsl"/>
   <xsl:import href="ext-CopyIndicator-d570e233.xsl"/>
   <xsl:import href="ext-TimeInterval.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <!-- ================================================================== -->
</xsl:stylesheet>