<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/mp/9.3.0/payload/2.0.0-beta.5/mp-VariableDosingRegimen.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 1.0.1; 2024-04-18T12:43:34.01+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <xsl:variable name="variableDosingRegimen"
                 select="'http://nictiz.nl/fhir/StructureDefinition/ext-MedicationAgreement.RelatedMedicationUse'"/>
   <xd:doc>
      <xd:desc>Template to convert f:MedicationRequest/f:meta/f:profile[value="http://nictiz.nl/fhir/StructureDefinition/mp-VariableDosingRegimen"] to ADA wisselend_doseerschema</xd:desc>
   </xd:doc>
   <xsl:template match="f:MedicationRequest"
                 mode="mp-VariableDosingRegimen">
      <wisselend_doseerschema>
         <!-- identificatie -->
         <xsl:apply-templates select="f:identifier"
                              mode="#current"/>
         <!-- registratiedatumtijd -->
         <xsl:apply-templates select="f:extension[@url = $urlExtRegistrationDateTime]"
                              mode="urlExtRegistrationDateTime"/>
         <!-- wisselend_doseerschema_datum_tijd -->
         <xsl:apply-templates select="f:authoredOn"
                              mode="#current"/>
         <!-- gebruiksperiode -->
         <xsl:if test="f:extension[@url = ($urlExtTimeInterval-Period, $urlExtTimeIntervalPeriod)] or f:extension[@url = ($urlExtTimeInterval-Duration, $urlExtTimeIntervalDuration)]">
            <gebruiksperiode>
               <xsl:apply-templates select="f:extension[@url = ($urlExtTimeInterval-Period, $urlExtTimeIntervalPeriod)]"
                                    mode="urlExtTimeInterval-Period"/>
               <!-- start MP9 2.0.0-bèta version -->
               <xsl:apply-templates select="f:extension[@url = ($urlExtTimeInterval-Duration, $urlExtTimeIntervalDuration)]"
                                    mode="urlExtTimeInterval-Duration"/>
               <!-- MP9 2.0.0 version (and higher) -->
               <xsl:apply-templates select="f:extension[@url = ($urlExtTimeInterval-Period, $urlExtTimeIntervalPeriod)]/f:valuePeriod/f:extension[@url = ($urlExtTimeInterval-Duration, $urlExtTimeIntervalDuration)]"
                                    mode="urlExtTimeInterval-Duration"/>
            </gebruiksperiode>
         </xsl:if>
         <!-- stoptype -->
         <xsl:apply-templates select="f:modifierExtension[@url = 'http://nictiz.nl/fhir/StructureDefinition/ext-StopType']"
                              mode="ext-StopType"/>
         <!-- reden_wijzigen_of_staken -->
         <xsl:apply-templates select="f:reasonCode"
                              mode="#current"/>
         <!-- afgesproken_geneesmiddel -->
         <xsl:apply-templates select="f:medicationReference"
                              mode="#current"/>
         <!-- relatie medicatieafspraak / relatie_wisselend_doseerschema zie opmerkingen WDS -->
         <xsl:apply-templates select="f:basedOn"
                              mode="#current"/>
         <xsl:apply-templates select="f:priorPrescription"
                              mode="#current"/>
         <!-- relatie_contact -->
         <xsl:apply-templates select="f:encounter[f:type/@value eq 'Encounter']"
                              mode="contextContactEpisodeOfCare"/>
         <!-- relatie_zorgepisode -->
         <xsl:apply-templates select="f:extension[@url = $urlExtContextEpisodeOfCare]/f:valueReference"
                              mode="contextContactEpisodeOfCare"/>
         <!--auteur/zorgverlener-->
         <xsl:apply-templates select="f:requester"
                              mode="#current"/>
         <!-- gebruiksinstructie -->
         <xsl:call-template name="mp-InstructionsForUse"/>
         <!-- kopie indicator -->
         <xsl:apply-templates select="f:extension[@url = $urlExtCopyIndicator] | f:reportedBoolean"
                              mode="ext-CopyIndicator"/>
         <!-- toelichting -->
         <xsl:apply-templates select="f:note"
                              mode="#current"/>
      </wisselend_doseerschema>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:requester to auteur/zorgverlener</xd:desc>
   </xd:doc>
   <xsl:template match="f:requester"
                 mode="mp-VariableDosingRegimen">
      <auteur>
         <zorgverlener value="{nf:process-reference-2NCName(f:reference/@value,ancestor::f:entry/f:fullUrl/@value)}"
                       datatype="reference"/>
      </auteur>
   </xsl:template>
   <!--xxxwim:-->
   <xd:doc>
      <xd:desc>Template to convert f:extension medication-AdditionalInformation to aanvullende_informatie element.</xd:desc>
      <xd:param name="adaElementName">Optional alternative ADA element name.</xd:param>
   </xd:doc>
   <xsl:template match="f:extension[@url = 'http://nictiz.nl/fhir/StructureDefinition/ext-MedicationAgreement.MedicationAgreementAdditionalInformation']"
                 mode="mp-VariableDosingRegimen">
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
   <!--	<xd:doc>
		<xd:desc>Template to resolve f:modifierExtension ext-Medication-stop-type.</xd:desc>
	</xd:doc>
	<xsl:template match="f:modifierExtension[@url = $extStoptype]" mode="mp-VariableDosingRegimen">
		<xsl:apply-templates select="f:valueCodeableConcept" mode="#current"/>
	</xsl:template>

    <xd:doc>
        <xd:desc>Template to convert f:valueCodeableConcept to stoptype.</xd:desc>
    </xd:doc>
    <xsl:template match="f:valueCodeableConcept" mode="mp-VariableDosingRegimen">
        <xsl:call-template name="CodeableConcept-to-code">
            <xsl:with-param name="in" select="."/>
            <xsl:with-param name="adaElementName" select="'medicatieafspraak_stop_type'"/>
        </xsl:call-template>
    </xsl:template>
    -->
   <xd:doc>
      <!-- ZZZNEW -->
      <xd:desc>Template to resolve priorPrescription.</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Template to convert f:f:basedOn to relatie_medicatieafspraak</xd:desc>
   </xd:doc>
   <xsl:template match="f:basedOn"
                 mode="mp-VariableDosingRegimen">
      <relatie_medicatieafspraak>
         <xsl:call-template name="Reference-to-identificatie"/>
      </relatie_medicatieafspraak>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:f:priorPrescription to relatie_wisselend_doseerschema</xd:desc>
   </xd:doc>
   <xsl:template match="f:priorPrescription"
                 mode="mp-VariableDosingRegimen">
      <relatie_wisselend_doseerschema>
         <xsl:call-template name="Reference-to-identificatie"/>
      </relatie_wisselend_doseerschema>
   </xsl:template>
   <xd:doc>
      <!-- ZZZNEW -->
      <xd:desc>Template to convert f:identifier to identificatie</xd:desc>
   </xd:doc>
   <xsl:template match="f:identifier"
                 mode="mp-VariableDosingRegimen">
      <xsl:call-template name="Identifier-to-identificatie"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:medicationReference to afgesproken_geneesmiddel</xd:desc>
   </xd:doc>
   <xsl:template match="f:medicationReference"
                 mode="mp-VariableDosingRegimen">
      <afgesproken_geneesmiddel>
         <farmaceutisch_product value="{nf:process-reference-2NCName(f:reference/@value, ancestor::f:entry/f:fullUrl/@value)}"
                                datatype="reference"/>
      </afgesproken_geneesmiddel>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:authoredOn to wisselend_doseerschema_datum_tijd</xd:desc>
   </xd:doc>
   <xsl:template match="f:authoredOn"
                 mode="mp-VariableDosingRegimen">
      <xsl:call-template name="datetime-to-datetime">
         <xsl:with-param name="adaElementName">wisselend_doseerschema_datum_tijd</xsl:with-param>
         <xsl:with-param name="adaDatatype">datetime</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:reasonCode to reden_wijzigen_of_staken</xd:desc>
   </xd:doc>
   <xsl:template match="f:reasonCode"
                 mode="mp-VariableDosingRegimen">
      <xsl:call-template name="CodeableConcept-to-code">
         <xsl:with-param name="in"
                         select="."/>
         <xsl:with-param name="adaElementName"
                         select="'reden_wijzigen_of_staken'"/>
         <xsl:with-param name="originalText"
                         select="./f:text/@value"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:note to toelichting</xd:desc>
   </xd:doc>
   <xsl:template match="f:note"
                 mode="mp-VariableDosingRegimen">
      <toelichting value="{f:text/@value}"/>
   </xsl:template>
</xsl:stylesheet>