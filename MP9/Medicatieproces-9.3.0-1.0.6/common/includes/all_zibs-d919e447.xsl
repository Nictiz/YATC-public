<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.8.0-beta.1/all_zibs.xsl == -->
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
   <xsl:import href="2_fhir_fhir_include-d919e448.xsl"/>
   <!-- If a file imported here exists in a different folder (meaning a different 'package'), this means the profile and therefore its ada2fhir mapping is the same in the current and the imported package version (and all versions in between). 
        If a bug is found and fixed, this fix should apply to the mapping in all versions of the package that use this mapping.
        If a profile is edited in a non-backwards compatible way, a new version of the ada2fhir mapping should be made for that profile. -->
   <xsl:import href="nl-core-AbilityToDressOneself-d919e449.xsl"/>
   <xsl:import href="nl-core-AbilityToDrink-d919e450.xsl"/>
   <xsl:import href="nl-core-AbilityToEat-d919e451.xsl"/>
   <xsl:import href="nl-core-AbilityToGroom-d919e453.xsl"/>
   <xsl:import href="nl-core-AbilityToUseToilet-d919e454.xsl"/>
   <xsl:import href="nl-core-AbilityToWashOneself-d919e455.xsl"/>
   <xsl:import href="nl-core-AddressInformation-d919e456.xsl"/>
   <xsl:import href="nl-core-AdvanceDirective-d919e457.xsl"/>
   <xsl:import href="nl-core-AlcoholUse-d919e458.xsl"/>
   <xsl:import href="nl-core-Alert-d919e459.xsl"/>
   <xsl:import href="nl-core-AllergyIntolerance-d919e460.xsl"/>
   <xsl:import href="nl-core-AnatomicalLocation-d919e461.xsl"/>
   <xsl:import href="nl-core-ApgarScore-d919e462.xsl"/>
   <xsl:import href="nl-core-BloodPressure-d919e463.xsl"/>
   <xsl:import href="nl-core-BodyHeight-d919e465.xsl"/>
   <xsl:import href="nl-core-BodyWeight-d919e466.xsl"/>
   <xsl:import href="nl-core-BodyTemperature-d919e467.xsl"/>
   <xsl:import href="nl-core-CareTeam-d919e468.xsl"/>
   <xsl:import href="nl-core-ComfortScale-d919e469.xsl"/>
   <xsl:import href="nl-core-ContactInformation-d919e470.xsl"/>
   <xsl:import href="nl-core-ContactPerson-d919e471.xsl"/>
   <xsl:import href="nl-core-DOSScore-d919e472.xsl"/>
   <xsl:import href="nl-core-DrugUse-d919e473.xsl"/>
   <xsl:import href="nl-core-Education-d919e474.xsl"/>
   <xsl:import href="nl-core-Encounter-d919e475.xsl"/>
   <xsl:import href="nl-core-EpisodeOfCare-d919e477.xsl"/>
   <xsl:import href="nl-core-FLACCpainScale-d919e478.xsl"/>
   <xsl:import href="nl-core-FluidBalance-d919e479.xsl"/>
   <xsl:import href="nl-core-FreedomRestrictingIntervention-d919e480.xsl"/>
   <xsl:import href="nl-core-FunctionalOrMentalStatus-d919e481.xsl"/>
   <xsl:import href="nl-core-HeadCircumference-d919e482.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-d919e483.xsl"/>
   <xsl:import href="nl-core-HealthcareProvider-d919e484.xsl"/>
   <xsl:import href="nl-core-HearingFunction-d919e485.xsl"/>
   <xsl:import href="nl-core-HeartRate-d919e486.xsl"/>
   <xsl:import href="nl-core-HelpFromOthers-d919e487.xsl"/>
   <xsl:import href="nl-core-LaboratoryTestResult-d919e489.xsl"/>
   <xsl:import href="nl-core-LegalSituation-d919e490.xsl"/>
   <xsl:import href="nl-core-LivingSituation-d919e491.xsl"/>
   <xsl:import href="nl-core-MedicalDevice-d919e492.xsl"/>
   <xsl:import href="nl-core-MedicationContraIndication-d919e493.xsl"/>
   <xsl:import href="nl-core-Mobility-d919e494.xsl"/>
   <xsl:import href="nl-core-MUSTScore-d919e495.xsl"/>
   <xsl:import href="nl-core-NameInformation-d919e496.xsl"/>
   <xsl:import href="nl-core-NutritionAdvice-d919e497.xsl"/>
   <xsl:import href="nl-core-O2Saturation-d919e498.xsl"/>
   <xsl:import href="nl-core-ParticipationInSociety-d919e499.xsl"/>
   <xsl:import href="nl-core-Patient-d919e501.xsl"/>
   <xsl:import href="nl-core-Payer-d919e502.xsl"/>
   <xsl:import href="nl-core-PharmaceuticalProduct-d919e503.xsl"/>
   <xsl:import href="nl-core-Problem-d919e504.xsl"/>
   <xsl:import href="nl-core-Procedure-d919e505.xsl"/>
   <xsl:import href="nl-core-Refraction-d919e506.xsl"/>
   <xsl:import href="nl-core-SOAPReport-d919e507.xsl"/>
   <xsl:import href="nl-core-Stoma-d919e508.xsl"/>
   <xsl:import href="nl-core-TextResult-d919e509.xsl"/>
   <xsl:import href="nl-core-TobaccoUse-d919e510.xsl"/>
   <xsl:import href="nl-core-TreatmentDirective2-d919e511.xsl"/>
   <xsl:import href="nl-core-Vaccination-d919e513.xsl"/>
   <xsl:import href="nl-core-VisualAcuity-d919e514.xsl"/>
   <xsl:import href="nl-core-VisualFunction-d919e515.xsl"/>
   <xsl:import href="ext-CodeSpecification-d919e516.xsl"/>
   <xsl:import href="ext-Comment-d919e517.xsl"/>
   <xsl:import href="ext-CopyIndicator-d919e518.xsl"/>
   <xsl:import href="ext-TimeInterval-d919e519.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <!-- ================================================================== -->
</xsl:stylesheet>