<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/nl-core-MedicationUse2.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.1; 2024-03-12T15:03:10.81+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <xsl:variable name="extStoptype">http://nictiz.nl/fhir/StructureDefinition/ext-StopType</xsl:variable>
   <xsl:variable name="extMedicationUse2Prescriber"
                 select="'http://nictiz.nl/fhir/StructureDefinition/ext-MedicationUse2.Prescriber'"/>
   <xsl:variable name="extMedicationUseAuthor"
                 select="'http://nictiz.nl/fhir/StructureDefinition/ext-MedicationUse2.Author'"/>
   <xd:doc>
      <xd:desc>Template to convert f:MedicationStatement to ADA medicatie_gebruik</xd:desc>
   </xd:doc>
   <xsl:template match="f:MedicationStatement"
                 mode="nl-core-MedicationUse2">
      <medicatiegebruik>
         <!--ext-StopType-->
         <!-- identificatie  -->
         <xsl:apply-templates select="f:identifier"
                              mode="#current"/>
         <!-- medicatiegebruik_datum_tijd -->
         <xsl:apply-templates select="f:dateAsserted"
                              mode="#current"/>
         <!-- gebruik_indicator -->
         <xsl:apply-templates select="f:status"
                              mode="#current"/>
         <!-- volgens_afspraak_indicator -->
         <xsl:apply-templates select="f:extension[@url = $urlExtAsAgreedIndicator]"
                              mode="#current"/>
         <!-- stoptype -->
         <xsl:apply-templates select="f:modifierExtension[@url = 'http://nictiz.nl/fhir/StructureDefinition/ext-StopType']"
                              mode="ext-StopType"/>
         <!-- gebruiksperiode -->
         <xsl:apply-templates select="f:effectivePeriod"
                              mode="#current"/>
         <!-- gebruiks_product -->
         <xsl:apply-templates select="f:medicationReference"
                              mode="#current"/>
         <!-- gebruiksinstructie -->
         <xsl:call-template name="nl-core-InstructionsForUse"/>
         <!-- relatie_medicatieafspraak, toedieningsafspraak, medicatieverstrekking -->
         <xsl:apply-templates select="f:derivedFrom"
                              mode="#current"/>
         <!-- relatie_contact en zorgepisode -->
         <xsl:apply-templates select="f:context"
                              mode="contextContactEpisodeOfCare"/>
         <!-- voorschrijver -->
         <xsl:apply-templates select="f:extension[@url = $extMedicationUse2Prescriber]"
                              mode="#current"/>
         <!-- informant -->
         <xsl:apply-templates select="f:informationSource"
                              mode="#current"/>
         <!-- auteur -->
         <xsl:apply-templates select="f:extension[@url = $extMedicationUseAuthor]"
                              mode="#current"/>
         <!-- reden_gebruik -->
         <xsl:apply-templates select="f:reasonCode"
                              mode="#current"/>
         <!-- reden_wijzigen_of_stoppen_gebruik -->
         <!--            <xsl:apply-templates select="f:extension[@url = $zib-MedicationUse-ReasonForChangeOrDiscontinuationOfUse]" mode="#current"/>-->
         <xsl:apply-templates select="f:statusReason"
                              mode="#current"/>
         <!-- reden_wijzigen_of_stoppen_gebruik -->
         <!--            <xsl:apply-templates select="f:extension[@url = $zib-MedicationUse-ReasonForChangeOrDiscontinuationOfUse]" mode="#current"/>-->
         <!-- kopie_indicator -->
         <xsl:apply-templates select="f:extension[@url = $urlExtCopyIndicator]"
                              mode="ext-CopyIndicator"/>
         <!-- toelichting -->
         <xsl:apply-templates select="f:note"
                              mode="#current"/>
      </medicatiegebruik>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:identifier to identificatie</xd:desc>
   </xd:doc>
   <xsl:template match="f:identifier"
                 mode="nl-core-MedicationUse2">
      <xsl:call-template name="Identifier-to-identificatie"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:effectivePeriod to gebruiksperiode</xd:desc>
   </xd:doc>
   <xsl:template match="f:effectivePeriod"
                 mode="nl-core-MedicationUse2">
      <gebruiksperiode>
         <xsl:apply-templates select="f:start"
                              mode="#current"/>
         <xsl:apply-templates select="f:end"
                              mode="#current"/>
         <xsl:apply-templates select="(. | parent::f:MedicationStatement)/f:extension[@url eq $urlExtTimeIntervalDuration]"
                              mode="nl-core-MedicationUse2"/>
      </gebruiksperiode>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert urlExtTimeInterval-Duration to tijds_duur</xd:desc>
   </xd:doc>
   <xsl:template match="f:extension[@url eq $urlExtTimeIntervalDuration]"
                 mode="nl-core-MedicationUse2">
      <xsl:variable name="code-value"
                    select="f:valueDuration/f:code/@value"/>
      <tijds_duur value="{f:valueDuration/f:value/@value}"
                  unit="{nf:convertTime_UCUM_FHIR2ADA_unit($code-value)}"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:start to gebruiksperiode_start</xd:desc>
   </xd:doc>
   <xsl:template match="f:start"
                 mode="nl-core-MedicationUse2">
      <xsl:call-template name="datetime-to-datetime">
         <xsl:with-param name="adaElementName">start_datum_tijd</xsl:with-param>
         <xsl:with-param name="adaDatatype">datetime</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:end to gebruiksperiode_eind</xd:desc>
   </xd:doc>
   <xsl:template match="f:end"
                 mode="nl-core-MedicationUse2">
      <xsl:call-template name="datetime-to-datetime">
         <xsl:with-param name="adaElementName">eind_datum_tijd</xsl:with-param>
         <xsl:with-param name="adaDatatype">datetime</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!--xxxwim        <xd:doc>
        <xd:desc>Template to convert f:start to gebruiksperiode_start</xd:desc>
    </xd:doc>
    <xsl:template match="f:start" mode="nl-core-MedicationUse2">
        <gebruiksperiode_start>
            <xsl:attribute name="value">
                <xsl:call-template name="format2ADADate">
                    <xsl:with-param name="dateTime" select="@value"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-\-<xsl:attribute name="datatype">datetime</xsl:attribute>-\->
        </gebruiksperiode_start>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Template to convert f:end to gebruiksperiode_eind</xd:desc>
    </xd:doc>
    <xsl:template match="f:end" mode="nl-core-MedicationUse2">
        <gebruiksperiode_eind>
            <xsl:attribute name="value">
                <xsl:call-template name="format2ADADate">
                    <xsl:with-param name="dateTime" select="@value"/>
                </xsl:call-template>
            </xsl:attribute>
            <!-\-<xsl:attribute name="datatype">datetime</xsl:attribute>-\->
        </gebruiksperiode_eind>
    </xsl:template>-->
   <xd:doc>
      <xd:desc>Template to convert f:dateAsserted to registratiedatum</xd:desc>
   </xd:doc>
   <xsl:template match="f:dateAsserted"
                 mode="nl-core-MedicationUse2">
      <xsl:call-template name="datetime-to-datetime">
         <xsl:with-param name="adaElementName">medicatiegebruik_datum_tijd</xsl:with-param>
         <xsl:with-param name="adaDatatype">datetime</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>
            Template to convert f:status to stoptype. Only the FHIR status values that map to a ADA stoptype value are mapped.
            Template to convert f:status to gebruik_indicator
            Note: the values below are not fully implemented in the xml schema.
            See MedicationStatement.status documentation.
            not-taken &gt; false
            on-hold &gt; false
            stopped &gt; false
            completed &gt; false
            active &gt; true
            unknown &gt; unknown (invalid ADA)
        </xd:desc>
   </xd:doc>
   <xsl:template match="f:status"
                 mode="nl-core-MedicationUse2">
      <xsl:choose>
         <xsl:when test="@value eq 'on-hold'">
            <gebruik_indicator>
               <xsl:attribute name="value"
                              select="'false'"/>
            </gebruik_indicator>
            <stoptype code="113381000146106"
                      codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2.1"
                      displayName="Onderbreking"/>
         </xsl:when>
         <xsl:when test="@value eq 'stopped'">
            <gebruik_indicator>
               <xsl:attribute name="value"
                              select="'false'"/>
            </gebruik_indicator>
            <stoptype code="113371000146109"
                      codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2.1"
                      displayName="Definitief"/>
         </xsl:when>
         <xsl:when test="                     some $val in ('not-taken', 'completed')                         satisfies $val eq string(./@value)">
            <gebruik_indicator>
               <xsl:attribute name="value"
                              select="'false'"/>
            </gebruik_indicator>
         </xsl:when>
         <xsl:when test="@value = 'active'">
            <gebruik_indicator>
               <xsl:attribute name="value"
                              select="'true'"/>
            </gebruik_indicator>
         </xsl:when>
         <xsl:otherwise>
            <xsl:comment select="concat('unhandeld FHIR value: ', @value)"/>
            <xsl:call-template name="util:logMessage">
               <xsl:with-param name="level"
                               select="$logERROR"/>
               <xsl:with-param name="msg">
                  <xsl:value-of select="./local-name()"/>
                  <xsl:text> with @value '</xsl:text>
                  <xsl:value-of select="@value"/>
                  <xsl:text>'is an unhandeld FHIR value</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xd:doc>
      <xd:desc>
            Template to convert f:statusReason to reden_wijzigen_of_stoppen_gebruik.
        </xd:desc>
   </xd:doc>
   <xsl:template match="f:statusReason"
                 mode="nl-core-MedicationUse2">
      <reden_wijzigen_of_stoppen_gebruik code="{f:coding/f:code/@value}"
                                         codeSystem="2.16.840.1.113883.6.96"
                                         displayName="{f:coding/f:display/@value}"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:medicationReference to gebruiks_product</xd:desc>
   </xd:doc>
   <xsl:template match="f:medicationReference"
                 mode="nl-core-MedicationUse2">
      <gebruiksproduct>
         <farmaceutisch_product value="{nf:process-reference-2NCName(f:reference/@value,ancestor::f:entry/f:fullUrl/@value)}"
                                datatype="reference"/>
      </gebruiksproduct>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:informationSource to informant</xd:desc>
   </xd:doc>
   <xsl:template match="f:informationSource"
                 mode="nl-core-MedicationUse2">
      <xsl:variable name="referenceValue"
                    select="f:reference/@value"/>
      <xsl:variable name="referenceValuePractitionerRole"
                    select="f:extension/f:valueReference/f:reference/@value"/>
      <xsl:variable name="resource"
                    select="(ancestor::f:Bundle/f:entry[f:fullUrl/@value = $referenceValue]/f:resource/f:*)[1]"/>
      <informant>
         <xsl:choose>
            <xsl:when test="ancestor::f:Bundle/f:entry[f:fullUrl/@value = $referenceValue]/f:resource/f:Patient">
               <informant_is_patient>
                  <xsl:attribute name="value"
                                 select="'true'"/>
               </informant_is_patient>
            </xsl:when>
            <xsl:when test="$resource/local-name() = 'Practitioner'">
               <informant_is_zorgverlener>
                  <xsl:apply-templates select="$resource"
                                       mode="nl-core-practitioner-2.0">
                     <xsl:with-param name="practitionerIdUnderscore"
                                     select="true()"
                                     tunnel="yes"/>
                     <xsl:with-param name="practitionerNaamgegevensElement"
                                     select="'zorgverlener_naam'"
                                     tunnel="yes"/>
                  </xsl:apply-templates>
               </informant_is_zorgverlener>
            </xsl:when>
            <xsl:when test="$resource/local-name() = 'PractitionerRole'">
               <informant_is_zorgverlener>
                  <xsl:apply-templates select="$resource"
                                       mode="resolve-practitionerRole">
                     <xsl:with-param name="practitionerIdUnderscore"
                                     select="true()"
                                     tunnel="yes"/>
                     <xsl:with-param name="organizationIdUnderscore"
                                     select="true()"
                                     tunnel="yes"/>
                     <xsl:with-param name="practitionerNaamgegevensElement"
                                     select="'zorgverlener_naam'"
                                     tunnel="yes"/>
                  </xsl:apply-templates>
               </informant_is_zorgverlener>
            </xsl:when>
            <xsl:when test="$resource/local-name() = 'Organization'">
               <informant_is_zorgverlener>
                  <xsl:apply-templates select="$resource"
                                       mode="nl-core-organization-2.0">
                     <xsl:with-param name="organizationIdUnderscore"
                                     select="true()"
                                     tunnel="yes"/>
                  </xsl:apply-templates>
               </informant_is_zorgverlener>
            </xsl:when>
            <xsl:when test="ancestor::f:Bundle/f:entry[f:fullUrl/@value = $referenceValue]/f:resource/f:RelatedPerson">
               <xsl:apply-templates select="$resource"
                                    mode="nl-core-relatedperson-2.0">
                  <xsl:with-param name="organizationIdUnderscore"
                                  select="true()"
                                  tunnel="yes"/>
               </xsl:apply-templates>
            </xsl:when>
         </xsl:choose>
      </informant>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:derivedFrom to gerelateerde_afspraak and gerelateerde_verstrekking</xd:desc>
      <xd:desc>First try to revolve reference.reference within Bundle, then try to use the reference.identifier based on identifier.type and lastly try to resolve based on identifier within the Bundle.</xd:desc>
   </xd:doc>
   <xsl:template match="f:derivedFrom"
                 mode="nl-core-MedicationUse2">
      <xsl:variable name="resource"
                    select="nf:resolveRefInBundle(.)"/>
      <xsl:choose>
         <xsl:when test="f:identifier">
            <xsl:choose>
               <xsl:when test="matches(f:identifier/f:value/@value, '_MA$') or matches(f:display/@value, 'relatie.*medicatieafspraak')">
                  <relatie_medicatieafspraak>
                     <identificatie value="{f:identifier/f:value/@value}"
                                    root="{replace(f:identifier/f:system/@value, 'urn:oid:', '')}"/>
                  </relatie_medicatieafspraak>
               </xsl:when>
               <xsl:when test="matches(f:identifier/f:value/@value, '_TA$') or matches(f:display/@value, 'relatie.*toedieningsafspraak')">
                  <relatie_toedieningsafspraak>
                     <identificatie value="{f:identifier/f:value/@value}"
                                    root="{replace(f:identifier/f:system/@value, 'urn:oid:', '')}"/>
                  </relatie_toedieningsafspraak>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="util:logMessage">
                     <xsl:with-param name="level"
                                     select="$logERROR"/>
                     <xsl:with-param name="msg">
                        <xsl:value-of select="./local-name()"/>
                        <xsl:text> with system/value '</xsl:text>
                        <xsl:value-of select="f:system/f:value/@value"/>
                        <xsl:text>' relatie_medicatieafspraak nor relatie_toedieningsafspraak could be established. Therefore information  will be lost.</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="f:type/@value = 'MedicationRequest' or $resource[f:MedicationRequest/f:identifier]">
            <relatie_medicatieafspraak>
               <xsl:call-template name="Identifier-to-identificatie">
                  <xsl:with-param name="in"
                                  select="(f:identifier | $resource/f:MedicationRequest/f:identifier)[1]"/>
                  <xsl:with-param name="adaElementName">identificatie</xsl:with-param>
               </xsl:call-template>
            </relatie_medicatieafspraak>
         </xsl:when>
         <xsl:when test="f:type/@value = 'MedicationDispense' or $resource[f:MedicationDispense/f:identifier]">
            <xsl:choose>
               <!-- TODO this extension not yet defined in profile -->
               <xsl:when test="f:extension/f:valueCode/@value = 'ta'">
                  <relatie_toedieningsafspraak>
                     <xsl:call-template name="Identifier-to-identificatie">
                        <xsl:with-param name="in"
                                        select="(f:identifier | $resource/f:MedicationDispense/f:identifier)[1]"/>
                        <xsl:with-param name="adaElementName">identificatie</xsl:with-param>
                     </xsl:call-template>
                  </relatie_toedieningsafspraak>
               </xsl:when>
               <xsl:when test="f:extension/f:valueCode/@value = 'mve'">
                  <relatie_medicatieverstrekking>
                     <xsl:call-template name="Identifier-to-identificatie">
                        <xsl:with-param name="in"
                                        select="(f:identifier | $resource/f:MedicationDispense/f:identifier)[1]"/>
                        <xsl:with-param name="adaElementName">identificatie</xsl:with-param>
                     </xsl:call-template>
                  </relatie_medicatieverstrekking>
               </xsl:when>
               <xsl:otherwise>
                  <!-- let's assume a TA -->
                  <xsl:call-template name="util:logMessage">
                     <xsl:with-param name="level"
                                     select="$logERROR"/>
                     <xsl:with-param name="msg">
                        <xsl:value-of select="parent::f:resource/f:*/local-name()"/>
                        <xsl:text> with fullUrl '</xsl:text>
                        <xsl:value-of select="parent::f:resource/f:*/parent::f:resource/preceding-sibling::f:fullUrl/@value"/>
                        <xsl:text>' could not determine if reference was to administration agreement or medication dispense, assuming administration agreement.</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
                  <relatie_toedieningsafspraak>
                     <xsl:call-template name="Identifier-to-identificatie">
                        <xsl:with-param name="in"
                                        select="(f:identifier | $resource/f:MedicationDispense/f:identifier)[1]"/>
                        <xsl:with-param name="adaElementName">identificatie</xsl:with-param>
                     </xsl:call-template>
                  </relatie_toedieningsafspraak>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="util:logMessage">
               <xsl:with-param name="level"
                               select="$logERROR"/>
               <xsl:with-param name="msg">
                  <xsl:value-of select="parent::f:resource/f:*/local-name()"/>
                  <xsl:text> with fullUrl '</xsl:text>
                  <xsl:value-of select="parent::f:resource/f:*/parent::f:resource/preceding-sibling::f:fullUrl/@value"/>
                  <xsl:text>' reference cannot be resolved within the Bundle nor can the type of reference be determined by the identifier. Therefore information (potentially the relation to medication agreeement, administration agreement or medication dispense) will be lost.</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:extension with extension url ext-MedicationUse.Author to auteur</xd:desc>
   </xd:doc>
   <xsl:template match="f:extension[@url = $extMedicationUseAuthor]"
                 mode="nl-core-MedicationUse2">
      <xsl:variable name="referenceValue"
                    select="f:valueReference/f:reference/@value"/>
      <xsl:variable name="resource"
                    select="(ancestor::f:Bundle/f:entry[f:fullUrl/@value = nf:process-reference($referenceValue, ancestor::f:entry/f:fullUrl/@value)]/f:resource/f:*)[1]"/>
      <auteur>
         <xsl:choose>
            <xsl:when test="$resource/local-name() = 'Patient'">
               <auteur_is_patient>
                  <xsl:attribute name="value"
                                 select="'true'"/>
               </auteur_is_patient>
            </xsl:when>
            <xsl:when test="$resource/local-name() = 'Practitioner'">
               <auteur_is_zorgverlener>
                  <zorgverlener datatype="reference"
                                value="{nf:process-reference-2NCName(f:valueReference/f:reference/@value, ancestor::f:entry/f:fullUrl/@value)}"/>
               </auteur_is_zorgverlener>
            </xsl:when>
            <xsl:when test="$resource/local-name() = 'PractitionerRole'">
               <auteur_is_zorgverlener>
                  <xsl:variable name="practitionerRole"
                                select="string(f:valueReference/f:reference/@value)"/>
                  <!-- LR: waar dient practitioner variabel voor? -->
                  <xsl:variable name="practitioner"
                                select="string(/f:Bundle/f:entry[f:fullUrl/@value eq $practitionerRole]/f:resource/f:PractitionerRole/f:practitioner/f:reference/@value)"/>
                  <zorgverlener datatype="reference"
                                value="{nf:process-reference-2NCName($practitionerRole, ancestor::f:entry/f:fullUrl/@value)}"/>
               </auteur_is_zorgverlener>
            </xsl:when>
            <xsl:when test="$resource/local-name() = 'Organization'">
               <auteur_is_zorgaanbieder>
                  <xsl:apply-templates select="$resource"
                                       mode="nl-core-organization-2.0">
                     <xsl:with-param name="organizationIdUnderscore"
                                     select="true()"
                                     tunnel="yes"/>
                  </xsl:apply-templates>
               </auteur_is_zorgaanbieder>
            </xsl:when>
         </xsl:choose>
      </auteur>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:extension with f:extension ext-MedicationUse2.Prescriber to voorschrijver</xd:desc>
   </xd:doc>
   <xsl:template match="f:extension[@url = $extMedicationUse2Prescriber]"
                 mode="nl-core-MedicationUse2">
      <voorschrijver>
         <zorgverlener value="{nf:process-reference-2NCName(f:valueReference/f:reference/@value, ancestor::f:entry/f:fullUrl/@value)}"
                       datatype="reference"/>
      </voorschrijver>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:extension with extension url "$asAgreedIndicator-url" to volgens_afspraak_indicator</xd:desc>
   </xd:doc>
   <xsl:template match="f:extension[@url = $urlExtAsAgreedIndicator]"
                 mode="nl-core-MedicationUse2">
      <volgens_afspraak_indicator>
         <xsl:attribute name="value"
                        select="f:valueBoolean/@value"/>
      </volgens_afspraak_indicator>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:reasonCode to reden_gebruik</xd:desc>
   </xd:doc>
   <xsl:template match="f:reasonCode"
                 mode="nl-core-MedicationUse2">
      <reden_gebruik value="{f:text/@value}"/>
   </xsl:template>
   <!--    <xd:doc>
        <xd:desc>Template to convert f:extension with extension url "$reasonForChangeOrDiscontinuationOfUse-url" to reden_wijzigen_of_stoppen_gebruik</xd:desc>
    </xd:doc>
    <xsl:template match="f:extension[@url = $zib-MedicationUse-ReasonForChangeOrDiscontinuationOfUse]" mode="nl-core-MedicationUse2">
        <xsl:call-template name="CodeableConcept-to-code">
            <xsl:with-param name="in" select="f:valueCodeableConcept"/>
            <xsl:with-param name="adaElementName" select="'reden_wijzigen_of_stoppen_gebruik'"/>
        </xsl:call-template>
    </xsl:template>-->
   <xd:doc>
      <xd:desc>Template to convert f:note to toelichting.</xd:desc>
   </xd:doc>
   <xsl:template match="f:note"
                 mode="nl-core-MedicationUse2">
      <toelichting value="{f:text/@value}"/>
   </xsl:template>
</xsl:stylesheet>