<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/fhir/2_fhir_fixtures.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.12; 2026-02-27T13:57:54.56+01:00 == -->
<xsl:stylesheet version="2.0"
                exclude-result-prefixes="#all"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="#local.2024111413163599491280100"
                xmlns:xhtml="http://www.w3.org/1999/xhtml">
   <xsl:import href="uuid-stable.xsl"/>
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
   <xsl:param name="usecase"
              as="xs:string?"/>
   <!-- ================================================================== -->
   <xsl:template name="generateLogicalId"
                 match="*"
                 mode="generateLogicalId">
      <!-- Helper template for creating logicalId for Touchstone. Adheres to requirements in MM-1752. Profilename-usecase-uniquestring. -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- The ada element for which to create a logical id. Optional. Used to find profileName. Defaults to context. -->
      </xsl:param>
      <xsl:param name="uniqueString"
                 as="xs:string?">
         <!-- The unique string with which to create a logical id. Optional. If not given a uuid will be generated. -->
      </xsl:param>
      <!-- NOTE: this does not work if you have two ada element names which may end up in different FHIR profiles, the function simply selects the first one found -->
      <xsl:param name="profile"
                 as="xs:string?"
                 select="nf:get-profilename-from-adaelement($in)"/>
      <xsl:variable name="logicalIdStartString"
                    as="xs:string*">
         <xsl:choose>
            <xsl:when test="$profile = ($profileNameHealthcareProvider, $profileNameHealthcareProviderOrganization)">
               <xsl:value-of select="replace(replace(replace($profile, 'HealthcareProvider', 'HPrv'), 'Organization', 'Org'), 'Location', 'Loc')"/>
            </xsl:when>
            <xsl:when test="$profile = ($profileNameHealthProfessionalPractitioner, $profileNameHealthProfessionalPractitionerRole)">
               <xsl:value-of select="replace(replace(replace($profile, 'HealthProfessional', 'HPrf'), 'Practitioner', 'Prac'), 'Role', 'Rol')"/>
            </xsl:when>
            <xsl:when test="self::farmaceutisch_product">
               <xsl:value-of select="replace($profile, 'PharmaceuticalProduct', 'PhPrd')"/>
            </xsl:when>
            <xsl:when test="self::medicatieafspraak | self::wisselend_doseerschema | self::verstrekkingsverzoek | self::toedieningsafspraak | self::medicatieverstrekking | self::medicatiegebruik | self::medicatietoediening">
               <xsl:value-of select="replace(replace(replace(replace(replace(replace($profile, 'Agreement', 'Agr'), 'Medication', 'Med'), 'Administration', 'Adm'), 'Dispense', 'Dsp'), 'Request', 'Req'), 'VariableDosingRegimen', 'VarDosReg')"/>
            </xsl:when>
            <xsl:when test="self::vaccinatie">
               <xsl:value-of select="replace($profile, 'nl-core-Vaccination-event', 'Imm')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$profile"/>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:value-of select="$usecase"/>
      </xsl:variable>
      <xsl:variable name="lengthUniqueStringOK"
                    as="xs:boolean"
                    select="string-length($uniqueString) le $maxLengthFHIRLogicalId and string-length($uniqueString) gt 0"/>
      <xsl:choose>
         <!-- NICTIZ-34243 dubbele "nl-core-Patient-mp9-" te voorkomen in id -->
         <xsl:when test="$lengthUniqueStringOK and starts-with($uniqueString, string-join($logicalIdStartString, '-'))">
            <xsl:value-of select="replace(nf:assure-logicalid-length(nf:assure-logicalid-chars($uniqueString)), '\.', '-')"/>
            <!-- <xsl:value-of select="nf:assure-logicalid-length(nf:assure-logicalid-chars($uniqueString))"/> -->
         </xsl:when>
         <xsl:when test="$lengthUniqueStringOK">
            <xsl:value-of select="replace(nf:assure-logicalid-length(nf:assure-logicalid-chars(concat(string-join($logicalIdStartString, '-'), '-', $uniqueString))), '\.', '-')"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- we do not have anything to create a stable logicalId, lets return a UUID -->
            <xsl:value-of select="nf:assure-logicalid-length(nf:assure-logicalid-chars(concat(string-join($logicalIdStartString, '-'), '-', uuid:get-uuid(.))))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:removeSpecialCharsAndDotForTouchstone">
      <!-- remove dots which are not accepted in filenames in Touchstone and also the special characters which are not allowed in FHIR -->
      <xsl:param name="in"
                 as="xs:string?">
         <!-- The input string to be replaced -->
      </xsl:param>
      <xsl:value-of select="replace(nf:removeSpecialCharacters($in), '\.', '-')"/>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="*"
                 mode="doResourceInResultdoc">
      <!-- Creates xml document for a FHIR resource -->
      <xsl:param name="outputDir"
                 select="'.'">
         <!-- The outputDir for the resource, defaults to 'current dir'. -->
      </xsl:param>
      <xsl:result-document href="{$outputDir}/{f:id/@value}.xml">
         <xsl:copy-of select="."/>
      </xsl:result-document>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="medicatieafspraak | wisselend_doseerschema | verstrekkingsverzoek | toedieningsafspraak | medicatieverstrekking | medicatiegebruik | medicatietoediening"
                 mode="_generateId">
      <!-- Template to generate a unique id to identify this instance. Override the logicalId generation for our Touchstone resources with the goal to remove oids from filenames. -->
      <xsl:variable name="uniqueString"
                    as="xs:string?">
         <xsl:choose>
            <xsl:when test="identificatie[@root][@value]">
               <xsl:for-each select="(identificatie[@root][@value])[1]">
                  <!-- we remove '.' in root oid and '_' in extension to enlarge the chance of staying in 64 chars -->
                  <xsl:value-of select="replace(@value, '_', '')"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <!-- we do not have anything to create a stable logicalId, lets return a UUID -->
               <xsl:value-of select="nf:get-uuid(.)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="generateLogicalId">
         <xsl:with-param name="uniqueString"
                         select="$uniqueString"/>
      </xsl:call-template>
   </xsl:template>
</xsl:stylesheet>