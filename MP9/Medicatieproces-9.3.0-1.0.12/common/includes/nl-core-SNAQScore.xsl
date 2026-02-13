<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.11.0-beta.1/nl-core-SNAQScore.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.12; 2026-02-13T13:07:12.23+01:00 == -->
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
                xmlns:local="#local.202411140821297347940100">
   <!-- ================================================================== -->
   <!--
        Converts ada snaqscore to FHIR Observation conforming to profile nl-core-SNAQScore
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
   <!-- ================================================================== -->
   <xsl:template match="snaqscore"
                 name="nl-core-SNAQScore"
                 mode="nl-core-SNAQScore"
                 as="element(f:Observation)?">
      <!-- Create an nl-core-SNAQScore instance as an Observation FHIR instance from ada snaqscore element. -->
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
                               select="'nl-core-SNAQScore'"/>
            </xsl:call-template>
            <meta>
               <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-SNAQScore"/>
            </meta>
            <status value="final"/>
            <code>
               <coding>
                  <system value="http://snomed.info/sct"/>
                  <code value="8881000146104"/>
                  <display value="Short Nutritional Assessment Questionnaire"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:for-each select="snaqscore_datum_tijd">
               <effectiveDateTime>
                  <xsl:call-template name="date-to-datetime">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </effectiveDateTime>
            </xsl:for-each>
            <xsl:for-each select="totaal_score">
               <valueInteger>
                  <xsl:attribute name="value">
                     <xsl:value-of select="@value"/>
                  </xsl:attribute>
               </valueInteger>
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
            <xsl:for-each select="gewichtsverlies_score">
               <component>
                  <code>
                     <coding>
                        <system value="urn:oid:2.16.840.1.113883.2.4.3.11.60.40.4.0.1"/>
                        <code value="4006003"/>
                        <display value="SNAQScore GewichtsverliesScore"/>
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
            <xsl:for-each select="eetlust_score">
               <component>
                  <code>
                     <coding>
                        <system value="urn:oid:2.16.840.1.113883.2.4.3.11.60.40.4.0.1"/>
                        <code value="4006004"/>
                        <display value="SNAQScore EetlustScore"/>
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
            <xsl:for-each select="voedings_score">
               <component>
                  <code>
                     <coding>
                        <system value="urn:oid:2.16.840.1.113883.2.4.3.11.60.40.4.0.1"/>
                        <code value="4006005"/>
                        <display value="SNAQScore VoedingsScore"/>
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
         </Observation>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>