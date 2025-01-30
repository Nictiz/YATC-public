<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.8.0-beta.1/all_zibs.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-01-29T18:25:49.35+01:00 == -->
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
   <xsl:import href="2_fhir_fhir_include-d620e271.xsl"/>
   <!-- If a file imported here exists in a different folder (meaning a different 'package'), this means the profile and therefore its ada2fhir mapping is the same in the current and the imported package version (and all versions in between). 
        If a bug is found and fixed, this fix should apply to the mapping in all versions of the package that use this mapping.
        If a profile is edited in a non-backwards compatible way, a new version of the ada2fhir mapping should be made for that profile. -->
   <xsl:import href="nl-core-AbilityToDressOneself-d620e272.xsl"/>
   <xsl:import href="nl-core-AbilityToDrink-d620e273.xsl"/>
   <xsl:import href="nl-core-AbilityToEat-d620e274.xsl"/>
   <xsl:import href="nl-core-AbilityToGroom-d620e275.xsl"/>
   <xsl:import href="nl-core-AbilityToUseToilet-d620e276.xsl"/>
   <xsl:import href="nl-core-AbilityToWashOneself-d620e278.xsl"/>
   <xsl:import href="nl-core-AddressInformation-d620e279.xsl"/>
   <xsl:import href="nl-core-AdvanceDirective-d620e280.xsl"/>
   <xsl:import href="nl-core-AlcoholUse-d620e281.xsl"/>
   <xsl:import href="nl-core-Alert-d620e282.xsl"/>
   <xsl:import href="nl-core-AllergyIntolerance-d620e283.xsl"/>
   <xsl:import href="nl-core-AnatomicalLocation-d620e284.xsl"/>
   <xsl:import href="nl-core-ApgarScore-d620e285.xsl"/>
   <xsl:import href="nl-core-BloodPressure-d620e286.xsl"/>
   <xsl:import href="nl-core-BodyHeight-d620e287.xsl"/>
   <xsl:import href="nl-core-BodyWeight-d620e288.xsl"/>
   <xsl:import href="nl-core-BodyTemperature-d620e290.xsl"/>
   <xsl:import href="nl-core-CareTeam-d620e291.xsl"/>
   <xsl:import href="nl-core-ComfortScale-d620e292.xsl"/>
   <xsl:import href="nl-core-ContactInformation-d620e293.xsl"/>
   <xsl:import href="nl-core-ContactPerson-d620e294.xsl"/>
   <xsl:import href="nl-core-DOSScore-d620e295.xsl"/>
   <xsl:import href="nl-core-DrugUse-d620e296.xsl"/>
   <xsl:import href="nl-core-Education-d620e297.xsl"/>
   <xsl:import href="nl-core-Encounter-d620e298.xsl"/>
   <xsl:import href="nl-core-EpisodeOfCare-d620e299.xsl"/>
   <xsl:import href="nl-core-FLACCpainScale-d620e300.xsl"/>
   <xsl:import href="nl-core-FluidBalance-d620e302.xsl"/>
   <xsl:import href="nl-core-FreedomRestrictingIntervention-d620e303.xsl"/>
   <xsl:import href="nl-core-FunctionalOrMentalStatus-d620e304.xsl"/>
   <xsl:import href="nl-core-HeadCircumference-d620e305.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-d620e306.xsl"/>
   <xsl:import href="nl-core-HealthcareProvider-d620e307.xsl"/>
   <xsl:import href="nl-core-HearingFunction-d620e308.xsl"/>
   <xsl:import href="nl-core-HeartRate-d620e309.xsl"/>
   <xsl:import href="nl-core-HelpFromOthers-d620e310.xsl"/>
   <xsl:import href="nl-core-LaboratoryTestResult-d620e311.xsl"/>
   <xsl:import href="nl-core-LegalSituation-d620e312.xsl"/>
   <xsl:import href="nl-core-LivingSituation-d620e314.xsl"/>
   <xsl:import href="nl-core-MedicalDevice-d620e315.xsl"/>
   <xsl:import href="nl-core-MedicationContraIndication-d620e316.xsl"/>
   <xsl:import href="nl-core-Mobility-d620e317.xsl"/>
   <xsl:import href="nl-core-MUSTScore-d620e318.xsl"/>
   <xsl:import href="nl-core-NameInformation-d620e319.xsl"/>
   <xsl:import href="nl-core-NutritionAdvice-d620e320.xsl"/>
   <xsl:import href="nl-core-O2Saturation-d620e321.xsl"/>
   <xsl:import href="nl-core-ParticipationInSociety-d620e322.xsl"/>
   <xsl:import href="nl-core-Patient-d620e323.xsl"/>
   <xsl:import href="nl-core-Payer-d620e324.xsl"/>
   <xsl:import href="nl-core-PharmaceuticalProduct-d620e326.xsl"/>
   <xsl:import href="nl-core-Problem-d620e327.xsl"/>
   <xsl:import href="nl-core-Procedure-d620e328.xsl"/>
   <xsl:import href="nl-core-Refraction-d620e329.xsl"/>
   <xsl:import href="nl-core-SOAPReport-d620e330.xsl"/>
   <xsl:import href="nl-core-Stoma-d620e331.xsl"/>
   <xsl:import href="nl-core-TextResult-d620e332.xsl"/>
   <xsl:import href="nl-core-TobaccoUse-d620e333.xsl"/>
   <xsl:import href="nl-core-TreatmentDirective2-d620e334.xsl"/>
   <xsl:import href="nl-core-Vaccination-d620e335.xsl"/>
   <xsl:import href="nl-core-VisualAcuity-d620e336.xsl"/>
   <xsl:import href="nl-core-VisualFunction-d620e338.xsl"/>
   <xsl:import href="ext-CodeSpecification-d620e339.xsl"/>
   <xsl:import href="ext-Comment-d620e340.xsl"/>
   <xsl:import href="ext-CopyIndicator-d620e341.xsl"/>
   <xsl:import href="ext-TimeInterval-d620e342.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <!-- ================================================================== -->
</xsl:stylesheet>