<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.8.0-beta.1/all_zibs.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.6; 2024-12-29T15:47:03.74+01:00 == -->
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
   <xsl:import href="2_fhir_fhir_include-d919e310.xsl"/>
   <!-- If a file imported here exists in a different folder (meaning a different 'package'), this means the profile and therefore its ada2fhir mapping is the same in the current and the imported package version (and all versions in between). 
        If a bug is found and fixed, this fix should apply to the mapping in all versions of the package that use this mapping.
        If a profile is edited in a non-backwards compatible way, a new version of the ada2fhir mapping should be made for that profile. -->
   <xsl:import href="nl-core-AbilityToDressOneself-d919e313.xsl"/>
   <xsl:import href="nl-core-AbilityToDrink-d919e314.xsl"/>
   <xsl:import href="nl-core-AbilityToEat-d919e315.xsl"/>
   <xsl:import href="nl-core-AbilityToGroom-d919e316.xsl"/>
   <xsl:import href="nl-core-AbilityToUseToilet-d919e317.xsl"/>
   <xsl:import href="nl-core-AbilityToWashOneself-d919e318.xsl"/>
   <xsl:import href="nl-core-AddressInformation-d919e319.xsl"/>
   <xsl:import href="nl-core-AdvanceDirective-d919e321.xsl"/>
   <xsl:import href="nl-core-AlcoholUse-d919e322.xsl"/>
   <xsl:import href="nl-core-Alert-d919e323.xsl"/>
   <xsl:import href="nl-core-AllergyIntolerance-d919e324.xsl"/>
   <xsl:import href="nl-core-AnatomicalLocation-d919e325.xsl"/>
   <xsl:import href="nl-core-ApgarScore-d919e326.xsl"/>
   <xsl:import href="nl-core-BloodPressure-d919e327.xsl"/>
   <xsl:import href="nl-core-BodyHeight-d919e328.xsl"/>
   <xsl:import href="nl-core-BodyWeight-d919e329.xsl"/>
   <xsl:import href="nl-core-BodyTemperature-d919e330.xsl"/>
   <xsl:import href="nl-core-CareTeam-d919e331.xsl"/>
   <xsl:import href="nl-core-ComfortScale-d919e333.xsl"/>
   <xsl:import href="nl-core-ContactInformation-d919e334.xsl"/>
   <xsl:import href="nl-core-ContactPerson-d919e335.xsl"/>
   <xsl:import href="nl-core-DOSScore-d919e336.xsl"/>
   <xsl:import href="nl-core-DrugUse-d919e337.xsl"/>
   <xsl:import href="nl-core-Education-d919e338.xsl"/>
   <xsl:import href="nl-core-Encounter-d919e339.xsl"/>
   <xsl:import href="nl-core-EpisodeOfCare-d919e340.xsl"/>
   <xsl:import href="nl-core-FLACCpainScale-d919e341.xsl"/>
   <xsl:import href="nl-core-FluidBalance-d919e342.xsl"/>
   <xsl:import href="nl-core-FreedomRestrictingIntervention-d919e343.xsl"/>
   <xsl:import href="nl-core-FunctionalOrMentalStatus-d919e345.xsl"/>
   <xsl:import href="nl-core-HeadCircumference-d919e346.xsl"/>
   <xsl:import href="nl-core-HealthProfessional-d919e347.xsl"/>
   <xsl:import href="nl-core-HealthcareProvider-d919e348.xsl"/>
   <xsl:import href="nl-core-HearingFunction-d919e349.xsl"/>
   <xsl:import href="nl-core-HeartRate-d919e350.xsl"/>
   <xsl:import href="nl-core-HelpFromOthers-d919e351.xsl"/>
   <xsl:import href="nl-core-LaboratoryTestResult-d919e352.xsl"/>
   <xsl:import href="nl-core-LegalSituation-d919e353.xsl"/>
   <xsl:import href="nl-core-LivingSituation-d919e354.xsl"/>
   <xsl:import href="nl-core-MedicalDevice-d919e355.xsl"/>
   <xsl:import href="nl-core-MedicationContraIndication-d919e357.xsl"/>
   <xsl:import href="nl-core-Mobility-d919e358.xsl"/>
   <xsl:import href="nl-core-MUSTScore-d919e359.xsl"/>
   <xsl:import href="nl-core-NameInformation-d919e360.xsl"/>
   <xsl:import href="nl-core-NutritionAdvice-d919e361.xsl"/>
   <xsl:import href="nl-core-O2Saturation-d919e362.xsl"/>
   <xsl:import href="nl-core-ParticipationInSociety-d919e363.xsl"/>
   <xsl:import href="nl-core-Patient-d919e364.xsl"/>
   <xsl:import href="nl-core-Payer-d919e365.xsl"/>
   <xsl:import href="nl-core-PharmaceuticalProduct-d919e366.xsl"/>
   <xsl:import href="nl-core-Problem-d919e367.xsl"/>
   <xsl:import href="nl-core-Procedure-d919e369.xsl"/>
   <xsl:import href="nl-core-Refraction-d919e370.xsl"/>
   <xsl:import href="nl-core-SOAPReport-d919e371.xsl"/>
   <xsl:import href="nl-core-Stoma-d919e372.xsl"/>
   <xsl:import href="nl-core-TextResult-d919e373.xsl"/>
   <xsl:import href="nl-core-TobaccoUse-d919e374.xsl"/>
   <xsl:import href="nl-core-TreatmentDirective2-d919e375.xsl"/>
   <xsl:import href="nl-core-Vaccination-d919e376.xsl"/>
   <xsl:import href="nl-core-VisualAcuity-d919e377.xsl"/>
   <xsl:import href="nl-core-VisualFunction-d919e378.xsl"/>
   <xsl:import href="ext-CodeSpecification-d919e379.xsl"/>
   <xsl:import href="ext-Comment-d919e381.xsl"/>
   <xsl:import href="ext-CopyIndicator-d919e382.xsl"/>
   <xsl:import href="ext-TimeInterval-d919e383.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc scope="stylesheet">
      <xd:desc>This document imports common and zib and nl-core specific functions and templates to convert zib2020 ada instances to FHIR.</xd:desc>
   </xd:doc>
</xsl:stylesheet>