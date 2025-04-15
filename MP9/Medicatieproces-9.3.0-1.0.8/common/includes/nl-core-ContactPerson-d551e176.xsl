<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.5-beta1/nl-core-ContactPerson.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-04-08T17:27:28.82+02:00 == -->
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
                xmlns:local="#local.2024111408213013856810100"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <!-- ================================================================== -->
   <!--
        Converts ADA contactpersoon to FHIR RelatedPerson resource conforming to profile nl-core-ContactPerson.
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
   <xsl:variable name="profileNameContactPerson">nl-core-ContactPerson</xsl:variable>
   <!-- ================================================================== -->
   <xsl:template match="contactpersoon"
                 name="nl-core-ContactPerson"
                 mode="nl-core-ContactPerson"
                 as="element(f:RelatedPerson)?">
      <!-- Creates an nl-core-ContactPerson instance as a RelatedPerson FHIR instance from ADA contactpersoon element. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <xsl:param name="patient"
                 select="patient"
                 as="element()?">
         <!-- Optional ADA instance or ADA reference element for the patient. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <RelatedPerson>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameContactPerson"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$patient"/>
               <xsl:with-param name="wrapIn"
                               select="'patient'"/>
            </xsl:call-template>
            <xsl:for-each select="rol[@code]">
               <relationship>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </relationship>
            </xsl:for-each>
            <xsl:for-each select="relatie[@code]">
               <relationship>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </relationship>
            </xsl:for-each>
            <xsl:for-each select="naamgegevens">
               <xsl:call-template name="nl-core-NameInformation"/>
            </xsl:for-each>
            <xsl:for-each select="contactgegevens">
               <xsl:call-template name="nl-core-ContactInformation"/>
            </xsl:for-each>
            <xsl:for-each select="adresgegevens">
               <xsl:call-template name="nl-core-AddressInformation"/>
            </xsl:for-each>
         </RelatedPerson>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="contactpersoon"
                 name="nl-core-ContactPerson-embedded"
                 mode="nl-core-ContactPerson-embedded"
                 as="element(f:contact)?">
      <!-- Creates an nl-core-Contactperson FHIR instance embedded in the Patient instance from ADA contactpersoon element. Since it is embedded in the Patient no Resource.id is needed. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- Node to consider in the creation of a Patient.contact element. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <contact>
            <xsl:for-each select="rol">
               <relationship>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </relationship>
            </xsl:for-each>
            <xsl:for-each select="relatie">
               <relationship>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </relationship>
            </xsl:for-each>
            <!-- We can't add the full name information here, just the name information needed to address the 
                     contact person -->
            <xsl:variable name="nameInformation"
                          as="element(f:name)*">
               <xsl:for-each select="naamgegevens">
                  <xsl:call-template name="nl-core-NameInformation"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:if test="count($nameInformation) &gt; 0">
               <xsl:copy-of select="$nameInformation[1]"/>
            </xsl:if>
            <xsl:for-each select="contactgegevens">
               <xsl:call-template name="nl-core-ContactInformation"/>
            </xsl:for-each>
            <xsl:for-each select="adresgegevens">
               <xsl:call-template name="nl-core-AddressInformation"/>
            </xsl:for-each>
         </contact>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="contactpersoon"
                 mode="_generateId">
      <!-- Template to generate a unique id to identify a patient present in a (set of) ada-instance(s) -->
      <xsl:variable name="uniqueString"
                    as="xs:string?">
         <xsl:choose>
            <xsl:when test="identificatie[@root][@value]">
               <xsl:for-each select="(identificatie[@root][@value])[1]">
                  <!-- we remove '.' in root oid and '_' in extension to enlarge the chance of staying in 64 chars -->
                  <xsl:value-of select="concat(replace(@root, '\.', ''), '-', replace(@value, '_', ''))"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:when test="naamgegevens[1]//*[not(name() = 'naamgebruik')]/@value">
               <xsl:value-of select="upper-case(replace(string-join(naamgegevens[1]//*[not(name() = 'naamgebruik')]/@value, ' '), '\s', ''))"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- we do not have anything to create a stable logicalId, lets return a UUID -->
               <xsl:value-of select="uuid:get-uuid(.)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="generateLogicalId">
         <xsl:with-param name="uniqueString"
                         select="$uniqueString"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="contactpersoon"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Contact person</xsl:text>
         <xsl:value-of select="nf:renderName(naamgegevens)"/>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>