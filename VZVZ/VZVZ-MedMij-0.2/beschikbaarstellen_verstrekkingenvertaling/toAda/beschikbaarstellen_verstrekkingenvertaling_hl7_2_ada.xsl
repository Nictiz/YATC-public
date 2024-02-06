<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/HL7-mappings/hl7_2_ada/mp/9.0.7/beschikbaarstellen_verstrekkingenvertaling/payload/beschikbaarstellen_verstrekkingenvertaling_hl7_2_ada.xsl"?>
<?yatc-distribution-info name="VZVZ-MedMij" timestamp="2024-02-06T09:13:30.86+01:00" version="0.2"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/HL7-mappings/hl7_2_ada/mp/9.0.7/beschikbaarstellen_verstrekkingenvertaling/payload/beschikbaarstellen_verstrekkingenvertaling_hl7_2_ada.xsl == -->
<!-- == Distribution: VZVZ-MedMij; 0.2; 2024-02-06T09:13:30.86+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:import href="../../common/includes/hl7_2_ada_mp_include.xsl"/>
   <xsl:import href="../../common/includes/all-zibs.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:variable name="transactionName">beschikbaarstellen_verstrekkingenvertaling</xsl:variable>
   <xsl:variable name="transactionOid">2.16.840.1.113883.2.4.3.11.60.20.77.4.102</xsl:variable>
   <xsl:variable name="transactionEffectiveDate"
                 as="xs:dateTime">2016-03-23T16:32:43</xsl:variable>
   <xsl:variable name="adaFormname">uitwisselen_verstrekkingenvertaling</xsl:variable>
   <xd:doc>
      <xd:desc>Template voor converteren van de 6.12 XML</xd:desc>
   </xd:doc>
   <xsl:template match="/">
      <xsl:variable name="verstrekkingslijst-612"
                    select="//hl7:QURX_IN990113NL/hl7:ControlActProcess/hl7:subject/hl7:MedicationDispenseList"/>
      <xsl:choose>
         <!-- alleen inhoudelijke conversie als er ook een verstrekkingenlijst is -->
         <xsl:when test="$verstrekkingslijst-612">
            <xsl:call-template name="Verstrekking_612">
               <xsl:with-param name="dispense-lists"
                               select="$verstrekkingslijst-612"/>
            </xsl:call-template>
         </xsl:when>
         <!-- anders alleen root element om valide xml in output te hebben -->
         <xsl:otherwise>
            <beschikbaarstellen_verstrekkingenvertaling app="mp-mp907"
                                                        shortName="{$transactionName}"
                                                        formName="{$adaFormname}"
                                                        transactionRef="{$transactionOid}"
                                                        transactionEffectiveDate="{$transactionEffectiveDate}"
                                                        prefix="mp-"
                                                        language="nl-NL"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xd:doc>
      <xd:desc>Converteert een verstrekkingenlijst</xd:desc>
      <xd:param name="dispense-lists"/>
   </xd:doc>
   <xsl:template name="Verstrekking_612">
      <xsl:param name="dispense-lists"
                 as="element()*"/>
      <xsl:comment>Generated from HL7v3 verstrekkingenlijst 6.12 xml with message id (QURX_IN990113NL/id) 
<xsl:value-of select="concat('root: ', /hl7:QURX_IN990113NL/hl7:id/@root, ' and extension: ', /hl7:QURX_IN990113NL/hl7:id/@extension)"/>.</xsl:comment>
      <adaxml xsi:noNamespaceSchemaLocation="../ada_schemas/ada_beschikbaarstellen_verstrekkingenvertaling.xsd">
         <meta status="new"
               created-by="generated"
               last-update-by="generated">
            <xsl:attribute name="creation-date"
                           select="current-dateTime()"/>
            <xsl:attribute name="last-update-date"
                           select="current-dateTime()"/>
         </meta>
         <data>
            <xsl:for-each select="$dispense-lists">
               <xsl:variable name="patient"
                             select="./hl7:subject/hl7:Patient"/>
               <xsl:variable name="dispense-events"
                             select="./hl7:component/hl7:medicationDispenseEvent"/>
               <beschikbaarstellen_verstrekkingenvertaling app="mp-mp907"
                                                           shortName="{$transactionName}"
                                                           formName="{$adaFormname}"
                                                           transactionRef="{$transactionOid}"
                                                           transactionEffectiveDate="{$transactionEffectiveDate}"
                                                           prefix="mp-"
                                                           language="nl-NL">
                  <xsl:attribute name="title">Generated from HL7v3 verstrekkingenlijst 6.12 xml</xsl:attribute>
                  <xsl:attribute name="id"
                                 select="tokenize(base-uri(), '/')[last()]"/>
                  <xsl:for-each select="$patient">
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.816_20130521000000_2_907"/>
                  </xsl:for-each>
                  <xsl:for-each select="$dispense-events">
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.110_20130521000000_2_907">
                        <xsl:with-param name="current-dispense-event"
                                        select="."/>
                        <xsl:with-param name="transaction"
                                        select="$transactionName"/>
                     </xsl:call-template>
                  </xsl:for-each>
               </beschikbaarstellen_verstrekkingenvertaling>
            </xsl:for-each>
         </data>
      </adaxml>
   </xsl:template>
</xsl:stylesheet>