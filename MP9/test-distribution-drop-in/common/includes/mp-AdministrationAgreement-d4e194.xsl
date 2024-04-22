<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/HL7-mappings/ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.2/mp-AdministrationAgreement.xsl"?>
<?yatc-distribution-info name="VZVZ-test-distribution-drop-in" timestamp="2024-01-25T12:13:11.57+01:00" version="0.2"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/HL7-mappings/ada_2_fhir-r4/mp/9.3.0/payload/2.0.0-beta.2/mp-AdministrationAgreement.xsl == -->
<!-- == Distribution: VZVZ-test-distribution-drop-in; 0.2; 2024-01-25T12:13:11.57+01:00 == -->
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
      <xd:desc>Converts ADA toedienings_afsrpaak to FHIR MedicationDispense conforming to profile mp-AdministrationAgreement.</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Create an mp-AdministrationAgreement instance as a MedicationDispense FHIR instance from ADA toedienings_afspraak.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="metaTag">The meta tag to be added. Optional. Typical use case is 'actionable' for prescriptions or proposals. Empty for informational purposes.</xd:param>
      <xd:param name="subject">The MedicationDispense.subject as ADA element or reference.</xd:param>
      <xd:param name="medicationReference">The MedicationDispense.medicationReference as ADA element or reference.</xd:param>
      <xd:param name="performer">The MedicationDispense.performer as ADA element or reference.</xd:param>
      <xd:param name="authorizingPrescription">The MedicationDispense.authorizingPrescription as ADA element or reference.</xd:param>
   </xd:doc>
   <xsl:template name="mp-AdministrationAgreement"
                 mode="mp-AdministrationAgreement"
                 match="toedieningsafspraak"
                 as="element(f:MedicationDispense)?">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:param name="metaTag"
                 as="xs:string?"/>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?"/>
      <xsl:param name="medicationReference"
                 select="(geneesmiddel_bij_toedienings_afspraak | geneesmiddel_bij_toedieningsafspraak)/farmaceutisch_product"
                 as="element()?"/>
      <xsl:param name="performer"
                 select="verstrekker/zorgaanbieder"
                 as="element()?"/>
      <xsl:param name="authorizingPrescription"
                 select="medicatieafspraak/medicatieafspraak"
                 as="element()?"/>
      <xsl:for-each select="$in">
         <MedicationDispense>
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
            <xsl:for-each select="toedieningsafspraak_aanvullende_informatie[@code | @value | @nullFlavor]">
               <extension url="{$urlExtAdministrationAgreementAdditionalInformation}">
                  <!-- Issue MP-536 change from code to free text -->
                  <xsl:choose>
                     <xsl:when test="@code">
                        <!-- legacy support -->
                        <valueCodeableConcept>
                           <xsl:call-template name="code-to-CodeableConcept"/>
                        </valueCodeableConcept>
                     </xsl:when>
                     <xsl:otherwise>
                        <valueString>
                           <xsl:call-template name="string-to-string"/>
                        </valueString>
                     </xsl:otherwise>
                  </xsl:choose>
               </extension>
            </xsl:for-each>
            <!-- Issue MP-369 dataset concept name change -->
            <xsl:for-each select="(reden_afspraak | toedieningsafspraak_reden_wijzigen_of_staken)[@value][not(@code)]">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-AdministrationAgreement.AgreementReason">
                  <valueString>
                     <xsl:call-template name="string-to-string"/>
                  </valueString>
               </extension>
            </xsl:for-each>
            <!-- Issue MP-370 dataset concept type change from string to codelist -->
            <xsl:for-each select="(reden_afspraak | toedieningsafspraak_reden_wijzigen_of_staken)[@code]">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-AdministrationAgreement.ReasonModificationOrDiscontinuation">
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="treatNullFlavorAsCoding"
                                        select="true()"/>
                     </xsl:call-template>
                  </valueCodeableConcept>
               </extension>
            </xsl:for-each>
            <xsl:for-each select="toedieningsafspraak_datum_tijd">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-AdministrationAgreement.AdministrationAgreementDateTime">
                  <valueDateTime>
                     <xsl:attribute name="value">
                        <xsl:call-template name="format2FHIRDate">
                           <xsl:with-param name="dateTime"
                                           select="./@value"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </valueDateTime>
               </extension>
            </xsl:for-each>
            <xsl:for-each select="gebruiksinstructie">
               <xsl:call-template name="ext-RenderedDosageInstruction"/>
            </xsl:for-each>
            <xsl:for-each select="gebruiksperiode">
               <xsl:call-template name="ext-TimeInterval.Period"/>
            </xsl:for-each>
            <xsl:for-each select="kopie_indicator[@value | @nullFlavor]">
               <xsl:call-template name="ext-CopyIndicator"/>
            </xsl:for-each>
            <!-- pharmaceuticalTreatmentIdentifier -->
            <xsl:for-each select="../identificatie">
               <xsl:call-template name="ext-PharmaceuticalTreatmentIdentifier">
                  <xsl:with-param name="in"
                                  select="."/>
               </xsl:call-template>
            </xsl:for-each>
            <!-- Issue MP-257: add disribution form to toedieningsafspraak -->
            <xsl:for-each select="distributievorm[@code]">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-MedicationDispense.DistributionForm">
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept"/>
                  </valueCodeableConcept>
               </extension>
            </xsl:for-each>
            <!-- MP-449: add relatie_toedieningsafspraak -->
            <xsl:for-each select="relatie_toedieningsafspraak/identificatie[@value]">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-RelationAdministrationAgreement">
                  <valueReference>
                     <type value="MedicationDispense"/>
                     <identifier>
                        <xsl:call-template name="id-to-Identifier"/>
                     </identifier>
                     <display value="relatie naar toedieningsafspraak met identificatie: {string-join((@value, @root), ' || ')}"/>
                  </valueReference>
               </extension>
            </xsl:for-each>
            <xsl:for-each select="toedieningsafspraak_stop_type">
               <modifierExtension url="http://nictiz.nl/fhir/StructureDefinition/ext-StopType">
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept"/>
                  </valueCodeableConcept>
               </modifierExtension>
            </xsl:for-each>
            <!-- herhaalperiode_cyclisch_schema -->
            <xsl:for-each select="gebruiksinstructie">
               <xsl:call-template name="ext-InstructionsForUse.RepeatPeriodCyclicalSchedule"/>
            </xsl:for-each>
            <xsl:for-each select="identificatie[@value | @root]">
               <identifier>
                  <xsl:call-template name="id-to-Identifier"/>
               </identifier>
            </xsl:for-each>
            <!-- we do not know the current status of this instance -->
            <status value="unknown"/>
            <category>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="422037009"/>
                  <display value="toedieningsafspraak"/>
               </coding>
            </category>
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
            <xsl:for-each select="$performer">
               <performer>
                  <!-- There's at most 1 perfomer, so we can write both elements here -->
                  <actor>
                     <xsl:call-template name="makeReference">
                        <xsl:with-param name="profile">nl-core-HealthcareProvider-Organization</xsl:with-param>
                     </xsl:call-template>
                  </actor>
               </performer>
            </xsl:for-each>
            <!-- zib dataset -->
            <xsl:for-each select="$authorizingPrescription">
               <authorizingPrescription>
                  <xsl:call-template name="makeReference"/>
               </authorizingPrescription>
            </xsl:for-each>
            <!-- mp9 dataset -->
            <xsl:for-each select="relatie_medicatieafspraak/identificatie[@value | @root]">
               <authorizingPrescription>
                  <type value="MedicationRequest"/>
                  <identifier>
                     <xsl:call-template name="id-to-Identifier"/>
                  </identifier>
                  <display value="relatie naar medicatieafspraak met identificatie: {string-join((@value, @root), ' || ')}"/>
               </authorizingPrescription>
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
         </MedicationDispense>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a unique id to identify this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="toedieningsafspraak"
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
   <xsl:template match="toedieningsafspraak"
                 mode="_generateDisplay">
      <xsl:choose>
         <xsl:when test="identificatie[@value | @root]">
            <xsl:for-each select="identificatie[@value | @root][1]">
               <xsl:value-of select="concat('Toedieningsafspraak met identificatie ', @value, ' in identificatiesysteem: ', @root)"/>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="parts">
               <xsl:value-of select="'Administration agreement'"/>
               <xsl:if test="toedieningsafspraak_datum_tijd[@value]">
                  <xsl:value-of select="concat('agreed on: ', toedieningsafspraak_datum_tijd/@value, '.')"/>
               </xsl:if>
            </xsl:variable>
            <xsl:value-of select="string-join($parts, ' ')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>