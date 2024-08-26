<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada/env/zibs2017/payload/nl-core-patient-2.1.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.0.7; 0.1; 2024-08-26T18:25:33.12+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
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
   <!--Uncomment imports for standalone use and testing.-->
   <!--<xsl:import href="../../fhir/fhir_2_ada_fhir_include.xsl"/>
    <xsl:import href="nl-core-humanname-2.0.xsl"/>-->
   <xsl:variable name="nl-core-patient"
                 select="'http://fhir.nl/fhir/StructureDefinition/nl-core-patient'"/>
   <!-- ================================================================== -->
   <xsl:template match="f:Patient"
                 mode="nl-core-patient-2.1">
      <!-- Template to convert f:Patient to ADA patient -->
      <patient>
         <!-- naamgegevens -->
         <xsl:apply-templates select="f:name"
                              mode="nl-core-humanname-2.0"/>
         <!-- identificatienummer -->
         <xsl:apply-templates select="f:identifier"
                              mode="#current"/>
         <!-- geboortedatum -->
         <xsl:apply-templates select="f:birthDate"
                              mode="#current"/>
         <!-- geslacht -->
         <xsl:apply-templates select="f:gender"
                              mode="#current"/>
         <!-- meerling_indicator -->
         <xsl:apply-templates select="f:multipleBirthBoolean"
                              mode="#current"/>
      </patient>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:identifier"
                 mode="nl-core-patient-2.1">
      <!-- Template to convert f:identifier to identificatienummer -->
      <xsl:call-template name="Identifier-to-identificatie">
         <xsl:with-param name="adaElementName">identificatienummer</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:birthDate"
                 mode="nl-core-patient-2.1">
      <!-- Template to convert f:birthDate to geboortedatum -->
      <geboortedatum>
         <xsl:attribute name="value">
            <xsl:call-template name="format2ADADate">
               <xsl:with-param name="dateTime"
                               select="@value"/>
               <xsl:with-param name="precision"
                               select="'DAY'"/>
            </xsl:call-template>
         </xsl:attribute>
         <!--<xsl:attribute name="datatype">datetime</xsl:attribute>-->
      </geboortedatum>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:gender"
                 mode="nl-core-patient-2.1">
      <!-- Template to convert f:gender to geslacht -->
      <geslacht>
         <xsl:call-template name="code-to-code">
            <xsl:with-param name="value"
                            select="@value"/>
            <xsl:with-param name="codeMap"
                            as="element()*">
               <map code="M"
                    codeSystem="2.16.840.1.113883.5.1"
                    inValue="male"
                    displayName="Man"/>
               <map code="F"
                    codeSystem="2.16.840.1.113883.5.1"
                    inValue="female"
                    displayName="Vrouw"/>
               <map code="UN"
                    codeSystem="2.16.840.1.113883.5.1"
                    inValue="other"
                    displayName="Ongedifferentieerd"/>
               <map code="UNK"
                    codeSystem="2.16.840.1.113883.5.1008"
                    inValue="unknown"
                    displayName="Onbekend"/>
            </xsl:with-param>
         </xsl:call-template>
         <!-- displayName attribute? -->
      </geslacht>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:multipleBirthBoolean"
                 mode="nl-core-patient-2.1">
      <!-- Template to convert f:multipleBirthBoolean to meerling_indicator -->
      <meerling_indicator>
         <xsl:call-template name="boolean-to-boolean"/>
      </meerling_indicator>
   </xsl:template>
</xsl:stylesheet>