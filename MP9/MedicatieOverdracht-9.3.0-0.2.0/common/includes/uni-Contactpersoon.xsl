<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/hl7_2_ada/zibs2020/payload/uni-Contactpersoon.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.2.0; 2024-03-14T08:34:46.14+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc>
      <xd:desc>Create ada contact_point using an hl7 element which must be in context</xd:desc>
      <xd:param name="adaId">Optional parameter to specify the ada id for this ada element. Defaults to a generate-id of context element</xd:param>
   </xd:doc>
   <xsl:template name="HandleContactPerson"
                 match="hl7:responsibleParty"
                 mode="HandleContactPerson">
      <xsl:param name="adaId"
                 as="xs:string?"
                 select="generate-id(.)"/>
      <contactpersoon>
         <xsl:attribute name="id"
                        select="$adaId"/>
         <xsl:call-template name="handleENtoNameInformation">
            <xsl:with-param name="in"
                            select="hl7:agentPerson/hl7:name"/>
            <xsl:with-param name="language"
                            select="$language"/>
         </xsl:call-template>
         <xsl:call-template name="handleTELtoContactInformation">
            <xsl:with-param name="in"
                            select="hl7:telecom"/>
            <xsl:with-param name="language"
                            select="$language"/>
         </xsl:call-template>
         <xsl:call-template name="handleADtoAddressInformation">
            <xsl:with-param name="in"
                            select="hl7:addr"/>
            <xsl:with-param name="language"
                            select="$language"/>
         </xsl:call-template>
      </contactpersoon>
   </xsl:template>
</xsl:stylesheet>