<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/hl7_2_ada/mp/9.3.0/sturen_voorstel_verstrekkingsverzoek/payload/sturen_voorstel_verstrekkingsverzoek_hl7_2_ada.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-01-29T18:25:49.35+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:import href="../../../../../common/includes/all-zibs.xsl"/>
   <xsl:import href="../../../../../common/includes/mp-handle-bouwstenen.xsl"/>
   <xsl:import href="../../../../../common/includes/uni-Voorstelgegevens.xsl"/>
   <xsl:output method="xml"
               indent="yes"
               exclude-result-prefixes="#all"
               omit-xml-declaration="yes"/>
   <!-- Dit is een conversie van MP 9.1.0 naar ADA 9.0 voorschrift bericht -->
   <!-- parameter to control whether or not the result should contain a reference to the ada xsd -->
   <xsl:param name="outputSchemaRef"
              as="xs:boolean"
              select="true()"/>
   <xsl:param name="schemaFileString"
              as="xs:string?">../../hl7_2_ada/mp/9.3.0/sturen_voorstel_verstrekkingsverzoek/ada_schemas/sturen_voorstel_verstrekkingsverzoek.xsd</xsl:param>
   <!-- whether or not this hl7_2_ada conversion should deduplicate bouwstenen, such as products, health providers, health professionals, contact persons -->
   <xsl:param name="deduplicateAdaBouwstenen"
              as="xs:boolean?"
              select="false()"/>
   <!--        <xsl:param name="deduplicateAdaBouwstenen" as="xs:boolean?" select="true()"/>-->
   <xsl:variable name="medicatiegegevensLijst"
                 select="//hl7:organizer[hl7:code/@codeSystem = '2.16.840.1.113883.2.4.3.11.60.20.77.4'] | //hl7:ClinicalDocument"/>
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
         <xsl:when test="string-length($medicatiegegevensLijst/../../../hl7:id/@extension) gt 0">
            <!-- let's use the extension of the message id -->
            <xsl:value-of select="$medicatiegegevensLijst/../../../hl7:id/@extension"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="generate-id(.)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:param>
   <xd:doc>
      <xd:desc>Template to start conversion for stand alone use. </xd:desc>
   </xd:doc>
   <xsl:template match="/">
      <xsl:variable name="patient-recordTarget"
                    select="//hl7:recordTarget/hl7:patientRole"/>
      <xsl:call-template name="Voorschrift-90-ADA">
         <xsl:with-param name="patient"
                         select="$patient-recordTarget"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Create adaxml for transaction sturen_voorstel_verstrekkingsverzoek</xd:desc>
      <xd:param name="patient">HL7 patient</xd:param>
   </xd:doc>
   <xsl:template name="Voorschrift-90-ADA">
      <xsl:param name="patient"
                 select="//hl7:recordTarget/hl7:patientRole"/>
      <xsl:call-template name="doGeneratedComment">
         <xsl:with-param name="in"
                         select="//*[hl7:ControlActProcess]"/>
      </xsl:call-template>
      <xsl:variable name="adaXml">
         <adaxml>
            <xsl:if test="$outputSchemaRef">
               <xsl:attribute name="xsi:noNamespaceSchemaLocation">../ada_schemas/ada_sturen_voorstel_verstrekkingsverzoek.xsd</xsl:attribute>
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
               <sturen_voorstel_verstrekkingsverzoek app="mp-mp93"
                                                     shortName="sturen_voorstel_verstrekkingsverzoek"
                                                     formName="sturen_voorstel_verstrekkingsverzoek"
                                                     transactionRef="2.16.840.1.113883.2.4.3.11.60.20.77.4.328"
                                                     transactionEffectiveDate="2022-02-07T00:00:00"
                                                     versionDate=""
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
                  <!-- medicatiebouwstenen -->
                  <xsl:variable name="component"
                                select="//*[@moodCode = 'PRP'][hl7:code/@code = $vvCode]"/>
                  <xsl:for-each-group select="$component"
                                      group-by="concat(hl7:entryRelationship/hl7:procedure[hl7:templateId = $templateId-medicamenteuze-behandeling]/hl7:id/@root, hl7:entryRelationship/hl7:procedure[hl7:templateId/@root = $templateId-medicamenteuze-behandeling]/hl7:id/@extension)">
                     <!-- medicamenteuze_behandeling -->
                     <xsl:variable name="mbhAdaId"
                                   select="generate-id(current-group()[1]/hl7:entryRelationship/hl7:procedure[hl7:templateId/@root = $templateId-medicamenteuze-behandeling])"/>
                     <medicamenteuze_behandeling id="{$mbhAdaId}">
                        <xsl:for-each select="hl7:entryRelationship/hl7:procedure[hl7:templateId/@root = $templateId-medicamenteuze-behandeling]/hl7:id">
                           <xsl:variable name="elemName">identificatie</xsl:variable>
                           <xsl:element name="{$elemName}">
                              <xsl:for-each select="@extension">
                                 <xsl:attribute name="value"
                                                select="."/>
                              </xsl:for-each>
                              <xsl:for-each select="@root">
                                 <xsl:attribute name="root"
                                                select="."/>
                              </xsl:for-each>
                           </xsl:element>
                        </xsl:for-each>
                        <!-- verstrekkingsverzoek -->
                        <xsl:for-each select="current-group()">
                           <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9449_20230106093041">
                              <xsl:with-param name="in"
                                              select="."/>
                           </xsl:call-template>
                        </xsl:for-each>
                     </medicamenteuze_behandeling>
                     <voorstel_gegevens>
                        <xsl:for-each select="current-group()">
                           <xsl:call-template name="uni-Voorstel">
                              <xsl:with-param name="inContainer"
                                              select="$medicatiegegevensLijst"/>
                              <xsl:with-param name="inComponent"
                                              select="."/>
                              <xsl:with-param name="mbhAdaId"
                                              select="$mbhAdaId"/>
                           </xsl:call-template>
                        </xsl:for-each>
                     </voorstel_gegevens>
                  </xsl:for-each-group>
                  <!-- lengte / gewicht van vóór 9.1.0 die in MA zitten ook converteren -->
                  <xsl:if test="//*[hl7:templateId/@root = ($templateId-lichaamslengte, $templateId-lichaamsgewicht)]">
                     <bouwstenen>
                        <!-- lichaamslengte  -->
                        <xsl:for-each select="//*[hl7:templateId/@root = $templateId-lichaamslengte]">
                           <xsl:call-template name="uni-Lichaamslengte"/>
                        </xsl:for-each>
                        <!-- lichaamsgewicht  -->
                        <xsl:for-each select="//*[hl7:templateId/@root = $templateId-lichaamsgewicht]">
                           <xsl:call-template name="uni-Lichaamsgewicht"/>
                        </xsl:for-each>
                     </bouwstenen>
                  </xsl:if>
               </sturen_voorstel_verstrekkingsverzoek>
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