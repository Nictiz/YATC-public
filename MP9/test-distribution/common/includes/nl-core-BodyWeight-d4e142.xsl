<?xml version="1.0" encoding="UTF-8"?>
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
      <xd:desc>Converts ada lichaamsgewicht to FHIR Observation conforming to profile nl-core-BodyWeight</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Create an nl-core-BodyWeight as a Observation FHIR instance from ada lichaamsgewicht element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="subject">Optional ADA instance or ADA reference element for the patient.</xd:param>
   </xd:doc>
   <xsl:template match="lichaamsgewicht"
                 name="nl-core-BodyWeight"
                 mode="nl-core-BodyWeight"
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
               <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-BodyWeight"/>
            </meta>
            <xsl:for-each select="identificatie[@value | @root | @nullFlavor]">
               <identifier>
                  <xsl:call-template name="id-to-Identifier"/>
               </identifier>
            </xsl:for-each>
            <status value="final"/>
            <category>
               <coding>
                  <system value="http://terminology.hl7.org/CodeSystem/observation-category"/>
                  <code value="vital-signs"/>
                  <display value="Vital Signs"/>
               </coding>
            </category>
            <code>
               <coding>
                  <system value="http://loinc.org"/>
                  <code value="29463-7"/>
                  <display value="Body weight"/>
               </coding>
            </code>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:for-each select="gewicht_datum_tijd">
               <effectiveDateTime>
                  <xsl:call-template name="date-to-datetime">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </effectiveDateTime>
            </xsl:for-each>
            <xsl:for-each select="gewicht_waarde">
               <valueQuantity>
                  <xsl:call-template name="hoeveelheid-to-Quantity">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </valueQuantity>
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
            <xsl:for-each select="kleding">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="248159006"/>
                        <display value="State of dress"/>
                     </coding>
                  </code>
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueCodeableConcept>
               </component>
            </xsl:for-each>
         </Observation>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a display that can be shown when referencing this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="lichaamsgewicht"
                 mode="_generateDisplay">
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Body weight observation</xsl:text>
         <xsl:if test="gewicht_datum_tijd[@value]">
            <xsl:value-of select="concat('measurement date ', gewicht_datum_tijd/@value)"/>
         </xsl:if>
         <xsl:value-of select="toelichting/@value"/>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>