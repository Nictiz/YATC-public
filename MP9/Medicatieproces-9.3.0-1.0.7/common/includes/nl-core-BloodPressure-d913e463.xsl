<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.5-beta1/nl-core-BloodPressure.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.7; 2025-01-17T18:03:28.04+01:00 == -->
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
                xmlns:local="#local.2024111408213003879750100">
   <!-- ================================================================== -->
   <!--
        Converts ADA bloeddruk to FHIR Observation resource conforming to profile nl-core-BloodPressure.
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
   <xsl:variable name="profileNameBloodPressure">nl-core-BloodPressure</xsl:variable>
   <!-- ================================================================== -->
   <xsl:template match="bloeddruk"
                 name="nl-core-BloodPressure"
                 mode="nl-core-BloodPressure"
                 as="element(f:Observation)?">
      <!-- Creates an nl-core-BloodPressure instance as an Observation FHIR instance from ADA bloeddruk element. -->
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
      <xsl:for-each select="$in">
         <Observation>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameBloodPressure"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <xsl:for-each select="houding">
               <extension url="http://hl7.org/fhir/StructureDefinition/observation-bodyPosition">
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueCodeableConcept>
               </extension>
            </xsl:for-each>
            <status value="final"/>
            <category>
               <coding>
                  <system value="http://terminology.hl7.org/CodeSystem/observation-category"/>
                  <code value="vital-signs"/>
                  <display value="Vital Signs"/>
               </coding>
            </category>
            <code>
               <coding>
                  <system value="{$oidMap[@oid=$oidLOINC]/@uri}"/>
                  <code value="85354-9"/>
                  <display value="Blood pressure panel with all children optional"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:for-each select="bloeddruk_datum_tijd">
               <effectiveDateTime>
                  <xsl:call-template name="date-to-datetime">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </effectiveDateTime>
            </xsl:for-each>
            <xsl:for-each select="toelichting">
               <note>
                  <text>
                     <xsl:call-template name="string-to-string">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </text>
               </note>
            </xsl:for-each>
            <xsl:for-each select="meet_locatie">
               <bodySite>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </bodySite>
            </xsl:for-each>
            <xsl:for-each select="meetmethode">
               <method>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </method>
            </xsl:for-each>
            <xsl:for-each select="systolische_bloeddruk">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidLOINC]/@uri}"/>
                        <code value="8480-6"/>
                        <display value="Systolic blood pressure"/>
                     </coding>
                  </code>
                  <valueQuantity>
                     <xsl:call-template name="hoeveelheid-to-Quantity">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueQuantity>
               </component>
            </xsl:for-each>
            <xsl:for-each select="diastolische_bloeddruk">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidLOINC]/@uri}"/>
                        <code value="8462-4"/>
                        <display value="Diastolic blood pressure"/>
                     </coding>
                  </code>
                  <valueQuantity>
                     <xsl:call-template name="hoeveelheid-to-Quantity">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueQuantity>
               </component>
            </xsl:for-each>
            <xsl:for-each select="diastolisch_eindpunt">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="85549003"/>
                        <display value="Korotkofftonen (waarneembare entiteit)"/>
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
            <xsl:for-each select="manchet_type">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="70665002"/>
                        <display value="Blood pressure cuff"/>
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
            <xsl:for-each select="gemiddelde_bloeddruk">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="6797001"/>
                        <display value="gemiddelde bloeddruk (waarneembare entiteit)"/>
                     </coding>
                  </code>
                  <valueQuantity>
                     <xsl:call-template name="hoeveelheid-to-Quantity">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueQuantity>
               </component>
            </xsl:for-each>
         </Observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="bloeddruk"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Blood pressure observation</xsl:text>
         <xsl:if test="bloeddruk_datum_tijd[@value]">
            <xsl:value-of select="concat('measurement date ', bloeddruk_datum_tijd/@value)"/>
         </xsl:if>
         <xsl:value-of select="toelichting/@value"/>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>