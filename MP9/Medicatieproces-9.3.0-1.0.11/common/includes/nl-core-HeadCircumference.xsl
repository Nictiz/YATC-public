<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.5-beta1/nl-core-HeadCircumference.xsl == -->
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
                xmlns:local="#local.2024111408213021946610100">
   <!-- ================================================================== -->
   <!--
        Converts ADA schedelomvang to FHIR Observation resource conforming to profile nl-core-HeadCircumference.
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
   <xsl:variable name="profileNameHeadCircumference"
                 select="'nl-core-HeadCircumference'"/>
   <!-- ================================================================== -->
   <xsl:template match="schedelomvang"
                 name="nl-core-HeadCircumference"
                 mode="nl-core-HeadCircumference"
                 as="element(f:Observation)?">
      <!-- Creates an nl-core-HeadCircumference instance as an Observation FHIR instance from ADA schedelomvang element. -->
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
                               select="$profileNameHeadCircumference"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
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
                  <code value="9843-4"/>
                  <display value="Head Occipital-frontal circumference"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:for-each select="schedelomvang_datum_tijd">
               <effectiveDateTime>
                  <xsl:call-template name="date-to-datetime">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </effectiveDateTime>
            </xsl:for-each>
            <xsl:for-each select="schedelomvang_waarde">
               <valueQuantity>
                  <xsl:call-template name="hoeveelheid-to-Quantity">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </valueQuantity>
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
            <xsl:for-each select="schedelomvang_meetmethode">
               <method>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </method>
            </xsl:for-each>
         </Observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="schedelomvang"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Head circumference observation</xsl:text>
         <xsl:if test="schedelomvang_datum_tijd[@value]">
            <xsl:value-of select="concat('measurement date ', temperatuur_datum_tijd/@value)"/>
         </xsl:if>
         <xsl:value-of select="toelichting/@value"/>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>