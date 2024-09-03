<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada/env/zibs2017/payload/zib-dispense-2.2.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.0.7; 0.1; 2024-08-26T18:25:33.12+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
    <xsl:import href="nl-core-practitionerrole-2.0.xsl"/>
    <xsl:import href="nl-core-practitioner-2.0.xsl"/>
    <xsl:import href="nl-core-organization-2.0.xsl"/>
    <xsl:import href="nl-core-location-2.0.xsl"/>
    <xsl:import href="zib-pharmaceuticalproduct-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-additional-information-2.0.xsl"/>-->
   <xsl:variable name="zib-Dispense-RequestDate"
                 select="'http://nictiz.nl/fhir/StructureDefinition/zib-Dispense-RequestDate'"/>
   <xsl:variable name="practitionerrole-reference"
                 select="'http://nictiz.nl/fhir/StructureDefinition/practitionerrole-reference'"/>
   <xsl:variable name="zib-Dispense-DistributionForm"
                 select="'http://nictiz.nl/fhir/StructureDefinition/zib-Dispense-DistributionForm'"/>
   <!-- ================================================================== -->
   <xsl:template match="f:MedicationDispense"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:MedicationDispense to ADA verstrekking -->
      <verstrekking>
         <!-- identificatie -->
         <xsl:apply-templates select="f:identifier"
                              mode="#current"/>
         <!-- datum -->
         <xsl:choose>
            <xsl:when test="f:whenHandedOver">
               <xsl:apply-templates select="f:whenHandedOver"
                                    mode="#current"/>
            </xsl:when>
            <xsl:otherwise>
               <datum nullFlavor="UNK"/>
            </xsl:otherwise>
         </xsl:choose>
         <!-- aanschrijfdatum -->
         <xsl:apply-templates select="f:extension[@url=$zib-Dispense-RequestDate]"
                              mode="#current"/>
         <!-- verstrekker -->
         <xsl:apply-templates select="f:performer"
                              mode="#current"/>
         <!-- verstrekte_hoeveelheid -->
         <xsl:apply-templates select="f:quantity"
                              mode="#current"/>
         <!-- verstrekt_geneesmiddel -->
         <xsl:apply-templates select="f:medicationReference"
                              mode="#current"/>
         <!-- verbruiksduur -->
         <xsl:apply-templates select="f:daysSupply"
                              mode="#current"/>
         <!-- afleverlocatie -->
         <xsl:apply-templates select="f:destination"
                              mode="#current"/>
         <!-- distributievorm -->
         <xsl:apply-templates select="f:extension[@url=$zib-Dispense-DistributionForm]"
                              mode="#current"/>
         <!-- aanvullende_informatie -->
         <xsl:apply-templates select="f:extension[@url='http://nictiz.nl/fhir/StructureDefinition/zib-Medication-AdditionalInformation']"
                              mode="ext-zib-Medication-AdditionalInformation-2.0"/>
         <!-- toelichting -->
         <xsl:apply-templates select="f:note"
                              mode="#current"/>
         <!-- relatie_naar_verstrekkingsverzoek -->
         <xsl:apply-templates select="f:authorizingPrescription"
                              mode="#current"/>
      </verstrekking>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:identifier"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:identifier to identificatie -->
      <xsl:call-template name="Identifier-to-identificatie"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:whenHandedOver"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:whenHandedOver to datum -->
      <datum>
         <xsl:attribute name="value">
            <xsl:call-template name="format2ADADate">
               <xsl:with-param name="dateTime"
                               select="@value"/>
            </xsl:call-template>
         </xsl:attribute>
      </datum>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:extension[@url=$zib-Dispense-RequestDate]"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:extension zib-Dispense-RequestDate to aanschrijfdatum -->
      <aanschrijfdatum>
         <xsl:attribute name="value">
            <xsl:call-template name="format2ADADate">
               <xsl:with-param name="dateTime"
                               select="f:valueDateTime/@value"/>
            </xsl:call-template>
         </xsl:attribute>
      </aanschrijfdatum>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:performer"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:performer to verstrekker -->
      <verstrekker>
         <xsl:choose>
            <xsl:when test="f:actor/f:extension[@url=$practitionerrole-reference]">
               <xsl:variable name="referenceValue"
                             select="f:actor/f:extension[@url = $practitionerrole-reference]/f:valueReference/f:reference/@value"/>
               <xsl:apply-templates select="ancestor::f:Bundle/f:entry[f:fullUrl/@value=$referenceValue]/f:resource/f:PractitionerRole"
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
                             select="(ancestor::f:Bundle/f:entry[f:fullUrl/@value=$referenceValue]/f:resource/f:*)[1]"/>
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
   <xsl:template match="f:quantity"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:quantity to verstrekte_hoeveelheid -->
      <verstrekte_hoeveelheid>
         <xsl:call-template name="Quantity-to-hoeveelheid-complex">
            <xsl:with-param name="adaWaarde">aantal</xsl:with-param>
         </xsl:call-template>
      </verstrekte_hoeveelheid>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:medicationReference"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:medicationReference to verstrekt_geneesmiddel -->
      <xsl:variable name="referenceValue"
                    select="f:reference/@value"/>
      <verstrekt_geneesmiddel>
         <xsl:apply-templates select="ancestor::f:Bundle/f:entry[f:fullUrl/@value=$referenceValue]/f:resource/f:Medication"
                              mode="zib-PharmaceuticalProduct-2.0"/>
      </verstrekt_geneesmiddel>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:daysSupply"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:daysSupply to verbruiksduur -->
      <xsl:call-template name="Duration-to-hoeveelheid">
         <xsl:with-param name="adaElementName">verbruiksduur</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:destination"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:destination to afleverlocatie -->
      <xsl:variable name="referenceValue"
                    select="f:reference/@value"/>
      <afleverlocatie>
         <xsl:apply-templates select="ancestor::f:Bundle/f:entry[f:fullUrl/@value=$referenceValue]/f:resource/f:Location"
                              mode="nl-core-location-2.0"/>
      </afleverlocatie>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:extension[@url=$zib-Dispense-DistributionForm]"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:extension zib-Dispense-DistributionFrom to distributievorm -->
      <xsl:call-template name="CodeableConcept-to-code">
         <xsl:with-param name="in"
                         select="f:valueCodeableConcept"/>
         <xsl:with-param name="adaElementName">distributievorm</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:note"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:note to toelichting -->
      <toelichting value="{f:text/@value}"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:authorizingPrescription"
                 mode="zib-Dispense-2.2">
      <!-- Template to convert f:authorizingPrescription to relatie_naar_verstrekkingsverzoek -->
      <relatie_naar_verstrekkingsverzoek>
         <xsl:call-template name="Reference-to-identificatie">
            <xsl:with-param name="resourceList"
                            select="('MedicationRequest')"/>
         </xsl:call-template>
      </relatie_naar_verstrekkingsverzoek>
   </xsl:template>
</xsl:stylesheet>