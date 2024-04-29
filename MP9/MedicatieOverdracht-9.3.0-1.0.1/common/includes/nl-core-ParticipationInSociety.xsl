<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.8.0-beta.1/nl-core-ParticipationInSociety.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 1.0.1; 2024-04-18T12:43:34.01+02:00 == -->
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
      <xd:desc>Converts ada participatie_in_maatschappij to FHIR Observation conforming to profile nl-core-ParticipationInSociety</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Create an nl-core-ParticipationInSociety instance as an Observation FHIR instance from ada participatie_in_maatschappij element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="subject">Optional ADA instance or ADA reference element for the patient.</xd:param>
   </xd:doc>
   <xsl:template match="participatie_in_maatschappij"
                 name="nl-core-ParticipationInSociety"
                 mode="nl-core-ParticipationInSociety"
                 as="element(f:Observation)?">
      <xsl:param name="in"
                 select="."
                 as="element()?"/>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?"/>
      <xsl:for-each select="$in">
         <Observation>
            <xsl:call-template name="insertLogicalId"/>
            <meta>
               <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-ParticipationInSociety"/>
            </meta>
            <status value="final"/>
            <code>
               <coding>
                  <system value="http://snomed.info/sct"/>
                  <code value="314845004"/>
                  <display value="status van participatie van patiënt"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
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
            <xsl:for-each select="sociaal_netwerk">
               <component>
                  <code>
                     <coding>
                        <system value="http://snomed.info/sct"/>
                        <code value="365469004"/>
                        <display value="bevinding betreffende netwerk van gezin, familie en ondersteuners"/>
                     </coding>
                  </code>
                  <valueString>
                     <xsl:call-template name="string-to-string">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueString>
               </component>
            </xsl:for-each>
            <xsl:for-each select="vrijetijdsbesteding">
               <component>
                  <code>
                     <coding>
                        <system value="http://snomed.info/sct"/>
                        <code value="405081003"/>
                        <display value="vrijetijdsgedrag"/>
                     </coding>
                  </code>
                  <valueString>
                     <xsl:call-template name="string-to-string">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueString>
               </component>
            </xsl:for-each>
            <xsl:for-each select="arbeidssituatie">
               <component>
                  <code>
                     <coding>
                        <system value="http://snomed.info/sct"/>
                        <code value="364703007"/>
                        <display value="arbeidssituatie"/>
                     </coding>
                  </code>
                  <valueString>
                     <xsl:call-template name="string-to-string">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueString>
               </component>
            </xsl:for-each>
         </Observation>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>