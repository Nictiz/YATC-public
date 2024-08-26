<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/mp/9.0.7/sturen_afhandeling_medicatievoorschrift/payload/sturen_afhandeling_medicatievoorschrift_org.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.0.7; 0.1; 2024-08-26T18:25:33.12+02:00 == -->
<xsl:stylesheet version="2.0"
                exclude-result-prefixes="#all"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="#local.202401150916575198330100"
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
   <!-- ================================================================== -->
   <xsl:template match="/">
      <xsl:call-template name="AfhandelenVoorschrift_90">
         <xsl:with-param name="patient"
                         select="//sturen_afhandeling_medicatievoorschrift/patient"/>
         <xsl:with-param name="mbh"
                         select="//sturen_afhandeling_medicatievoorschrift/medicamenteuze_behandeling"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="AfhandelenVoorschrift_90">
      <xsl:param name="patient"/>
      <xsl:param name="mbh"/>
      <!-- phase="#ALL" achteraan de volgende regel zorgt dat oXygen niet met een phase chooser dialoog komt elke keer dat je de HL7 XML opent -->
      <xsl:processing-instruction name="xml-model">href="file:/C:/SVN/AORTA/branches/Onderhoud_Mp_v90/XML/schematron_closed_warnings/mp-MP90_av.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron" phase="#ALL"</xsl:processing-instruction>
      <organizer classCode="CLUSTER"
                 moodCode="EVN">
         <xsl:attribute name="xsi:schemaLocation"
                        select="'urn:hl7-org:v3 file:/C:/SVN/AORTA/branches/Onderhoud_Mp_v90/XML/schemas/organizer.xsd'"/>
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9260"/>
         <code code="131"
               displayName="Afhandeling voorschrift"
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
            <!-- Toedieningsafspraak -->
            <xsl:for-each select="./toedieningsafspraak">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9259_20181206160523">
                     <xsl:with-param name="ta"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
            <!-- Verstrekking -->
            <xsl:for-each select="./verstrekking">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9255_20181206145856">
                     <xsl:with-param name="vs"
                                     select="."/>
                  </xsl:call-template>
               </component>
            </xsl:for-each>
         </xsl:for-each>
      </organizer>
   </xsl:template>
</xsl:stylesheet>