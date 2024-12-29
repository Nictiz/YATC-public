<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir/env/mp/9.0.7/fhir_fixtures4Touchstone/payload/beschikbaarstellen_verstrekkingenvertaling_2_fhir.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.0.7; 0.1; 2024-08-26T18:25:33.12+02:00 == -->
<xsl:stylesheet version="2.0"
                exclude-result-prefixes="#all"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="#local.202310051115568083620200"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <!-- ================================================================== -->
   <!--
        This XSL was created to facilitate mapping from ADA MP9-transaction, to HL7 FHIR STU3 profiles.
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
   <!-- import because we want to be able to override the param for macAddress for UUID generation
         and the param for referById -->
   <xsl:import href="../../../../../common/includes/2_fhir_mp90_include.xsl"/>
   <xsl:import href="../../../../../common/includes/2_fhir_fixtures_Touchstone.xsl"/>
   <xsl:output method="xml"
               indent="yes"
               omit-xml-declaration="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:include href="../../../../../common/includes/general.mod.xsl"/>
   <xsl:include href="../../../../../common/includes/href.mod.xsl"/>
   <!-- ======================================================================= -->
   <xsl:param name="outputDirectory"
              as="xs:string"
              required="yes"/>
   <!-- If the desired output is to be a Bundle, then a self link string of type url is required. 
         See: https://www.hl7.org/fhir/stu3/search.html#conformance -->
   <xsl:param name="bundleSelfLink"
              as="xs:string?"/>
   <!-- parameter for debug level -->
   <xsl:param name="logLevel"
              select="$logWARN"
              as="xs:string"/>
   <!-- 02-00-00-00-00-00 may not be used in a production situation -->
   <xsl:param name="macAddress">02-00-00-00-00-00</xsl:param>
   <!-- date T for relativedate calculation (only relevant for test instances) -->
   <xsl:param name="dateT"
              as="xs:date?"/>
   <!-- whether to generate a user instruction description text from the structured information, typically only needed for test instances  -->
   <!--    <xsl:param name="generateInstructionText" as="xs:boolean?" select="true()"/>-->
   <xsl:param name="generateInstructionText"
              as="xs:boolean?"
              select="false()"/>
   <!-- select="$oidBurgerservicenummer" zorgt voor maskeren BSN -->
   <xsl:param name="mask-ids"
              as="xs:string?"
              select="$oidBurgerservicenummer"/>
   <!-- parameter to determine whether to refer by resource/id -->
   <!-- should be false when there is no FHIR server available to retrieve the resources -->
   <xsl:param name="referById"
              as="xs:boolean"
              select="false()"/>
   <xsl:variable name="commonEntries"
                 as="element(f:entry)*">
      <xsl:copy-of select="$patients/f:entry, $practitioners/f:entry, $organizations/f:entry, $practitionerRoles/f:entry, $products/f:entry, $locations/f:entry"/>
   </xsl:variable>
   <!-- ================================================================== -->
   <xsl:template match="/">
      <!-- Start conversion. Handle interaction specific stuff for "beschikbaarstellen verstrekkingenvertaling". -->
      <xsl:call-template name="verstrekkingenvertaling_90">
         <xsl:with-param name="mbh"
                         select="//beschikbaarstellen_verstrekkingenvertaling/medicamenteuze_behandeling"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="verstrekkingenvertaling_90">
      <!-- Build a FHIR Bundle of type searchset. -->
      <xsl:param name="mbh"
                 as="element()*">
         <!-- ada medicamenteuze behandeling -->
      </xsl:param>
      <xsl:processing-instruction name="xml-model">href="http://hl7.org/fhir/STU3/bundle.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
      <Bundle xsl:exclude-result-prefixes="#all"
              xsi:schemaLocation="http://hl7.org/fhir http://hl7.org/fhir/STU3/bundle.xsd"
              xmlns="http://hl7.org/fhir">
         <id value="{nf:get-uuid(*[1])}"/>
         <type value="searchset"/>
         <total value="{count($bouwstenen-verstrekkingenvertaling)}"/>
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
         <xsl:apply-templates select="$bouwstenen-verstrekkingenvertaling"
                              mode="ResultOutput"/>
         <!-- common entries (patient, practitioners, organizations, practitionerroles, locations -->
         <xsl:apply-templates select="$commonEntries"
                              mode="ResultOutput"/>
      </Bundle>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:Organization/f:meta/f:profile"
                 mode="ResultOutput">
      <!-- Exceptions for results output in verstrekkingenvertaling -->
      <xsl:copy>
         <xsl:attribute name="value">http://nictiz.nl/fhir/StructureDefinition/mp612-DispenseToFHIRConversion-Organization</xsl:attribute>
      </xsl:copy>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:Patient/f:meta/f:profile"
                 mode="ResultOutput">
      <!-- Exceptions for results output in verstrekkingenvertaling -->
      <xsl:copy>
         <xsl:attribute name="value">http://nictiz.nl/fhir/StructureDefinition/mp612-DispenseToFHIRConversion-Patient</xsl:attribute>
      </xsl:copy>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:Medication/f:meta/f:profile"
                 mode="ResultOutput">
      <!-- Exceptions for results output in verstrekkingenvertaling -->
      <xsl:copy>
         <xsl:attribute name="value">http://nictiz.nl/fhir/StructureDefinition/mp612-DispenseToFHIRConversion-Product</xsl:attribute>
      </xsl:copy>
   </xsl:template>
</xsl:stylesheet>