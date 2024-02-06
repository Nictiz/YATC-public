<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:import href="../../common/includes/all-zibs.xsl"/>
   <xsl:import href="../../common/includes/mp-handle-bouwstenen.xsl"/>
   <xd:doc>
      <xd:desc>Dit is een conversie voor MP 9 3.0 van HL7v3 naar ADA beschikbaarstellen medicatiegegevens</xd:desc>
   </xd:doc>
   <xsl:output method="xml"
               indent="yes"
               exclude-result-prefixes="#all"
               omit-xml-declaration="yes"/>
   <!-- parameter to control whether or not the result should contain a reference to the ada xsd -->
   <xsl:param name="outputSchemaRef"
              as="xs:boolean"
              select="true()"/>
   <xsl:param name="schemaFileString"
              as="xs:string?">../../hl7_2_ada/mp/9.3.0/beschikbaarstellen_medicatiegegevens/ada_schemas/beschikbaarstellen_medicatiegegevens.xsd</xsl:param>
   <!-- whether or not this hl7_2_ada conversion should deduplicate bouwstenen, such as products, health providers, health professionals, contact persons -->
   <!--    <xsl:param name="deduplicateAdaBouwstenen" as="xs:boolean?" select="false()"/>-->
   <xsl:param name="deduplicateAdaBouwstenen"
              as="xs:boolean?"
              select="true()"/>
   <xsl:variable name="medicatiegegevens-lijst-93"
                 select="//hl7:organizer[hl7:code[@code = '102'][@codeSystem = '2.16.840.1.113883.2.4.3.11.60.20.77.4']] | //hl7:organizer[hl7:code[@code = '419891008'][@codeSystem = '2.16.840.1.113883.6.96']] | hl7:ClinicalDocument[hl7:code[@code = '52981000146104'][@codeSystem = '2.16.840.1.113883.6.96']]"/>
   <xsl:variable name="filename"
                 select="tokenize(document-uri(/), '/')[last()]"/>
   <xsl:variable name="extension"
                 select="tokenize($filename, '\.')[last()]"/>
   <xsl:variable name="idBasedOnFilename"
                 select="replace($filename, concat('.', $extension, '$'), '')"/>
   <xsl:param name="theId">
      <xsl:choose>
         <xsl:when test="string-length($idBasedOnFilename) gt 0">
            <xsl:value-of select="$idBasedOnFilename"/>
         </xsl:when>
         <xsl:when test="string-length($medicatiegegevens-lijst-93/../../../hl7:id/@extension) gt 0">
            <!-- let's use the extension of the message id -->
            <xsl:value-of select="$medicatiegegevens-lijst-93/../../../hl7:id/@extension"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="generate-id(.)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:param>
   <xd:doc>
      <xd:desc> if this xslt is used stand alone the template below could be used. </xd:desc>
   </xd:doc>
   <xsl:template match="/">
      <xsl:call-template name="Medicatiegegevens-93-ADA">
         <xsl:with-param name="medicatiegegevens-lijst"
                         select="$medicatiegegevens-lijst-93"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Handles HL7 9 3.0 medication information, transforms it to ada.</xd:desc>
      <xd:param name="medicatiegegevens-lijst">HL7 9 3.0 organizer/CDA with medication information.</xd:param>
   </xd:doc>
   <xsl:template name="Medicatiegegevens-93-ADA">
      <xsl:param name="medicatiegegevens-lijst"
                 select="$medicatiegegevens-lijst-93"/>
      <xsl:call-template name="doGeneratedComment">
         <xsl:with-param name="in"
                         select="$medicatiegegevens-lijst/ancestor::*[hl7:ControlActProcess]"/>
      </xsl:call-template>
      <xsl:variable name="adaXml">
         <adaxml>
            <xsl:if test="$outputSchemaRef">
               <xsl:attribute name="xsi:noNamespaceSchemaLocation">../ada_schemas/ada_beschikbaarstellen_medicatiegegevens.xsd</xsl:attribute>
            </xsl:if>
            <meta status="new"
                  created-by="generated"
                  last-update-by="generated">
               <xsl:attribute name="creation-date"
                              select="current-dateTime()"/>
               <xsl:attribute name="last-update-date"
                              select="current-dateTime()"/>
            </meta>
            <data>
               <xsl:for-each select="$medicatiegegevens-lijst">
                  <xsl:call-template name="doGeneratedComment"/>
                  <xsl:variable name="patient"
                                select="hl7:recordTarget/hl7:patientRole"/>
                  <beschikbaarstellen_medicatiegegevens app="mp-mp93"
                                                        shortName="beschikbaarstellen_medicatiegegevens"
                                                        formName="medicatiegegevens"
                                                        transactionRef="2.16.840.1.113883.2.4.3.11.60.20.77.4.374"
                                                        transactionEffectiveDate="2022-06-30T00:00:00"
                                                        prefix="mp-"
                                                        language="nl-NL"
                                                        title="{$theId}"
                                                        id="{$theId}">
                     <xsl:for-each select="$patient">
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1_20210701">
                           <xsl:with-param name="in"
                                           select="."/>
                           <xsl:with-param name="language"
                                           select="$language"/>
                        </xsl:call-template>
                     </xsl:for-each>
                     <xsl:variable name="component"
                                   select=".//*[hl7:templateId/@root = ($templateId-medicatieafspraak, $templateId-wisselend_doseerschema, $templateId-verstrekkingsverzoek, $templateId-toedieningsafspraak, $templateId-medicatieverstrekking, $templateId-medicatiegebruik, $templateId-medicatietoediening)]"/>
                     <xsl:for-each-group select="$component"
                                         group-by="hl7:entryRelationship/hl7:procedure[hl7:templateId/@root = $templateId-medicamenteuze-behandeling]/hl7:id/concat(@root, @extension)">
                        <!-- medicamenteuze_behandeling -->
                        <medicamenteuze_behandeling>
                           <xsl:for-each select="./hl7:entryRelationship/hl7:procedure[hl7:templateId/@root = $templateId-medicamenteuze-behandeling]/hl7:id">
                              <xsl:call-template name="handleII">
                                 <xsl:with-param name="elemName">identificatie</xsl:with-param>
                                 <xsl:with-param name="in"
                                                 select="."/>
                              </xsl:call-template>
                           </xsl:for-each>
                           <!-- medicatieafspraak -->
                           <xsl:for-each select="current-group()[hl7:templateId/@root = $templateId-medicatieafspraak]">
                              <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9430_20221122132432">
                                 <xsl:with-param name="ma_hl7"
                                                 select="."/>
                              </xsl:call-template>
                           </xsl:for-each>
                           <!-- wisselend_doseerschema -->
                           <xsl:for-each select="current-group()[hl7:templateId/@root = $templateId-wisselend_doseerschema]">
                              <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9412_20221118130922">
                                 <xsl:with-param name="in_hl7"
                                                 select="."/>
                              </xsl:call-template>
                           </xsl:for-each>
                           <!-- verstrekkingsverzoek -->
                           <xsl:for-each select="current-group()[hl7:templateId/@root = $templateId-verstrekkingsverzoek]">
                              <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9449_20230106093041">
                                 <xsl:with-param name="in"
                                                 select="."/>
                              </xsl:call-template>
                           </xsl:for-each>
                           <!-- toedieningsafspraak -->
                           <xsl:for-each select="current-group()[hl7:templateId/@root = $templateId-toedieningsafspraak]">
                              <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9416_20221121074758">
                                 <xsl:with-param name="in"
                                                 select="."/>
                              </xsl:call-template>
                           </xsl:for-each>
                           <!-- verstrekking -->
                           <xsl:for-each select="current-group()[hl7:templateId/@root = $templateId-medicatieverstrekking]">
                              <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9364_20210602161935">
                                 <xsl:with-param name="in"
                                                 select="."/>
                              </xsl:call-template>
                           </xsl:for-each>
                           <!-- medicatiegebruik -->
                           <xsl:for-each select="current-group()[hl7:templateId/@root = $templateId-medicatiegebruik]">
                              <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9444_20221124154710">
                                 <xsl:with-param name="in"
                                                 select="."/>
                              </xsl:call-template>
                           </xsl:for-each>
                           <!-- medicatietoediening -->
                           <xsl:for-each select="current-group()[hl7:templateId/@root = $templateId-medicatietoediening]">
                              <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9406_20221101091730">
                                 <xsl:with-param name="in"
                                                 select="."/>
                              </xsl:call-template>
                           </xsl:for-each>
                        </medicamenteuze_behandeling>
                     </xsl:for-each-group>
                  </beschikbaarstellen_medicatiegegevens>
               </xsl:for-each>
            </data>
         </adaxml>
      </xsl:variable>
      <xsl:variable name="adaXmlWithBouwstenen">
         <xsl:choose>
            <xsl:when test="$deduplicateAdaBouwstenen = true()">
               <xsl:variable name="adaXmlDeduplicated">
                  <xsl:apply-templates select="$adaXml"
                                       mode="deduplicateBouwstenenStep1"/>
               </xsl:variable>
               <xsl:apply-templates select="$adaXmlDeduplicated"
                                    mode="deduplicateBouwstenenStep2"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- don't deduplicate the bouwstenen -->
               <xsl:apply-templates select="$adaXml"
                                    mode="handleBouwstenen"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:copy-of select="$adaXmlWithBouwstenen"/>
   </xsl:template>
</xsl:stylesheet>