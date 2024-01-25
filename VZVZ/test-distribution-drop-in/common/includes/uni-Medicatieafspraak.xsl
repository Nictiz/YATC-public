<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/HL7-mappings/hl7_2_ada/zibs2020/payload/uni-Medicatieafspraak.xsl"?>
<?yatc-distribution-info name="VZVZ-test-distribution-drop-in" timestamp="2024-01-25T12:13:11.57+01:00" version="0.2"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/HL7-mappings/hl7_2_ada/zibs2020/payload/uni-Medicatieafspraak.xsl == -->
<!-- == Distribution: VZVZ-test-distribution-drop-in; 0.2; 2024-01-25T12:13:11.57+01:00 == -->
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
   <xsl:variable name="maCode"
                 as="xs:string*"
                 select="'33633005', '16076005'"/>
   <xsl:variable name="templateId-medicatieafspraak"
                 as="xs:string*"
                 select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9431', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9430', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9429', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9325', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9324', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9323', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9275', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9233', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9235', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9241', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9216'"/>
   <xsl:variable name="template-id-rel-ma">2.16.840.1.113883.2.4.3.11.60.20.77.10.9086</xsl:variable>
   <xsl:variable name="templateId-redenVanVoorschrijven"
                 as="xs:string*"
                 select="'2.16.840.1.113883.2.4.3.11.60.121.10.24', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9316', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9160'"/>
   <xsl:variable name="templateId-redenWijzigenOfStaken"
                 as="xs:string*"
                 select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9438', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9370', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9270'"/>
   <xd:doc>
      <xd:desc>Creates ada attributes taking a hl7 code element as input</xd:desc>
      <xd:param name="current-hl7-code">The hl7 code element for which to create the attributes</xd:param>
   </xd:doc>
   <xsl:template name="mp9-code-attribs">
      <xsl:param name="current-hl7-code"
                 as="element()?"
                 select="."/>
      <xsl:for-each select="$current-hl7-code">
         <xsl:choose>
            <xsl:when test=".[@code]">
               <xsl:copy-of select="@code | @codeSystem | @codeSystemName | @codeSystemVersion | @displayName"/>
            </xsl:when>
            <xsl:when test=".[@nullFlavor]">
               <xsl:attribute name="code"
                              select="./@nullFlavor"/>
               <xsl:attribute name="codeSystem"
                              select="$oidHL7NullFlavor"/>
               <xsl:attribute name="displayName"
                              select="$hl7NullFlavorMap[@hl7NullFlavor = @nullFlavor]/@displayName"/>
               <xsl:for-each select="hl7:originalText">
                  <xsl:attribute name="originalText"
                                 select="."/>
               </xsl:for-each>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Helper template for the relatie medicatieafspraak</xd:desc>
      <xd:param name="in">The hl7 building block which has the relations in entryRelationships. Defaults to context.</xd:param>
   </xd:doc>
   <xsl:template name="uni-relatieMedicatieafspraak">
      <xsl:param name="in"
                 select="."/>
      <xsl:for-each select="$in">
         <xsl:call-template name="_relatieBouwsteen">
            <xsl:with-param name="adaElementName">relatie_medicatieafspraak</xsl:with-param>
            <xsl:with-param name="hl7Code"
                            select="$maCode"/>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc> Medicatieafspraak MP 9.2</xd:desc>
      <xd:param name="ma_hl7">HL7 medicatieafspraak, defaults to context.</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9324_20201015132016">
      <xsl:param name="ma_hl7"
                 select="."/>
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9323_20201015131556">
         <xsl:with-param name="in"
                         select="$ma_hl7"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc> Medicatieafspraak MP 9.2 Inhoud </xd:desc>
      <xd:param name="in">HL7 medicatieafspraak, defaults to context.</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9323_20201015131556">
      <xsl:param name="in"
                 select="."/>
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
            <!-- stoptype -->
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="hl7:entryRelationship/*[hl7:templateId/@root = $templateId-stoptype]/hl7:value"/>
               <xsl:with-param name="elemName">medicatieafspraak_stop_type</xsl:with-param>
            </xsl:call-template>
            <!-- relatie_medicatieafspraak -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:code/@code = $maCode]/hl7:id[@extension | @root | @nullFlavor]">
               <relatie_medicatieafspraak>
                  <xsl:call-template name="handleII">
                     <xsl:with-param name="elemName">identificatie</xsl:with-param>
                  </xsl:call-template>
               </relatie_medicatieafspraak>
            </xsl:for-each>
            <!-- relatie_toedieningsafspraak -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:code/@code = $taCode]/hl7:id[@extension | @root | @nullFlavor]">
               <relatie_toedieningsafspraak>
                  <xsl:call-template name="handleII">
                     <xsl:with-param name="elemName">identificatie</xsl:with-param>
                  </xsl:call-template>
               </relatie_toedieningsafspraak>
            </xsl:for-each>
            <!-- relatie_medicatiegebruik -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:code/@code = $mgbCode]/hl7:id[@extension | @root | @nullFlavor]">
               <relatie_medicatiegebruik>
                  <xsl:call-template name="handleII">
                     <xsl:with-param name="elemName">identificatie</xsl:with-param>
                  </xsl:call-template>
               </relatie_medicatiegebruik>
            </xsl:for-each>
            <!-- relatie contact -->
            <xsl:call-template name="uni-relatieContact"/>
            <!-- relatie zorgepisode -->
            <xsl:call-template name="uni-relatieZorgepisode"/>
            <!-- voorschrijver / voorstelgegevens/auteur -->
            <xsl:apply-templates select="hl7:author"
                                 mode="uni-Medicatieafspraak"/>
            <!-- reden wijzigen of staken -->
            <xsl:variable name="ada-elemName">reden_wijzigen_of_staken</xsl:variable>
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
   <xd:doc>
      <xd:desc> Medicatieafspraak MP9 3.0</xd:desc>
      <xd:param name="ma_hl7">HL7 medicatieafspraak, defaults to context.</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9430_20221122132432">
      <xsl:param name="ma_hl7"
                 select="."/>
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9429_20221122130054">
         <xsl:with-param name="in"
                         select="$ma_hl7"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc> Medicatieafspraak MP9 3.0 Inhoud </xd:desc>
      <xd:param name="in">HL7 medicatieafspraak, defaults to context.</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9429_20221122130054">
      <xsl:param name="in"
                 select="."/>
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
            <!-- stoptype -->
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="hl7:entryRelationship/*[hl7:templateId/@root = $templateId-stoptype]/hl7:value"/>
               <xsl:with-param name="elemName">medicatieafspraak_stop_type</xsl:with-param>
            </xsl:call-template>
            <!-- relatie_medicatieafspraak -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:code/@code = $maCode]/hl7:id[@extension | @root | @nullFlavor]">
               <relatie_medicatieafspraak>
                  <xsl:call-template name="handleII">
                     <xsl:with-param name="elemName">identificatie</xsl:with-param>
                  </xsl:call-template>
               </relatie_medicatieafspraak>
            </xsl:for-each>
            <!-- relatie_toedieningsafspraak -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:code/@code = $taCode]/hl7:id[@extension | @root | @nullFlavor]">
               <relatie_toedieningsafspraak>
                  <xsl:call-template name="handleII">
                     <xsl:with-param name="elemName">identificatie</xsl:with-param>
                  </xsl:call-template>
               </relatie_toedieningsafspraak>
            </xsl:for-each>
            <!-- relatie_medicatiegebruik -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:code/@code = $mgbCode]/hl7:id[@extension | @root | @nullFlavor]">
               <relatie_medicatiegebruik>
                  <xsl:call-template name="handleII">
                     <xsl:with-param name="elemName">identificatie</xsl:with-param>
                  </xsl:call-template>
               </relatie_medicatiegebruik>
            </xsl:for-each>
            <!-- relatie contact -->
            <xsl:call-template name="uni-relatieContact"/>
            <!-- relatie zorgepisode -->
            <xsl:call-template name="uni-relatieZorgepisode"/>
            <!-- voorschrijver / voorstelgegevens/auteur -->
            <xsl:apply-templates select="hl7:author"
                                 mode="uni-Medicatieafspraak"/>
            <!-- reden wijzigen of staken -->
            <xsl:variable name="ada-elemName">reden_wijzigen_of_staken</xsl:variable>
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
                  <zorgverlener>
                     <xsl:attribute name="id">
                        <xsl:value-of select="generate-id()"/>
                     </xsl:attribute>
                     <xsl:call-template name="handleII">
                        <xsl:with-param name="in"
                                        select="hl7:id"/>
                        <xsl:with-param name="elemName">zorgverlener_identificatienummer</xsl:with-param>
                     </xsl:call-template>
                     <!-- naamgegevens -->
                     <xsl:call-template name="handleENtoNameInformation">
                        <xsl:with-param name="in"
                                        select="hl7:playingEntity/hl7:name"/>
                        <xsl:with-param name="language">nl-NL</xsl:with-param>
                        <xsl:with-param name="unstructurednameElement">ongestructureerde_naam</xsl:with-param>
                        <xsl:with-param name="outputNaamgebruik"
                                        select="false()"/>
                     </xsl:call-template>
                     <!-- specialisme -->
                     <xsl:call-template name="handleCV">
                        <xsl:with-param name="in"
                                        select="hl7:code"/>
                        <xsl:with-param name="elemName">specialisme</xsl:with-param>
                     </xsl:call-template>
                     <!-- zorgaanbieder -->
                     <xsl:for-each select="hl7:scopingEntity">
                        <zorgaanbieder>
                           <xsl:attribute name="id">
                              <xsl:value-of select="generate-id()"/>
                           </xsl:attribute>
                           <xsl:call-template name="handleII">
                              <xsl:with-param name="in"
                                              select="hl7:id"/>
                              <xsl:with-param name="elemName">zorgaanbieder_identificatienummer</xsl:with-param>
                           </xsl:call-template>
                           <!-- organisatienaam has 1..1 R in MP 9 ADA transactions, but is not always present in HL7 input messages.  -->
                           <!-- fill with nullFlavor if necessary -->
                           <xsl:call-template name="handleST">
                              <xsl:with-param name="in"
                                              select="hl7:desc"/>
                              <xsl:with-param name="elemName">organisatie_naam</xsl:with-param>
                              <xsl:with-param name="nullIfMissing">NI</xsl:with-param>
                           </xsl:call-template>
                        </zorgaanbieder>
                     </xsl:for-each>
                  </zorgverlener>
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
   <xd:doc>
      <xd:desc>Convert hl7:author/hl7:time into ada medicatieafspraak_datum_tijd</xd:desc>
   </xd:doc>
   <xsl:template match="hl7:author/hl7:time"
                 mode="uni-Medicatieafspraak">
      <xsl:call-template name="handleTS">
         <xsl:with-param name="in"
                         select="."/>
         <xsl:with-param name="elemName">medicatieafspraak_datum_tijd</xsl:with-param>
         <xsl:with-param name="vagueDate"
                         select="true()"/>
         <xsl:with-param name="datatype">datetime</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Convert hl7:author into ada voorschrijver</xd:desc>
   </xd:doc>
   <xsl:template match="hl7:author"
                 mode="uni-Medicatieafspraak">
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