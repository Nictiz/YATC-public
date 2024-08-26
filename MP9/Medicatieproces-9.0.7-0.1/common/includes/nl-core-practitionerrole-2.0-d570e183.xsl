<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada/env/zibs2017/payload/nl-core-practitionerrole-2.0.xsl == -->
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
   <!--<xsl:import href="../../fhir/fhir_2_ada_fhir_include.xsl"/>-->
   <!-- ================================================================== -->
   <xsl:template match="f:PractitionerRole"
                 mode="resolve-practitionerRole">
      <!-- Template to resolve f:PractitionerRole and apply f:Practitioner -->
      <xsl:variable name="practionerReference"
                    select="f:practitioner/f:reference/@value"/>
      <xsl:variable name="organizationReference"
                    select="f:organization/f:reference/@value"/>
      <xsl:variable name="specialtyReference"
                    select="ancestor::f:entry/f:fullUrl/@value"/>
      <xsl:apply-templates select="ancestor::f:Bundle/f:entry[f:fullUrl/@value=$practionerReference]/f:resource/f:Practitioner"
                           mode="nl-core-practitioner-2.0">
         <xsl:with-param name="organizationReference"
                         select="$organizationReference"/>
         <xsl:with-param name="specialtyReference"
                         select="$specialtyReference"/>
      </xsl:apply-templates>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:PractitionerRole"
                 mode="nl-core-practitionerrole-2.0">
      <!-- Template to apply f:specialty within f:PractitionerRole -->
      <xsl:apply-templates select="f:specialty"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:specialty">
      <!-- Template to convert f:specialty to ADA specialisme -->
      <xsl:call-template name="CodeableConcept-to-code">
         <xsl:with-param name="adaElementName"
                         select="'specialisme'"/>
         <xsl:with-param name="in"
                         select="."/>
      </xsl:call-template>
   </xsl:template>
</xsl:stylesheet>