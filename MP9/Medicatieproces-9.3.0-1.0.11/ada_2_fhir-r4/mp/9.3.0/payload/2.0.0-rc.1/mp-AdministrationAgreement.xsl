<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/mp/9.3.0/payload/2.0.0-rc.1/mp-AdministrationAgreement.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="#local.2024102208231510488350200"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <!-- ================================================================== -->
   <!--
        Converts ADA toedienings_afsrpaak to FHIR MedicationDispense conforming to profile mp-AdministrationAgreement.
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
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:variable name="taCode930"
                 select="$taCode[1]"/>
   <!-- ================================================================== -->
   <xsl:template name="mp-AdministrationAgreement"
                 mode="mp-AdministrationAgreement"
                 match="toedieningsafspraak"
                 as="element(f:MedicationDispense)?">
      <!-- Create an mp-AdministrationAgreement instance as a MedicationDispense FHIR instance from ADA toedienings_afspraak. -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <xsl:param name="metaTag"
                 as="xs:string?">
         <!-- The meta tag to be added. Optional. Typical use case is 'actionable' for prescriptions or proposals. Empty for informational purposes. -->
      </xsl:param>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?">
         <!-- The MedicationDispense.subject as ADA element or reference. -->
      </xsl:param>
      <xsl:param name="medicationReference"
                 select="(geneesmiddel_bij_toedienings_afspraak | geneesmiddel_bij_toedieningsafspraak)/farmaceutisch_product"
                 as="element()?">
         <!-- The MedicationDispense.medicationReference as ADA element or reference. -->
      </xsl:param>
      <xsl:param name="performer"
                 select="verstrekker/zorgaanbieder"
                 as="element()?">
         <!-- The MedicationDispense.performer as ADA element or reference. -->
      </xsl:param>
      <xsl:param name="authorizingPrescription"
                 select="medicatieafspraak/medicatieafspraak"
                 as="element()?">
         <!-- The MedicationDispense.authorizingPrescription as ADA element or reference. -->
      </xsl:param>
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
            <!-- MP-433: Starting from MP 9.3.0 beta.3 additionalInformation is nolonger supported in the profile AdministrationAgreement
                        however to ensure backwards compatibility, handling this extension is kept in the mapping -->
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
            <xsl:for-each select="toedieningsafspraak_datum_tijd[@value | @nullFlavor]">
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
            <!-- MP-1406 added registrationdatetime to MA/TA/WDS/MTD -->
            <xsl:for-each select="registratie_datum_tijd[@value | @nullFlavor]">
               <xsl:call-template name="ext-RegistrationDateTime"/>
            </xsl:for-each>
            <xsl:for-each select="gebruiksinstructie">
               <xsl:call-template name="ext-RenderedDosageInstruction"/>
            </xsl:for-each>
            <xsl:for-each select="gebruiksperiode">
               <xsl:call-template name="ext-mp-TimeInterval.Period"/>
            </xsl:for-each>
            <xsl:for-each select="kopie_indicator[@value | @nullFlavor]">
               <xsl:call-template name="ext-CopyIndicator"/>
            </xsl:for-each>
            <!-- pharmaceuticalTreatmentIdentifier -->
            <xsl:for-each select="../identificatie[@value | @root | @nullFlavor]">
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
            <xsl:for-each select="toedieningsafspraak_stop_type[@code]">
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
            <xsl:for-each select="identificatie[@value | @root | @nullFlavor]">
               <identifier>
                  <xsl:call-template name="id-to-Identifier"/>
               </identifier>
            </xsl:for-each>
            <!-- we do not know the current status of this instance -->
            <status value="unknown"/>
            <category>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="{$taCode930}"/>
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
            <xsl:for-each select="toelichting[@value]">
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
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="toedieningsafspraak"
                 mode="_generateId">
      <!-- Template to generate a unique id to identify this instance. -->
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
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="toedieningsafspraak"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
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