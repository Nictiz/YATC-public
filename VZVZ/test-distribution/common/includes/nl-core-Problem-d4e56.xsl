<?xml version="1.0" encoding="UTF-8"?>

<!-- == Flattened from: C:/Data/Erik/work/Nictiz/new/HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/nl-core-Problem.xsl == -->
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
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <!--Uncomment imports for standalone use and testing.-->
   <!--<xsl:import href="../../fhir/fhir_2_ada_fhir_include.xsl"/>-->
   <xd:doc>
      <xd:desc>Template to convert f:Condition to ADA probleem.</xd:desc>
   </xd:doc>
   <xsl:template match="f:Condition"
                 mode="nl-core-Problem">
      <probleem>
         <!-- Voor MedicationAgreement alleen probleem_naam -->
         <xsl:apply-templates select="f:code"
                              mode="#current"/>
      </probleem>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:code to probleem_naam</xd:desc>
   </xd:doc>
   <xsl:template match="f:code"
                 mode="nl-core-Problem">
      <xsl:call-template name="CodeableConcept-to-code">
         <xsl:with-param name="adaElementName">probleem_naam</xsl:with-param>
         <xsl:with-param name="originalText"
                         select="f:text/@value"/>
      </xsl:call-template>
   </xsl:template>
</xsl:stylesheet>