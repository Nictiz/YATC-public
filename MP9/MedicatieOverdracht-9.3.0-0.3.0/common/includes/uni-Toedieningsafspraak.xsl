<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/hl7_2_ada/zibs2020/payload/uni-Toedieningsafspraak.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.3.0; 2024-04-09T18:20:47.77+02:00 == -->
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
   <xsl:variable name="taCode"
                 as="xs:string*"
                 select="'422037009'"/>
   <xsl:variable name="templateId-toedieningsafspraak"
                 as="xs:string*"
                 select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9417', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9416', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9415', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9332', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9327', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9326', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9299', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9259', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9256'"/>
   <xsl:variable name="template-id-rel-ta">2.16.840.1.113883.2.4.3.11.60.20.77.10.9101</xsl:variable>
   <xd:doc>
      <xd:desc> Toedieningsafspraak MP9 2.0</xd:desc>
      <xd:param name="in">HL7 substanceAdministration for toedieningsafspraak</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9332_20201015134926"
                 match="hl7:substanceAdministration"
                 mode="HandleTAContents92">
      <xsl:param name="in"
                 select="."/>
      <!-- toedieningsafspraak -->
      <xsl:for-each select="$in">
         <toedieningsafspraak>
            <xsl:variable name="IVL_TS"
                          select="hl7:effectiveTime[resolve-QName(xs:string(@xsi:type), .) = QName('urn:hl7-org:v3', 'IVL_TS')]"/>
            <!-- identificatie -->
            <xsl:for-each select="hl7:id">
               <xsl:call-template name="handleII">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName">identificatie</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- afspraak_datum_tijd -->
            <xsl:for-each select="hl7:author/hl7:time">
               <xsl:call-template name="handleTS">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName">toedieningsafspraak_datum_tijd</xsl:with-param>
                  <xsl:with-param name="vagueDate"
                                  select="true()"/>
                  <xsl:with-param name="datatype">datetime</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- gebruiksperiode -->
            <xsl:variable name="IVL_TS"
                          select="hl7:effectiveTime[resolve-QName(xs:string(@xsi:type), .) = QName('urn:hl7-org:v3', 'IVL_TS')]"/>
            <xsl:call-template name="mp92-gebruiksperiode">
               <xsl:with-param name="IVL_TS"
                               select="($IVL_TS[hl7:low | hl7:width | hl7:high])[1]"/>
            </xsl:call-template>
            <!-- geannuleerd_indicator -->
            <xsl:for-each select="hl7:statusCode[@code = 'nullified']">
               <geannuleerd_indicator value="true"/>
            </xsl:for-each>
            <!-- stoptype  -->
            <xsl:call-template name="uni-stoptype">
               <xsl:with-param name="adaElementName">toedieningsafspraak_stop_type</xsl:with-param>
            </xsl:call-template>
            <!-- verstrekker -->
            <xsl:for-each select="hl7:author/hl7:assignedAuthor/hl7:representedOrganization">
               <verstrekker>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.33_20210701">
                     <xsl:with-param name="generateId"
                                     select="true()"/>
                     <xsl:with-param name="hl7-current-organization"
                                     select="."/>
                  </xsl:call-template>
               </verstrekker>
            </xsl:for-each>
            <!-- reden afspraak MP9 2beta -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:templateId/@root = ('2.16.840.1.113883.2.4.3.11.60.20.77.10.9083', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9394') or hl7:code[@code = ('112231000146109', '160121000146101')][@codeSystem = $oidSNOMEDCT]]/hl7:text">
               <reden_afspraak value="{text()}"/>
            </xsl:for-each>
            <!-- toedieningsafspraak_reden_wijzigen_of_staken MP9 2.0.0 -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:templateId/@root = ('2.16.840.1.113883.2.4.3.11.60.20.77.10.9083', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9394') or hl7:code[@code = ('112231000146109', '160121000146101')][@codeSystem = $oidSNOMEDCT]]/hl7:value[@code | @nullFlavor]">
               <xsl:call-template name="handleCV">
                  <xsl:with-param name="elemName">toedieningsafspraak_reden_wijzigen_of_staken</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- geneesmiddel_bij_toedieningsafspraak -->
            <xsl:for-each select="hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial">
               <geneesmiddel_bij_toedieningsafspraak>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9362_20210602154632">
                     <xsl:with-param name="product-hl7"
                                     select="."/>
                     <xsl:with-param name="generateId"
                                     select="true()"/>
                  </xsl:call-template>
               </geneesmiddel_bij_toedieningsafspraak>
            </xsl:for-each>
            <!-- gebruiksinstructie -->
            <xsl:call-template name="mp92-gebruiksinstructie-from-mp9">
               <xsl:with-param name="in"
                               select="."/>
            </xsl:call-template>
            <!-- distributievorm -->
            <xsl:for-each select="hl7:entryRelationship/hl7:act[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9097']/hl7:code">
               <xsl:variable name="elemName">distributievorm</xsl:variable>
               <xsl:call-template name="handleCV">
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
               </xsl:call-template>
            </xsl:for-each>
            <!-- aanvullende_informatie -->
            <!-- pre 9.2.0 this was a valueset -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9175']/hl7:value[@code]">
               <xsl:call-template name="handleCV">
                  <xsl:with-param name="elemName">toedieningsafspraak_aanvullende_informatie</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- now it is a free text thing -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9402']/hl7:text">
               <xsl:call-template name="handleST">
                  <xsl:with-param name="elemName">toedieningsafspraak_aanvullende_informatie</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- toelichting -->
            <xsl:call-template name="uni-toelichting"/>
            <!-- kopie_indicator -->
            <xsl:call-template name="uni-kopieIndicator"/>
            <!-- relatie_medicatieafspraak -->
            <xsl:call-template name="uni-relatieMedicatieafspraak"/>
         </toedieningsafspraak>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc> Toedieningsafspraak MP9 3.0</xd:desc>
      <xd:param name="in">HL7 substanceAdministration for toedieningsafspraak</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9416_20221121074758"
                 match="hl7:substanceAdministration"
                 mode="HandleTA93">
      <xsl:param name="in"
                 select="."/>
      <!-- toedieningsafspraak -->
      <xsl:for-each select="$in">
         <toedieningsafspraak>
            <xsl:variable name="IVL_TS"
                          select="hl7:effectiveTime[resolve-QName(xs:string(@xsi:type), .) = QName('urn:hl7-org:v3', 'IVL_TS')]"/>
            <!-- identificatie -->
            <xsl:for-each select="hl7:id">
               <xsl:call-template name="handleII">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName">identificatie</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- afspraak_datum_tijd -->
            <xsl:for-each select="hl7:author/hl7:time">
               <xsl:call-template name="handleTS">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName">toedieningsafspraak_datum_tijd</xsl:with-param>
                  <xsl:with-param name="vagueDate"
                                  select="true()"/>
                  <xsl:with-param name="datatype">datetime</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- gebruiksperiode -->
            <xsl:variable name="IVL_TS"
                          select="hl7:effectiveTime[resolve-QName(xs:string(@xsi:type), .) = QName('urn:hl7-org:v3', 'IVL_TS')]"/>
            <xsl:choose>
               <xsl:when test="$IVL_TS instance of element()">
                  <xsl:call-template name="mp92-gebruiksperiode">
                     <xsl:with-param name="IVL_TS"
                                     select="($IVL_TS[hl7:low | hl7:width | hl7:high])[1]"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:when test="hl7:effectiveTime[@value]">
                  <!-- timestamp, we should translate into both low and high, which have the same value -->
                  <gebruiksperiode>
                     <!-- gebruiksperiode_start -->
                     <xsl:call-template name="handleTS">
                        <xsl:with-param name="in"
                                        select="hl7:effectiveTime"/>
                        <xsl:with-param name="elemName">start_datum_tijd</xsl:with-param>
                        <xsl:with-param name="vagueDate"
                                        select="true()"/>
                        <xsl:with-param name="datatype">datetime</xsl:with-param>
                     </xsl:call-template>
                     <!-- gebruiksperiode_eind -->
                     <xsl:call-template name="handleTS">
                        <xsl:with-param name="in"
                                        select="hl7:effectiveTime"/>
                        <xsl:with-param name="elemName">eind_datum_tijd</xsl:with-param>
                        <xsl:with-param name="vagueDate"
                                        select="true()"/>
                        <xsl:with-param name="datatype">datetime</xsl:with-param>
                     </xsl:call-template>
                  </gebruiksperiode>
               </xsl:when>
            </xsl:choose>
            <!-- geannuleerd_indicator -->
            <xsl:for-each select="hl7:statusCode[@code = 'nullified']">
               <geannuleerd_indicator value="true"/>
            </xsl:for-each>
            <!-- stoptype  -->
            <xsl:call-template name="uni-stoptype">
               <xsl:with-param name="adaElementName">toedieningsafspraak_stop_type</xsl:with-param>
            </xsl:call-template>
            <!-- verstrekker -->
            <xsl:for-each select="hl7:author/hl7:assignedAuthor/hl7:representedOrganization">
               <verstrekker>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.33_20210701">
                     <xsl:with-param name="generateId"
                                     select="true()"/>
                     <xsl:with-param name="hl7-current-organization"
                                     select="."/>
                  </xsl:call-template>
               </verstrekker>
            </xsl:for-each>
            <!-- reden afspraak pre-MP9 2 -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:templateId/@root = ('2.16.840.1.113883.2.4.3.11.60.20.77.10.9083', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9394') or hl7:code[@code = ('112231000146109', '160121000146101')][@codeSystem = $oidSNOMEDCT]]/hl7:text">
               <reden_afspraak value="{text()}"/>
            </xsl:for-each>
            <!-- toedieningsafspraak_reden_wijzigen_of_staken MP9 2 onwards -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:templateId/@root = ('2.16.840.1.113883.2.4.3.11.60.20.77.10.9440', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9083', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9394') or hl7:code[@code = ('112231000146109', '160121000146101')][@codeSystem = $oidSNOMEDCT]]/hl7:value[@code | @nullFlavor]">
               <xsl:call-template name="handleCV">
                  <xsl:with-param name="elemName">toedieningsafspraak_reden_wijzigen_of_staken</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- geneesmiddel_bij_toedieningsafspraak -->
            <xsl:for-each select="hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial">
               <geneesmiddel_bij_toedieningsafspraak>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9362_20210602154632">
                     <xsl:with-param name="product-hl7"
                                     select="."/>
                     <xsl:with-param name="generateId"
                                     select="true()"/>
                  </xsl:call-template>
               </geneesmiddel_bij_toedieningsafspraak>
            </xsl:for-each>
            <!-- gebruiksinstructie -->
            <xsl:call-template name="mp92-gebruiksinstructie-from-mp9">
               <xsl:with-param name="in"
                               select="."/>
            </xsl:call-template>
            <!-- distributievorm -->
            <xsl:for-each select="hl7:entryRelationship/hl7:act[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9097']/hl7:code">
               <xsl:variable name="elemName">distributievorm</xsl:variable>
               <xsl:call-template name="handleCV">
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
               </xsl:call-template>
            </xsl:for-each>
            <!-- aanvullende_informatie -->
            <!-- pre 9.2.0 this was a valueset -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9175']/hl7:value[@code]">
               <xsl:call-template name="handleCV">
                  <xsl:with-param name="elemName">toedieningsafspraak_aanvullende_informatie</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- now it is a free text thing -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9402']/hl7:text">
               <xsl:call-template name="handleST">
                  <xsl:with-param name="elemName">toedieningsafspraak_aanvullende_informatie</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- toelichting -->
            <xsl:call-template name="uni-toelichting"/>
            <!-- kopie_indicator -->
            <xsl:call-template name="uni-kopieIndicator"/>
            <!-- relatie_medicatieafspraak -->
            <xsl:call-template name="uni-relatieMedicatieafspraak"/>
            <!-- relatie_toedieningsafspraak -->
            <xsl:call-template name="uni-relatieToedieningsafspraak"/>
         </toedieningsafspraak>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Helper template for the relatie toedieningsafspraak</xd:desc>
      <xd:param name="in">The hl7 building block which has the relations in entryRelationships. Defaults to context.</xd:param>
   </xd:doc>
   <xsl:template name="uni-relatieToedieningsafspraak">
      <xsl:param name="in"
                 select="."/>
      <xsl:for-each select="$in">
         <xsl:call-template name="_relatieBouwsteen">
            <xsl:with-param name="hl7Code"
                            select="$taCode"/>
            <xsl:with-param name="adaElementName">relatie_toedieningsafspraak</xsl:with-param>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>