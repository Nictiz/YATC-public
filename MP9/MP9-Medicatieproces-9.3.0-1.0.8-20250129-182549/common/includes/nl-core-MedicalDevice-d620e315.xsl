<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.5-beta1/nl-core-MedicalDevice.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-01-29T18:25:49.35+01:00 == -->
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
                xmlns:local="urn:fhir:stu3:functions">
   <!-- ================================================================== -->
   <!--
        Converts ADA medisch_hulpmiddel to FHIR DeviceUseStatement resource conforming to profile nl-core-MedicalDevice and FHIR Device resource conforming to profile nl-core-MedicalDevice.Product.
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
   <xsl:variable name="profileNameMedicalDevice">nl-core-MedicalDevice</xsl:variable>
   <xsl:variable name="profileNameMedicalDeviceProduct">nl-core-MedicalDevice.Product</xsl:variable>
   <!-- ================================================================== -->
   <xsl:template match="medisch_hulpmiddel"
                 name="nl-core-MedicalDevice"
                 mode="nl-core-MedicalDevice"
                 as="element(f:DeviceUseStatement)?">
      <!-- Creates an nl-core-MedicalDevice instance as a DeviceUseStatement FHIR instance from ADA medisch_hulpmiddel element. -->
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
      <xsl:param name="profile"
                 select="$profileNameMedicalDevice"
                 as="xs:string">
         <!-- Optional string that represents the (derived) profile of which a FHIR resource should be created. Defaults to 'nl-core-MedicalDevice'. Other uses are 'nl-core-HearingFunction.HearingAid', 'nl-core-VisualFunction.VisualAid' and 'nl-core-Wound.Drain'. -->
      </xsl:param>
      <xsl:param name="reasonReference"
                 as="element()?">
         <!-- Optional ADA instance used to populate the reasonReference element. Used for several zibs that contain a reference to MedicalDevice, which is mapped via this reasonReference. -->
      </xsl:param>
      <xsl:param name="reasonReferenceProfile"
                 as="xs:string"
                 select="''">
         <!-- Optional profile name for the FHIR instance that is referenced in reasonReference, when the reasonReference can result in multiple different profiles. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <DeviceUseStatement>
            <xsl:variable name="startDate"
                          select="begin_datum/@value"/>
            <xsl:variable name="endDate"
                          select="eind_datum/@value"/>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profile"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profile)}"/>
            </meta>
            <xsl:for-each select="zorgverlener">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-MedicalDevice.HealthProfessional">
                  <valueReference>
                     <xsl:call-template name="makeReference">
                        <xsl:with-param name="in"
                                        select="zorgverlener"/>
                        <xsl:with-param name="profile"
                                        select="$profileNameHealthProfessionalPractitionerRole"/>
                     </xsl:call-template>
                  </valueReference>
               </extension>
            </xsl:for-each>
            <xsl:for-each select="locatie">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-MedicalDevice.Location">
                  <valueReference>
                     <xsl:call-template name="makeReference">
                        <xsl:with-param name="in"
                                        select="zorgaanbieder"/>
                        <xsl:with-param name="profile"
                                        select="$profileNameHealthcareProvider"/>
                     </xsl:call-template>
                  </valueReference>
               </extension>
            </xsl:for-each>
            <status>
               <xsl:choose>
                  <!-- When startDate is in the future: _intended_  -->
                  <xsl:when test="nf:isFuture($startDate)">
                     <xsl:attribute name="value"
                                    select="'intended'"/>
                  </xsl:when>
                  <!--When startDate is in the past or absent and endDate is in the future or absent: _active_  -->
                  <xsl:when test="(not($startDate) or nf:isPast($startDate)) and (not($endDate) or nf:isFuture($endDate))">
                     <xsl:attribute name="value"
                                    select="'active'"/>
                  </xsl:when>
                  <!-- When startDate is absent or in the past and endDate is in the past: _completed_  -->
                  <xsl:when test="(not($startDate) or nf:isPast($startDate)) and nf:isPast($endDate)">
                     <xsl:attribute name="value"
                                    select="'completed'"/>
                  </xsl:when>
                  <!-- If no status can be derived from the startDate and endDate, the MedicalDevice is assumed to be active. 
                            A status code must be provided and no unknown code exists in the required ValueSet.-->
                  <xsl:otherwise>
                     <xsl:attribute name="value"
                                    select="'active'"/>
                  </xsl:otherwise>
               </xsl:choose>
            </status>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:if test="$startDate or $endDate">
               <timingPeriod>
                  <xsl:for-each select="begin_datum">
                     <start>
                        <xsl:call-template name="date-to-datetime">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </start>
                  </xsl:for-each>
                  <xsl:for-each select="eind_datum">
                     <end>
                        <xsl:call-template name="date-to-datetime">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </end>
                  </xsl:for-each>
               </timingPeriod>
            </xsl:if>
            <xsl:for-each select="product">
               <device>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="profile"
                                     select="concat($profile,'.Product')"/>
                  </xsl:call-template>
               </device>
            </xsl:for-each>
            <xsl:for-each select="indicatie">
               <xsl:call-template name="makeReference">
                  <xsl:with-param name="in"
                                  select="probleem"/>
                  <xsl:with-param name="wrapIn"
                                  select="'reasonReference'"/>
               </xsl:call-template>
            </xsl:for-each>
            <!--The element reasonReference is present to support resources that refer to a MedicalDevice, such as HearingFunction and VisualFunction. -->
            <xsl:for-each select="$reasonReference">
               <reasonReference>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="profile"
                                     select="$reasonReferenceProfile"/>
                  </xsl:call-template>
               </reasonReference>
            </xsl:for-each>
            <xsl:for-each select="anatomische_locatie">
               <bodySite>
                  <xsl:call-template name="nl-core-AnatomicalLocation">
                     <xsl:with-param name="profile"
                                     select="$profile"/>
                  </xsl:call-template>
               </bodySite>
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
         </DeviceUseStatement>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="product"
                 name="nl-core-MedicalDevice.Product"
                 mode="nl-core-MedicalDevice.Product"
                 as="element(f:Device)?">
      <!-- Creates an nl-core-MedicalDevice.Product instance as a Device FHIR instance from ADA product element. -->
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
      <xsl:param name="profile"
                 select="$profileNameMedicalDeviceProduct"
                 as="xs:string">
         <!-- Optional string that represents the (derived) profile of which a FHIR resource should be created. Defaults to 'nl-core-MedicalDevice.Product'. Other uses are 'nl-core-HearingFunction.HearingAid.Product', 'nl-core-VisualFunction.VisualAid.Product' and 'nl-core-Wound.Drain'. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <Device>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profile"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profile)}"/>
            </meta>
            <xsl:for-each select="product_id">
               <xsl:choose>
                  <xsl:when test="@codeSystem = ($oidGTIN, $oidHIBC)">
                     <identifier>
                        <system value="{local:getUri(@codeSystem)}"/>
                        <value value="{@code}"/>
                     </identifier>
                     <udiCarrier>
                        <issuer value="{local:getUri(@codeSystem)}"/>
                        <carrierHRF value="{@code}"/>
                     </udiCarrier>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- Let's hope for the best -->
                     <identifier>
                        <system value="{local:getUri(@codeSystem)}"/>
                        <value value="{@code}"/>
                     </identifier>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="product_type">
               <type>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </type>
            </xsl:for-each>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'patient'"/>
            </xsl:call-template>
            <xsl:for-each select="../product_omschrijving">
               <note>
                  <text>
                     <xsl:call-template name="string-to-string">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </text>
               </note>
            </xsl:for-each>
         </Device>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="product"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:value-of select="../product_omschrijving/@value"/>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>