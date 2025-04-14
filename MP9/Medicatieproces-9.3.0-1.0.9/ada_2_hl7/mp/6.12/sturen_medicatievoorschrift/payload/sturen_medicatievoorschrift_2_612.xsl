<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/mp/6.12/sturen_medicatievoorschrift/payload/sturen_medicatievoorschrift_2_612.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.9; 2025-04-14T13:20:38.56+02:00 == -->
<xsl:stylesheet version="2.0"
                exclude-result-prefixes="#all"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:util="urn:hl7:utilities"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="#local.2024011810474694939990100"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <!-- ================================================================== -->
   <!--
        TBD
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
   <xsl:import href="../../../../../common/includes/2_hl7_mp_include_612.xsl"/>
   <xsl:output method="xml"
               indent="yes"
               exclude-result-prefixes="#all"
               omit-xml-declaration="yes"/>
   <!-- Dit is een conversie van ADA 9.0 naar MP 6.12 voorschrift bericht -->
   <!-- ================================================================== -->
   <xsl:template match="/">
      <xsl:variable name="voorschrift"
                    select="//sturen_medicatievoorschrift"/>
      <xsl:choose>
         <xsl:when test="$voorschrift/medicamenteuze_behandeling[verstrekkingsverzoek]">
            <!-- alleen conversie naar 6.12 vooraankondiging als er ook een verstrekkingsverzoek is -->
            <xsl:call-template name="Voorschrift_612">
               <xsl:with-param name="patient"
                               select="$voorschrift/patient"/>
               <xsl:with-param name="mbh"
                               select="$voorschrift/medicamenteuze_behandeling[verstrekkingsverzoek]"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="util:logMessage">
               <xsl:with-param name="level"
                               select="$logFATAL"/>
               <xsl:with-param name="msg">No dispenserequest in input, cannot convert to 6.12 vooraankondiging.</xsl:with-param>
               <xsl:with-param name="terminate"
                               select="true()"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="Make_Voorschrift_612">
      <xsl:param name="voorschrift"
                 select="//sturen_medicatievoorschrift"/>
      <xsl:if test="$voorschrift/medicamenteuze_behandeling[verstrekkingsverzoek]">
         <!-- alleen conversie naar 6.12 vooraankondiging als er ook een verstrekkingsverzoek is -->
         <xsl:call-template name="Voorschrift_612">
            <xsl:with-param name="patient"
                            select="$voorschrift/patient"/>
            <xsl:with-param name="mbh"
                            select="$voorschrift/medicamenteuze_behandeling[verstrekkingsverzoek]"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="Voorschrift_612">
      <xsl:param name="patient"/>
      <xsl:param name="mbh"/>
      <xsl:for-each select="$mbh/verstrekkingsverzoek">
         <xsl:comment>Generated from ada instance with title: "
<xsl:value-of select="$mbh/../@title"/>" and id: "
<xsl:value-of select="$mbh/../@id"/>".</xsl:comment>
         <subject>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.104_20130521000000">
               <xsl:with-param name="patient"
                               select="$patient"/>
               <xsl:with-param name="verstrekkingsverzoek"
                               select="."/>
               <!-- NOTE! There can be more than one MA in MP9!-->
               <!-- but only consider MA's that are not stop-MA's and not cancelled MA's
                        , since stop- and cancelled MA's are not understood in 6.12 -->
               <xsl:with-param name="medicatieafspraak"
                               select="../medicatieafspraak[not(stoptype/@code)][not(geannuleerd_indicator/@value = 'true')]"/>
            </xsl:call-template>
         </subject>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>