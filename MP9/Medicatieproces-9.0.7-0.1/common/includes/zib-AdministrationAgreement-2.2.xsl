<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada/env/zibs2017/payload/zib-AdministrationAgreement-2.2.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.0.7; 0.1; 2024-08-26T18:25:33.12+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <!-- ================================================================== -->
   <!--
        TBD
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
   <!--Uncomment imports for standalone use and testing.-->
   <!--<xsl:import href="../../fhir/fhir_2_ada_fhir_include.xsl"/>
    <xsl:import href="ext-zib-medication-period-of-use-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-use-duration-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-additional-information-2.0.xsl"/>
    <xsl:import href="zib-instructions-for-use-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-stop-type-2.0.xsl"/>
    <xsl:import href="nl-core-practitionerrole-2.0.xsl"/>
    <xsl:import href="nl-core-practitioner-2.0.xsl"/>
    <xsl:import href="nl-core-organization-2.0.xsl"/>
    <xsl:import href="zib-pharmaceuticalproduct-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-copy-indicator-2.0.xsl"/>-->
   <xsl:variable name="zib-Medication-PeriodOfUse"
                 select="'http://nictiz.nl/fhir/StructureDefinition/zib-Medication-PeriodOfUse'"/>
   <xsl:variable name="zib-AdministrationAgreement-AuthoredOn"
                 select="'http://nictiz.nl/fhir/StructureDefinition/zib-AdministrationAgreement-AuthoredOn'"/>
   <xsl:variable name="zib-MedicationUse-Duration"
                 select="'http://nictiz.nl/fhir/StructureDefinition/zib-MedicationUse-Duration'"/>
   <xsl:variable name="zib-Medication-StopType"
                 select="'http://nictiz.nl/fhir/StructureDefinition/zib-Medication-StopType'"/>
   <xsl:variable name="practitionerrole-reference"
                 select="'http://nictiz.nl/fhir/StructureDefinition/practitionerrole-reference'"/>
   <xsl:variable name="zib-Medication-CopyIndicator"
                 select="'http://nictiz.nl/fhir/StructureDefinition/zib-Medication-CopyIndicator'"/>
   <xsl:variable name="zib-Medication-AdditionalInformation"
                 select="'http://nictiz.nl/fhir/StructureDefinition/zib-Medication-AdditionalInformation'"/>
   <!-- ================================================================== -->
   <xsl:template match="f:MedicationDispense"
                 mode="zib-AdministrationAgreement-2.2">
      <!-- Template to convert f:MedicationDispense to ADA toedieningsafspraak. -->
      <toedieningsafspraak>
         <!--gebruiksperiode_start-->
         <!--gebruiksperiode_eind-->
         <xsl:apply-templates select="f:extension[@url = $zib-Medication-PeriodOfUse]"
                              mode="ext-zib-Medication-PeriodOfUse-2.0"/>
         <!--identificatie-->
         <xsl:apply-templates select="f:identifier"
                              mode="#current"/>
         <!--afspraakdatum-->
         <xsl:apply-templates select="f:extension[@url = $zib-AdministrationAgreement-AuthoredOn]"
                              mode="#current"/>
         <!--gebruiksperiode-->
         <xsl:apply-templates select="f:extension[@url = $zib-MedicationUse-Duration]"
                              mode="ext-zib-medication-use-duration-2.0"/>
         <!--geannuleerd_indicator-->
         <xsl:apply-templates select="f:status"
                              mode="#current"/>
         <!--stoptype-->
         <xsl:apply-templates select="f:modifierExtension[@url = $zib-Medication-StopType]"
                              mode="ext-zib-Medication-Stop-Type-2.0"/>
         <!--verstrekker-->
         <xsl:apply-templates select="f:performer"
                              mode="#current"/>
         <!--reden_afspraak-->
         <xsl:apply-templates select="f:agreementReason"
                              mode="#current"/>
         <!--geneesmiddel_bij_toedieningsafspraak-->
         <xsl:apply-templates select="f:medicationReference"
                              mode="#current"/>
         <!--gebruiksinstructie-->
         <xsl:apply-templates select="f:dosageInstruction"
                              mode="zib-instructions-for-use-2.0"/>
         <!--aanvullende_informatie-->
         <xsl:apply-templates select="f:extension[@url = $zib-Medication-AdditionalInformation]"
                              mode="ext-zib-Medication-AdditionalInformation-2.0"/>
         <!--toelichting-->
         <xsl:apply-templates select="f:note"
                              mode="#current"/>
         <!--kopie_indicator -->
         <xsl:apply-templates select="f:extension[@url = $zib-Medication-CopyIndicator]"
                              mode="ext-zib-Medication-CopyIndicator-2.0"/>
         <!--relatie_naar_medicatieafspraak-->
         <xsl:apply-templates select="f:authorizingPrescription"
                              mode="#current"/>
      </toedieningsafspraak>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:identifier"
                 mode="zib-AdministrationAgreement-2.2">
      <!-- Template to convert f:identifier to identificatie -->
      <xsl:call-template name="Identifier-to-identificatie"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:extension[@url = $zib-AdministrationAgreement-AuthoredOn]"
                 mode="zib-AdministrationAgreement-2.2">
      <!-- Template to convert zib-AdministrationAgreement-AuthoredOn f:extension to afspraakdatum. -->
      <afspraakdatum>
         <xsl:attribute name="value">
            <xsl:call-template name="format2ADADate">
               <xsl:with-param name="dateTime"
                               select="f:valueDateTime/@value"/>
            </xsl:call-template>
         </xsl:attribute>
      </afspraakdatum>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:status"
                 mode="zib-AdministrationAgreement-2.2">
      <!-- Template to convert f:status with value 'entered-in-error' to geannuleerd_indicator. -->
      <xsl:if test="@value='entered-in-error'">
         <geannuleerd_indicator value="true"/>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:performer"
                 mode="zib-AdministrationAgreement-2.2">
      <!-- Template to convert f:performer to verstrekker. -->
      <verstrekker>
         <xsl:choose>
            <xsl:when test="f:actor/f:extension[@url = $practitionerrole-reference]">
               <xsl:variable name="referenceValue"
                             select="f:actor/f:extension[@url = $practitionerrole-reference]/f:valueReference/f:reference/@value"/>
               <xsl:apply-templates select="ancestor::f:Bundle/f:entry[f:fullUrl/@value = $referenceValue]/f:resource/f:PractitionerRole"
                                    mode="resolve-practitionerRole">
                  <xsl:with-param name="organizationIdUnderscore"
                                  select="true()"
                                  tunnel="yes"/>
               </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
               <xsl:variable name="referenceValue"
                             select="f:actor/f:reference/@value"/>
               <xsl:variable name="resource"
                             select="(ancestor::f:Bundle/f:entry[f:fullUrl/@value = $referenceValue]/f:resource/f:*)[1]"/>
               <xsl:choose>
                  <xsl:when test="$resource/local-name()='Practitioner'">
                     <xsl:apply-templates select="$resource"
                                          mode="nl-core-practitioner-2.0"/>
                  </xsl:when>
                  <xsl:when test="$resource/local-name()='Organization'">
                     <xsl:apply-templates select="$resource"
                                          mode="nl-core-organization-2.0">
                        <xsl:with-param name="organizationIdUnderscore"
                                        select="true()"
                                        tunnel="yes"/>
                     </xsl:apply-templates>
                  </xsl:when>
               </xsl:choose>
               <!-- f:onBehalfOf? -->
               <!-- nl-core-patient, HCIM MedicalDevice Product, nl-core-relatedperson -->
            </xsl:otherwise>
         </xsl:choose>
      </verstrekker>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:medicationReference"
                 mode="zib-AdministrationAgreement-2.2">
      <!-- Template to convert f:medicationReference to geneesmiddel_bij_toedieningsafspraak. -->
      <xsl:variable name="referenceValue"
                    select="f:reference/@value"/>
      <geneesmiddel_bij_toedieningsafspraak>
         <xsl:apply-templates select="ancestor::f:Bundle/f:entry[f:fullUrl/@value = $referenceValue]/f:resource/f:Medication"
                              mode="zib-PharmaceuticalProduct-2.0"/>
      </geneesmiddel_bij_toedieningsafspraak>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:note"
                 mode="zib-AdministrationAgreement-2.2">
      <!-- Template to convert f:note to toelichting. -->
      <toelichting value="{f:text/@value}"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:authorizingPrescription"
                 mode="zib-AdministrationAgreement-2.2">
      <!-- Template to convert f:authorizingPrescription to relatie_naar_medicatieafspraak. -->
      <relatie_naar_medicatieafspraak>
         <xsl:call-template name="Reference-to-identificatie">
            <xsl:with-param name="resourceList"
                            select="('MedicationRequest')"/>
         </xsl:call-template>
      </relatie_naar_medicatieafspraak>
   </xsl:template>
</xsl:stylesheet>