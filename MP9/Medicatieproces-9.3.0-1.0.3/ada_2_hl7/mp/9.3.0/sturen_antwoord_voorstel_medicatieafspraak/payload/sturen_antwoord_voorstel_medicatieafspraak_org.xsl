<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/mp/9.3.0/sturen_antwoord_voorstel_medicatieafspraak/payload/sturen_antwoord_voorstel_medicatieafspraak_org.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.3; 2024-07-23T09:24:32.82+02:00 == -->
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
                xmlns:local="#local.2024011810474757236480100"
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
   <xsl:import href="../../2_hl7_mp_include_930.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <!-- Generates a HL7 message based on ADA input -->
   <!-- give dateT a value when you need conversion of relative T dates, typically only needed for test instances -->
   <!--    <xsl:param name="dateT" as="xs:date?" select="current-date()"/>-->
   <xsl:param name="dateT"
              as="xs:date?"
              select="xs:date('2022-01-01')"/>
   <!--    <xsl:param name="dateT" as="xs:date?"/>-->
   <!-- whether to generate a user instruction description text from the structured information, typically only needed for test instances  -->
   <xsl:param name="generateInstructionText"
              as="xs:boolean?"
              select="false()"/>
   <!-- param to influence whether to output schematron references, typically only needed for test instances -->
   <xsl:param name="schematronRef"
              as="xs:boolean"
              select="false()"/>
   <!-- ================================================================== -->
   <xsl:template match="/">
      <xsl:call-template name="SturenAntwVoorstelMA-930">
         <xsl:with-param name="in"
                         select="adaxml/data/sturen_antwoord_voorstel_medicatieafspraak"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="SturenAntwVoorstelMA-930">
      <xsl:param name="in"
                 select="adaxml/data/sturen_antwoord_voorstel_medicatieafspraak"/>
      <xsl:variable name="patient"
                    select="$in/patient"/>
      <xsl:variable name="mbh"
                    select="$in/medicamenteuze_behandeling"/>
      <xsl:if test="$schematronRef">
         <xsl:processing-instruction name="nictiz">status="example"</xsl:processing-instruction>
         <xsl:processing-instruction name="xml-model">phase="#ALL" href="../../schematron_closed_warnings/mp-mp93_avma.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron" phase="#ALL"</xsl:processing-instruction>
      </xsl:if>
      <xsl:comment>Generated from ada instance with title: "
<xsl:value-of select="$mbh/../@title"/>" and id: "
<xsl:value-of select="$mbh/../@id"/>".</xsl:comment>
      <organizer classCode="CLUSTER"
                 moodCode="EVN"
                 xmlns:cda="urn:hl7-org:v3">
         <xsl:attribute name="xsi:schemaLocation"
                        select="'urn:hl7-org:v3 file:/C:/SVN/AORTA/branches/Onderhoud_Mp_v90/XML/schemas/organizer.xsd'"/>
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9399"/>
         <xsl:for-each select="$in/voorstel_gegevens/antwoord/identificatie[@value | @root]">
            <xsl:call-template name="makeIIValue">
               <xsl:with-param name="elemName">id</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <code code="373"
               displayName="Sturen antwoord voorstel medicatieafspraak"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.4"
               codeSystemName="ART DECOR transacties"/>
         <statusCode nullFlavor="NI"/>
         <!-- Patient -->
         <xsl:for-each select="$patient">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1_20210701000000"/>
         </xsl:for-each>
         <!-- antwoord -->
         <xsl:for-each select="$in/voorstel_gegevens/antwoord[.//(@value | @code | @nullFlavor)]">
            <component typeCode="COMP">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9396_20220315000000"/>
            </component>
         </xsl:for-each>
      </organizer>
   </xsl:template>
</xsl:stylesheet>