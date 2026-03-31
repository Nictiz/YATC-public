<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.11.0-beta.1/nl-core-IllnessPerception.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.15; 2026-03-30T14:44:27.6+02:00 == -->
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
                xmlns:local="#local.202411140821295279060100">
   <!-- ================================================================== -->
   <!--
        Converts ADA ziektebeleving to FHIR Observation resource conforming to profile nl-core-IllnessPerception.
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
   <xsl:variable name="profileNameIllnessPerception"
                 select="'nl-core-IllnessPerception'"/>
   <xsl:variable name="profileNameIllnessPerceptionPatientIllnessInsight"
                 select="'nl-core-IllnessPerception.PatientIllnessInsight'"/>
   <xsl:variable name="profileNameIllnessPerceptionCopingWithIllnessByPatient"
                 select="'nl-core-IllnessPerception.CopingWithIllnessByPatient'"/>
   <xsl:variable name="profileNameIllnessPerceptionCopingWithIllnessByFamily"
                 select="'nl-core-IllnessPerception.CopingWithIllnessByFamily'"/>
   <!-- ================================================================== -->
   <xsl:template match="ziektebeleving"
                 name="nl-core-IllnessPerception"
                 mode="nl-core-IllnessPerception"
                 as="element(f:Observation)?">
      <!-- Creates an nl-core-IllnessPerception instance as an Observation FHIR instance from ADA ziektebeleving element. -->
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
                               select="$profileNameIllnessPerception"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <status value="final"/>
            <code>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="363910003"/>
                  <display value="kenmerk van psychosociaal functioneren"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:for-each select="ziekte_inzicht_van_patient">
               <hasMember>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="."/>
                     <xsl:with-param name="profile"
                                     select="$profileNameIllnessPerceptionPatientIllnessInsight"/>
                  </xsl:call-template>
               </hasMember>
            </xsl:for-each>
            <xsl:for-each select="omgaan_met_ziekteproces_door_patient">
               <hasMember>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="."/>
                     <xsl:with-param name="profile"
                                     select="$profileNameIllnessPerceptionCopingWithIllnessByPatient"/>
                  </xsl:call-template>
               </hasMember>
            </xsl:for-each>
            <xsl:for-each select="omgaan_met_ziekteproces_door_naasten">
               <hasMember>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="."/>
                     <xsl:with-param name="profile"
                                     select="$profileNameIllnessPerceptionCopingWithIllnessByFamily"/>
                  </xsl:call-template>
               </hasMember>
            </xsl:for-each>
         </Observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="ziekte_inzicht_van_patient[parent::ziektebeleving]"
                 name="nl-core-IllnessPerception.PatientIllnessInsight"
                 mode="nl-core-IllnessPerception.PatientIllnessInsight"
                 as="element(f:Observation)?">
      <!-- Creates an nl-core-IllnessPerception.PatientIllnessInsight instance as an Observation FHIR instance from ADA social_netwerk element. -->
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
                               select="$profileNameIllnessPerceptionPatientIllnessInsight"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <status value="final"/>
            <code>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="27026000"/>
                  <display value="inzicht"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <valueString>
               <xsl:call-template name="string-to-string">
                  <xsl:with-param name="in"
                                  select="."/>
               </xsl:call-template>
            </valueString>
         </Observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="omgaan_met_ziekteproces_door_patient[parent::ziektebeleving]"
                 name="nl-core-IllnessPerception.CopingWithIllnessByPatient"
                 mode="nl-core-IllnessPerception.CopingWithIllnessByPatient"
                 as="element(f:Observation)?">
      <!-- Creates an nl-core-IllnessPerception.CopingWithIllnessByPatient instance as an Observation FHIR instance from ADA social_netwerk element. -->
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
                               select="$profileNameIllnessPerceptionCopingWithIllnessByPatient"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <status value="final"/>
            <code>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="364667003"/>
                  <display value="vermogen tot coping"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <valueString>
               <xsl:call-template name="string-to-string">
                  <xsl:with-param name="in"
                                  select="."/>
               </xsl:call-template>
            </valueString>
         </Observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="omgaan_met_ziekteproces_door_naasten[parent::ziektebeleving]"
                 name="nl-core-IllnessPerception.CopingWithIllnessByFamily"
                 mode="nl-core-IllnessPerception.CopingWithIllnessByFamily"
                 as="element(f:Observation)?">
      <!-- Creates an nl-core-IllnessPerception.CopingWithIllnessByFamily instance as an Observation FHIR instance from ADA social_netwerk element. -->
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
                               select="$profileNameIllnessPerceptionCopingWithIllnessByFamily"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <status value="final"/>
            <code>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="405199009"/>
                  <display value="copinggedrag van familie"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <valueString>
               <xsl:call-template name="string-to-string">
                  <xsl:with-param name="in"
                                  select="."/>
               </xsl:call-template>
            </valueString>
         </Observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="ziektebeleving"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>IllnessPerception observation</xsl:text>
         <xsl:value-of select="toelichting/@value"/>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="ziekte_inzicht_van_patient[parent::ziektebeleving]"
                 mode="_generateDisplay">
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Ziekte inzicht van patiënt</xsl:text>
         <xsl:if test=".[@value]">
            <xsl:value-of select="./@value"/>
         </xsl:if>
      </xsl:variable>
      <xsl:value-of select="string-join($parts, ': ')"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="omgaan_met_ziekteproces_door_patient[parent::ziektebeleving]"
                 mode="_generateDisplay">
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Omgaan met ziekteproces door patiënt</xsl:text>
         <xsl:if test=".[@value]">
            <xsl:value-of select="./@value"/>
         </xsl:if>
      </xsl:variable>
      <xsl:value-of select="string-join($parts, ': ')"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="omgaan_met_ziekteproces_door_naasten[parent::ziektebeleving]"
                 mode="_generateDisplay">
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Omgaan met ziekteproces door naasten</xsl:text>
         <xsl:if test=".[@value]">
            <xsl:value-of select="./@value"/>
         </xsl:if>
      </xsl:variable>
      <xsl:value-of select="string-join($parts, ': ')"/>
   </xsl:template>
</xsl:stylesheet>