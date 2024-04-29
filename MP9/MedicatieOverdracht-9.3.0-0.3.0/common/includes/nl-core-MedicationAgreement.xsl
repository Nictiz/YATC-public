<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/nl-core-MedicationAgreement.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.3.0; 2024-04-09T18:20:47.77+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <xsl:variable name="medication-AdditionalInformation"
                 select="'http://nictiz.nl/fhir/StructureDefinition/ext-MedicationAgreement.MedicationAgreementAdditionalInformation'"/>
   <xd:doc>
      <xd:desc>Template to convert f:MedicationRequest to ADA medicatieafspraak</xd:desc>
   </xd:doc>
   <xsl:template match="f:MedicationRequest"
                 mode="nl-core-MedicationAgreement">
      <medicatieafspraak>
         <!-- identificatie -->
         <xsl:apply-templates select=".[f:intent/@value = 'order']/f:identifier"
                              mode="#current"/>
         <!-- afspraakdatum -->
         <xsl:apply-templates select=".[f:intent/@value = 'order']/f:authoredOn"
                              mode="#current"/>
         <!-- gebruiksperiode -->
         <xsl:if test="f:extension[@url = ($urlExtTimeInterval-Period, $urlExtTimeIntervalPeriod)] or f:extension[@url = ($urlExtTimeInterval-Duration, $urlExtTimeIntervalDuration)]">
            <gebruiksperiode>
               <xsl:apply-templates select="f:extension[@url = ($urlExtTimeInterval-Period, $urlExtTimeIntervalPeriod)]"
                                    mode="urlExtTimeInterval-Period"/>
               <!-- MP9 2.0.0-bèta version -->
               <xsl:apply-templates select="f:extension[@url = ($urlExtTimeInterval-Duration, $urlExtTimeIntervalDuration)]"
                                    mode="urlExtTimeInterval-Duration"/>
               <!-- MP9 2.0.0 version -->
               <xsl:apply-templates select="f:extension[@url = ($urlExtTimeInterval-Period, $urlExtTimeIntervalPeriod)]/f:valuePeriod/f:extension[@url = ($urlExtTimeInterval-Duration, $urlExtTimeIntervalDuration)]"
                                    mode="urlExtTimeInterval-Duration"/>
               <!-- criterium -->
               <xsl:apply-templates select="f:extension[@url = ($urlExtTimeInterval-Period, $urlExtTimeIntervalPeriod)]/f:valuePeriod/f:extension[@url = $urlExtMedicationAgreementPeriodOfUseCondition]"
                                    mode="urlExtMedicationAgreementPeriodOfUseCondition"/>
            </gebruiksperiode>
         </xsl:if>
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
         <!-- relatie medicatieafspraak -->
         <xsl:apply-templates select="f:priorPrescription"
                              mode="#current"/>
         <!-- relatie_medicatiegebruik -->
         <xsl:apply-templates select="f:extension[@url = $urlExtMedicationAgreementRelationMedicationUse] | f:basedOn/f:extension[@url = $urlExtMedicationAgreementRelationMedicationUse]"
                              mode="#current"/>
         <!-- voorschrijver -->
         <xsl:apply-templates select=".[f:intent/@value = 'order']/f:requester"
                              mode="#current"/>
         <!-- reden_wijzigen_of_staken -->
         <xsl:apply-templates select="f:reasonCode"
                              mode="#current"/>
         <!-- reden_van_voorschrijven -->
         <xsl:apply-templates select="f:reasonReference"
                              mode="#current"/>
         <!-- afgesproken_geneesmiddel -->
         <xsl:apply-templates select="f:medicationReference"
                              mode="#current"/>
         <!-- gebruiksinstructie -->
         <xsl:call-template name="nl-core-InstructionsForUse"/>
         <!-- aanvullende_informatie -->
         <xsl:apply-templates select="f:extension[@url = $medication-AdditionalInformation]"
                              mode="#current"/>
         <!-- kopie indicator -->
         <xsl:apply-templates select="f:extension[@url = $urlExtCopyIndicator] | f:reportedBoolean"
                              mode="ext-CopyIndicator"/>
         <!-- toelichting -->
         <xsl:apply-templates select="f:note"
                              mode="nl-core-Note"/>
      </medicatieafspraak>
   </xsl:template>
   <!--xxxwim:-->
   <xd:doc>
      <xd:desc>Template to convert f:extension medication-AdditionalInformation to aanvullende_informatie element.</xd:desc>
      <xd:param name="adaElementName">Optional alternative ADA element name.</xd:param>
   </xd:doc>
   <xsl:template match="f:extension[@url = 'http://nictiz.nl/fhir/StructureDefinition/ext-MedicationAgreement.MedicationAgreementAdditionalInformation']"
                 mode="nl-core-MedicationAgreement">
      <xsl:param name="adaElementName"
                 tunnel="yes"
                 select="'aanvullende_informatie'"/>
      <xsl:call-template name="CodeableConcept-to-code">
         <xsl:with-param name="in"
                         select="f:valueCodeableConcept"/>
         <xsl:with-param name="adaElementName"
                         select="$adaElementName"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:extension/relatedMedicationUse to aanvullende_informatie element.</xd:desc>
   </xd:doc>
   <xsl:template match="f:extension[@url = $urlExtMedicationAgreementRelationMedicationUse]"
                 mode="nl-core-MedicationAgreement">
      <relatie_medicatiegebruik>
         <identificatie value="{f:valueReference/f:identifier/f:value/@value}"
                        root="{f:valueReference/f:identifier/f:system/replace(@value, 'urn:oid:', '')}"/>
      </relatie_medicatiegebruik>
   </xsl:template>
   <!--	<xd:doc>
		<xd:desc>Template to resolve f:modifierExtension ext-Medication-stop-type.</xd:desc>
	</xd:doc>
	<xsl:template match="f:modifierExtension[@url = $extStoptype]" mode="nl-core-MedicationAgreement">
		<xsl:apply-templates select="f:valueCodeableConcept" mode="#current"/>
	</xsl:template>

    <xd:doc>
        <xd:desc>Template to convert f:valueCodeableConcept to stoptype.</xd:desc>
    </xd:doc>
    <xsl:template match="f:valueCodeableConcept" mode="nl-core-MedicationAgreement">
        <xsl:call-template name="CodeableConcept-to-code">
            <xsl:with-param name="in" select="."/>
            <xsl:with-param name="adaElementName" select="'medicatieafspraak_stop_type'"/>
        </xsl:call-template>
    </xsl:template>
    -->
   <xd:doc>
      <xd:desc>Template to resolve priorPrescription.</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Template to convert f:authorizingPrescription to relatie_medicatieafspraak</xd:desc>
   </xd:doc>
   <xsl:template match="f:priorPrescription"
                 mode="nl-core-MedicationAgreement">
      <relatie_medicatieafspraak>
         <xsl:call-template name="Reference-to-identificatie"/>
      </relatie_medicatieafspraak>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:identifier to identificatie</xd:desc>
   </xd:doc>
   <xsl:template match="f:identifier"
                 mode="nl-core-MedicationAgreement">
      <xsl:call-template name="Identifier-to-identificatie"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:medicationReference to afgesproken_geneesmiddel</xd:desc>
   </xd:doc>
   <xsl:template match="f:medicationReference"
                 mode="nl-core-MedicationAgreement">
      <afgesproken_geneesmiddel>
         <farmaceutisch_product value="{nf:process-reference-2NCName(f:reference/@value,ancestor::f:entry/f:fullUrl/@value)}"
                                datatype="reference"/>
      </afgesproken_geneesmiddel>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:authoredOn to afspraakdatum</xd:desc>
   </xd:doc>
   <xsl:template match="f:authoredOn"
                 mode="nl-core-MedicationAgreement">
      <xsl:call-template name="datetime-to-datetime">
         <xsl:with-param name="adaElementName">medicatieafspraak_datum_tijd</xsl:with-param>
         <xsl:with-param name="adaDatatype">datetime</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:status to geannuleerd_indicator. Only the FHIR status value 'entered-in-error' is used in this mapping.</xd:desc>
   </xd:doc>
   <xsl:template match="f:status"
                 mode="nl-core-MedicationAgreement">
      <xsl:if test="@value = 'entered-in-error'">
         <geannuleerd_indicator value="true"/>
      </xsl:if>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:requester to voorschrijver</xd:desc>
   </xd:doc>
   <xsl:template match="f:requester"
                 mode="nl-core-MedicationAgreement">
      <voorschrijver>
         <zorgverlener value="{nf:process-reference-2NCName(f:reference/@value, ancestor::f:entry/f:fullUrl/@value)}"
                       datatype="reference"/>
      </voorschrijver>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:reasonCode to reden_wijzigen_of_staken</xd:desc>
   </xd:doc>
   <xsl:template match="f:reasonCode"
                 mode="nl-core-MedicationAgreement">
      <xsl:call-template name="CodeableConcept-to-code">
         <xsl:with-param name="in"
                         select="."/>
         <xsl:with-param name="adaElementName"
                         select="'reden_wijzigen_of_staken'"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:reasonReference to reden_van_voorschrijven</xd:desc>
   </xd:doc>
   <xsl:template match="f:reasonReference"
                 mode="nl-core-MedicationAgreement">
      <xsl:variable name="resource"
                    select="nf:resolveRefInBundle(.)"/>
      <reden_van_voorschrijven>
         <xsl:apply-templates select="$resource/f:*"
                              mode="nl-core-Problem"/>
      </reden_van_voorschrijven>
   </xsl:template>
</xsl:stylesheet>