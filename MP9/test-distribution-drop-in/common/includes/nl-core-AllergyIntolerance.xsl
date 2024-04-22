<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.5-beta1/nl-core-AllergyIntolerance.xsl"?>
<?yatc-distribution-info name="VZVZ-test-distribution-drop-in" timestamp="2024-01-25T12:13:11.57+01:00" version="0.2"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/HL7-mappings/ada_2_fhir-r4/zibs2020/payload/0.5-beta1/nl-core-AllergyIntolerance.xsl == -->
<!-- == Distribution: VZVZ-test-distribution-drop-in; 0.2; 2024-01-25T12:13:11.57+01:00 == -->
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
      <xd:desc>Converts ADA [...] to FHIR [...] conforming to profile [...]</xd:desc>
   </xd:doc>
   <xd:doc>
      <xd:desc>Create a nl-core-AllergyIntolerance instance as a AllergyIntolerance FHIR instance from ADA allergie_intolerantie.</xd:desc>
      <xd:param name="in">ADA element as input. Defaults to self.</xd:param>
      <xd:param name="subject">The AllergyIntolerance.patient as ADA element or reference.</xd:param>
   </xd:doc>
   <xsl:template name="nl-core-AllergyIntolerance"
                 mode="nl-core-AllergyIntolerance"
                 match="allergie_intolerantie"
                 as="element(f:AllergyIntolerance)">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?"/>
      <xsl:for-each select="$in">
         <AllergyIntolerance>
            <xsl:call-template name="insertLogicalId"/>
            <meta>
               <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-AllergyIntolerance"/>
            </meta>
            <xsl:for-each select="allergie_status">
               <xsl:choose>
                  <xsl:when test="(./@code = 'active')                              or (./@code = 'obsolete')                              or (./@code = 'completed')">
                     <clinicalStatus>
                        <xsl:call-template name="code-to-CodeableConcept">
                           <xsl:with-param name="in"
                                           select="."/>
                           <xsl:with-param name="codeMap"
                                           as="element()*">
                              <map inCode="active"
                                   inCodeSystem="2.16.840.1.113883.5.14"
                                   code="active"
                                   codeSystem="http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical"
                                   displayName="Active"/>
                              <map inCode="obsolete"
                                   inCodeSystem="2.16.840.1.113883.5.14"
                                   code="inactive"
                                   codeSystem="http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical"
                                   displayName="Inactive"/>
                              <map inCode="completed"
                                   inCodeSystem="2.16.840.1.113883.5.14"
                                   code="resolved"
                                   codeSystem="http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical"
                                   displayName="Resolved"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </clinicalStatus>
                  </xsl:when>
                  <xsl:when test="./@code = 'nullified'">
                     <verificationStatus>
                        <xsl:call-template name="code-to-CodeableConcept">
                           <xsl:with-param name="in"
                                           select="."/>
                           <xsl:with-param name="codeMap"
                                           as="element()*">
                              <map inCode="nullified"
                                   inCodeSystem="2.16.840.1.113883.5.14"
                                   code="entered-in-error"
                                   codeSystem="http://terminology.hl7.org/CodeSystem/allergyintolerance-verification"
                                   displayName="Entered in Error"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </verificationStatus>
                  </xsl:when>
               </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="allergie_categorie">
               <category>
                  <xsl:attribute name="value">
                     <xsl:call-template name="code-to-code">
                        <xsl:with-param name="in"
                                        select="."/>
                        <xsl:with-param name="codeMap"
                                        as="element()*">
                           <map inCode="418471000"
                                inCodeSystem="2.16.840.1.113883.6.96"
                                code="food"/>
                           <map inCode="419511003"
                                inCodeSystem="2.16.840.1.113883.6.96"
                                code="medication"/>
                           <map inCode="426232007"
                                inCodeSystem="2.16.840.1.113883.6.96"
                                code="environment"/>
                           <map inCode="419199007"
                                inCodeSystem="2.16.840.1.113883.6.96"
                                code="biologic"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:attribute>
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-CodeSpecification">
                     <valueCodeableConcept>
                        <xsl:call-template name="code-to-CodeableConcept"/>
                     </valueCodeableConcept>
                  </extension>
               </category>
            </xsl:for-each>
            <xsl:for-each select="mate_van_kritiek_zijn">
               <criticality>
                  <xsl:attribute name="value">
                     <xsl:call-template name="code-to-code">
                        <xsl:with-param name="in"
                                        select="."/>
                        <xsl:with-param name="codeMap"
                                        as="element()*">
                           <map inCode="255604002"
                                inCodeSystem="2.16.840.1.113883.6.96"
                                code="low"/>
                           <map inCode="6736007"
                                inCodeSystem="2.16.840.1.113883.6.96"
                                code="high"/>
                           <map inCode="24484000"
                                inCodeSystem="2.16.840.1.113883.6.96"
                                code="high"/>
                           <map inCode="399166001"
                                inCodeSystem="2.16.840.1.113883.6.96"
                                code="high"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:attribute>
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-CodeSpecification">
                     <valueCodeableConcept>
                        <xsl:call-template name="code-to-CodeableConcept"/>
                     </valueCodeableConcept>
                  </extension>
               </criticality>
            </xsl:for-each>
            <xsl:for-each select="veroorzakende_stof">
               <code>
                  <xsl:call-template name="code-to-CodeableConcept"/>
               </code>
            </xsl:for-each>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn">patient</xsl:with-param>
            </xsl:call-template>
            <xsl:for-each select="begin_datum_tijd">
               <onsetDateTime>
                  <xsl:attribute name="value">
                     <xsl:call-template name="format2FHIRDate">
                        <xsl:with-param name="dateTime"
                                        select="./@value"/>
                     </xsl:call-template>
                  </xsl:attribute>
               </onsetDateTime>
            </xsl:for-each>
            <xsl:for-each select="laatste_reactie_datum_tijd">
               <lastOccurrence>
                  <xsl:attribute name="value">
                     <xsl:call-template name="format2FHIRDate">
                        <xsl:with-param name="dateTime"
                                        select="./@value"/>
                     </xsl:call-template>
                  </xsl:attribute>
               </lastOccurrence>
            </xsl:for-each>
            <xsl:for-each select="toelichting">
               <note>
                  <text value="{normalize-space(@value)}"/>
               </note>
            </xsl:for-each>
            <xsl:for-each select="reactie">
               <reaction>
                  <xsl:for-each select="specifieke_stof">
                     <substance>
                        <xsl:call-template name="code-to-CodeableConcept"/>
                     </substance>
                  </xsl:for-each>
                  <xsl:for-each select="symptoom">
                     <manifestation>
                        <xsl:call-template name="code-to-CodeableConcept"/>
                     </manifestation>
                  </xsl:for-each>
                  <xsl:for-each select="reactie_beschrijving">
                     <description value="{normalize-space(@value)}"/>
                  </xsl:for-each>
                  <xsl:for-each select="reactie_tijdstip">
                     <onset>
                        <xsl:attribute name="value">
                           <xsl:call-template name="format2FHIRDate">
                              <xsl:with-param name="dateTime"
                                              select="./@value"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </onset>
                  </xsl:for-each>
                  <xsl:for-each select="ernst">
                     <severity>
                        <xsl:attribute name="value">
                           <xsl:call-template name="code-to-code">
                              <xsl:with-param name="in"
                                              select="."/>
                              <xsl:with-param name="codeMap"
                                              as="element()*">
                                 <map inCode="255604002"
                                      inCodeSystem="2.16.840.1.113883.6.96"
                                      code="mild"/>
                                 <map inCode="6736007"
                                      inCodeSystem="2.16.840.1.113883.6.96"
                                      code="moderate"/>
                                 <map inCode="24484000"
                                      inCodeSystem="2.16.840.1.113883.6.96"
                                      code="severe"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:attribute>
                     </severity>
                  </xsl:for-each>
                  <xsl:for-each select="wijze_van_blootstelling">
                     <exposureRoute>
                        <xsl:call-template name="code-to-CodeableConcept"/>
                     </exposureRoute>
                  </xsl:for-each>
               </reaction>
            </xsl:for-each>
         </AllergyIntolerance>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a unique id to identify this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="allergie_intolerantie"
                 mode="_generateId">
      <xsl:variable name="parts">
         <xsl:text>AllergyIntollerance</xsl:text>
         <xsl:value-of select="veroorzakende_stof/@displayName"/>
         <xsl:value-of select="allergie_categorie/@displayName"/>
         <xsl:value-of select="allergie_status/@displayName"/>
         <xsl:value-of select="mate_van_kritiek_zijn/@displayName"/>
         <xsl:if test="begin_datum_tijd/@value">
            <xsl:value-of select="concat('start datum', begin_datum_tijd/@value)"/>
         </xsl:if>
         <xsl:if test="eind_datum_tijd/@value">
            <xsl:value-of select="concat('eind datum', eind_datum_tijd/@value)"/>
         </xsl:if>
         <xsl:value-of select="toelichting/@value"/>
      </xsl:variable>
      <xsl:value-of select="substring(replace(string-join($parts, '-'), '[^A-Za-z0-9-.]', ''), 1, 64)"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to generate a display that can be shown when referencing this instance.</xd:desc>
   </xd:doc>
   <xsl:template match="allergie_intolerantie"
                 mode="_generateDisplay">
      <xsl:variable name="parts">
         <xsl:text>AllergyIntolerance:</xsl:text>
         <xsl:value-of select="veroorzakende_stof/@displayName"/>
         <xsl:value-of select="allergie_categorie/@displayName"/>
         <xsl:if test="begin_datum_tijd/@value">
            <xsl:value-of select="concat('start datum: ', begin_datum_tijd/@value)"/>
         </xsl:if>
      </xsl:variable>
      <xsl:value-of select="string-join($parts, ', ')"/>
   </xsl:template>
</xsl:stylesheet>