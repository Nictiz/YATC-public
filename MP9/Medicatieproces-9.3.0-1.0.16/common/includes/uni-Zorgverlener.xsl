<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/hl7-2-ada/env/zibs/2020/payload/uni-Zorgverlener.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.16; 2026-04-29T11:02:12.55+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.32_20210701">
      <!-- auteur - zib2020  -->
      <xsl:param name="author-hl7"
                 select=".">
         <!-- hl7 element author -->
      </xsl:param>
      <xsl:param name="generateId"
                 as="xs:boolean?"
                 select="false()">
         <!-- whether or not to output an ada id on the root element of zorgverlener and zorgaanbieder, optional, default to false() -->
      </xsl:param>
      <xsl:param name="outputNaamgebruik"
                 as="xs:boolean?"
                 select="true()">
         <!-- whether or not to output naamgebruik, default to true() -->
      </xsl:param>
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.37_20210701">
         <xsl:with-param name="in-hl7"
                         select="$author-hl7/hl7:assignedAuthor"/>
         <xsl:with-param name="generateId"
                         select="$generateId"/>
         <xsl:with-param name="outputNaamgebruik"
                         select="$outputNaamgebruik"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.37_20210701">
      <!--  zorgverlener assigned contents - zib2020  -->
      <xsl:param name="in-hl7"
                 select=".">
         <!-- hl7 element assigned Contents, typically an assignedAuthor or assignedEntity -->
      </xsl:param>
      <xsl:param name="generateId"
                 as="xs:boolean?"
                 select="false()">
         <!-- whether or not to output an ada id on the root element of zorgverlener and zorgaanbieder, optional, default to false() -->
      </xsl:param>
      <xsl:param name="outputNaamgebruik"
                 as="xs:boolean?"
                 select="true()">
         <!-- whether or not to output naamgebruik, default to true() -->
      </xsl:param>
      <xsl:for-each select="$in-hl7">
         <zorgverlener>
            <xsl:if test="$generateId">
               <xsl:attribute name="id">
                  <xsl:value-of select="generate-id()"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="handleII">
               <xsl:with-param name="in"
                               select="hl7:id"/>
               <xsl:with-param name="elemName">zorgverlener_identificatienummer</xsl:with-param>
            </xsl:call-template>
            <!-- naamgegevens -->
            <xsl:call-template name="handleENtoNameInformation">
               <xsl:with-param name="in"
                               select="(hl7:assignedPerson | hl7:playingEntity)/hl7:name"/>
               <xsl:with-param name="language">nl-NL</xsl:with-param>
               <xsl:with-param name="unstructurednameElement">ongestructureerde_naam</xsl:with-param>
               <xsl:with-param name="outputNaamgebruik"
                               select="$outputNaamgebruik"/>
            </xsl:call-template>
            <!-- specialisme -->
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="hl7:code"/>
               <xsl:with-param name="elemName">specialisme</xsl:with-param>
            </xsl:call-template>
            <!-- geslacht, new hl7nl element from zib-2020 -->
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="(hl7:assignedPerson | hl7:playingEntity)/hl7nl:administrativeGenderCode"/>
               <xsl:with-param name="elemName">geslacht</xsl:with-param>
            </xsl:call-template>
            <!-- adresgegevens -->
            <xsl:call-template name="handleADtoAddressInformation">
               <xsl:with-param name="in"
                               select="hl7:addr"/>
            </xsl:call-template>
            <!-- contactgegevens -->
            <xsl:call-template name="handleTELtoContactInformation">
               <xsl:with-param name="in"
                               select="hl7:telecom"/>
            </xsl:call-template>
            <!-- zorgaanbieder -->
            <xsl:for-each select="hl7:representedOrganization | hl7:scopingEntity">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.33_20210701">
                  <xsl:with-param name="hl7-current-organization"
                                  select="."/>
                  <xsl:with-param name="generateId"
                                  select="$generateId"/>
               </xsl:call-template>
            </xsl:for-each>
            <!-- zorgverlener_rol -->
            <!-- no mapping in HL7 on this valueset, it is typically implicit / derivable from context, 
                    for example in the location of the zorgverlener in the surrounding zib (author/performer) -->
         </zorgverlener>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>