<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_hl7/zib2020bbr/payload/hl7-Contactpersoon-20210701.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.1; 2024-03-12T15:03:10.81+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="language"
              as="xs:string?">nl-NL</xsl:param>
   <xd:doc>
      <xd:desc>Mapping of zib nl.zorg.Contactpersoon 3.4 concept in ADA to HL7 CDA template 2.16.840.1.113883.2.4.3.11.60.121.10.30</xd:desc>
      <xd:param name="in">ADA Node to consider in the creation of the hl7 element</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.30_20210701000000"
                 match="contactpersoon"
                 mode="handleContactPersRelEnt">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:for-each select="$in">
         <relatedEntity>
            <xsl:attribute name="classCode">AGNT</xsl:attribute>
            <!-- shared part 1, role, address, telecom -->
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.31_20210701000000">
               <xsl:with-param name="idMandatory"
                               select="false()"/>
               <xsl:with-param name="codeMandatory"
                               select="true()"/>
            </xsl:call-template>
            <xsl:if test="(naamgegevens | relatie)[.//(@value | @code | @nullFlavor)]">
               <relatedPerson>
                  <!-- shared part 2, name, relation -->
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.36_20210701000000"/>
               </relatedPerson>
            </xsl:if>
         </relatedEntity>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Mapping of some shared parts of zib nl.zorg.Contactpersoon 3.4 concept in ADA to HL7 CDA template 2.16.840.1.113883.2.4.3.11.60.121.10.31</xd:desc>
      <xd:param name="in">ADA Node to consider in the creation of the hl7 element, typically contactpersoon. Defaults to context</xd:param>
      <xd:param name="idMandatory">Whether or not id is mandatory in xsd, so output a nullFlavor if necessary</xd:param>
      <xd:param name="codeMandatory">Whether or not code is mandatory in xsd, so output a nullFlavor if necessary</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.31_20210701000000"
                 match="contactpersoon"
                 mode="handleContactPersSharedPart1">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:param name="idMandatory"
                 as="xs:boolean"
                 select="false()"/>
      <xsl:param name="codeMandatory"
                 as="xs:boolean"
                 select="false()"/>
      <xsl:for-each select="$in">
         <!-- no use case for id here yet, but may be added later on -->
         <xsl:if test="$idMandatory">
            <id nullFlavor="NI"/>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="rol[@code]">
               <xsl:for-each select="rol[@code]">
                  <xsl:call-template name="makeCode"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:if test="$codeMandatory">
                  <code nullFlavor="NI"/>
               </xsl:if>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:for-each select=".//adresgegevens[not(adresgegevens)][.//(@value | @code | @nullFlavor)]">
            <addr>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.101_20180611000000"/>
            </addr>
         </xsl:for-each>
         <!--Telecom gegevens-->
         <xsl:for-each select=".//contactgegevens[not(contactgegevens)][.//(@value | @code | @nullFlavor)]">
            <xsl:call-template name="_CdaTelecom"/>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Mapping of zib nl.zorg.Contactpersoon 3.4 concept in ADA to HL7 CDA template 2.16.840.1.113883.2.4.3.11.60.121.10.35</xd:desc>
      <xd:param name="in">ADA Node to consider in the creation of the hl7 element</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.35_20210701000000"
                 match="contactpersoon"
                 mode="handleContactPersAuth">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:for-each select="$in">
         <!-- no use case for author/time here yet, but should probably be added later on -->
         <time nullFlavor="NI"/>
         <assignedAuthor>
            <!-- shared part 1, role, address, telecom -->
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.31_20210701000000">
               <xsl:with-param name="idMandatory"
                               select="true()"/>
               <xsl:with-param name="codeMandatory"
                               select="false()"/>
            </xsl:call-template>
            <xsl:if test="(naamgegevens | relatie)[.//(@value | @code | @nullFlavor)]">
               <assignedPerson>
                  <!-- shared part 2, name, relation -->
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.36_20210701000000"/>
               </assignedPerson>
            </xsl:if>
         </assignedAuthor>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Mapping of some shared parts of zib nl.zorg.Contactpersoon 3.4 concept in ADA to HL7 CDA template 2.16.840.1.113883.2.4.3.11.60.121.10.36</xd:desc>
      <xd:param name="in">ADA Node to consider in the creation of the hl7 element, typically contactpersoon. Defaults to context</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.36_20210701000000"
                 match="contactpersoon"
                 mode="handleContactPersSharedPart2">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:for-each select="$in">
         <xsl:if test="naamgegevens[.//(@value | @code | @nullFlavor)]">
            <name>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.100_20170602000000">
                  <xsl:with-param name="naamgegevens"
                                  select="naamgegevens"/>
               </xsl:call-template>
            </name>
         </xsl:if>
         <xsl:for-each select="relatie[.//(@value | @code | @nullFlavor)]">
            <sdtc:asPatientRelationship classCode="PRS">
               <sdtc:code>
                  <xsl:call-template name="makeCodeAttribs"/>
               </sdtc:code>
            </sdtc:asPatientRelationship>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Mapping of zib nl.zorg.Contactpersoon 3.4 concept in ADA to HL7 CDA template 2.16.840.1.113883.2.4.3.11.60.121.10.44</xd:desc>
      <xd:param name="in">ADA Node to consider in the creation of the hl7 element</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.44_20210701000000"
                 match="contactpersoon"
                 mode="handleContactPersAssEntity">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:for-each select="$in">
         <!-- no use case for author/time here yet, but should probably be added later on -->
         <time nullFlavor="NI"/>
         <assignedEntity>
            <!-- shared part 1, role, address, telecom -->
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.31_20210701000000">
               <xsl:with-param name="idMandatory"
                               select="true()"/>
               <xsl:with-param name="codeMandatory"
                               select="false()"/>
            </xsl:call-template>
            <xsl:if test="(naamgegevens | relatie)[.//(@value | @code | @nullFlavor)]">
               <assignedPerson>
                  <!-- shared part 2, name, relation -->
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.36_20210701000000"/>
               </assignedPerson>
            </xsl:if>
         </assignedEntity>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>