<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.5-beta1/nl-core-HealthcareProvider.xsl == -->
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
                xmlns:local="#local.2024111408213023342010100"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <!-- ================================================================== -->
   <!--
        Converts ADA zorgaanbieder to FHIR Location resource conforming to profile nl-core-HealthcareProvider and FHIR Organization resource conforming to profile nl-core-HealthcareProvider-Organization.
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
   <xsl:variable name="profileNameHealthcareProvider">nl-core-HealthcareProvider</xsl:variable>
   <xsl:variable name="profileNameHealthcareProviderOrganization">nl-core-HealthcareProvider-Organization</xsl:variable>
   <!-- ================================================================== -->
   <xsl:template match="zorgaanbieder[not(zorgaanbieder)]"
                 mode="nl-core-HealthcareProvider"
                 name="nl-core-HealthcareProvider"
                 as="element(f:Location)?">
      <!-- Creates an nl-core-HealthcareProvider instance as a Location FHIR instance from ADA zorgaanbieder element. -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <Location>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameHealthcareProvider"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profileNameHealthcareProvider)}"/>
            </meta>
            <xsl:choose>
               <xsl:when test="organisatie_locatie/locatie_naam[@value]">
                  <name>
                     <xsl:call-template name="string-to-string"/>
                  </name>
               </xsl:when>
               <xsl:otherwise>
                  <!-- fallback on organisation name -->
                  <xsl:for-each select="organisatie_naam[@value]">
                     <name>
                        <xsl:call-template name="string-to-string"/>
                     </name>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="organisatie_locatie/locatie_nummer[@value]">
               <name>
                  <xsl:call-template name="string-to-string"/>
               </name>
            </xsl:for-each>
            <xsl:call-template name="nl-core-ContactInformation">
               <xsl:with-param name="in"
                               select="contactgegevens"/>
            </xsl:call-template>
            <xsl:call-template name="nl-core-AddressInformation">
               <xsl:with-param name="in"
                               select="adresgegevens"/>
            </xsl:call-template>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="."/>
               <xsl:with-param name="profile"
                               select="$profileNameHealthcareProviderOrganization"/>
               <xsl:with-param name="wrapIn"
                               select="'managingOrganization'"/>
            </xsl:call-template>
         </Location>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorgaanbieder[not(zorgaanbieder)]"
                 mode="nl-core-HealthcareProvider-Organization"
                 name="nl-core-HealthcareProvider-Organization"
                 as="element(f:Organization)?">
      <!-- Creates an nl-core-HealthcareProvider-Organization instance as an Organization FHIR instance from ADA zorgaanbieder element. -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <Organization>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameHealthcareProviderOrganization"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profileNameHealthcareProviderOrganization)}"/>
            </meta>
            <xsl:for-each select="zorgaanbieder_identificatienummer[@value]">
               <identifier>
                  <xsl:call-template name="id-to-Identifier">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </identifier>
            </xsl:for-each>
            <xsl:for-each select="organisatie_type | afdeling_specialisme">
               <type>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </type>
            </xsl:for-each>
            <xsl:for-each select="organisatie_naam">
               <name>
                  <xsl:call-template name="string-to-string"/>
               </name>
            </xsl:for-each>
            <xsl:call-template name="nl-core-ContactInformation">
               <xsl:with-param name="in"
                               select="contactgegevens"/>
            </xsl:call-template>
            <xsl:call-template name="nl-core-AddressInformation">
               <xsl:with-param name="in"
                               select="adresgegevens"/>
            </xsl:call-template>
         </Organization>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorgaanbieder"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing a HealthcareProvider, both to a Location and an Organization resource -->
      <xsl:param name="profile"
                 required="yes"
                 as="xs:string">
         <!-- Parameter to indicate for which target profile a display is to be generated. -->
      </xsl:param>
      <xsl:choose>
         <xsl:when test="$profile = $profileNameHealthcareProvider">
            <xsl:variable name="parts"
                          as="item()*">
               <xsl:text>Healthcare provider (location)</xsl:text>
               <xsl:value-of select="organisatie_naam/@value"/>
               <!-- only output location name if it is actually different from the organisation name -->
               <xsl:if test="organisatie_naam/@value != organisatie_locatie/locatie_naam/@value">
                  <xsl:value-of select="organisatie_locatie/locatie_naam/@value"/>
               </xsl:if>
               <xsl:if test="not(organisatie_naam/@value | organisatie_locatie/locatie_naam/@value)">
                  <xsl:value-of select="concat('organisation-id ', zorgaanbieder_identificatienummer/@value, ' in system ', zorgaanbieder_identificatienummer/@root)"/>
               </xsl:if>
               <xsl:value-of select="toelichting/@value"/>
            </xsl:variable>
            <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
         </xsl:when>
         <xsl:when test="$profile = $profileNameHealthcareProviderOrganization">
            <xsl:variable name="parts"
                          as="item()*">
               <xsl:text>Healthcare provider (organization)</xsl:text>
               <xsl:value-of select="organisatie_naam/@value"/>
               <xsl:if test="not(organisatie_naam/@value)">
                  <xsl:value-of select="concat('organisation-id ', zorgaanbieder_identificatienummer/@value, ' in system ', zorgaanbieder_identificatienummer/@root)"/>
               </xsl:if>
            </xsl:variable>
            <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
         </xsl:when>
         <xsl:when test="$profile = $profileNameHealthProfessionalPractitionerRole">
            <xsl:variable name="parts"
                          as="item()*">
               <xsl:text>Healthcare provider (organization via PractitionerRole)</xsl:text>
               <xsl:value-of select="organisatie_naam/@value"/>
               <xsl:if test="not(organisatie_naam/@value)">
                  <xsl:value-of select="concat('organisation-id ', zorgaanbieder_identificatienummer/@value, ' in system ', zorgaanbieder_identificatienummer/@root)"/>
               </xsl:if>
            </xsl:variable>
            <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorgaanbieder"
                 mode="_generateId">
      <!-- Template to generate a unique id to identify a HealthProfessional present in a (set of) ada-instance(s) -->
      <xsl:param name="profile"
                 required="yes"
                 as="xs:string">
         <!-- Parameter to indicate for which target profile an id is to be generated. -->
      </xsl:param>
      <xsl:param name="partNumber"
                 as="xs:integer"
                 select="0">
         <!-- The sequence number of the ADA instance being passed in the total collection of ADA instances of this kind. This sequence number is needed for uniqueness of ids in resources. -->
      </xsl:param>
      <xsl:param name="fullUrl"
                 tunnel="yes">
         <!-- If the HealthProvider is identified by fullUrl, this optional parameter can be used as fallback for an id -->
      </xsl:param>
      <xsl:variable name="organizationLocation"
                    select="(organisatie_locatie/locatie_naam/@value[not(. = '')], 'Location')[1]"/>
      <!-- we can use zorgaanbieder_identificatienummer as logicalId, from partNumber 2 onwards, we append the partNumber for uniqueness purposes -->
      <xsl:variable name="currentZaId"
                    select="nf:ada-healthprovider-id(zorgaanbieder_identificatienummer)"/>
      <xsl:variable name="uniqueString"
                    as="xs:string*">
         <xsl:choose>
            <xsl:when test="$currentZaId[@value | @root]">
               <xsl:for-each select="($currentZaId[@value | @root])[1]">
                  <!-- use append for Organization to also create stable id based on identifier, but make it unique cause Location uses the same -->
                  <xsl:if test="$profile = $profileNameHealthcareProviderOrganization">Org-</xsl:if>
                  <xsl:if test="$profile = $profileNameHealthProfessionalPractitionerRole">PrcRol-</xsl:if>
                  <!-- we remove '.' in root oid and '_' in extension to enlarge the chance of staying in 64 chars -->
                  <xsl:value-of select="concat(replace(@root, '\.', ''), '-', replace(@value, '_', ''))"/>
                  <xsl:if test="$partNumber gt 1">
                     <xsl:value-of select="concat('-', $partNumber)"/>
                  </xsl:if>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:next-match>
                  <xsl:with-param name="profile"
                                  select="$profile"/>
               </xsl:next-match>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="."
                           mode="generateLogicalId">
         <xsl:with-param name="uniqueString"
                         select="string-join($uniqueString, '')"/>
         <xsl:with-param name="profile"
                         select="$profile"/>
      </xsl:apply-templates>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:ada-healthprovider-id"
                 as="element()?">
      <!-- Selects the most appropriate health provider identification. For example to do deduplication of organizations or to base a logicalId on. -->
      <xsl:param name="healthcareProviderIdentification"
                 as="element()*">
         <!-- ADA element containing the healthcare provider organization identification -->
      </xsl:param>
      <xsl:choose>
         <xsl:when test="$healthcareProviderIdentification[@root = $oidURAOrganizations]">
            <xsl:copy-of select="$healthcareProviderIdentification[@root = $oidURAOrganizations][1]"/>
         </xsl:when>
         <xsl:when test="$healthcareProviderIdentification[@root = $oidAGB]">
            <xsl:copy-of select="$healthcareProviderIdentification[@root = $oidAGB][1]"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$healthcareProviderIdentification[1]"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorgaanbieder"
                 mode="_nl-core-HealthProfessional-PractitionerRole_toOrganization"
                 name="_nl-core-HealthProfessional-PractionerRole_toOrganization"
                 as="element(f:PractitionerRole)?">
      <!-- _nl-core-HealthProfessional-PractionerRole_toOrganization -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- the element to be handled, defaults to context item -->
      </xsl:param>
      <xsl:for-each select="$in">
         <PractitionerRole>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameHealthProfessionalPractitionerRole"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profileNameHealthProfessionalPractitionerRole)}"/>
            </meta>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$in"/>
               <xsl:with-param name="profile"
                               select="$profileNameHealthcareProviderOrganization"/>
               <xsl:with-param name="wrapIn"
                               select="'organization'"/>
            </xsl:call-template>
         </PractitionerRole>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>