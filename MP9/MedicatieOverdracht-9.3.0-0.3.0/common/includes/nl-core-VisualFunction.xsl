<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.5-beta1/nl-core-VisualFunction.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.3.0; 2024-04-09T18:20:47.77+02:00 == -->
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
      <xd:desc>Converts ada functie_zien to FHIR Observation conforming to profile nl-core-VisualFunction, FHIR DeviceUseStatement conforming to profile nl-core-VisualFunction.VisualAid and FHIR Device conforming to profile nl-core-VisualFunction.VisualAid.Product</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Create an nl-core-VisualFunction instance as an Observation FHIR instance from ada functie_zien element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="subject">Optional ADA instance or ADA reference element for the patient.</xd:param>
   </xd:doc>
   <xsl:template match="functie_zien"
                 name="nl-core-VisualFunction"
                 mode="nl-core-VisualFunction"
                 as="element(f:Observation)?">
      <xsl:param name="in"
                 select="."
                 as="element()?"/>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?"/>
      <xsl:for-each select="$in">
         <Observation>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="'nl-core-VisualFunction'"/>
            </xsl:call-template>
            <meta>
               <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-VisualFunction"/>
            </meta>
            <status value="final"/>
            <code>
               <coding>
                  <system value="http://snomed.info/sct"/>
                  <code value="281004000"/>
                  <display value="visuele functie"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:for-each select="visuele_functie">
               <valueCodeableConcept>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </valueCodeableConcept>
            </xsl:for-each>
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
         </Observation>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Create an nl-core-VisualFunction.VisualAid instance as a DeviceUseStatement FHIR instance from ada zien_hulpmiddel/medisch_hulpmiddel element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="subject">Optional ADA instance or ADA reference element for the patient.</xd:param>
      <xd:param name="reasonReference">ADA instance used to populate the reasonReference element in the MedicalDevice.</xd:param>
   </xd:doc>
   <xsl:template match="zien_hulpmiddel/medisch_hulpmiddel"
                 name="nl-core-VisualFunction.VisualAid"
                 mode="nl-core-VisualFunction.VisualAid"
                 as="element(f:DeviceUseStatement)?">
      <xsl:param name="in"
                 select="."
                 as="element()?"/>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?"/>
      <xsl:param name="reasonReference"
                 select="ancestor::functie_zien"/>
      <xsl:call-template name="nl-core-MedicalDevice">
         <xsl:with-param name="subject"
                         select="$subject"/>
         <xsl:with-param name="profile"
                         select="'nl-core-VisualFunction.VisualAid'"/>
         <xsl:with-param name="reasonReference"
                         select="$reasonReference"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Create an nl-core-VisualFunction.VisualAid.Product instance as a Device FHIR instance from ada product element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="subject">Optional ADA instance or ADA reference element for the patient.</xd:param>
   </xd:doc>
   <xsl:template match="product"
                 name="nl-core-VisualFunction.VisualAid.Product"
                 mode="nl-core-VisualFunction.VisualAid.Product"
                 as="element(f:Device)?">
      <xsl:param name="in"
                 select="."
                 as="element()?"/>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?"/>
      <xsl:call-template name="nl-core-MedicalDevice.Product">
         <xsl:with-param name="subject"
                         select="$subject"/>
         <xsl:with-param name="profile"
                         select="'nl-core-VisualFunction.VisualAid.Product'"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a display that can be shown when referencing this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="functie_zien"
                 mode="_generateDisplay">
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Visual function observation</xsl:text>
         <xsl:if test="visuele_functie[@displayName]">
            <xsl:value-of select="visuele_functie/@displayName"/>
         </xsl:if>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>