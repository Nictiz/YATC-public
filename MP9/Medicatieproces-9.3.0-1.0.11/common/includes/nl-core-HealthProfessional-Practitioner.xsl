<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/zibs/2020/payload/0.8.0-beta.1/nl-core-HealthProfessional-Practitioner.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
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
    <xsl:import href="nl-core-humanname-2.0.xsl"/>
    <xsl:import href="nl-core-practitionerrole-2.0.xsl"/>
    <xsl:import href="nl-core-organization-2.0.xsl"/>-->
   <!-- ================================================================== -->
   <xsl:template match="f:Practitioner"
                 mode="nl-core-HealthProfessional-Practitioner">
      <!-- Template to convert f:Practitioner to ADA zorgverlener -->
      <xsl:param name="organizationReference">
         <!-- Optional reference to the Organization the Practitioner belongs to e.g. the ADA zorgaanbieder -->
      </xsl:param>
      <xsl:param name="specialtyReference">
         <!-- Optional reference to the PractitionerRole the Practitioner belongs to e.g. the ADA specialisme -->
      </xsl:param>
      <zorgverlener>
         <xsl:if test="$specialtyReference or ../../f:fullUrl[@value]">
            <xsl:attribute name="id">
               <xsl:choose>
                  <xsl:when test="$specialtyReference">
                     <xsl:value-of select="nf:convert2NCName($specialtyReference)"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="nf:convert2NCName(../../f:fullUrl/@value)"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
         </xsl:if>
         <!-- zorgverlener_identificatienummer -->
         <xsl:apply-templates select="f:identifier"
                              mode="#current"/>
         <!-- naamgegevens -->
         <xsl:apply-templates select="f:name"
                              mode="#current"/>
         <!-- specialisme -->
         <xsl:if test="not($specialtyReference = '')">
            <xsl:apply-templates select="ancestor::f:Bundle/f:entry[f:fullUrl/@value = $specialtyReference]/f:resource/f:PractitionerRole"
                                 mode="nl-core-HealthProfessional-PractitionerRole"/>
         </xsl:if>
         <!-- geslacht, we re-use the patient implementation, patient xsl should always be in scope -->
         <xsl:apply-templates select="f:gender"
                              mode="nl-core-Patient"/>
         <!-- adresgegevens -->
         <xsl:apply-templates select="f:address"
                              mode="nl-core-AddressInformation"/>
         <!-- contactgegevens -->
         <xsl:if test="f:telecom">
            <contactgegevens>
               <xsl:apply-templates select="f:telecom"
                                    mode="nl-core-ContactInformation"/>
            </contactgegevens>
         </xsl:if>
         <!-- zorgaanbieder -->
         <xsl:if test="not($organizationReference = '')">
            <zorgaanbieder>
               <zorgaanbieder datatype="reference"
                              value="{nf:convert2NCName($organizationReference)}"/>
            </zorgaanbieder>
         </xsl:if>
      </zorgverlener>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:identifier"
                 mode="nl-core-HealthProfessional-Practitioner">
      <!-- Template to convert f:identifier to zorgverlener_identificatienummer -->
      <xsl:param name="practitionerIdUnderscore"
                 select="false()"
                 tunnel="yes">
         <!-- Optional boolean to create ADA element zorgverlener_identificatie_nummer -->
      </xsl:param>
      <xsl:variable name="adaElementName">
         <xsl:choose>
            <xsl:when test="$practitionerIdUnderscore = true()">zorgverlener_identificatie_nummer</xsl:when>
            <xsl:otherwise>zorgverlener_identificatienummer</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="Identifier-to-identificatie">
         <xsl:with-param name="adaElementName"
                         select="$adaElementName"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:name"
                 mode="nl-core-HealthProfessional-Practitioner">
      <!-- Template to convert f:name to naamgegevens, we re-use the patient implementation, patient xsl should always be in scope -->
      <xsl:apply-templates select="."
                           mode="nl-core-Patient"/>
   </xsl:template>
</xsl:stylesheet>