<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.8.0-beta.1/nl-core-LegalSituation.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.4; 2024-10-31T16:16:31.52+01:00 == -->
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
      <xd:desc>Converts ADA juridische_situatie to FHIR Condition resource conforming to profile nl-core-LegalSituation-LegalStatus or nl-core-LegalSituation-Representation.</xd:desc>
   </xd:doc>
   <xsl:variable name="profileNameLegalSituationLegalStatus">nl-core-LegalSituation-LegalStatus</xsl:variable>
   <xsl:variable name="profileNameLegalSituationRepresentation">nl-core-LegalSituation-Representation</xsl:variable>
   <xd:doc>
      <xd:desc>Creates an nl-core-LegalSituation-LegalStatus instance as a Condition FHIR instance from ADA juridische_situatie element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="subject">The subject as ADA element or reference.</xd:param>
   </xd:doc>
   <xsl:template match="juridische_situatie"
                 name="nl-core-LegalSituation-LegalStatus"
                 mode="nl-core-LegalSituation-LegalStatus"
                 as="element(f:Condition)?">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:param name="subject"
                 select="patient"
                 as="element()?"/>
      <xsl:for-each select="$in[juridische_status]">
         <Condition>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameLegalSituationLegalStatus"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profileNameLegalSituationLegalStatus)}"/>
            </meta>
            <xsl:if test="datum_einde">
               <clinicalStatus>
                  <coding>
                     <system value="http://terminology.hl7.org/CodeSystem/condition-clinical"/>
                     <code value="inactive"/>
                     <display value="Inactive"/>
                  </coding>
               </clinicalStatus>
            </xsl:if>
            <category>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="303186005"/>
                  <display value="juridische status van patiënt"/>
               </coding>
            </category>
            <xsl:for-each select="juridische_status">
               <code>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </code>
            </xsl:for-each>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:for-each select="datum_aanvang">
               <onsetDateTime>
                  <xsl:attribute name="value">
                     <xsl:call-template name="format2FHIRDate">
                        <xsl:with-param name="dateTime"
                                        select="xs:string(./@value)"/>
                     </xsl:call-template>
                  </xsl:attribute>
               </onsetDateTime>
            </xsl:for-each>
            <xsl:for-each select="datum_einde">
               <abatementDateTime>
                  <xsl:attribute name="value">
                     <xsl:call-template name="format2FHIRDate">
                        <xsl:with-param name="dateTime"
                                        select="xs:string(./@value)"/>
                     </xsl:call-template>
                  </xsl:attribute>
               </abatementDateTime>
            </xsl:for-each>
         </Condition>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Creates an nl-core-LegalSituation-Representation instance as a Condition FHIR instance from ADA juridische_situatie element.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="subject">Optional ADA instance or ADA reference element for the patient.</xd:param>
   </xd:doc>
   <xsl:template match="juridische_situatie"
                 name="nl-core-LegalSituation-Representation"
                 mode="nl-core-LegalSituation-Representation"
                 as="element(f:Condition)?">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:param name="subject"
                 select="patient"
                 as="element()?"/>
      <xsl:for-each select="$in[vertegenwoordiging]">
         <Condition>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameLegalSituationRepresentation"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profileNameLegalSituationRepresentation)}"/>
            </meta>
            <xsl:if test="datum_einde">
               <clinicalStatus>
                  <coding>
                     <system value="http://terminology.hl7.org/CodeSystem/condition-clinical"/>
                     <code value="inactive"/>
                     <display value="Inactive"/>
                  </coding>
               </clinicalStatus>
            </xsl:if>
            <category>
               <coding>
                  <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                  <code value="151701000146105"/>
                  <display value="type voogd"/>
               </coding>
            </category>
            <xsl:for-each select="vertegenwoordiging">
               <code>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </code>
            </xsl:for-each>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:for-each select="datum_aanvang">
               <onsetDateTime>
                  <xsl:attribute name="value">
                     <xsl:call-template name="format2FHIRDate">
                        <xsl:with-param name="dateTime"
                                        select="xs:string(./@value)"/>
                     </xsl:call-template>
                  </xsl:attribute>
               </onsetDateTime>
            </xsl:for-each>
            <xsl:for-each select="datum_einde">
               <abatementDateTime>
                  <xsl:attribute name="value">
                     <xsl:call-template name="format2FHIRDate">
                        <xsl:with-param name="dateTime"
                                        select="xs:string(./@value)"/>
                     </xsl:call-template>
                  </xsl:attribute>
               </abatementDateTime>
            </xsl:for-each>
         </Condition>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a display that can be shown when referencing this instance.</xd:desc>
      <xd:param name="profile">Parameter to indicate for which target profile a display is to be generated.</xd:param>
   </xd:doc>
   <xsl:template match="juridische_situatie"
                 mode="_generateDisplay">
      <xsl:param name="profile"
                 required="yes"
                 as="xs:string"/>
      <xsl:choose>
         <xsl:when test="$profile = $profileNameLegalSituationLegalStatus">
            <xsl:variable name="parts"
                          as="item()*">
               <xsl:text>Legal situation</xsl:text>
               <xsl:if test="juridische_status/@displayName">
                  <xsl:value-of select="concat('legal status: ',juridische_status/@displayName)"/>
               </xsl:if>
               <xsl:if test="datum_aanvang[@value]">
                  <xsl:value-of select="concat('from ', datum_aanvang/@value)"/>
               </xsl:if>
               <xsl:if test="datum_einde[@value]">
                  <xsl:value-of select="concat('until ', datum_einde/@value)"/>
               </xsl:if>
            </xsl:variable>
            <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
         </xsl:when>
         <xsl:when test="$profile = $profileNameLegalSituationRepresentation">
            <xsl:variable name="parts"
                          as="item()*">
               <xsl:text>Legal situation</xsl:text>
               <xsl:if test="vertegenwoordiging/@displayName">
                  <xsl:value-of select="concat('representation: ',vertegenwoordiging/@displayName)"/>
               </xsl:if>
               <xsl:if test="datum_aanvang[@value]">
                  <xsl:value-of select="concat('from ', datum_aanvang/@value)"/>
               </xsl:if>
               <xsl:if test="datum_einde[@value]">
                  <xsl:value-of select="concat('until ', datum_einde/@value)"/>
               </xsl:if>
            </xsl:variable>
            <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>