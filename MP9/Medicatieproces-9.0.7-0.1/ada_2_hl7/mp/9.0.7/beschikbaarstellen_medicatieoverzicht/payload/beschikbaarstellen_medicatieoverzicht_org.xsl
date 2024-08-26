<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/mp/9.0.7/beschikbaarstellen_medicatieoverzicht/payload/beschikbaarstellen_medicatieoverzicht_org.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.0.7; 0.1; 2024-08-26T18:25:33.12+02:00 == -->
<xsl:stylesheet version="2.0"
                exclude-result-prefixes="#all"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="#local.2024011509165749283170100"
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
   <xsl:import href="../../../../../common/includes/2_hl7_mp_include_90.xsl"/>
   <xsl:output method="xml"
               indent="yes"
               exclude-result-prefixes="#default"/>
   <!-- ======================================================================= -->
   <!-- only give dateT a value if you want conversion of relative T dates -->
   <!--    <xsl:param name="dateT" as="xs:date?" select="current-date()"/>-->
   <xsl:param name="dateT"
              as="xs:date?"
              select="xs:date('2020-03-24')"/>
   <!-- whether to generate a user instruction description text from the structured information, typically only needed for test instances  -->
   <xsl:param name="generateInstructionText"
              as="xs:boolean?"
              select="true()"/>
   <!-- param to influence whether to output schematron references, typically only needed for test instances -->
   <xsl:param name="schematronRef"
              as="xs:boolean"
              select="true()"/>
   <!-- ================================================================== -->
   <xsl:template match="/"
                 name="baseMedicatieoverzicht">
      <xsl:param name="in"
                 select="adaxml/data/beschikbaarstellen_medicatieoverzicht"
                 as="element()*"/>
      <xsl:if test="$schematronRef">
         <xsl:processing-instruction name="xml-model">href="file:/C:/SVN/AORTA/branches/Onderhoud_Mp_v90/Publicaties/20181220/mp-xml-20181220T121121/schematron_closed_warnings/mp-MP90_mo.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron" phase="#ALL"</xsl:processing-instruction>
         <xsl:processing-instruction name="xml-model">href="file:/C:/SVN/art_decor/trunk/ada-data/ada_2_test-xslt/mp/9.0.7/beschikbaarstellen_medicatieoverzicht/test_xslt_instance/
<xsl:value-of select="$in[1]/@id"/>.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="count($in) gt 1">
            <batch xmlns="">
               <xsl:for-each select="$in">
                  <xsl:call-template name="Medicatieoverzicht_90">
                     <xsl:with-param name="patient"
                                     select="./patient"/>
                     <xsl:with-param name="mbh"
                                     select="./medicamenteuze_behandeling"/>
                     <xsl:with-param name="docGeg"
                                     select="./documentgegevens"/>
                  </xsl:call-template>
               </xsl:for-each>
            </batch>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="Medicatieoverzicht_90">
               <xsl:with-param name="patient"
                               select="$in/patient"/>
               <xsl:with-param name="mbh"
                               select="$in/medicamenteuze_behandeling"/>
               <xsl:with-param name="docGeg"
                               select="$in/documentgegevens"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="Medicatieoverzicht_90">
      <xsl:param name="patient"/>
      <xsl:param name="mbh"/>
      <xsl:param name="docGeg"/>
      <organizer classCode="CLUSTER"
                 moodCode="EVN">
         <xsl:attribute name="xsi:schemaLocation"
                        select="'urn:hl7-org:v3 file:/C:/SVN/AORTA/branches/Onderhoud_Mp_v90/XML/schemas/organizer.xsd'"/>
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9245"/>
         <code code="129"
               displayName="Medicatieoverzicht"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.4"
               codeSystemName="ART DECOR transacties"/>
         <statusCode nullFlavor="NI"/>
         <!-- Documentdatum -->
         <xsl:call-template name="makeEffectiveTime">
            <xsl:with-param name="effectiveTime"
                            select="$docGeg/document_datum"/>
         </xsl:call-template>
         <!-- Patient -->
         <xsl:for-each select="$patient">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.3_20170602000000">
               <xsl:with-param name="in"
                               select="."/>
            </xsl:call-template>
         </xsl:for-each>
         <!-- Auteur (=samenstellende organisatie (of patient) van hele overzicht) -->
         <xsl:for-each select="$docGeg/auteur">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9171_20180111143827">
               <xsl:with-param name="auteur"
                               select="."/>
            </xsl:call-template>
         </xsl:for-each>
         <!-- Verificatie patient -->
         <xsl:for-each select="$docGeg/verificatie_patient">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9179_20170523115538"/>
         </xsl:for-each>
         <!-- Verificatie zorgverlener -->
         <xsl:for-each select="$docGeg/verificatie_zorgverlener">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9180_20170523115753"/>
         </xsl:for-each>
         <xsl:for-each select="$mbh">
            <!-- eigen Medicatieafspraak -->
            <xsl:for-each select="./medicatieafspraak[not(kopie_indicator/@value = 'true')]">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9235_20181204143321">
                     <xsl:with-param name="ma"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
            <!-- andermans Medicatieafspraak -->
            <xsl:for-each select="./medicatieafspraak[kopie_indicator/@value = 'true']">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9241_20181204150624">
                     <xsl:with-param name="ma"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
            <!-- eigen Toedieningsafspraak -->
            <xsl:for-each select="./toedieningsafspraak[not(kopie_indicator/@value = 'true')]">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9259_20181206160523">
                     <xsl:with-param name="ta"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
            <!-- andermans Toedieningsafspraak -->
            <xsl:for-each select="./toedieningsafspraak[kopie_indicator/@value = 'true']">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9258_20181206160248">
                     <xsl:with-param name="ta"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
            <!-- eigen Medicatiegebruik -->
            <xsl:for-each select="./medicatie_gebruik[not(kopie_indicator/@value = 'true')]">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9246_20181205101627">
                     <xsl:with-param name="gb"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
            <!-- andermans Medicatiegebruik -->
            <xsl:for-each select="./medicatie_gebruik[kopie_indicator/@value = 'true']">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9248_20181205103359">
                     <xsl:with-param name="gb"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
         </xsl:for-each>
      </organizer>
   </xsl:template>
</xsl:stylesheet>