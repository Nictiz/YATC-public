<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.5-beta1/nl-core-ContactPerson.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-01-29T18:25:49.35+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc scope="stylesheet">
      <xd:desc>Converts ADA contactpersoon to FHIR RelatedPerson resource conforming to profile nl-core-ContactPerson.</xd:desc>
   </xd:doc>
   <xsl:variable name="profileNameContactPerson">nl-core-ContactPerson</xsl:variable>
   <xd:doc>
      <xd:desc>Creates an nl-core-ContactPerson instance as a RelatedPerson FHIR instance from ADA contactpersoon element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="patient">Optional ADA instance or ADA reference element for the patient.</xd:param>
   </xd:doc>
   <xsl:template match="contactpersoon"
                 name="nl-core-ContactPerson"
                 mode="nl-core-ContactPerson"
                 as="element(f:RelatedPerson)?">
      <xsl:param name="in"
                 select="."
                 as="element()?"/>
      <xsl:param name="patient"
                 select="patient"
                 as="element()?"/>
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
   <xd:doc>
      <xd:desc>Creates an nl-core-Contactperson FHIR instance embedded in the Patient instance from ADA contactpersoon element. Since it is embedded in the Patient no Resource.id is needed.</xd:desc>
      <xd:param name="in">Node to consider in the creation of a Patient.contact element.</xd:param>
   </xd:doc>
   <xsl:template match="contactpersoon"
                 name="nl-core-ContactPerson-embedded"
                 mode="nl-core-ContactPerson-embedded"
                 as="element(f:contact)?">
      <xsl:param name="in"
                 select="."
                 as="element()?"/>
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
   <xd:doc>
      <xd:desc>Template to generate a unique id to identify a patient present in a (set of) ada-instance(s)</xd:desc>
   </xd:doc>
   <xsl:template match="contactpersoon"
                 mode="_generateId">
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
   <xd:doc>
      <xd:desc>Template to generate a display that can be shown when referencing this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="contactpersoon"
                 mode="_generateDisplay">
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Contact person</xsl:text>
         <xsl:value-of select="nf:renderName(naamgegevens)"/>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>