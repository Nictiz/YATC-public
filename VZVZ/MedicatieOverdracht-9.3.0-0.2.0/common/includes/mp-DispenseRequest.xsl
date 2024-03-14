<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/mp/9.2.0/payload/1.0/mp-DispenseRequest.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.2.0; 2024-03-14T08:34:46.14+01:00 == -->
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
      <xd:desc>Converts ADA verstrekkingsverzoek to FHIR MedicationRequest conforming to profile mp-DispenseRequest.</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Create an mp-DispenseRequest instance as a MedicationRequest FHIR instance from ADA verstrekkingsverzoek.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="metaTag">The meta tag to be added. Optional. Typical use case is 'actionable' for prescriptions or proposals. Empty for informational purposes.</xd:param>
      <xd:param name="subject">The MedicationRequest.subject as ADA element or reference.</xd:param>
      <xd:param name="medicationReference">The MedicationRequest.medicationReference as ADA element or reference.</xd:param>
      <xd:param name="performer">The MedicationDispense.performer as ADA element or reference.</xd:param>
   </xd:doc>
   <xsl:template name="mp-DispenseRequest"
                 mode="mp-DispenseRequest"
                 match="verstrekkingsverzoek"
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
                 select="te_verstrekken_geneesmiddel/farmaceutisch_product"
                 as="element()?"/>
      <xsl:param name="performer"
                 select="beoogd_verstrekker/zorgaanbieder"
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
            <xsl:for-each select="aanvullende_wensen">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.AdditionalWishes">
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept"/>
                  </valueCodeableConcept>
               </extension>
            </xsl:for-each>
            <!-- pharmaceuticalTreatmentIdentifier -->
            <xsl:for-each select="../identificatie">
               <xsl:call-template name="ext-PharmaceuticalTreatmentIdentifier">
                  <xsl:with-param name="in"
                                  select="."/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="financiele_indicatiecode">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.FinancialIndicationCode">
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept"/>
                  </valueCodeableConcept>
               </extension>
            </xsl:for-each>
            <xsl:for-each select="relatie_zorgepisode/(identificatie | identificatienummer)[@value]">
               <xsl:call-template name="ext-Context-EpisodeOfCare"/>
            </xsl:for-each>
            <!-- voorstel toelichting -->
            <xsl:for-each select="ancestor::*[voorstel_gegevens]/voorstel_gegevens/voorstel/toelichting">
               <xsl:call-template name="ext-Comment"/>
            </xsl:for-each>
            <xsl:for-each select="(identificatie | ancestor::*[voorstel_gegevens]/voorstel_gegevens/voorstel/identificatie)[@value | @root | @nullFlavor]">
               <identifier>
                  <xsl:call-template name="id-to-Identifier"/>
               </identifier>
            </xsl:for-each>
            <status>
               <xsl:attribute name="value">
                  <xsl:choose>
                     <xsl:when test="geannuleerd_indicator/@value = 'true'">entered-in-error</xsl:when>
                     <!-- There's no mapping from the dataset to the status except for geannuleerd_indicator, 
                            but we'll default to active in sturen_medicatievoorschrift and voorstel transacations -->
                     <xsl:when test="ancestor::sturen_medicatievoorschrift or ancestor::*[contains(local-name(), 'voorstel')]">active</xsl:when>
                     <!-- otherwise we don't know the status and can't make it up -->
                     <xsl:otherwise>unknown</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
            </status>
            <xsl:choose>
               <xsl:when test="ancestor::sturen_medicatievoorschrift">
                  <intent value="order"/>
               </xsl:when>
               <xsl:when test="ancestor::*[contains(local-name(), 'voorstel')]">
                  <intent value="plan"/>
               </xsl:when>
               <xsl:otherwise>
                  <intent value="order"/>
               </xsl:otherwise>
            </xsl:choose>
            <category>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="52711000146108"/>
                  <display value="verstrekkingsverzoek"/>
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
            <xsl:for-each select="relatie_contact/(identificatie | identificatienummer)[@value]">
               <encounter>
                  <xsl:apply-templates select="."
                                       mode="nl-core-Encounter-RefIdentifier"/>
               </encounter>
            </xsl:for-each>
            <!-- MP-560 name change dataset concept -->
            <xsl:for-each select="(verstrekkingsverzoek_datum | verstrekkingsverzoek_datum_tijd  | ancestor::*[voorstel_gegevens]/voorstel_gegevens/voorstel/voorstel_datum)[@value | @nullFlavor]">
               <authoredOn>
                  <xsl:attribute name="value">
                     <xsl:call-template name="date-to-datetime"/>
                  </xsl:attribute>
               </authoredOn>
            </xsl:for-each>
            <xsl:variable name="requester"
                          as="element()?">
               <xsl:choose>
                  <xsl:when test="auteur/zorgverlener/@value">
                     <xsl:sequence select="(ancestor::adaxml/data/*/bouwstenen/zorgverlener[@id = current()/auteur/zorgverlener/@value])[1]"/>
                  </xsl:when>
                  <xsl:when test="auteur//zorgverlener[not(zorgverlener)][*]">
                     <xsl:sequence select="(auteur//zorgverlener[not(zorgverlener)][*])[1]"/>
                  </xsl:when>
                  <!-- voorstel stuff -->
                  <xsl:when test="ancestor::*[voorstel_gegevens]/voorstel_gegevens/voorstel/auteur/*">
                     <xsl:for-each select="ancestor::*[voorstel_gegevens]/voorstel_gegevens/voorstel/auteur">
                        <xsl:choose>
                           <xsl:when test="auteur_is_zorgverlener/zorgverlener[@value]">
                              <xsl:sequence select="(ancestor::adaxml/data/*/bouwstenen/zorgverlener[@id = current()/auteur_is_zorgverlener/zorgverlener/@value])[1]"/>
                           </xsl:when>
                           <xsl:when test="auteur_is_zorgaanbieder/zorgaanbieder[@value]">
                              <xsl:sequence select="(ancestor::adaxml/data/*/bouwstenen/zorgaanbieder[@id = current()/auteur_is_zorgaanbieder/zorgaanbieder/@value])[1]"/>
                           </xsl:when>
                           <xsl:when test="auteur_is_patient[@value = 'true']">
                              <xsl:sequence select="(ancestor::*[patient[*]]/patient)[1]"/>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:for-each>
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
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
            <xsl:for-each select="$performer">
               <performer>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="profile"
                                     select="$profilenameHealthcareProviderOrganization"/>
                  </xsl:call-template>
               </performer>
            </xsl:for-each>
            <xsl:for-each select="relatie_medicatieafspraak/identificatie[@value]">
               <basedOn>
                  <type value="MedicationRequest"/>
                  <identifier>
                     <xsl:call-template name="id-to-Identifier"/>
                  </identifier>
                  <display value="relatie naar medicatieafspraak  met identificatie: {string-join((@value, @root), ' || ')}"/>
               </basedOn>
            </xsl:for-each>
            <xsl:for-each select="toelichting">
               <note>
                  <text>
                     <xsl:call-template name="string-to-string"/>
                  </text>
               </note>
            </xsl:for-each>
            <xsl:variable name="dispenseRequest"
                          as="element()*">
               <xsl:for-each select="afleverlocatie[@value]">
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-DispenseRequest.DispenseLocation">
                     <xsl:call-template name="makeReference">
                        <xsl:with-param name="in"
                                        select="."/>
                        <xsl:with-param name="wrapIn">valueReference</xsl:with-param>
                     </xsl:call-template>
                  </extension>
               </xsl:for-each>
               <xsl:for-each select="verbruiksperiode">
                  <xsl:call-template name="ext-TimeInterval.Period">
                     <xsl:with-param name="wrapIn">validityPeriod</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
               <xsl:for-each select="aantal_herhalingen">
                  <numberOfRepeatsAllowed value="{./@value}"/>
               </xsl:for-each>
               <!-- zib ada dataset -->
               <xsl:for-each select="te_verstrekken_hoeveelheid[@value]">
                  <quantity>
                     <xsl:call-template name="hoeveelheid-to-Quantity"/>
                  </quantity>
               </xsl:for-each>
               <!-- MP9 ada dataset -->
               <xsl:for-each select="te_verstrekken_hoeveelheid/aantal[@value]">
                  <quantity>
                     <xsl:call-template name="_buildMedicationQuantity">
                        <xsl:with-param name="adaValue"
                                        select="."/>
                        <xsl:with-param name="adaUnit"
                                        select="../eenheid[@codeSystem = $oidGStandaardBST902THES2]"/>
                     </xsl:call-template>
                  </quantity>
               </xsl:for-each>
            </xsl:variable>
            <xsl:if test="count($dispenseRequest) gt 0">
               <dispenseRequest>
                  <xsl:copy-of select="$dispenseRequest"/>
               </dispenseRequest>
            </xsl:if>
         </MedicationRequest>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a unique id to identify this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="verstrekkingsverzoek"
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
      <xd:desc>Template to generate a unique id to identify this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="verstrekkingsverzoek/afleverlocatie"
                 mode="_generateId">
      <xsl:variable name="uniqueString"
                    as="xs:string?">
         <xsl:choose>
            <xsl:when test="@value">
               <xsl:value-of select="@value"/>
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
   <xsl:template match="verstrekkingsverzoek"
                 mode="_generateDisplay">
      <xsl:text>Dispense request</xsl:text>
      <xsl:if test="afleverlocatie/@value">
         <xsl:value-of select="concat(', ', afleverlocatie/@value)"/>
      </xsl:if>
      <xsl:if test="verstrekkingsverzoekdatum[@value]">
         <xsl:value-of select="concat(' (', verstrekkingsverzoekdatum/@value, ')')"/>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>