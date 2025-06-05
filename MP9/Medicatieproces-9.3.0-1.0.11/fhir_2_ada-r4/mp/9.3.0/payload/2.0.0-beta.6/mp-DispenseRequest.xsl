<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/mp/9.3.0/payload/2.0.0-beta.6/mp-DispenseRequest.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-05T16:01:14.01+02:00 == -->
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
   <xsl:variable name="medication-AdditionalInformation"
                 select="'http://nictiz.nl/fhir/StructureDefinition/ext-MedicationAgreement.MedicationAgreementAdditionalInformation'"/>
   <!-- ================================================================== -->
   <xsl:template match="f:MedicationRequest"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:MedicationRequest to ADA medicatieafspraak -->
      <verstrekkingsverzoek>
         <!-- identificatie -->
         <xsl:apply-templates select=".[f:intent/@value = 'order']/f:identifier"
                              mode="#current"/>
         <!-- verstrekkingsverzoek_datum_tijd -->
         <xsl:apply-templates select=".[f:intent/@value = 'order']/f:authoredOn"
                              mode="#current"/>
         <!--auteur/zorgverlener-->
         <xsl:apply-templates select=".[f:intent/@value = 'order']/f:requester"
                              mode="#current"/>
         <!-- (ref) te_verstrekken_geneesmiddel -->
         <xsl:apply-templates select="f:medicationReference"
                              mode="#current"/>
         <!--te_verstrekken_hoeveelheid-->
         <xsl:apply-templates select="f:dispenseRequest/f:quantity[f:extension/@url = 'http://hl7.org/fhir/StructureDefinition/iso21090-PQ-translation']"
                              mode="#current"/>
         <!--aantal_herhalingen-->
         <xsl:apply-templates select="f:dispenseRequest/f:numberOfRepeatsAllowed"
                              mode="#current"/>
         <!-- verbruiksperiode/@start_datum_tijd/@value en eind_datum_tijd/@value en tijds_duur-->
         <xsl:apply-templates select="f:dispenseRequest/f:validityPeriod[f:start | f:end | f:extension[@url = ($urlExtTimeInterval-Duration, $urlExtTimeIntervalDuration)]]"
                              mode="#current"/>
         <!--geannuleerd_indicator-->
         <xsl:if test="f:status/@value = ('entered-in-error','cancelled')">
            <geannuleerd_indicator value="true"/>
         </xsl:if>
         <!--beoogd_verstrekker/zorgaanbieder-->
         <xsl:apply-templates select="f:performer"
                              mode="#current"/>
         <!--afleverlocatie-->
         <xsl:apply-templates select="f:dispenseRequest/f:extension[@url eq 'http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.DispenseLocation']"
                              mode="#current"/>
         <!--AanvullendeWensen-->
         <xsl:apply-templates select="f:extension[@url eq 'http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.AdditionalWishes']"
                              mode="#current"/>
         <!--financiele_indicatiecode-->
         <xsl:apply-templates select="f:extension[@url eq 'http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.FinancialIndicationCode']"
                              mode="#current"/>
         <!--toelichting-->
         <xsl:apply-templates select="f:note"
                              mode="nl-core-Note"/>
         <!-- relatie medicatieafspraak -->
         <xsl:apply-templates select="f:basedOn"
                              mode="#current"/>
         <!-- relatie_contact -->
         <xsl:apply-templates select="f:encounter[f:type/@value eq 'Encounter']"
                              mode="contextContactEpisodeOfCare"/>
         <!-- relatie_zorgepisode -->
         <xsl:apply-templates select="f:extension[@url = $urlExtContextEpisodeOfCare]/f:valueReference"
                              mode="contextContactEpisodeOfCare"/>
         <!-- geannuleerd_indicator niet voor MA -->
         <!--			<xsl:apply-templates select="f:status" mode="#current"/>-->
         <!-- stop_type -->
         <xsl:apply-templates select="f:modifierExtension[@url = 'http://nictiz.nl/fhir/StructureDefinition/ext-StopType']"
                              mode="ext-StopType"/>
         <!-- relatie_medicatiegebruik -->
         <xsl:apply-templates select="f:extension[@url = $urlExtMedicationAgreementRelationMedicationUse]"
                              mode="#current"/>
         <!-- reden_wijzigen_of_staken -->
         <xsl:apply-templates select="f:reasonCode"
                              mode="#current"/>
         <!-- reden_van_voorschrijven -->
         <xsl:apply-templates select="f:reasonReference"
                              mode="#current"/>
         <!-- gebruiksinstructie -->
         <xsl:call-template name="mp-InstructionsForUse"/>
      </verstrekkingsverzoek>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:extension[@url eq 'http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.FinancialIndicationCode']"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:extension[@url eq 'http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.FinancialIndicationCode'] to financiele_indicatiecode -->
      <xsl:choose>
         <xsl:when test="./f:valueCodeableConcept/f:extension/f:valueCode/@value">
            <financiele_indicatiecode code="{f:valueCodeableConcept/f:extension/f:valueCode/@value}"
                                      codeSystem="2.16.840.1.113883.5.1008"
                                      originalText="{f:valueCodeableConcept/f:text/@value}"/>
            <xsl:if test="./f:valueCodeableConcept/f:extension[@value eq 'http://hl7.org/fhir/StructureDefinition/iso21090-nullFlavor']">
               <xsl:attribute name="codeSystemName"
                              select="'NullFlavor'"/>
            </xsl:if>
         </xsl:when>
         <xsl:when test="./f:valueCodeableConcept/f:coding">
            <xsl:call-template name="CodeableConcept-to-code">
               <xsl:with-param name="in"
                               select="./f:valueCodeableConcept"/>
               <xsl:with-param name="adaElementName"
                               select="'financiele_indicatiecode'"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:extension[@url eq 'http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.AdditionalWishes']"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:extension[@url eq 'http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.AdditionalWishes'] to aanvullende_wensen -->
      <aanvullende_wensen>
         <xsl:call-template name="Coding-to-code">
            <xsl:with-param name="in"
                            as="element()"
                            select="f:valueCodeableConcept/f:coding"/>
         </xsl:call-template>
      </aanvullende_wensen>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:extension[@url eq 'http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.DispenseLocation']"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:extension[url eq 'http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.DispenseLocation'] to afleverlocatie -->
      <xsl:variable name="resource"
                    select="nf:resolveRefInBundle(f:valueReference)"/>
      <afleverlocatie value="{$resource/f:*/f:name/@value}"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:performer"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:performer to beoogd_verstrekker/zorgaanbieder  -->
      <beoogd_verstrekker>
         <zorgaanbieder datatype="reference"
                        value="{nf:process-reference-2NCName(f:reference/@value, ancestor::f:entry/f:fullUrl/@value)}"/>
      </beoogd_verstrekker>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:extension[@url = ($urlExtTimeInterval-Duration, $urlExtTimeIntervalDuration)]"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:extension[@url = 'http://nictiz.nl/fhir/StructureDefinition/urlExtTimeInterval-Duration'] to verbruiksperiode/tijdsduur -->
      <verbruiksperiode>
         <xsl:call-template name="Duration-to-hoeveelheid">
            <xsl:with-param name="in"
                            select="f:valueDuration"/>
            <xsl:with-param name="adaElementName">tijds_duur</xsl:with-param>
         </xsl:call-template>
      </verbruiksperiode>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:validityPeriod"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:validityPeriod to verbruiksperiode/@start_datum_tijd/@value en eind_datum_tijd/@value -->
      <verbruiksperiode>
         <xsl:call-template name="Period-to-dates">
            <xsl:with-param name="in"
                            select="."/>
            <xsl:with-param name="adaElementNameStart">start_datum_tijd</xsl:with-param>
            <xsl:with-param name="adaElementNameEnd">eind_datum_tijd</xsl:with-param>
            <xsl:with-param name="adaDatatype"
                            as="xs:string?">datetime</xsl:with-param>
         </xsl:call-template>
         <xsl:call-template name="Duration-to-hoeveelheid">
            <xsl:with-param name="in"
                            select="f:extension[@url = ($urlExtTimeInterval-Duration, $urlExtTimeIntervalDuration)]/f:valueDuration"/>
            <xsl:with-param name="adaElementName">tijds_duur</xsl:with-param>
         </xsl:call-template>
      </verbruiksperiode>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:numberOfRepeatsAllowed"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:numberOfRepeatsAllowed to aantal_herhalingen -->
      <aantal_herhalingen value="{@value}"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:quantity[f:extension/@url = 'http://hl7.org/fhir/StructureDefinition/iso21090-PQ-translation']"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:quantity to te_verstrekken_hoeveelheid -->
      <te_verstrekken_hoeveelheid>
         <aantal value="{f:extension/f:valueQuantity/f:value/@value}"/>
         <eenheid code="{f:extension/f:valueQuantity/f:code/@value}"
                  codeSystem="{replace(f:extension/f:valueQuantity/f:system/@value, 'urn:oid:', '')}"
                  displayName="{f:unit/@value}"/>
      </te_verstrekken_hoeveelheid>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:requester"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:requester to auteur/zorgverlener -->
      <auteur>
         <zorgverlener value="{nf:process-reference-2NCName(f:reference/@value,ancestor::f:entry/f:fullUrl/@value)}"
                       datatype="reference"/>
      </auteur>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:basedOn"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:priorPrescription to relatie_medicatieafspraak -->
      <relatie_medicatieafspraak>
         <xsl:call-template name="Reference-to-identificatie"/>
      </relatie_medicatieafspraak>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:identifier"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:identifier to identificatie -->
      <xsl:call-template name="Identifier-to-identificatie"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:medicationReference"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:medicationReference to afgesproken_geneesmiddel -->
      <te_verstrekken_geneesmiddel>
         <farmaceutisch_product value="{nf:process-reference-2NCName(f:reference/@value, ancestor::f:entry/f:fullUrl/@value)}"
                                datatype="reference"/>
      </te_verstrekken_geneesmiddel>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:authoredOn"
                 mode="nl-core-DispenseRequest">
      <!-- Template to convert f:authoredOn to afspraakdatum -->
      <xsl:call-template name="datetime-to-datetime">
         <xsl:with-param name="adaElementName">verstrekkingsverzoek_datum_tijd</xsl:with-param>
         <xsl:with-param name="adaDatatype">datetime</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
</xsl:stylesheet>