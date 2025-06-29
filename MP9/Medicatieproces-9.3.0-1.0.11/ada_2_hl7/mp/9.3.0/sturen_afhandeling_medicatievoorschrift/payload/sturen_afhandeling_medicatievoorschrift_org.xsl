<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/mp/9.3.0/sturen_afhandeling_medicatievoorschrift/payload/sturen_afhandeling_medicatievoorschrift_org.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="#local.202401181047475614050100">
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
   <xsl:import href="../../2_hl7_mp_include_930.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <!-- Generates a HL7 message based on ADA input -->
   <!-- give dateT a value when you need conversion of relative T dates, typically only needed for test instances -->
   <!--    <xsl:param name="dateT" as="xs:date?" select="current-date()"/>-->
   <xsl:param name="dateT"
              as="xs:date?"
              select="xs:date('2021-03-24')"/>
   <!--    <xsl:param name="dateT" as="xs:date?"/>-->
   <!-- param to influence whether to output schematron references, typically only needed for test instances -->
   <xsl:param name="schematronRef"
              as="xs:boolean"
              select="false()"/>
   <!-- ================================================================== -->
   <xsl:template match="/">
      <xsl:call-template name="SturenAfhandVoorschr-930">
         <xsl:with-param name="in"
                         select="adaxml/data/sturen_afhandeling_medicatievoorschrift"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="SturenAfhandVoorschr-930">
      <xsl:param name="in"
                 select="adaxml/data/sturen_afhandeling_medicatievoorschrift"/>
      <xsl:variable name="patient"
                    select="$in/patient"/>
      <xsl:variable name="mbh"
                    select="$in/medicamenteuze_behandeling"/>
      <xsl:if test="$schematronRef">
         <xsl:processing-instruction name="xml-model">phase="#ALL" href="../../schematron_closed_warnings/mp-mp93-av.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron" phase="#ALL"</xsl:processing-instruction>
         <xsl:comment>Generated from ada instance with title: "
<xsl:value-of select="$mbh/../@title"/>" and id: "
<xsl:value-of select="$mbh/../@id"/>".</xsl:comment>
      </xsl:if>
      <organizer classCode="CLUSTER"
                 moodCode="EVN"
                 xmlns:cda="urn:hl7-org:v3"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xmlns:pharm="urn:ihe:pharm:medication">
         <xsl:if test="$schematronRef">
            <xsl:attribute name="xsi:schemaLocation"
                           select="'urn:hl7-org:v3 ../../../../../../../../SVN/AORTA/branches/Onderhoud_Mp_v90/XML/schemas/organizer.xsd'"/>
         </xsl:if>
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9420"/>
         <code code="131"
               displayName="Afhandelen voorschrift"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.4"
               codeSystemName="ART DECOR transacties"/>
         <statusCode nullFlavor="NI"/>
         <!-- Patient -->
         <xsl:for-each select="$patient">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1_20210701000000"/>
         </xsl:for-each>
         <!-- Medicamenteuze behandeling -->
         <xsl:for-each select="$mbh">
            <!-- Toedieningsafspraak -->
            <xsl:for-each select="toedieningsafspraak[not(kopie_indicator/@value = 'true')]">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9416_20221121074758"/>
               </component>
            </xsl:for-each>
            <!-- Toedieningsafspraak kopie -->
            <xsl:for-each select="toedieningsafspraak[kopie_indicator/@value = 'true']">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9417_20221121085549"/>
               </component>
            </xsl:for-each>
            <!-- Verstrekking -->
            <xsl:for-each select="medicatieverstrekking | verstrekking">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9364_20210602161935">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
         </xsl:for-each>
      </organizer>
   </xsl:template>
</xsl:stylesheet>