<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/hl7-2-ada/env/zibs/2020/payload/uni-Medicatieafspraak.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.16; 2026-04-29T11:02:12.55+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:variable name="maCode"
                 as="xs:string*"
                 select="'33633005', '16076005'"/>
   <xsl:variable name="templateId-medicatieafspraak"
                 as="xs:string*"
                 select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9431', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9430', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9429', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9325', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9324', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9323', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9275', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9233', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9235', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9241', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9216'"/>
   <xsl:variable name="template-id-rel-ma"
                 select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9086'"/>
   <xsl:variable name="templateId-redenVanVoorschrijven"
                 as="xs:string*"
                 select="'2.16.840.1.113883.2.4.3.11.60.121.10.24', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9316', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9160'"/>
   <xsl:variable name="templateId-redenWijzigenOfStaken"
                 as="xs:string*"
                 select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9438', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9370', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9270'"/>
   <xsl:template name="uni-relatieMedicatieafspraak">
      <!-- Helper template for the relatie medicatieafspraak -->
      <xsl:param name="in"
                 select=".">
         <!-- The hl7 building block which has the relations in entryRelationships. Defaults to context.-->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:call-template name="_relatieBouwsteen">
            <xsl:with-param name="adaElementName"
                            select="'relatie_medicatieafspraak'"/>
            <xsl:with-param name="hl7Code"
                            select="$maCode"/>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9430_20221122132432">
      <!--  Medicatieafspraak MP9 3.0 -->
      <xsl:param name="ma_hl7"
                 select=".">
         <!-- HL7 medicatieafspraak, defaults to context. -->
      </xsl:param>
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9429_20221122130054">
         <xsl:with-param name="in"
                         select="$ma_hl7"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9429_20221122130054">
      <!--  Medicatieafspraak MP9 3.0 Inhoud -->
      <xsl:param name="in"
                 select=".">
         <!-- HL7 medicatieafspraak, defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:element name="medicatieafspraak">
            <!-- identificatie -->
            <xsl:call-template name="handleII">
               <xsl:with-param name="in"
                               select="hl7:id"/>
               <xsl:with-param name="elemName">identificatie</xsl:with-param>
            </xsl:call-template>
            <!-- medicatieafspraak_datum_tijd -->
            <xsl:apply-templates select="hl7:author/hl7:time"
                                 mode="uni-Medicatieafspraak"/>
            <!-- gebruiksperiode -->
            <xsl:call-template name="mp93-gebruiksperiode">
               <xsl:with-param name="in"
                               select="."/>
            </xsl:call-template>
            <!-- geannuleerd_indicator -->
            <xsl:for-each select="hl7:statusCode[@code = 'nullified']">
               <geannuleerd_indicator value="true"/>
            </xsl:for-each>
            <!-- stoptype -->
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="hl7:entryRelationship/*[hl7:templateId/@root = $templateId-stoptype]/hl7:value"/>
               <xsl:with-param name="elemName">medicatieafspraak_stop_type</xsl:with-param>
            </xsl:call-template>
            <!-- relatie_medicatieafspraak -->
            <xsl:call-template name="uni-relatieMedicatieafspraak"/>
            <!-- relatie_toedieningsafspraak -->
            <xsl:call-template name="uni-relatieToedieningsafspraak"/>
            <!-- relatie_medicatiegebruik -->
            <xsl:call-template name="uni-relatieMedicatiegebruik"/>
            <!-- relatie contact -->
            <xsl:call-template name="uni-relatieContact"/>
            <!-- relatie zorgepisode -->
            <xsl:call-template name="uni-relatieZorgepisode"/>
            <!-- voorschrijver / voorstelgegevens/auteur -->
            <xsl:apply-templates select="hl7:author"
                                 mode="uni-Medicatieafspraak"/>
            <!-- reden wijzigen of staken -->
            <xsl:variable name="ada-elemName"
                          select="'reden_wijzigen_of_staken'"/>
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="hl7:entryRelationship/*[hl7:templateId/@root = $templateId-redenWijzigenOfStaken]/hl7:value"/>
               <xsl:with-param name="elemName"
                               select="$ada-elemName"/>
            </xsl:call-template>
            <!-- reden van voorschrijven -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:templateId/@root = $templateId-redenVanVoorschrijven]/hl7:value">
               <reden_van_voorschrijven>
                  <probleem>
                     <!-- probleem_naam -->
                     <xsl:call-template name="handleCV">
                        <xsl:with-param name="in"
                                        select="."/>
                        <xsl:with-param name="elemName">probleem_naam</xsl:with-param>
                     </xsl:call-template>
                  </probleem>
               </reden_van_voorschrijven>
            </xsl:for-each>
            <!-- afgesproken_geneesmiddel -->
            <xsl:for-each select="hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial">
               <afgesproken_geneesmiddel>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9362_20210602154632">
                     <xsl:with-param name="product-hl7"
                                     select="."/>
                     <xsl:with-param name="generateId"
                                     select="true()"/>
                  </xsl:call-template>
               </afgesproken_geneesmiddel>
            </xsl:for-each>
            <!-- gebruiksinstructie -->
            <xsl:call-template name="mp92-gebruiksinstructie-from-mp9">
               <xsl:with-param name="in"
                               select="."/>
            </xsl:call-template>
            <!-- volgende behandelaar -->
            <xsl:for-each select="hl7:participant[@typeCode = 'CALLBCK']/hl7:participantRole">
               <volgende_behandelaar>
                  <xsl:choose>
                     <xsl:when test="*[not(self::hl7:scopingEntity)] | hl7:playingEntity/*">
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.37_20210701">
                           <xsl:with-param name="generateId"
                                           select="true()"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <!-- MP-1935, just zorgaanbieder -->
                        <xsl:for-each select="hl7:scopingEntity">
                           <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.33_20210701">
                              <xsl:with-param name="generateId"
                                              select="true()"/>
                           </xsl:call-template>
                        </xsl:for-each>
                     </xsl:otherwise>
                  </xsl:choose>
               </volgende_behandelaar>
            </xsl:for-each>
            <!-- aanvullende_informatie -->
            <xsl:variable name="templateIdMAAanvullendeInformatie"
                          select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9177', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9401'"/>
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="hl7:entryRelationship/*[hl7:templateId/@root = $templateIdMAAanvullendeInformatie]/hl7:value"/>
               <xsl:with-param name="elemName">aanvullende_informatie</xsl:with-param>
            </xsl:call-template>
            <!-- kopie_indicator -->
            <xsl:call-template name="handleBL">
               <xsl:with-param name="in"
                               select="hl7:entryRelationship/*[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9200']/hl7:value"/>
               <xsl:with-param name="elemName">kopie_indicator</xsl:with-param>
            </xsl:call-template>
            <!-- toelichting -->
            <xsl:call-template name="handleST">
               <xsl:with-param name="in"
                               select="hl7:entryRelationship/hl7:act[hl7:code[@code = '48767-8'][@codeSystem = $oidLOINC]]/hl7:text"/>
               <xsl:with-param name="elemName">toelichting</xsl:with-param>
            </xsl:call-template>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="hl7:author/hl7:time"
                 mode="uni-Medicatieafspraak">
      <!-- Convert hl7:author/hl7:time into ada registratie_datum_tijd -->
      <xsl:call-template name="handleTS">
         <xsl:with-param name="in"
                         select="."/>
         <!-- vanaf mp9 3.0-beta.3 naamswijziging -->
         <xsl:with-param name="elemName">registratie_datum_tijd</xsl:with-param>
         <xsl:with-param name="vagueDate"
                         select="true()"/>
         <xsl:with-param name="datatype">datetime</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="hl7:author"
                 mode="uni-Medicatieafspraak">
      <!-- Convert hl7:author into ada voorschrijver -->
      <voorschrijver>
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.32_20210701">
            <xsl:with-param name="author-hl7"
                            select="."/>
            <xsl:with-param name="generateId"
                            select="true()"/>
            <!-- naamgebruik not in MP transactions -->
            <xsl:with-param name="outputNaamgebruik"
                            select="false()"/>
         </xsl:call-template>
      </voorschrijver>
   </xsl:template>
</xsl:stylesheet>