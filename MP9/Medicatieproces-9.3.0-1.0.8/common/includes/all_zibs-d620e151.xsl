<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.8.0-beta.1/all_zibs.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-01-29T18:25:49.35+01:00 == -->
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
   <xsl:import href="2_fhir_fhir_include-d620e152.xsl"/>
   <!-- If a file imported here exists in a different folder (meaning a different 'package'), this means the profile and therefore its ada2fhir mapping is the same in the current and the imported package version (and all versions in between). 
        If a bug is found and fixed, this fix should apply to the mapping in all versions of the package that use this mapping.
        If a profile is edited in a non-backwards compatible way, a new version of the ada2fhir mapping should be made for that profile. -->
   <xsl:import href="nl-core-AbilityToDressOneself-d620e155.xsl"/>
   <xsl:import href="nl-core-AbilityToDrink-d620e156.xsl"/>
   <xsl:import href="nl-core-AbilityToEat-d620e158.xsl"/>
   <xsl:import href="nl-core-AbilityToGroom-d620e159.xsl"/>
   <xsl:import href="nl-core-AbilityToUseToilet-d620e160.xsl"/>
   <xsl:import href="nl-core-AbilityToWashOneself-d620e161.xsl"/>
   <xsl:import href="nl-core-AddressInformation-d620e162.xsl"/>
   <xsl:import href="nl-core-AdvanceDirective-d620e163.xsl"/>
   <xsl:import href="nl-core-AlcoholUse-d620e164.xsl"/>
   <xsl:import href="nl-core-Alert-d620e165.xsl"/>
   <xsl:import href="nl-core-AllergyIntolerance-d620e166.xsl"/>
   <xsl:import href="nl-core-AnatomicalLocation-d620e167.xsl"/>
   <xsl:import href="nl-core-ApgarScore-d620e168.xsl"/>
   <xsl:import href="nl-core-BloodPressure-d620e170.xsl"/>
   <xsl:import href="nl-core-BodyHeight-d620e171.xsl"/>
   <xsl:import href="nl-core-BodyWeight-d620e172.xsl"/>
   <xsl:import href="nl-core-BodyTemperature-d620e173.xsl"/>
   <xsl:import href="nl-core-CareTeam-d620e174.xsl"/>
   <xsl:import href="nl-core-ComfortScale-d620e175.xsl"/>
   <xsl:import href="nl-core-ContactInformation-d620e176.xsl"/>
   <xsl:import href="nl-core-ContactPerson-d620e177.xsl"/>
   <xsl:import href="nl-core-DOSScore-d620e178.xsl"/>
   <xsl:import href="nl-core-DrugUse-d620e179.xsl"/>
   <xsl:import href="nl-core-Education-d620e180.xsl"/>
   <xsl:import href="nl-core-Encounter-d620e182.xsl"/>
   <xsl:import href="nl-core-EpisodeOfCare-d620e183.xsl"/>
   <xsl:import href="nl-core-FLACCpainScale-d620e184.xsl"/>
   <xsl:import href="nl-core-FluidBalance-d620e185.xsl"/>
   <xsl:import href="nl-core-FreedomRestrictingIntervention-d620e186.xsl"/>
   <xsl:import href="nl-core-FunctionalOrMentalStatus-d620e187.xsl"/>
   <xsl:import href="nl-core-HeadCircumference-d620e188.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-d620e189.xsl"/>
   <xsl:import href="nl-core-HealthcareProvider-d620e190.xsl"/>
   <xsl:import href="nl-core-HearingFunction-d620e191.xsl"/>
   <xsl:import href="nl-core-HeartRate-d620e192.xsl"/>
   <xsl:import href="nl-core-HelpFromOthers-d620e194.xsl"/>
   <xsl:import href="nl-core-LaboratoryTestResult-d620e195.xsl"/>
   <xsl:import href="nl-core-LegalSituation-d620e196.xsl"/>
   <xsl:import href="nl-core-LivingSituation-d620e197.xsl"/>
   <xsl:import href="nl-core-MedicalDevice-d620e198.xsl"/>
   <xsl:import href="nl-core-MedicationContraIndication-d620e199.xsl"/>
   <xsl:import href="nl-core-Mobility-d620e200.xsl"/>
   <xsl:import href="nl-core-MUSTScore-d620e201.xsl"/>
   <xsl:import href="nl-core-NameInformation-d620e202.xsl"/>
   <xsl:import href="nl-core-NutritionAdvice-d620e203.xsl"/>
   <xsl:import href="nl-core-O2Saturation-d620e204.xsl"/>
   <xsl:import href="nl-core-ParticipationInSociety-d620e206.xsl"/>
   <xsl:import href="nl-core-Patient-d620e207.xsl"/>
   <xsl:import href="nl-core-Payer-d620e208.xsl"/>
   <xsl:import href="nl-core-PharmaceuticalProduct-d620e209.xsl"/>
   <xsl:import href="nl-core-Problem-d620e210.xsl"/>
   <xsl:import href="nl-core-Procedure-d620e211.xsl"/>
   <xsl:import href="nl-core-Refraction-d620e212.xsl"/>
   <xsl:import href="nl-core-SOAPReport-d620e213.xsl"/>
   <xsl:import href="nl-core-Stoma-d620e214.xsl"/>
   <xsl:import href="nl-core-TextResult-d620e215.xsl"/>
   <xsl:import href="nl-core-TobaccoUse-d620e216.xsl"/>
   <xsl:import href="nl-core-TreatmentDirective2-d620e218.xsl"/>
   <xsl:import href="nl-core-Vaccination-d620e219.xsl"/>
   <xsl:import href="nl-core-VisualAcuity-d620e220.xsl"/>
   <xsl:import href="nl-core-VisualFunction-d620e221.xsl"/>
   <xsl:import href="ext-CodeSpecification-d620e222.xsl"/>
   <xsl:import href="ext-Comment-d620e223.xsl"/>
   <xsl:import href="ext-CopyIndicator-d620e224.xsl"/>
   <xsl:import href="ext-TimeInterval-d620e225.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc scope="stylesheet">
      <xd:desc>This document imports common and zib and nl-core specific functions and templates to convert zib2020 ada instances to FHIR.</xd:desc>
   </xd:doc>
</xsl:stylesheet>