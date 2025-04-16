<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.5-beta1/nl-core-EpisodeOfCare.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.10; 2025-04-16T18:06:20.52+02:00 == -->
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
                xmlns:local="#local.2024111408213018640290100"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <!-- ================================================================== -->
   <!--
        Converts ADA zorg_episode to FHIR EpisodeOfCare resource conforming to profile nl-core-EpisodeOfCare.
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
   <xsl:variable name="profileNameEpisodeOfCare"
                 select="'nl-core-EpisodeOfCare'"/>
   <!-- ================================================================== -->
   <xsl:template match="zorg_episode"
                 name="nl-core-EpisodeOfCare"
                 mode="nl-core-EpisodeOfCare"
                 as="element(f:EpisodeOfCare)">
      <!-- Create an nl-core-EpisodeOfCare instance as an EpisodeOfCare FHIR instance from ADA zorg_episode. -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?">
         <!-- The subject as ADA element or reference. -->
      </xsl:param>
      <xsl:param name="problem"
                 select="focus_zorg_episode/probleem"
                 as="element()?"/>
      <xsl:for-each select="$in">
         <EpisodeOfCare>
            <xsl:variable name="startDate"
                          select="begin_datum/@value"/>
            <xsl:variable name="endDate"
                          select="eind_datum/@value"/>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameEpisodeOfCare"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <xsl:for-each select="zorg_episode_naam">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-EpisodeOfCare.EpisodeOfCareName">
                  <valueString>
                     <xsl:call-template name="string-to-string">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueString>
               </extension>
            </xsl:for-each>
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
            <status>
               <xsl:choose>
                  <!-- When StartDate is present and StartDate in the future: _planned_  -->
                  <xsl:when test="nf:isFuture($startDate)">
                     <xsl:attribute name="value"
                                    select="'planned'"/>
                  </xsl:when>
                  <!--When StartDate is in the past and EndDate in the future or absent: _active_  -->
                  <xsl:when test="nf:isPast($startDate) and (nf:isFuture($endDate) or not($endDate))">
                     <xsl:attribute name="value"
                                    select="'active'"/>
                  </xsl:when>
                  <!-- When StartDate is absent or in the past and EndDate in the past: _finished_  -->
                  <xsl:when test="(not($startDate) or nf:isPast($startDate)) and nf:isPast($endDate)">
                     <xsl:attribute name="value"
                                    select="'finished'"/>
                  </xsl:when>
                  <!-- When StartDate is absent and EndDate in the future: _active_ -->
                  <xsl:when test="not($startDate) and nf:isFuture($endDate)">
                     <xsl:attribute name="value"
                                    select="'active'"/>
                  </xsl:when>
                  <!-- If no status can be derived from the start and enddate, the EpisodeOfCare is assumed to be active. 
                            A status code must be provided and no unkown code exists in the required ValueSet.-->
                  <xsl:otherwise>
                     <xsl:attribute name="value"
                                    select="'active'"/>
                  </xsl:otherwise>
               </xsl:choose>
            </status>
            <xsl:for-each select="$problem">
               <diagnosis>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="."/>
                     <xsl:with-param name="wrapIn"
                                     select="'condition'"/>
                  </xsl:call-template>
               </diagnosis>
            </xsl:for-each>
            <xsl:for-each select="$subject">
               <xsl:call-template name="makeReference">
                  <xsl:with-param name="in"
                                  select="$subject"/>
                  <xsl:with-param name="wrapIn"
                                  select="'patient'"/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$startDate or $endDate">
               <period>
                  <xsl:for-each select="$startDate">
                     <start>
                        <xsl:attribute name="value">
                           <xsl:call-template name="format2FHIRDate">
                              <xsl:with-param name="dateTime"
                                              select="$startDate"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </start>
                  </xsl:for-each>
                  <xsl:for-each select="$endDate">
                     <end>
                        <xsl:attribute name="value">
                           <xsl:call-template name="format2FHIRDate">
                              <xsl:with-param name="dateTime"
                                              select="$endDate"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </end>
                  </xsl:for-each>
               </period>
            </xsl:if>
         </EpisodeOfCare>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorg_episode"
                 mode="_generateId">
      <!-- Template to generate a unique id to identify this instance. -->
      <xsl:variable name="parts">
         <xsl:text>EpisodeOfCare</xsl:text>
         <xsl:value-of select="zorg_episode_naam/@value"/>
         <xsl:if test="begin_datum/@value">
            <xsl:value-of select="concat('start datum', begin_datum/@value)"/>
         </xsl:if>
         <xsl:if test="eind_datum/@value">
            <xsl:value-of select="concat('eind datum', eind_datum/@value)"/>
         </xsl:if>
         <xsl:value-of select="toelichting/@value"/>
      </xsl:variable>
      <xsl:value-of select="substring(replace(string-join($parts, '-'), '[^A-Za-z0-9-.]', ''), 1, 64)"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorg_episode"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
      <xsl:variable name="parts">
         <xsl:text>EpisodeOfCare</xsl:text>
         <xsl:value-of select="zorg_episode_naam/@value"/>
         <xsl:if test="begin_datum/@value">
            <xsl:value-of select="concat('start datum', begin_datum/@value)"/>
         </xsl:if>
         <xsl:if test="eind_datum/@value">
            <xsl:value-of select="concat('eind datum', eind_datum/@value)"/>
         </xsl:if>
         <xsl:value-of select="toelichting/@value"/>
      </xsl:variable>
      <xsl:value-of select="string-join($parts, ', ')"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="ext-Context-EpisodeOfCare"
                 match="*"
                 as="element()?"
                 mode="ext-Context-EpisodeOfCare">
      <!-- Template for shared extension http://nictiz.nl/fhir/StructureDefinition/ext-Context-EpisodeOfCare -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- Optional. Ada element containing the identifier of the episode. Defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-Context-EpisodeOfCare">
            <valueReference>
               <xsl:apply-templates select="."
                                    mode="nl-core-EpisodeOfCare-RefIdentifier"/>
            </valueReference>
         </extension>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="nl-core-EpisodeOfCare-RefIdentifier"
                 match="identificatie | identificatienummer"
                 mode="nl-core-EpisodeOfCare-RefIdentifier">
      <!-- Creates an EpisodeOfCare reference based on identifier using ada identificatie element -->
      <type value="EpisodeOfCare"/>
      <identifier>
         <xsl:call-template name="id-to-Identifier"/>
      </identifier>
      <display value="relatie naar zorgepisode met identificatie: {string-join((@value, @root), ' || ')}"/>
   </xsl:template>
</xsl:stylesheet>