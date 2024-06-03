<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/mp/9.3.0/sturen_medicatiegegevens/payload/sturen_medicatiegegevens_org.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 1.0.0; 2024-04-17T17:00:31.15+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:f="http://hl7.org/fhir"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="#local.2024011810474759329520100"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <!-- ================================================================== -->
   <!--
        
            Created on: Feb 16, 2019
            Author: nictiz
            Mapping xslt for use case 'sturen medicatiegegevens' in MP-9. From ada to hl7.
        
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
   <!-- only give dateT a value if you want conversion of relative T dates to actual dates -->
   <!--    <xsl:param name="dateT" as="xs:date?" select="current-date()"/>-->
   <xsl:param name="dateT"
              as="xs:date?"
              select="xs:date('2020-03-24')"/>
   <!--    <xsl:param name="dateT" as="xs:date?"/>-->
   <!-- whether to generate a user instruction description text from the structured information, typically only needed for test instances  -->
   <!--    <xsl:param name="generateInstructionText" as="xs:boolean?" select="true()"/>-->
   <xsl:param name="generateInstructionText"
              as="xs:boolean?"
              select="false()"/>
   <!-- param to influence whether to output schema and schematron references, typically only needed for test instances -->
   <xsl:param name="schematronRef"
              as="xs:boolean"
              select="true()"/>
   <!-- ================================================================== -->
   <xsl:template match="/"
                 name="baseMedicatiegegevens">
      <!--  Base template puts a reference to schematron useful in development/testing phases. Then calls appropriate template to do the conversion. Puts a reference to schematron. phase="#ALL" achteraan de volgende regel zorgt dat oXygen niet met een phase chooser dialoog komt elke keer dat je de HL7 XML opent  -->
      <xsl:param name="in"
                 select="//sturen_medicatiegegevens"
                 as="element()*">
         <!-- The input ada transaction, may be more then one in case of a batch file -->
      </xsl:param>
      <xsl:if test="$schematronRef">
         <!--            <xsl:processing-instruction name="xml-model">phase="#ALL" href="../../schematron_closed_warnings/mp-mp93_mgb.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron" phase="#ALL"</xsl:processing-instruction>-->
         <!-- <xsl:processing-instruction name="xml-model">href="file:/C:/SVN/art_decor/trunk/ada-data/ada_2_test-xslt/mp/9.0.7/sturen_medicatiegegevens/test_xslt_instance/<xsl:value-of select="$in[1]/@id"/>.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
            <xsl:text>
</xsl:text>-->
         <xsl:processing-instruction name="xml-model">phase="#ALL" href="file:/C:/SVN/AORTA/trunk/Zorgtoepassing/Medicatieproces/DECOR/mp-runtime-develop/mp-mp93_mgb.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
         <xsl:text>
         </xsl:text>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="count($in) gt 1">
            <batch xmlns="">
               <xsl:for-each select="$in">
                  <xsl:call-template name="Medicatiegegevens_930">
                     <xsl:with-param name="patient"
                                     select="patient"/>
                     <xsl:with-param name="mbh"
                                     select="medicamenteuze_behandeling"/>
                  </xsl:call-template>
               </xsl:for-each>
            </batch>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="Medicatiegegevens_930">
               <xsl:with-param name="patient"
                               select="$in/patient"/>
               <xsl:with-param name="mbh"
                               select="$in/medicamenteuze_behandeling"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="Medicatiegegevens_930">
      <xsl:param name="patient"
                 as="element()?"/>
      <xsl:param name="mbh"
                 as="element()*"/>
      <organizer classCode="CLUSTER"
                 moodCode="EVN"
                 xmlns:cda="urn:hl7-org:v3"
                 xmlns:pharm="urn:ihe:pharm:medication">
         <xsl:if test="$schematronRef">
            <xsl:attribute name="xsi:schemaLocation">urn:hl7-org:v3 file:/C:/SVN/AORTA/branches/Onderhoud_Mp_v90/XML/schemas/organizer.xsd</xsl:attribute>
         </xsl:if>
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9411"/>
         <code code="102"
               displayName="Medicatiegegevens"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.4"
               codeSystemName="ART DECOR transacties"/>
         <statusCode nullFlavor="NI"/>
         <!-- Patient -->
         <xsl:for-each select="$patient">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.3_20170602000000">
               <xsl:with-param name="in"
                               select="."/>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:for-each select="$mbh">
            <!-- Medicatieafspraak -->
            <xsl:for-each select="medicatieafspraak">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9430_20221122132432">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
            <!-- wisselend_doseerschema -->
            <xsl:for-each select="wisselend_doseerschema">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9412_20221118130922">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
            <!-- Verstrekkingsverzoek -->
            <xsl:for-each select="verstrekkingsverzoek">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9449_20230106093041">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
            <!-- Toedieningsafspraak -->
            <xsl:for-each select="toedieningsafspraak">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9416_20221121074758">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
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
            <!-- Medicatiegebruik -->
            <xsl:for-each select="medicatie_gebruik | medicatiegebruik">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9444_20221124154710">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
            <!-- Medicatietoediening -->
            <xsl:for-each select="medicatietoediening">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9406_20221101091730">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
         </xsl:for-each>
      </organizer>
   </xsl:template>
</xsl:stylesheet>