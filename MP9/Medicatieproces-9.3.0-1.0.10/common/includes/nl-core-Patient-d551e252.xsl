<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/zibs/2020/payload/0.8.0-beta.1/nl-core-Patient.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.10; 2025-04-16T18:06:20.52+02:00 == -->
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
   <xsl:variable name="nl-core-patient"
                 select="'http://nictiz.nl/fhir/StructureDefinition/nl-core-Patient'"/>
   <!-- ================================================================== -->
   <xsl:template match="f:Patient"
                 mode="nl-core-Patient">
      <!-- Template to convert f:Patient to ADA patient, currently only support for elements that are part of MP9 2.0 transactions -->
      <patient>
         <!-- naamgegevens -->
         <!-- TODO naam even uitstellen vanwege zib issue -->
         <!-- naamgegevens -->
         <xsl:apply-templates select="f:name"
                              mode="#current"/>
         <!-- adresgegevens -->
         <xsl:apply-templates select="f:address"
                              mode="nl-core-AddressInformation"/>
         <!-- contactgegevens -->
         <xsl:if test="f:telephoneNumbers | f:emailAddresses">
            <contactgegevens>
               <xsl:apply-templates select="f:telephoneNumbers"
                                    mode="nl-core-ContactInformation-TelephoneNumbers"/>
               <xsl:apply-templates select="f:emailAddresses"
                                    mode="nl-core-ContactInformation-EmailAddresses"/>
            </contactgegevens>
         </xsl:if>
         <!-- identificatienummer -->
         <xsl:apply-templates select="f:identifier"
                              mode="#current"/>
         <!-- geboortedatum -->
         <xsl:apply-templates select="f:birthDate"
                              mode="#current"/>
         <!-- geslacht -->
         <xsl:apply-templates select="f:gender"
                              mode="#current"/>
         <!-- meerling_indicator -->
         <xsl:apply-templates select="f:multipleBirthBoolean"
                              mode="#current"/>
         <!-- TODO overlijdensindicator datum_overlijden -->
      </patient>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:identifier"
                 mode="nl-core-Patient">
      <!-- Template to convert f:identifier to identificatienummer -->
      <xsl:call-template name="Identifier-to-identificatie">
         <xsl:with-param name="adaElementName">identificatienummer</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:birthDate"
                 mode="nl-core-Patient">
      <!-- Template to convert f:birthDate to geboortedatum -->
      <xsl:call-template name="datetime-to-datetime">
         <xsl:with-param name="adaElementName">geboortedatum</xsl:with-param>
         <xsl:with-param name="adaDatatype">datetime</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:gender"
                 mode="nl-core-Patient">
      <!-- Template to convert f:gender to geslacht -->
      <geslacht>
         <xsl:call-template name="fhircode-to-adacode">
            <xsl:with-param name="value"
                            select="@value"/>
            <xsl:with-param name="codeMap"
                            as="element()*">
               <map code="M"
                    codeSystem="2.16.840.1.113883.5.1"
                    inValue="male"
                    displayName="Man"/>
               <map code="F"
                    codeSystem="2.16.840.1.113883.5.1"
                    inValue="female"
                    displayName="Vrouw"/>
               <map code="UN"
                    codeSystem="2.16.840.1.113883.5.1"
                    inValue="other"
                    displayName="Ongedifferentieerd"/>
               <map code="UNK"
                    codeSystem="2.16.840.1.113883.5.1008"
                    inValue="unknown"
                    displayName="Onbekend"/>
            </xsl:with-param>
         </xsl:call-template>
         <!-- displayName attribute? -->
      </geslacht>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:multipleBirthBoolean"
                 mode="nl-core-Patient">
      <!-- Template to convert f:multipleBirthBoolean to meerling_indicator -->
      <meerling_indicator>
         <xsl:call-template name="boolean-to-boolean"/>
      </meerling_indicator>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:name[not(preceding-sibling::f:name)]"
                 mode="nl-core-Patient">
      <!-- Template to convert f:name to naamgegevens, only the first occurance. The rest is handled in nl-core-NameInformation -->
      <xsl:apply-templates select="."
                           mode="nl-core-NameInformation"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:name[preceding-sibling::f:name]"
                 mode="nl-core-Patient">
      <!-- Do nothing for the name following the first name -->
   </xsl:template>
</xsl:stylesheet>