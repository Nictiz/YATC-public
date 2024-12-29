<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.5-beta1/nl-core-ContactInformation.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.6; 2024-12-29T15:47:03.74+01:00 == -->
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
                xmlns:local="#local.2024111408213012461380100"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <!-- ================================================================== -->
   <!--
        Converts ADA contactgegevens to FHIR ContactPoint datatype conforming to profile nl-core-ContactInformation-TelephoneNumbers and nl-core-ContactInformation-E-mailAddresses.
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
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <!-- ================================================================== -->
   <xsl:template match="contactgegevens"
                 mode="nl-core-ContactInformation"
                 name="nl-core-ContactInformation"
                 as="element(f:telecom)*">
      <!-- Converts FHIR ContactPoint datatype from ADA contactgegevens element. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- Ada 'contactgegevens' element containing the nl-core data -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:for-each select="telefoonnummers[telefoonnummer/@value]">
            <xsl:variable name="telecomType"
                          select="telecom_type/@code"/>
            <xsl:variable name="telecomSystem"
                          as="xs:string?">
               <xsl:choose>
                  <xsl:when test="$telecomType = 'LL'">phone</xsl:when>
                  <xsl:when test="$telecomType = 'FAX'">fax</xsl:when>
                  <xsl:when test="$telecomType = 'MC'">phone</xsl:when>
                  <xsl:when test="$telecomType = 'PG'">pager</xsl:when>
                  <!-- Otherwise we don't know, assumption is phone -->
                  <xsl:otherwise>phone</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="numberType"
                          select="nummer_soort/@code"/>
            <xsl:variable name="numberUse"
                          as="xs:string?">
               <xsl:choose>
                  <xsl:when test="$numberType = 'HP'">home</xsl:when>
                  <xsl:when test="$numberType = 'TMP'">temp</xsl:when>
                  <xsl:when test="$numberType = 'WP'">work</xsl:when>
               </xsl:choose>
            </xsl:variable>
            <telecom>
               <xsl:for-each select="toelichting">
                  <xsl:call-template name="ext-Comment">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <xsl:if test="telefoonnummer[@value]">
                  <system>
                     <xsl:if test="string-length($telecomSystem) gt 0">
                        <xsl:attribute name="value"
                                       select="$telecomSystem"/>
                     </xsl:if>
                     <xsl:if test="$telecomType">
                        <xsl:call-template name="ext-CodeSpecification">
                           <xsl:with-param name="in"
                                           select="telecom_type"/>
                        </xsl:call-template>
                     </xsl:if>
                  </system>
               </xsl:if>
               <xsl:for-each select="telefoonnummer">
                  <value value="{normalize-space(@value)}"/>
               </xsl:for-each>
               <xsl:if test="string-length($numberUse) gt 0">
                  <use value="{$numberUse}"/>
               </xsl:if>
            </telecom>
         </xsl:for-each>
         <xsl:for-each select="email_adressen[email_adres/@value]">
            <xsl:variable name="emailType"
                          select="email_soort/@code"/>
            <xsl:variable name="emailUse"
                          as="xs:string?">
               <xsl:choose>
                  <xsl:when test="$emailType = 'WP'">work</xsl:when>
                  <xsl:when test="$emailType = 'HP'">home</xsl:when>
               </xsl:choose>
            </xsl:variable>
            <telecom>
               <system value="email"/>
               <xsl:for-each select="email_adres">
                  <value value="{normalize-space(@value)}"/>
               </xsl:for-each>
               <xsl:if test="$emailUse">
                  <use value="{$emailUse}"/>
               </xsl:if>
            </telecom>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>