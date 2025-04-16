<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/zibs/2020/payload/0.8.0-beta.1/nl-core-BodyWeight.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.10; 2025-04-16T17:40:18.95+02:00 == -->
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
   <xsl:variable name="bodyWeightLOINCcode"
                 as="xs:string*"
                 select="'29463-7'"/>
   <!-- ================================================================== -->
   <xsl:template match="f:Observation[f:code/f:coding/f:code/@value=$bodyWeightLOINCcode]"
                 mode="nl-core-BodyWeight">
      <!-- Template to convert f:Observation to ADA lichaamslengte. -->
      <lichaamsgewicht>
         <!-- identificatie -->
         <xsl:apply-templates select="f:identifier"
                              mode="#current"/>
         <!-- gewicht_waarde -->
         <xsl:apply-templates select="f:valueQuantity"
                              mode="#current"/>
         <!-- gewicht_datum_tijd -->
         <xsl:apply-templates select="f:effectiveDateTime"
                              mode="#current"/>
      </lichaamsgewicht>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:effectiveDateTime"
                 mode="nl-core-BodyWeight">
      <!-- Template to convert f:effectiveDateTime to lengte_datum_tijd -->
      <xsl:call-template name="datetime-to-datetime">
         <xsl:with-param name="adaElementName">gewicht_datum_tijd</xsl:with-param>
         <xsl:with-param name="adaDatatype">datetime</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:identifier"
                 mode="nl-core-BodyWeight">
      <!-- Template to convert f:identifier to identificatie -->
      <xsl:call-template name="Identifier-to-identificatie"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:valueQuantity"
                 mode="nl-core-BodyWeight">
      <!-- Template to convert f:valueQuantity to lengte_waarde -->
      <xsl:call-template name="Quantity-to-hoeveelheid">
         <xsl:with-param name="adaElementName">gewicht_waarde</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
</xsl:stylesheet>