<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/mp/9.3.0/beschikbaarstellen_medicatiegegevens/payload/beschikbaarstellen_medicatiegegevens_2_fhir.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="#local.2024102208230952452870200"
                xmlns:nm="http://www.nictiz.nl/mappings"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <!-- ================================================================== -->
   <!--
        
            Author: Nictiz
            Purpose: This XSL was created to facilitate mapping from ADA MP9-transaction, to HL7 FHIR profiles.
 
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
   <xsl:import href="../../2_fhir_mp93_include.xsl"/>
   <xsl:import href="../../../../../common/includes/2_fhir_BundleEntrySearch.xsl"/>
   <xsl:output method="xml"
               indent="yes"
               omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <!-- ======================================================================= -->
   <!-- If the desired output is to be a Bundle, then a self link string of type url is required. 
         See: https://www.hl7.org/fhir/search.html#conformance -->
   <xsl:param name="bundleSelfLink"
              as="xs:string?"/>
   <!-- only give dateT a value if you want conversion of relative T dates to actual dates, otherwise a Touchstone relative T-date string will be generated -->
   <!--    <xsl:param name="dateT" as="xs:date?" select="current-date()"/>-->
   <!--        <xsl:param name="dateT" as="xs:date?" select="xs:date('2020-03-24')"/>-->
   <xsl:param name="dateT"
              as="xs:date?"/>
   <!-- pass an appropriate macAddress to ensure uniqueness of the UUID -->
   <!-- 02-00-00-00-00-00 may not be used in a production situation -->
   <xsl:param name="macAddress">02-00-00-00-00-00</xsl:param>
   <!-- parameter for debug level -->
   <xsl:param name="logLevel"
              select="$logWARN"
              as="xs:string"/>
   <!-- select="$oidBurgerservicenummer" zorgt voor maskeren BSN -->
   <xsl:param name="mask-ids"
              as="xs:string?"
              select="$oidBurgerservicenummer"/>
   <!-- parameter to determine whether to refer by resource/id -->
   <!-- should be false when there is no FHIR server available to retrieve the resources -->
   <xsl:param name="referById"
              as="xs:boolean"
              select="false()"/>
   <!--    <xsl:param name="generateInstructionText" as="xs:boolean?" select="false()"/>-->
   <!-- whether or nog to output schema / schematron links -->
   <xsl:param name="schematronXsdLinkInOutput"
              as="xs:boolean?"
              select="false()"/>
   <!-- ================================================================== -->
   <xsl:template match="/">
      <!-- Start conversion. Handle interaction specific stuff for "beschikbaarstellen medicatiegegevens". -->
      <xsl:call-template name="Medicatiegegevens_90">
         <xsl:with-param name="mbh"
                         select="//beschikbaarstellen_medicatiegegevens/medicamenteuze_behandeling"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="Medicatiegegevens_90">
      <!-- Build a FHIR Bundle of type searchset. -->
      <xsl:param name="mbh">
         <!-- ada medicamenteuze behandeling -->
      </xsl:param>
      <xsl:if test="$schematronXsdLinkInOutput">
         <xsl:processing-instruction name="xml-model">href="http://hl7.org/fhir/R4/bundle.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
      </xsl:if>
      <Bundle xsl:exclude-result-prefixes="#all">
         <xsl:if test="$schematronXsdLinkInOutput">
            <xsl:attribute name="xsi:schemaLocation">http://hl7.org/fhir https://hl7.org/fhir/R4/bundle.xsd</xsl:attribute>
         </xsl:if>
         <id value="{nf:get-uuid(*[1])}"/>
         <type value="searchset"/>
         <total value="{count($bouwstenen-930)}"/>
         <xsl:choose>
            <xsl:when test="$bundleSelfLink[not(. = '')]">
               <link>
                  <relation value="self"/>
                  <url value="{$bundleSelfLink}"/>
               </link>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logWARN"/>
                  <xsl:with-param name="msg">Parameter bundleSelfLink is empty, but server SHALL return the parameters that were actually used to process the search.</xsl:with-param>
                  <xsl:with-param name="terminate"
                                  select="false()"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:apply-templates select="$bouwstenen-930"
                              mode="addBundleEntrySearchOrRequest"/>
         <!-- common entries (patient, practitioners, organizations, practitionerroles, products, locations -->
         <xsl:apply-templates select="$commonEntries"
                              mode="addBundleEntrySearchOrRequest">
            <xsl:with-param name="entrySearchMode">include</xsl:with-param>
         </xsl:apply-templates>
      </Bundle>
   </xsl:template>
</xsl:stylesheet>