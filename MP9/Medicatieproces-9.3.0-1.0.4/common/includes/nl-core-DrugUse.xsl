<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.5-beta1/nl-core-DrugUse.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.4; 2024-11-07T16:21:01.99+01:00 == -->
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
      <xd:desc>Converts ADA drugs_gebruik to FHIR Observation resource conforming to profile nl-core-DrugUse.</xd:desc>
   </xd:doc>
   <xsl:variable name="profileNameDrugUse">nl-core-DrugUse</xsl:variable>
   <xd:doc>
      <xd:desc>Creates an nl-core-DrugUse instance as an Observation FHIR instance from ADA drugs_gebruik element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
   </xd:doc>
   <xsl:template match="drugs_gebruik"
                 name="nl-core-DrugUse"
                 mode="nl-core-DrugUse"
                 as="element(f:Observation)">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?"/>
      <xsl:for-each select="$in">
         <Observation>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameDrugUse"/>
            </xsl:call-template>
            <meta>
               <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
            </meta>
            <status value="final"/>
            <code>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="228366006"/>
                  <display value="bevinding betreffende drugsgebruik"/>
               </coding>
            </code>
            <xsl:for-each select="$subject">
               <xsl:call-template name="makeReference">
                  <xsl:with-param name="in"
                                  select="$subject"/>
                  <xsl:with-param name="wrapIn"
                                  select="'subject'"/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="waarneming_gebruik/start_datum or waarneming_gebruik/stop_datum">
               <effectivePeriod>
                  <xsl:for-each select="waarneming_gebruik/start_datum">
                     <start>
                        <xsl:attribute name="value">
                           <xsl:call-template name="format2FHIRDate">
                              <xsl:with-param name="dateTime"
                                              select="@value"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </start>
                  </xsl:for-each>
                  <xsl:for-each select="waarneming_gebruik/stop_datum">
                     <end>
                        <xsl:attribute name="value">
                           <xsl:call-template name="format2FHIRDate">
                              <xsl:with-param name="dateTime"
                                              select="@value"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </end>
                  </xsl:for-each>
               </effectivePeriod>
            </xsl:if>
            <xsl:for-each select="drugs_gebruik_status">
               <valueCodeableConcept>
                  <xsl:call-template name="code-to-CodeableConcept"/>
               </valueCodeableConcept>
            </xsl:for-each>
            <xsl:for-each select="toelichting">
               <note>
                  <text>
                     <xsl:attribute name="value"
                                    select="./@value"/>
                  </text>
               </note>
            </xsl:for-each>
            <xsl:for-each select="drugs_of_geneesmiddel_soort">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="105590001"/>
                        <display value="substantie"/>
                     </coding>
                  </code>
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept"/>
                  </valueCodeableConcept>
               </component>
            </xsl:for-each>
            <xsl:for-each select="toedieningsweg">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="410675002"/>
                        <display value="toedieningsweg"/>
                     </coding>
                  </code>
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept"/>
                  </valueCodeableConcept>
               </component>
            </xsl:for-each>
            <xsl:for-each select="waarneming_gebruik/hoeveelheid">
               <component>
                  <code>
                     <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="363908000"/>
                        <display value="detail over drugsmisbruik"/>
                     </coding>
                  </code>
                  <valueString>
                     <xsl:attribute name="value"
                                    select="./@value"/>
                  </valueString>
               </component>
            </xsl:for-each>
         </Observation>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a unique id to identify this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="drugs_gebruik"
                 mode="_generateId">
      <xsl:variable name="parts">
         <xsl:text>DrugUse</xsl:text>
         <xsl:value-of select="drugs_gebruik_status/@displayName"/>
         <xsl:value-of select="drugs_of_geneesmiddel_soort/@displayName"/>
         <xsl:value-of select="toedieningsweg/@displayName"/>
         <xsl:value-of select="waarneming_gebruik/start_datum/@value"/>
         <xsl:value-of select="waarneming_gebruik/stop_datum/@value"/>
         <xsl:value-of select="waarneming_gebruik/hoeveelheid/@value"/>
         <xsl:value-of select="toelichting/@value"/>
      </xsl:variable>
      <xsl:value-of select="substring(replace(string-join($parts, '-'), '[^A-Za-z0-9-.]', ''), 1, 64)"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a display that can be shown when referencing this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="drugs_gebruik"
                 mode="_generateDisplay">
      <xsl:variable name="parts">
         <xsl:text>DrugUse observartion</xsl:text>
         <xsl:if test="waarneming_gebruik/start_datum/@value">
            <xsl:value-of select="concat('start datum: ', waarneming_gebruik/start_datum/@value)"/>
         </xsl:if>
         <xsl:if test="waarneming_gebruik/stop_datum/@value">
            <xsl:value-of select="concat('stop datum: ', waarneming_gebruik/stop_datum/@value)"/>
         </xsl:if>
      </xsl:variable>
      <xsl:value-of select="string-join($parts, ', ')"/>
   </xsl:template>
</xsl:stylesheet>