<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="HL7-mappings/hl7_2_ada/ketenzorg/3.0.2/beschikbaarstellen/payload/beschikbaarstellen_medicatieafspraken907_2_ada.xsl"?>
<?yatc-distribution-info name="ketenzorg-3.0.2" timestamp="2024-06-28T14:38:20.79+02:00" version="1.4.28"?>
<!-- == Provenance: HL7-mappings/hl7_2_ada/ketenzorg/3.0.2/beschikbaarstellen/payload/beschikbaarstellen_medicatieafspraken907_2_ada.xsl == -->
<!-- == Distribution: ketenzorg-3.0.2; 1.4.28; 2024-06-28T14:38:20.79+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:import href="../../../../common/include/hl7_2_ada_mp_include.xsl"/>
   <xsl:import href="../../../../common/include/all-zibs.xsl"/>
   <xd:doc>
      <xd:desc>Conversie van 
<xd:a href="https://decor.nictiz.nl/ketenzorg/kz-html-20190110T164948/tmp-2.16.840.1.113883.2.4.3.11.60.20.77.10.9265-2018-12-13T000000.html">Organizer Medicatieafspraken</xd:a> id: 2.16.840.1.113883.2.4.3.11.60.20.77.10.9265 versie 2018-12-13T00:00:00 naar ADA formaat </xd:desc>
      <xd:desc>Documentatie voor deze mapping staat op de wikipagina 
<xd:a href="https://informatiestandaarden.nictiz.nl/wiki/Mappings/KZ302BeschikbaarstellenMedicatieafsprakenCDA_2_ADA">https://informatiestandaarden.nictiz.nl/wiki/Mappings/KZ302BeschikbaarstellenMedicatieafsprakenCDA_2_ADA</xd:a>
      </xd:desc>
   </xd:doc>
   <xsl:output method="xml"
               indent="yes"/>
   <xd:doc>
      <xd:desc> if this xslt is used stand alone the template below could be used. </xd:desc>
   </xd:doc>
   <xsl:template match="/">
      <xsl:call-template name="doGeneratedComment"/>
      <adaxml xsi:noNamespaceSchemaLocation="../ada_schemas/ada_beschikbaarstellen_medicatieafspraken.xsd">
         <meta status="new"
               created-by="generated"
               last-update-by="generated">
            <xsl:attribute name="creation-date"
                           select="current-dateTime()"/>
            <xsl:attribute name="last-update-date"
                           select="current-dateTime()"/>
         </meta>
         <data>
            <xsl:for-each select="//hl7:organizer[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9265']">
               <xsl:call-template name="BeschikbaarstellenMedicatieafspraken-ADA">
                  <xsl:with-param name="in"
                                  select="."/>
               </xsl:call-template>
            </xsl:for-each>
         </data>
      </adaxml>
   </xsl:template>
   <xd:doc>
      <xd:desc/>
      <xd:param name="in"/>
   </xd:doc>
   <xsl:template name="BeschikbaarstellenMedicatieafspraken-ADA">
      <xsl:param name="in"
                 as="element()"/>
      <xsl:variable name="patient"
                    select="$in/hl7:recordTarget/hl7:patientRole"/>
      <beschikbaarstellen_medicatieafspraken app="ketenzorg3.0"
                                             shortName="beschikbaarstellen_medicatieafspraken"
                                             formName="beschikbaarstellen_medicatieafspraken"
                                             transactionRef="2.16.840.1.113883.2.4.3.11.60.66.4.523"
                                             transactionEffectiveDate="2018-04-13T00:00:00"
                                             versionDate=""
                                             prefix="kz-"
                                             language="nl-NL"
                                             title="Generated Through Conversion"
                                             id="{uuid:get-uuid(.)}">
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.2_20170602000000">
            <xsl:with-param name="elementName">patient</xsl:with-param>
            <xsl:with-param name="in"
                            select="$patient"/>
            <xsl:with-param name="language"
                            select="nl-NL"/>
         </xsl:call-template>
         <xsl:variable name="component"
                       select="$in//*[hl7:templateId/@root = ('2.16.840.1.113883.2.4.3.11.60.20.77.10.9235', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9233')]"
                       as="element()*"/>
         <xsl:for-each-group select="$component"
                             group-by="concat(hl7:entryRelationship/hl7:procedure[hl7:templateId = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9084']/hl7:id/@root, hl7:entryRelationship/hl7:procedure[hl7:templateId = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9084']/hl7:id/@extension)">
            <!-- medicamenteuze_behandeling -->
            <xsl:choose>
               <xsl:when test="string-length(current-grouping-key()) gt 0">
                  <medicamenteuze_behandeling>
                     <xsl:for-each select="hl7:entryRelationship/hl7:procedure[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9084']/hl7:id">
                        <xsl:call-template name="handleII">
                           <xsl:with-param name="elemName">identificatie</xsl:with-param>
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                        <!--<identificatie value="{@extension}" root="{@root}"/>-->
                     </xsl:for-each>
                     <!-- medicatieafspraak -->
                     <xsl:for-each select="current-group()[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9235']">
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9235_20181204143321">
                           <xsl:with-param name="ma_hl7_90"
                                           select="."/>
                        </xsl:call-template>
                     </xsl:for-each>
                  </medicamenteuze_behandeling>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:for-each select="current-group()[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9235']">
                     <medicamenteuze_behandeling>
                        <xsl:for-each select="hl7:entryRelationship/hl7:procedure[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9084']/hl7:id">
                           <xsl:call-template name="handleII">
                              <xsl:with-param name="elemName">identificatie</xsl:with-param>
                              <xsl:with-param name="in"
                                              select="."/>
                           </xsl:call-template>
                           <!--<identificatie value="{@extension}" root="{@root}"/>-->
                        </xsl:for-each>
                        <!-- medicatieafspraak -->
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9235_20181204143321">
                           <xsl:with-param name="ma_hl7_90"
                                           select="."/>
                        </xsl:call-template>
                     </medicamenteuze_behandeling>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each-group>
      </beschikbaarstellen_medicatieafspraken>
   </xsl:template>
</xsl:stylesheet>