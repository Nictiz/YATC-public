<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.8.0-beta.1/nl-core-VisualAcuity.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-01-29T18:25:49.35+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc scope="stylesheet">
      <xd:desc>Converts ADA visus to FHIR Observation resource conforming to profile nl-core-VisualAcuity.</xd:desc>
   </xd:doc>
   <xsl:variable name="profileNameVisualAcuity">nl-core-VisualAcuity</xsl:variable>
   <xd:doc>
      <xd:desc>Creates a FHIR Observation instance conforming to profile nl-core-VisualAcuity from ADA visus element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="subject">Optional ADA instance or ADA reference element for the patient.</xd:param>
   </xd:doc>
   <xsl:template match="visus"
                 name="nl-core-VisualAcuity"
                 mode="nl-core-VisualAcuity"
                 as="element(f:Observation)?">
      <xsl:param name="in"
                 select="."
                 as="element()?"/>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?"/>
      <xsl:for-each select="$in">
         <Observation>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameVisualAcuity"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <xsl:for-each select="visus_meet_hulpmiddel">
               <extension url="http://hl7.org/fhir/StructureDefinition/observation-deviceCode">
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueCodeableConcept>
               </extension>
            </xsl:for-each>
            <status value="final"/>
            <code>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="363983007"/>
                  <display value="visus"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:for-each select="visus_datum_tijd">
               <effectiveDateTime>
                  <xsl:attribute name="value">
                     <xsl:call-template name="format2FHIRDate">
                        <xsl:with-param name="dateTime"
                                        select="xs:string(./@value)"/>
                     </xsl:call-template>
                  </xsl:attribute>
               </effectiveDateTime>
            </xsl:for-each>
            <xsl:for-each select="decimale_visus_waarde">
               <valueQuantity>
                  <value value="{@value}"/>
               </valueQuantity>
            </xsl:for-each>
            <xsl:for-each select="anatomische_locatie[lateraliteit]">
               <bodySite>
                  <xsl:call-template name="nl-core-AnatomicalLocation"/>
                  <coding>
                     <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                     <code value="81745001"/>
                     <display value="oog"/>
                  </coding>
               </bodySite>
            </xsl:for-each>
            <xsl:for-each select="visus_meting_type">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="363983007"/>
                        <display value="visus"/>
                     </coding>
                  </code>
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueCodeableConcept>
               </component>
            </xsl:for-each>
            <xsl:for-each select="visus_meting_kaart">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="363691001"/>
                        <display value="verrichting ingedeeld naar hulpmiddel (verrichting)"/>
                     </coding>
                  </code>
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueCodeableConcept>
               </component>
            </xsl:for-each>
            <xsl:for-each select="afstand_tot_kaart">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="152731000146106"/>
                        <display value="afstand tot visuskaart"/>
                     </coding>
                  </code>
                  <valueQuantity>
                     <value value="{@value}"/>
                     <unit value="m"/>
                     <system value="http://unitsofmeasure.org"/>
                     <code value="{nf:convert_ADA_unit2UCUM_FHIR('m')}"/>
                  </valueQuantity>
               </component>
            </xsl:for-each>
         </Observation>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a display that can be shown when referencing this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="visus"
                 mode="_generateDisplay">
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Visual acuity observation</xsl:text>
         <xsl:if test="visus_datum_tijd[@value]">
            <xsl:value-of select="concat('measurement date ', visus_datum_tijd/@value)"/>
         </xsl:if>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>