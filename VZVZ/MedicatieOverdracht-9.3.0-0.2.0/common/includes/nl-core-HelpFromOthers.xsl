<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.8.0-beta.1/nl-core-HelpFromOthers.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.2.0; 2024-03-14T08:34:46.14+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc scope="stylesheet">
      <xd:desc>Converts ada hulp_van_anderen to FHIR CarePlan conforming to profile nl-core-HelpFromOthers.</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Create an nl-core-HelpFromOthers instance as an Observation FHIR instance from ada hulp_van_anderen element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="subject">Optional ADA instance or ADA reference element for the patient.</xd:param>
   </xd:doc>
   <xsl:template match="hulp_van_anderen"
                 name="nl-core-HelpFromOthers"
                 mode="nl-core-HelpFromOthers"
                 as="element(f:CarePlan)?">
      <xsl:param name="in"
                 select="."
                 as="element()?"/>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?"/>
      <xsl:for-each select="$in">
         <CarePlan>
            <xsl:call-template name="insertLogicalId"/>
            <meta>
               <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-HelpFromOthers"/>
            </meta>
            <status value="active"/>
            <intent value="plan"/>
            <category>
               <coding>
                  <system value="http://snomed.info/sct"/>
                  <code value="243114000"/>
                  <display value="ondersteuning"/>
               </coding>
            </category>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <activity>
               <detail>
                  <xsl:for-each select="soort_hulp">
                     <code>
                        <xsl:call-template name="code-to-CodeableConcept">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </code>
                  </xsl:for-each>
                  <status value="in-progress"/>
                  <xsl:for-each select="frequentie">
                     <scheduledString>
                        <xsl:call-template name="string-to-string">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </scheduledString>
                  </xsl:for-each>
                  <xsl:for-each select="hulpverlener/zorgverlener">
                     <performer>
                        <xsl:call-template name="makeReference">
                           <xsl:with-param name="in"
                                           select="zorgverlener"/>
                           <xsl:with-param name="profile"
                                           select="'nl-core-HealthProfessional-PractitionerRole'"/>
                        </xsl:call-template>
                     </performer>
                  </xsl:for-each>
                  <xsl:for-each select="hulpverlener/mantelzorger">
                     <performer>
                        <xsl:call-template name="makeReference">
                           <xsl:with-param name="in"
                                           select="contactpersoon"/>
                           <xsl:with-param name="profile"
                                           select="'nl-core-ContactPerson'"/>
                        </xsl:call-template>
                     </performer>
                  </xsl:for-each>
                  <xsl:for-each select="hulpverlener/zorgaanbieder">
                     <performer>
                        <xsl:call-template name="makeReference">
                           <xsl:with-param name="in"
                                           select="zorgaanbieder"/>
                           <xsl:with-param name="profile"
                                           select="'nl-core-HealthcareProvider-Organization'"/>
                        </xsl:call-template>
                     </performer>
                  </xsl:for-each>
                  <xsl:for-each select="aard">
                     <description>
                        <xsl:call-template name="string-to-string">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </description>
                  </xsl:for-each>
               </detail>
            </activity>
            <xsl:for-each select="toelichting">
               <note>
                  <text>
                     <xsl:call-template name="string-to-string">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </text>
               </note>
            </xsl:for-each>
         </CarePlan>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a display that can be shown when referencing this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="hulp_van_anderen"
                 mode="_generateDisplay">
      <xsl:variable name="parts">
         <xsl:text>Help from others: </xsl:text>
         <xsl:if test="aard/@value">
            <xsl:value-of select="aard/@value"/>
         </xsl:if>
         <xsl:if test="frequentie/@value">
            <xsl:value-of select="frequentie/@value"/>
         </xsl:if>
      </xsl:variable>
      <xsl:value-of select="string-join($parts, ', ')"/>
   </xsl:template>
</xsl:stylesheet>