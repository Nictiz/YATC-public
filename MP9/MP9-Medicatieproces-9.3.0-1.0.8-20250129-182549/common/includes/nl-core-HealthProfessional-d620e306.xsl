<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.5-beta1/nl-core-HealthProfessional.xsl == -->
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
                xmlns:local="#local.2024111408213025016680100"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <!-- ================================================================== -->
   <!--
        Converts ADA zorgverlener to FHIR PractitionerRole resource conforming to profile nl-core-HealthProfessional-PractitionerRole and FHIR Practitioner resource conforming to profile nl-core-HealthProfessional-Practitioner.
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
   <xsl:variable name="profileNameHealthProfessionalPractitionerRole">nl-core-HealthProfessional-PractitionerRole</xsl:variable>
   <xsl:variable name="profileNameHealthProfessionalPractitioner">nl-core-HealthProfessional-Practitioner</xsl:variable>
   <!-- ================================================================== -->
   <xsl:template match="zorgverlener"
                 mode="nl-core-HealthProfessional-PractitionerRole"
                 name="nl-core-HealthProfessional-PractitionerRole"
                 as="element(f:PractitionerRole)?">
      <!-- Creates an nl-core-HealthProfessional-PractitionerRole instance as a PractitionerRole FHIR instance from ADA zorgverlener element. Please note that following the zib2020 R4 profiling guidelines, a PractitionerRole that references a Practitioner is considered more meaningful than directly referencing a Practitioner. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <!-- we need the zorgaanbieder resolved for deduplication purposes, if not received like that let's log a warning and do it now anyway -->
      <xsl:variable name="zorgverlenerWithResolvedZorgaanbieder"
                    as="element(zorgverlener)*">
         <xsl:choose>
            <xsl:when test="$in//zorgaanbieder[not(zorgaanbieder)][not(*)]/@value">
               <!-- let's resolve the zorgaanbieder ín the zorgverlener, to make sure we can find appropriate data in fhirMetaData -->
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logWARN"/>
                  <xsl:with-param name="msg">nl-core-HealthProfessional-Practitioner: Expected an ada zorgverlener with resolved zorgaanbieder. This is needed for proper deduplication. Please check this! </xsl:with-param>
               </xsl:call-template>
               <xsl:apply-templates select="$in"
                                    mode="resolveAdaZorgaanbieder"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- the input zorgverlener has a resolved zorgaanbieder -->
               <xsl:sequence select="$in"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:for-each select="$zorgverlenerWithResolvedZorgaanbieder">
         <PractitionerRole>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameHealthProfessionalPractitionerRole"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profileNameHealthProfessionalPractitionerRole)}"/>
            </meta>
            <xsl:if test="zorgverlener_identificatienummer | naamgegevens | geslacht | adresgegevens">
               <practitioner>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="profile"
                                     select="$profileNameHealthProfessionalPractitioner"/>
                  </xsl:call-template>
               </practitioner>
            </xsl:if>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="zorgaanbieder"/>
               <xsl:with-param name="profile"
                               select="$profileNameHealthcareProviderOrganization"/>
               <xsl:with-param name="wrapIn"
                               select="'organization'"/>
            </xsl:call-template>
            <xsl:for-each select="specialisme">
               <specialty>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </specialty>
            </xsl:for-each>
            <xsl:for-each select="contactgegevens">
               <xsl:call-template name="nl-core-ContactInformation"/>
            </xsl:for-each>
         </PractitionerRole>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorgverlener"
                 mode="nl-core-HealthProfessional-Practitioner"
                 name="nl-core-HealthProfessional-Practitioner"
                 as="element(f:Practitioner)*">
      <!-- Creates an nl-core-HealthProfessional-Practitioner instance as a Practitioner FHIR instance from ADA zorgverlener element. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <!-- we need the zorgaanbieder resolved for deduplication purposes, if not received like that let's log a warning and do it now anyway -->
      <xsl:variable name="zorgverlenerWithResolvedZorgaanbieder"
                    as="element(zorgverlener)*">
         <xsl:choose>
            <xsl:when test="$in//zorgaanbieder[not(zorgaanbieder)][not(*)]/@value">
               <!-- let's resolve the zorgaanbieder ín the zorgverlener, to make sure we can find appropriate data in fhirMetaData -->
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logWARN"/>
                  <xsl:with-param name="msg">nl-core-HealthProfessional-Practitioner: Expected an ada zorgverlener with resolved zorgaanbieder. This is needed for proper deduplication. Please check this! </xsl:with-param>
               </xsl:call-template>
               <xsl:apply-templates select="$in"
                                    mode="resolveAdaZorgaanbieder"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- the input zorgverlener has a resolved zorgaanbieder -->
               <xsl:sequence select="$in"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:for-each select="$zorgverlenerWithResolvedZorgaanbieder">
         <Practitioner>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="in"
                               select="."/>
               <xsl:with-param name="profile"
                               select="$profileNameHealthProfessionalPractitioner"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profileNameHealthProfessionalPractitioner)}"/>
            </meta>
            <xsl:for-each select="zorgverlener_identificatienummer">
               <identifier>
                  <xsl:call-template name="id-to-Identifier">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </identifier>
            </xsl:for-each>
            <xsl:for-each select="naamgegevens">
               <xsl:call-template name="nl-core-NameInformation"/>
            </xsl:for-each>
            <xsl:for-each select="contactgegevens">
               <xsl:call-template name="nl-core-ContactInformation"/>
            </xsl:for-each>
            <xsl:for-each select="adresgegevens">
               <xsl:call-template name="nl-core-AddressInformation"/>
            </xsl:for-each>
            <xsl:for-each select="geslacht">
               <gender>
                  <xsl:call-template name="code-to-code">
                     <xsl:with-param name="in"
                                     select="."/>
                     <xsl:with-param name="codeMap"
                                     as="element()*">
                        <map inCode="M"
                             inCodeSystem="2.16.840.1.113883.5.1"
                             code="male"/>
                        <map inCode="F"
                             inCodeSystem="2.16.840.1.113883.5.1"
                             code="female"/>
                        <map inCode="UN"
                             inCodeSystem="2.16.840.1.113883.5.1"
                             code="other"/>
                        <map inCode="UNK"
                             inCodeSystem="2.16.840.1.113883.5.1008"
                             code="unknown"/>
                     </xsl:with-param>
                  </xsl:call-template>
                  <xsl:call-template name="ext-CodeSpecification"/>
               </gender>
            </xsl:for-each>
         </Practitioner>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorgverlener"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing a HealthProfessional, both to a PractitionerRole and a Practitioner resource -->
      <xsl:param name="profile"
                 required="yes"
                 as="xs:string">
         <!-- Parameter to indicate for which target profile a display is to be generated. -->
      </xsl:param>
      <!-- let's resolve the zorgaanbieder ín the zorgverlener, to make sure we can find appropriate data in fhirMetaData -->
      <xsl:variable name="zorgverlenerWithResolvedZorgaanbieder"
                    as="element(zorgverlener)*">
         <xsl:apply-templates select="."
                              mode="resolveAdaZorgaanbieder"/>
      </xsl:variable>
      <xsl:for-each select="$zorgverlenerWithResolvedZorgaanbieder">
         <xsl:variable name="personIdentifier"
                       select="nf:ada-zvl-id(.//zorgverlener_identificatienummer[1])"/>
         <xsl:variable name="personIdentifierDisplay">
            <xsl:variable name="codesystemDisplay"
                          as="xs:string?">
               <xsl:choose>
                  <xsl:when test="string-length($oidMap[@oid = $personIdentifier/@root]/@displayName) gt 0">
                     <xsl:value-of select="$oidMap[@oid = $personIdentifier/@root]/@displayName"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$personIdentifier/@root"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="idDisplay"
                          as="xs:string*">
               <xsl:if test="string-length($personIdentifier/@value) gt 0">person identification: 
<xsl:value-of select="normalize-space($personIdentifier/@value)"/>
               </xsl:if>
               <xsl:if test="string-length($codesystemDisplay) gt 0"> from system 
<xsl:value-of select="normalize-space($codesystemDisplay)"/>
               </xsl:if>
            </xsl:variable>
            <xsl:value-of select="normalize-space(string-join($idDisplay, ' '))"/>
         </xsl:variable>
         <xsl:variable name="personName"
                       select="nf:renderName(naamgegevens)"/>
         <xsl:variable name="organizationName"
                       select=".//organisatie_naam[1]/@value"/>
         <xsl:variable name="specialty"
                       select=".//specialisme[not(@codeSystem = $oidHL7NullFlavor)][1]/@displayName"/>
         <xsl:variable name="role"
                       select=".//zorgverleners_rol[1]/(@displayName, @code)[1]"/>
         <xsl:choose>
            <xsl:when test="$profile = $profileNameHealthProfessionalPractitionerRole">
               <xsl:variable name="parts"
                             as="item()*">
                  <xsl:text>Healthcare professional (role)</xsl:text>
                  <xsl:value-of select="$personName"/>
                  <xsl:value-of select="$specialty"/>
                  <xsl:value-of select="$organizationName"/>
                  <xsl:if test="not($specialty | $organizationName)">
                     <xsl:value-of select="$role"/>
                  </xsl:if>
               </xsl:variable>
               <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
            </xsl:when>
            <xsl:when test="$profile = $profileNameHealthProfessionalPractitioner">
               <xsl:variable name="parts"
                             as="item()*">
                  <xsl:text>Healthcare professional (person)</xsl:text>
                  <xsl:value-of select="$personName"/>
                  <xsl:if test="not($personName)">
                     <xsl:value-of select="$personIdentifierDisplay"/>
                  </xsl:if>
               </xsl:variable>
               <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorgverlener"
                 mode="_generateId">
      <!-- Template to generate a unique id to identify a HealthProfessional present in a (set of) ada-instance(s) -->
      <xsl:param name="profile"
                 required="yes"
                 as="xs:string">
         <!-- Profile being handled, to distinguish between Practitioner and PractitionerRole -->
      </xsl:param>
      <xsl:param name="partNumber"
                 as="xs:integer"
                 select="0">
         <!-- The sequence number of the ADA instance being passed in the total collection of ADA instances of this kind. This sequence number is needed for uniqueness of ids in resources. -->
      </xsl:param>
      <xsl:param name="fullUrl"
                 tunnel="yes">
         <!-- If the HealthProfessional is identified by fullUrl, this optional parameter can be used as fallback for an id -->
      </xsl:param>
      <!-- we need the zorgaanbieder resolved for deduplication purposes, if not received like that let's log a warning and do it now anyway -->
      <xsl:variable name="zorgverlenerWithResolvedZorgaanbieder"
                    as="element(zorgverlener)*">
         <xsl:choose>
            <xsl:when test=".//zorgaanbieder[not(zorgaanbieder)][not(*)]/@value">
               <!-- log a warning an resolve the zorgaanbieder ín the zorgverlener, to make sure we can find appropriate data in fhirMetaData -->
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logWARN"/>
                  <xsl:with-param name="msg">nl-core-HealthProfessional-Practitioner: Expected an ada zorgverlener with resolved zorgaanbieder. This is needed for proper deduplication. Please check this! </xsl:with-param>
               </xsl:call-template>
               <xsl:apply-templates select="."
                                    mode="resolveAdaZorgaanbieder"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- the input zorgverlener has a resolved zorgaanbieder -->
               <xsl:sequence select="."/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- we can use zorgverlener_identificatienummer as logicalId, from partNumber 2 onwards, we append the partNumber for uniqueness purposes -->
      <xsl:variable name="currentZvlId"
                    select="nf:ada-healthprofessional-id(zorgverlener_identificatienummer)"/>
      <xsl:variable name="uniqueString"
                    as="xs:string*">
         <xsl:choose>
            <xsl:when test="$currentZvlId[@value | @root]">
               <xsl:for-each select="($currentZvlId[@value | @root])[1]">
                  <!-- use append for PractitionerRole to also create stable id based on identifier, but make it unique -->
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
   <xsl:template match="zorgverlener//zorgaanbieder[zorgaanbieder]"
                 mode="resolveAdaZorgaanbieder">
      <!-- Do not copy the double nested zorgaanbieder -->
      <xsl:apply-templates select="node()"
                           mode="#current"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorgverlener//zorgaanbieder[@value][not(*)]"
                 mode="resolveAdaZorgaanbieder">
      <!-- Find the appropriate zorgaanbieder contents in this ada instance and copy those when found -->
      <!-- we'll be a bit tolerant, sometimes an undesired space is left behind in the reference -->
      <xsl:variable name="normalizedRef"
                    select="normalize-space(@value)"/>
      <xsl:choose>
         <!-- assumption zorgaanbieder is found at same level as zorgverlener, which is a reasonable assumption -->
         <xsl:when test="ancestor::zorgverlener/../zorgaanbieder[@id = $normalizedRef]">
            <!-- should be max one found, but defensive programming -->
            <xsl:copy-of select="(ancestor::zorgverlener/../zorgaanbieder[@id = $normalizedRef])[1]"/>
         </xsl:when>
         <!-- okay, assumption did not work out, let's search anywhere in the ada instance -->
         <xsl:when test="ancestor::adaxml/data/*//zorgaanbieder[@id = current()/@value]">
            <!-- should be max one found, but defensive programming -->
            <xsl:copy-of select="(ancestor::adaxml/data/*//zorgaanbieder[@id = $normalizedRef])[1]"/>
         </xsl:when>
         <!-- even that did not work out, the ada instance really let us down. Now we'll have to fallback on whatever was in input -->
         <xsl:otherwise>
            <xsl:call-template name="util:logMessage">
               <xsl:with-param name="level"
                               select="$logWARN"/>
               <xsl:with-param name="msg">nl-core-HealthProfessional: the ada instance really let us down, we could not resolve the zorgaanbieder with @id: '
<xsl:value-of select="current()/@value"/>'. Now we'll have to fallback on whatever was in input and this will not be nice. Please check this! </xsl:with-param>
            </xsl:call-template>
            <xsl:copy>
               <xsl:apply-templates select="@* | node()"
                                    mode="#current"/>
            </xsl:copy>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="@* | node()"
                 mode="resolveAdaZorgaanbieder">
      <!-- Default copy template -->
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"
                              mode="#current"/>
      </xsl:copy>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:ada-healthprofessional-id"
                 as="element()?">
      <!-- Selects the most appropriate health professional identification. For example to do deduplication of persons or to base a logicalId on. -->
      <xsl:param name="healthProfessionalIdentification"
                 as="element()*">
         <!-- ADA element containing the health professional identification -->
      </xsl:param>
      <xsl:choose>
         <xsl:when test="$healthProfessionalIdentification[@root = $oidUZIPersons]">
            <xsl:copy-of select="$healthProfessionalIdentification[@root = $oidUZIPersons][1]"/>
         </xsl:when>
         <xsl:when test="$healthProfessionalIdentification[@root = $oidAGB]">
            <xsl:copy-of select="$healthProfessionalIdentification[@root = $oidAGB][1]"/>
         </xsl:when>
         <xsl:when test="$healthProfessionalIdentification[@root = $oidBIGregister]">
            <xsl:copy-of select="$healthProfessionalIdentification[@root = $oidBIGregister][1]"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$healthProfessionalIdentification[1]"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
</xsl:stylesheet>