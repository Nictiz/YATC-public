<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.7-beta1/nl-core-TreatmentDirective2.xsl == -->
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
                xmlns:local="#local.2024111408213063721520100">
   <!-- ================================================================== -->
   <!--
        Converts ADA behandel_aanwijzing to FHIR Consent resource conforming to profile nl-core-TreatmentDirective2.
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
   <xsl:variable name="profileNameTreatmentDirective"
                 select="'nl-core-TreatmentDirective2'"/>
   <!-- ================================================================== -->
   <xsl:template match="behandel_aanwijzing"
                 name="nl-core-TreatmentDirective2"
                 mode="nl-core-TreatmentDirective2"
                 as="element(f:Consent)?">
      <!-- Creates an nl-core-TreatmentDirective2 instance as a Consent FHIR instance from ADA behandel_aanwijzing element. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?">
         <!-- Optional ADA instance or ADA reference element for the patient. -->
      </xsl:param>
      <xsl:param name="advanceDirective"
                 select="wilsverklaring/wilsverklaring"
                 as="element()*"/>
      <xsl:param name="agreementParty"
                 select="afspraak_partij/*[self::patient or self::vertegenwoordiger or self::zorgverlener]/*"/>
      <xsl:for-each select="$in">
         <Consent>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameTreatmentDirective"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <xsl:for-each select="toelichting">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-Comment">
                  <valueString>
                     <xsl:call-template name="string-to-string">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueString>
               </extension>
            </xsl:for-each>
            <xsl:if test="count($advanceDirective) gt 1">
               <xsl:for-each select="$advanceDirective[position() gt 1]">
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-TreatmentDirective2.AdvanceDirective">
                     <valueReference>
                        <xsl:call-template name="makeReference">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </valueReference>
                  </extension>
               </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="specificatie_anders">
               <modifierExtension url="http://nictiz.nl/fhir/StructureDefinition/ext-TreatmentDirective2.SpecificationOther">
                  <valueString>
                     <xsl:call-template name="string-to-string"/>
                  </valueString>
               </modifierExtension>
            </xsl:for-each>
            <status>
               <xsl:variable name="startDate"
                             select="meest_recente_bespreekdatum/@value"/>
               <xsl:variable name="endDate"
                             select="datum_beeindigd/@value"/>
               <xsl:choose>
                  <!--When startDate is in the past and endDate is in the future or absent: _active_  -->
                  <xsl:when test="nf:isPast($startDate) and (nf:isFuture($endDate) or not($endDate)) ">
                     <xsl:attribute name="value"
                                    select="'active'"/>
                  </xsl:when>
                  <!-- When endDate is in the past: _inactive_  -->
                  <xsl:when test="nf:isPast($endDate)">
                     <xsl:attribute name="value"
                                    select="'inactive'"/>
                  </xsl:when>
                  <!-- When startDate is absent or in the future (not possible according to zib): _draft_ -->
                  <xsl:when test="not($startDate) or nf:isFuture($startDate)">
                     <xsl:attribute name="value"
                                    select="'draft'"/>
                  </xsl:when>
                  <!-- If no status can be derived from the startDate and endDate, the Consent is assumed to be active. 
                            A status code must be provided and no unknown code exists in the required ValueSet.-->
                  <xsl:otherwise>
                     <xsl:attribute name="value"
                                    select="'active'"/>
                  </xsl:otherwise>
               </xsl:choose>
            </status>
            <scope>
               <coding>
                  <system value="http://terminology.hl7.org/CodeSystem/consentscope"/>
                  <code value="treatment"/>
                  <display value="Treatment"/>
               </coding>
            </scope>
            <category>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="129125009"/>
                  <display value="verrichting met expliciete context"/>
               </coding>
            </category>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'patient'"/>
            </xsl:call-template>
            <xsl:for-each select="meest_recente_bespreekdatum">
               <dateTime>
                  <xsl:call-template name="date-to-datetime">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </dateTime>
            </xsl:for-each>
            <xsl:if test="$advanceDirective">
               <sourceReference>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="$advanceDirective[position() = 1]"/>
                  </xsl:call-template>
               </sourceReference>
            </xsl:if>
            <policy>
               <uri value="https://wetten.overheid.nl/"/>
            </policy>
            <xsl:if test="reden_beeindigd or behandel_besluit or specificatie_anders or datum_beeindigd or behandeling">
               <provision>
                  <xsl:for-each select="reden_beeindigd">
                     <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-TreatmentDirective2.ReasonForEnding">
                        <valueString>
                           <xsl:call-template name="string-to-string"/>
                        </valueString>
                     </extension>
                  </xsl:for-each>
                  <xsl:if test="behandel_besluit[@code = ('0', '2')]">
                     <type>
                        <xsl:for-each select="behandel_besluit">
                           <xsl:call-template name="code-to-code">
                              <xsl:with-param name="codeMap"
                                              as="element()*">
                                 <map inCode="0"
                                      inCodeSystem="2.16.840.1.113883.2.4.3.11.60.40.4.25.1"
                                      code="permit"/>
                                 <!-- code '1' is unmatched, 'specificatie_anders' should be present -->
                                 <map inCode="2"
                                      inCodeSystem="2.16.840.1.113883.2.4.3.11.60.40.4.25.1"
                                      code="deny"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:for-each>
                     </type>
                  </xsl:if>
                  <xsl:for-each select="datum_beeindigd">
                     <period>
                        <end>
                           <xsl:attribute name="value">
                              <xsl:call-template name="format2FHIRDate">
                                 <xsl:with-param name="dateTime"
                                                 select="xs:string(@value)"/>
                              </xsl:call-template>
                           </xsl:attribute>
                        </end>
                     </period>
                  </xsl:for-each>
                  <xsl:for-each select="$agreementParty">
                     <actor>
                        <role>
                           <coding>
                              <system value="http://terminology.hl7.org/CodeSystem/v3-RoleCode"/>
                              <code value="CONSENTER"/>
                              <display value="consenter"/>
                           </coding>
                        </role>
                        <reference>
                           <xsl:choose>
                              <xsl:when test=".[self::zorgverlener]">
                                 <xsl:call-template name="makeReference">
                                    <xsl:with-param name="in"
                                                    select="."/>
                                    <xsl:with-param name="profile"
                                                    select="$profileNameHealthProfessionalPractitionerRole"/>
                                 </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:call-template name="makeReference">
                                    <xsl:with-param name="in"
                                                    select="."/>
                                 </xsl:call-template>
                              </xsl:otherwise>
                           </xsl:choose>
                        </reference>
                     </actor>
                  </xsl:for-each>
                  <xsl:for-each select="behandeling">
                     <code>
                        <xsl:call-template name="code-to-CodeableConcept">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </code>
                  </xsl:for-each>
               </provision>
            </xsl:if>
         </Consent>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="wilsverklaring"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Wilsverklaring</xsl:text>
         <xsl:value-of select="wilsverklaring_type/@displayName"/>
         <xsl:value-of select="wilsverklaring_datum/@value"/>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>