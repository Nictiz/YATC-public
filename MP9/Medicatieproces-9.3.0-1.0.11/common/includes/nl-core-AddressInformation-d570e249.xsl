<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/zibs/2020/payload/0.8.0-beta.1/nl-core-AddressInformation.xsl == -->
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
   <!--<xsl:import href="../../fhir/fhir_2_ada_fhir_include.xsl"/>-->
   <!-- ================================================================== -->
   <xsl:template match="f:address"
                 mode="nl-core-AddressInformation">
      <!-- Template to convert f:address to ADA adresgegevens -->
      <adresgegevens>
         <!-- straat -->
         <!-- huisnummer -->
         <!-- huisnummerletter -->
         <!-- huisnummertoevoeging -->
         <!-- aanduiding_bij_nummer -->
         <xsl:apply-templates select="f:line"
                              mode="#current"/>
         <!-- postcode -->
         <xsl:apply-templates select="f:postalCode"
                              mode="#current"/>
         <!-- woonplaats -->
         <xsl:apply-templates select="f:city"
                              mode="#current"/>
         <!-- gemeente -->
         <xsl:apply-templates select="f:district"
                              mode="#current"/>
         <!-- land -->
         <xsl:apply-templates select="f:country"
                              mode="#current"/>
         <!-- additionele_informatie -->
         <xsl:apply-templates select="f:line/f:extension[@url='http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-unitID']"
                              mode="#current"/>
         <!-- adres_soort -->
         <xsl:call-template name="address-use-type"/>
      </adresgegevens>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:line"
                 mode="nl-core-AddressInformation">
      <!-- Template to resolve f:line -->
      <xsl:apply-templates select="f:extension[@url='http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetName']"
                           mode="#current"/>
      <xsl:apply-templates select="f:extension[@url='http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumber']"
                           mode="#current"/>
      <xsl:apply-templates select="f:extension[@url='http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-buildingNumberSuffix']"
                           mode="#current"/>
      <xsl:apply-templates select="f:extension[@url='http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-additionalLocator']"
                           mode="#current"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:extension"
                 mode="nl-core-AddressInformation">
      <!-- Template to convert several f:extensions to either straat, huisnummer, huisnummertoevoeging, additionele_informatie or aanduiding_bij_nummer -->
      <xsl:choose>
         <xsl:when test="@url='http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetName'">
            <straat value="{f:valueString/@value}"/>
         </xsl:when>
         <xsl:when test="@url='http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumber'">
            <huisnummer value="{f:valueString/@value}"/>
         </xsl:when>
         <xsl:when test="@url='http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-buildingNumberSuffix'">
            <xsl:variable name="value"
                          select="f:valueString/@value"/>
            <xsl:choose>
               <xsl:when test="not(contains($value, ' '))">
                  <huisnummerletter value="{$value}"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:if test="string-length(substring-before($value, ' ')) gt 0">
                     <huisnummerletter value="{substring-before($value, ' ')}"/>
                  </xsl:if>
                  <xsl:if test="string-length(substring-after($value, ' ')) gt 0">
                     <huisnummertoevoeging value="{substring-after($value, ' ')}"/>
                  </xsl:if>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="@url='http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-unitID'">
            <additionele_informatie value="{f:valueString/@value}"/>
         </xsl:when>
         <xsl:when test="@url='http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-additionalLocator'">
            <aanduiding_bij_nummer value="{f:valueString/@value}"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:postalCode"
                 mode="nl-core-AddressInformation">
      <!-- Template to convert f:postalCode to postcode -->
      <postcode value="{@value}"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:city"
                 mode="nl-core-AddressInformation">
      <!-- Template to convert f:city to woonplaats -->
      <woonplaats value="{@value}"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:district"
                 mode="nl-core-AddressInformation">
      <!-- Template to convert f:district to gemeente -->
      <gemeente value="{@value}"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:country"
                 mode="nl-core-AddressInformation">
      <!-- Template to convert f:country to land -->
      <xsl:choose>
         <xsl:when test="f:extension[@url='http://nictiz.nl/fhir/StructureDefinition/ext-CodeSpecification']">
            <xsl:call-template name="CodeableConcept-to-code">
               <xsl:with-param name="in"
                               select="f:extension[@url='http://nictiz.nl/fhir/StructureDefinition/ext-CodeSpecification']/f:valueCodeableConcept"/>
               <xsl:with-param name="adaElementName"
                               select="'land'"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <land displayName="{@value}"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="address-use-type">
      <!-- Template to convert AD-use f:extension to adres_soort. -->
      <xsl:variable name="ad-use"
                    select="'http://nictiz.nl/fhir/StructureDefinition/ext-AddressInformation.AddressType'"/>
      <xsl:variable name="ad-use-valueCode"
                    select="f:extension[@url=$ad-use]/f:valueCodeableConcept/f:coding[f:system/@value='http://terminology.hl7.org/CodeSystem/v3-AddressUse']/f:code/@value"/>
      <xsl:if test="not(empty($ad-use-valueCode))">
         <xsl:variable name="codeMapInput">
            <xsl:choose>
               <!-- Postadres -->
               <xsl:when test="$ad-use-valueCode='PST' or f:type/@value='postal'">PST</xsl:when>
               <!-- Officieel adres -->
               <xsl:when test="$ad-use-valueCode='HP'">HP</xsl:when>
               <xsl:when test="f:use/@value='home' and f:type/@value='both'">HP</xsl:when>
               <!-- Woon-/verblijfadres -->
               <xsl:when test="$ad-use-valueCode='PHYS'">PHYS</xsl:when>
               <xsl:when test="f:use/@value='home' and f:type/@value='physical'">PHYS</xsl:when>
               <!-- Vakantie-adres -->
               <xsl:when test="$ad-use-valueCode='HV'">HV</xsl:when>
               <!-- Tijdelijk adres -->
               <xsl:when test="$ad-use-valueCode='TMP'">TMP</xsl:when>
               <xsl:when test="f:use/@value='temp'">TMP</xsl:when>
               <!-- Werkadres -->
               <xsl:when test="$ad-use-valueCode='WP'">WP</xsl:when>
               <xsl:when test="f:use/@value='work'">WP</xsl:when>
            </xsl:choose>
         </xsl:variable>
         <adres_soort>
            <xsl:call-template name="fhircode-to-adacode">
               <xsl:with-param name="value"
                               select="$codeMapInput"/>
               <xsl:with-param name="codeMap"
                               as="element()*">
                  <map inValue="PST"
                       code="PST"
                       codeSystem="2.16.840.1.113883.5.1119"
                       displayName="Postadres"/>
                  <map inValue="HP"
                       code="HP"
                       codeSystem="2.16.840.1.113883.5.1119"
                       displayName="Officieel adres"/>
                  <map inValue="PHYS"
                       code="PHYS"
                       codeSystem="2.16.840.1.113883.5.1119"
                       displayName="Woon-/verblijfadres"/>
                  <map inValue="TMP"
                       code="TMP"
                       codeSystem="2.16.840.1.113883.5.1119"
                       displayName="Tijdelijk adres"/>
                  <map inValue="WP"
                       code="WP"
                       codeSystem="2.16.840.1.113883.5.1119"
                       displayName="Werkadres"/>
                  <map inValue="HV"
                       code="HV"
                       codeSystem="2.16.840.1.113883.5.1119"
                       displayName="Vakantie adres"/>
               </xsl:with-param>
            </xsl:call-template>
         </adres_soort>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>