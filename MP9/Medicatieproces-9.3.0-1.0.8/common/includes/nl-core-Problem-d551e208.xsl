<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.5-beta1/nl-core-Problem.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-04-08T17:27:28.82+02:00 == -->
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
                xmlns:local="#local.202411140821304039350100"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <!-- ================================================================== -->
   <!--
        Converts ADA probleem to FHIR Condition resource conforming to profile nl-core-Problem.
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
   <xsl:variable name="profileNameProblem">nl-core-Problem</xsl:variable>
   <!-- ================================================================== -->
   <xsl:template match="probleem"
                 name="nl-core-Problem"
                 mode="nl-core-Problem"
                 as="element(f:Condition)?">
      <!-- Creates an nl-core-Problem instance as a Condition FHIR instance from ADA probleem element. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <xsl:param name="subject"
                 select="patient"
                 as="element()?">
         <!-- Optional ADA instance or ADA reference element for the patient. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <Condition>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameProblem"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <xsl:for-each select="probleem_status">
               <clinicalStatus>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                     <xsl:with-param name="codeMap"
                                     as="element()*">
                        <map inCode="55561003"
                             inCodeSystem="2.16.840.1.113883.6.96"
                             code="active"
                             codeSystem="http://terminology.hl7.org/CodeSystem/condition-clinical"
                             displayName="Active"/>
                        <map inCode="73425007"
                             inCodeSystem="2.16.840.1.113883.6.96"
                             code="inactive"
                             codeSystem="http://terminology.hl7.org/CodeSystem/condition-clinical"
                             displayName="Inactive"/>
                     </xsl:with-param>
                  </xsl:call-template>
               </clinicalStatus>
            </xsl:for-each>
            <xsl:for-each select="verificatie_status">
               <verificationStatus>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                     <xsl:with-param name="codeMap"
                                     as="element()*">
                        <map inCode="415684004"
                             inCodeSystem="2.16.840.1.113883.6.96"
                             code="provisional"
                             codeSystem="http://terminology.hl7.org/CodeSystem/condition-ver-status"
                             displayName="Provisional"/>
                        <map inCode="410590009"
                             inCodeSystem="2.16.840.1.113883.6.96"
                             code="differential"
                             codeSystem="http://terminology.hl7.org/CodeSystem/condition-ver-status"
                             displayName="Differential"/>
                        <map inCode="410605003"
                             inCodeSystem="2.16.840.1.113883.6.96"
                             code="confirmed"
                             codeSystem="http://terminology.hl7.org/CodeSystem/condition-ver-status"
                             displayName="Confirmed"/>
                        <map inCode="410516002"
                             inCodeSystem="2.16.840.1.113883.6.96"
                             code="refuted"
                             codeSystem="http://terminology.hl7.org/CodeSystem/condition-ver-status"
                             displayName="Refuted"/>
                        <map inCode="UNK"
                             inCodeSystem="2.16.840.1.113883.5.1008"
                             code="unconfirmed"
                             codeSystem="http://terminology.hl7.org/CodeSystem/condition-ver-status"
                             displayName="Unconfirmed"/>
                     </xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </verificationStatus>
            </xsl:for-each>
            <xsl:for-each select="probleem_type">
               <category>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </category>
            </xsl:for-each>
            <xsl:if test="probleem_naam or nadere_specificatie_probleem_naam">
               <code>
                  <xsl:if test="nadere_specificatie_probleem_naam">
                     <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-Problem.FurtherSpecificationProblemName">
                        <valueString>
                           <xsl:call-template name="string-to-string">
                              <xsl:with-param name="in"
                                              select="nadere_specificatie_probleem_naam"/>
                           </xsl:call-template>
                        </valueString>
                     </extension>
                  </xsl:if>
                  <xsl:if test="probleem_naam">
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="probleem_naam"/>
                     </xsl:call-template>
                  </xsl:if>
               </code>
            </xsl:if>
            <xsl:for-each select="probleem_anatomische_locatie">
               <bodySite>
                  <xsl:call-template name="nl-core-AnatomicalLocation"/>
               </bodySite>
            </xsl:for-each>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:for-each select="probleem_begin_datum">
               <onsetDateTime>
                  <xsl:call-template name="date-to-datetime">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </onsetDateTime>
            </xsl:for-each>
            <xsl:for-each select="probleem_eind_datum">
               <abatementDateTime>
                  <xsl:call-template name="date-to-datetime">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </abatementDateTime>
            </xsl:for-each>
            <xsl:for-each select="toelichting">
               <note>
                  <text value="{normalize-space(@value)}"/>
               </note>
            </xsl:for-each>
         </Condition>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="probleem"
                 mode="_generateId">
      <!-- Template to generate a unique id to identify this instance. -->
      <xsl:variable name="uniqueString"
                    as="xs:string?">
         <xsl:choose>
            <xsl:when test="identificatie[@root][@value][string-length(concat(@root, @value)) le $maxLengthFHIRLogicalId - 2]">
               <xsl:for-each select="(identificatie[@root][@value])[1]">
                  <xsl:value-of select="concat(@root, '-', @value)"/>
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
   <xsl:template match="probleem"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Problem</xsl:text>
         <xsl:value-of select="probleem/@value"/>
         <xsl:if test="probleem_type/@displayName">
            <xsl:value-of select="concat('type: ', probleem_type/@displayName)"/>
         </xsl:if>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>