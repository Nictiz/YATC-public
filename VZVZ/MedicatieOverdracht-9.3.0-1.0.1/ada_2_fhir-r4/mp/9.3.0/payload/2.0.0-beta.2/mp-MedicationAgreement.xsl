<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.2/mp-MedicationAgreement.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 1.0.1; 2024-04-18T12:43:34.01+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc scope="stylesheet">
      <xd:desc>Converts ADA medicatieafspraak to FHIR MedicationRequest conforming to profile mp-MedicationAgreement</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Create a mp-MedicationAgreement instance as a MedicationRequest FHIR instance from ADA medicatieafspraak.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="metaTag">The meta tag to be added. Optional. Typical use case is 'actionable' for prescriptions or proposals. Empty for informational purposes.</xd:param>
      <xd:param name="subject">The MedicationRequest.subject as ADA element or reference.</xd:param>
      <xd:param name="medicationReference">The MedicationRequest.medicationReference as ADA element or reference.</xd:param>
      <xd:param name="requester">The MedicationRequest.requester as ADA element or reference.</xd:param>
      <xd:param name="reasonReference">The MedicationRequest.reasonReference as ADA element or reference.</xd:param>
      <xd:param name="nextPractitioner">The practitioner who should follow up on the treatment, usually a general practitioner after discharge from hospital.</xd:param>
   </xd:doc>
   <xsl:template name="mp-MedicationAgreement"
                 mode="mp-MedicationAgreement"
                 match="medicatieafspraak"
                 as="element(f:MedicationRequest)?">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:param name="metaTag"
                 as="xs:string?"/>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?"/>
      <xsl:param name="medicationReference"
                 select="$in/ancestor::*[@app]//farmaceutisch_product[@id = $in/(afgesprokengeneesmiddel | afgesproken_geneesmiddel)/farmaceutisch_product/@value]"
                 as="element()?"/>
      <xsl:param name="requester"
                 select="$in/ancestor::*[@app]//zorgverlener[@id = $in/voorschrijver/zorgverlener/@value] | $in/voorschrijver/zorgverlener[*]"
                 as="element()?"/>
      <xsl:param name="nextPractitioner"
                 select="$in/ancestor::*[@app]//zorgverlener[@id = $in/volgende_behandelaar/zorgverlener/@value] | $in/volgende_behandelaar/zorgverlener[*]"
                 as="element()?"/>
      <!-- in the zib there is a reference to problem, in MP9 dataset problem has been inherited directly in reden_van_voorschrijven -->
      <xsl:param name="reasonReference"
                 select="$in//probleem[@id = $in/reden_van_voorschrijven/probleem/@value] | $in/reden_van_voorschrijven/probleem[*]"
                 as="element()?"/>
      <xsl:for-each select="$in">
         <MedicationRequest>
            <xsl:call-template name="insertLogicalId"/>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
               <xsl:if test="string-length($metaTag) gt 0">
                  <tag>
                     <system value="http://terminology.hl7.org/CodeSystem/common-tags"/>
                     <code value="{$metaTag}"/>
                  </tag>
               </xsl:if>
            </meta>
            <xsl:for-each select="(medicatieafspraak_aanvullende_informatie | aanvullende_informatie)">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-MedicationAgreement.MedicationAgreementAdditionalInformation">
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept"/>
                  </valueCodeableConcept>
               </extension>
            </xsl:for-each>
            <xsl:for-each select="gebruiksinstructie">
               <xsl:call-template name="ext-RenderedDosageInstruction"/>
            </xsl:for-each>
            <xsl:for-each select="gebruiksperiode">
               <xsl:call-template name="ext-TimeInterval.Period"/>
            </xsl:for-each>
            <!-- pharmaceuticalTreatmentIdentifier -->
            <xsl:for-each select="../identificatie">
               <xsl:call-template name="ext-PharmaceuticalTreatmentIdentifier">
                  <xsl:with-param name="in"
                                  select="."/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="relatie_zorgepisode/(identificatie | identificatienummer)[@value]">
               <xsl:call-template name="ext-Context-EpisodeOfCare"/>
            </xsl:for-each>
            <!-- voorstel toelichting -->
            <xsl:for-each select="ancestor::*[voorstel_gegevens]/voorstel_gegevens/voorstel/toelichting">
               <xsl:call-template name="ext-Comment"/>
            </xsl:for-each>
            <!-- MP-629: Add nextPractitioner extension -->
            <xsl:for-each select="$nextPractitioner">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-MedicationAgreement.NextPractitioner">
                  <valueReference>
                     <xsl:call-template name="makeReference">
                        <xsl:with-param name="profile">nl-core-HealthProfessional-PractitionerRole</xsl:with-param>
                     </xsl:call-template>
                  </valueReference>
               </extension>
            </xsl:for-each>
            <!--herhaalperiode_cyclisch_schema-->
            <xsl:for-each select="gebruiksinstructie">
               <xsl:call-template name="ext-InstructionsForUse.RepeatPeriodCyclicalSchedule"/>
            </xsl:for-each>
            <xsl:for-each select="medicatieafspraak_stop_type">
               <modifierExtension url="http://nictiz.nl/fhir/StructureDefinition/ext-StopType">
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept"/>
                  </valueCodeableConcept>
               </modifierExtension>
            </xsl:for-each>
            <xsl:for-each select="(identificatie | ancestor::*[voorstel_gegevens]/voorstel_gegevens/voorstel/identificatie)[@value | @root | @nullFlavor]">
               <identifier>
                  <xsl:call-template name="id-to-Identifier"/>
               </identifier>
            </xsl:for-each>
            <xsl:choose>
               <xsl:when test="ancestor::sturen_medicatievoorschrift">
                  <status value="active"/>
                  <intent value="order"/>
               </xsl:when>
               <xsl:when test="ancestor::*[contains(local-name(), 'voorstel')]">
                  <status value="active"/>
                  <intent value="plan"/>
               </xsl:when>
               <xsl:otherwise>
                  <!-- we do not know the current status of this instance -->
                  <status value="unknown"/>
                  <intent value="order"/>
               </xsl:otherwise>
            </xsl:choose>
            <!-- Issue MP-489: code updated to 33633005 -->
            <category>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="{$maCodeMP920}"/>
                  <display value="voorschrijven van geneesmiddel"/>
               </coding>
            </category>
            <xsl:for-each select="kopie_indicator[@value | @nullFlavor]">
               <reportedBoolean>
                  <xsl:call-template name="boolean-to-boolean"/>
               </reportedBoolean>
            </xsl:for-each>
            <xsl:for-each select="$medicationReference">
               <medicationReference>
                  <xsl:call-template name="makeReference"/>
               </medicationReference>
            </xsl:for-each>
            <xsl:for-each select="$subject">
               <subject>
                  <xsl:call-template name="makeReference"/>
               </subject>
            </xsl:for-each>
            <xsl:for-each select="relatie_contact/(identificatie | identificatienummer)[@value]">
               <encounter>
                  <xsl:apply-templates select="."
                                       mode="nl-core-Encounter-RefIdentifier"/>
               </encounter>
            </xsl:for-each>
            <xsl:for-each select="(medicatieafspraak_datum_tijd | ancestor::*[voorstel_gegevens]/voorstel_gegevens/voorstel/voorstel_datum)[@value | @nullFlavor]">
               <authoredOn>
                  <xsl:attribute name="value">
                     <xsl:call-template name="date-to-datetime"/>
                  </xsl:attribute>
               </authoredOn>
            </xsl:for-each>
            <xsl:for-each select="$requester">
               <requester>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="profile">
                        <xsl:choose>
                           <xsl:when test="self::zorgverlener">nl-core-HealthProfessional-PractitionerRole</xsl:when>
                           <xsl:when test="self::zorgaanbieder">nl-core-HealthcareProvider-Organization</xsl:when>
                        </xsl:choose>
                     </xsl:with-param>
                  </xsl:call-template>
               </requester>
            </xsl:for-each>
            <xsl:for-each select="(reden_medicatieafspraak | reden_wijzigen_of_staken)[@code]">
               <reasonCode>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="treatNullFlavorAsCoding"
                                     select="true()"/>
                  </xsl:call-template>
               </reasonCode>
            </xsl:for-each>
            <xsl:for-each select="$reasonReference">
               <reasonReference>
                  <xsl:call-template name="makeReference"/>
               </reasonReference>
            </xsl:for-each>
            <xsl:for-each select="relatie_toedieningsafspraak/identificatie[@value]">
               <basedOn>
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-RelationAdministrationAgreement">
                     <valueReference>
                        <type value="MedicationDispense"/>
                        <identifier>
                           <xsl:call-template name="id-to-Identifier"/>
                        </identifier>
                        <display value="relatie naar toedieningsafspraak met identificatie: {string-join((@value, @root), ' || ')}"/>
                     </valueReference>
                  </extension>
               </basedOn>
            </xsl:for-each>
            <xsl:for-each select="relatie_medicatiegebruik/identificatie[@value]">
               <basedOn>
                  <extension url="{$urlExtMedicationAgreementRelationMedicationUse}">
                     <valueReference>
                        <type value="MedicationStatement"/>
                        <identifier>
                           <xsl:call-template name="id-to-Identifier"/>
                        </identifier>
                        <display value="relatie naar medicatiegebruik met identificatie: {string-join((@value, @root), ' || ')}"/>
                     </valueReference>
                  </extension>
               </basedOn>
            </xsl:for-each>
            <xsl:for-each select="toelichting">
               <note>
                  <text>
                     <xsl:call-template name="string-to-string"/>
                  </text>
               </note>
            </xsl:for-each>
            <xsl:for-each select="gebruiksinstructie">
               <xsl:call-template name="mp-InstructionsForUse.DosageInstruction">
                  <xsl:with-param name="wrapIn">dosageInstruction</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="relatie_medicatieafspraak/identificatie[@value | @root | @nullFlavor]">
               <priorPrescription>
                  <type value="MedicationRequest"/>
                  <identifier>
                     <xsl:call-template name="id-to-Identifier"/>
                  </identifier>
                  <display value="relatie naar medicatieafspraak: {string-join((@value, @root), ' || ')}"/>
               </priorPrescription>
            </xsl:for-each>
         </MedicationRequest>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a unique id to identify this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="medicatieafspraak"
                 mode="_generateId">
      <xsl:variable name="uniqueString"
                    as="xs:string?">
         <xsl:choose>
            <xsl:when test="identificatie[@root][@value]">
               <xsl:for-each select="(identificatie[@root][@value])[1]">
                  <!-- we remove '.' in root oid and '_' in extension to enlarge the chance of staying in 64 chars -->
                  <xsl:value-of select="concat(replace(@root, '\.', ''), '-', replace(@value, '_', ''))"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <!-- we do not have anything to create a stable logicalId, lets return a UUID -->
               <xsl:value-of select="uuid:get-uuid(.)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="generateLogicalId">
         <xsl:with-param name="uniqueString"
                         select="$uniqueString"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a display that can be shown when referencing this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="medicatieafspraak"
                 mode="_generateDisplay">
      <xsl:choose>
         <xsl:when test="identificatie[@value | @root]">
            <xsl:for-each select="identificatie[@value | @root][1]">
               <xsl:value-of select="concat('Medicatieafspraak met identificatie ', @value, ' in identificatiesysteem: ', @root)"/>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="parts">
               <xsl:value-of select="'Medication agreement'"/>
               <xsl:if test="medicatieafspraak_datum_tijd[@value]">
                  <xsl:value-of select="concat(',agreed on: ', medicatieafspraak_datum_tijd/@value, '.')"/>
               </xsl:if>
            </xsl:variable>
            <xsl:value-of select="string-join($parts, ' ')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>