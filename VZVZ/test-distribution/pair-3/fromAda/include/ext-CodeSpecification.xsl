<?xml version="1.0" encoding="UTF-8"?>

<!-- == Flattened from: C:/xdata/Nictiz/HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.5-beta1/ext-CodeSpecification.xsl == -->
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
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org">
   <!-- Can be uncommented for debug purposes. Please comment before committing! -->
   <!--<xsl:import href="../../../fhir/2_fhir_fhir_include.xsl"/>-->
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc scope="stylesheet">
      <xd:desc>Converts ada code to FHIR extension conforming to profile ext-CodeSpecification</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Template for shared extension http://nictiz.nl/fhir/StructureDefinition/ext-CodeSpecification</xd:desc>
      <xd:param name="in">Optional. Ada element containing the comment code element</xd:param>
   </xd:doc>
   <xsl:template match="*"
                 name="ext-CodeSpecification"
                 mode="ext-CodeSpecification"
                 as="element()?">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:for-each select="$in">
         <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-CodeSpecification">
            <valueCodeableConcept>
               <xsl:call-template name="code-to-CodeableConcept">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="treatNullFlavorAsCoding"
                                  select="true()"/>
               </xsl:call-template>
            </valueCodeableConcept>
         </extension>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>