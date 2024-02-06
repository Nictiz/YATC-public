<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/HL7-mappings/hl7_2_ada/cio/1.0.0/beschikbaarstellen_allergie_intolerantie_vertaling/payload/beschikbaarstellen_allergie_intolerantie_vertaling_hl7_2_ada.xsl"?>
<?yatc-distribution-info name="VZVZ-MedMij" timestamp="2024-01-29T11:45:25.52+01:00" version="0.1"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/HL7-mappings/hl7_2_ada/cio/1.0.0/beschikbaarstellen_allergie_intolerantie_vertaling/payload/beschikbaarstellen_allergie_intolerantie_vertaling_hl7_2_ada.xsl == -->
<!-- == Distribution: VZVZ-MedMij; 0.1; 2024-01-29T11:45:25.52+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ncf="http://www.nictiz.nl/cio-functions"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:import href="../../common/includes/hl7_2_ada_cio_include.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xd:doc>
      <xd:desc>Conversion ICA 6.12 to CIO 1.0 "allergie intolerantie vertaling" (AllergyIntoleranceConversion) transaction</xd:desc>
   </xd:doc>
   <!-- ada output language -->
   <xsl:param name="language">nl-NL</xsl:param>
   <!-- debug parameter whether to output the $transactionResult variable in a debug dir -->
   <xsl:param name="debug"
              as="xs:boolean?"
              select="false()"/>
   <xsl:variable name="adaFormname">beschikbaarstellen_allergie_intolerantie_vertaling</xsl:variable>
   <xsl:variable name="transactionName"
                 select="$adaFormname"/>
   <xsl:variable name="transactionOid">2.16.840.1.113883.2.4.3.11.60.26.4.6</xsl:variable>
   <xsl:variable name="transactionEffectiveDate"
                 as="xs:dateTime">2019-08-28T13:33:41</xsl:variable>
   <xsl:variable name="ica612Root"
                 select="//hl7:REPC_IN000024NL"/>
   <!-- Variable to hold all information to create actual ada instance -->
   <!-- Only uses reference for patient, but outputs the whole element for others -->
   <!-- When references are needed in output, this is done in templates with mode "adaOutput".  -->
   <xsl:variable name="transactionResult">
      <xsl:for-each select="$ica612Root">
         <xsl:text>
         </xsl:text>
         <xsl:comment>Generated from HL7v3 ica 6.12 xml with message id (
<xsl:value-of select="./local-name()"/>/id) 
<xsl:value-of select="concat('root: ', ./hl7:id/@root, ' and extension: ', ./hl7:id/@extension)"/>.</xsl:comment>
         <xsl:text>
         </xsl:text>
         <beschikbaarstellen_allergie_intolerantie_vertaling app="cio"
                                                             shortName="{$transactionName}"
                                                             formName="{$adaFormname}"
                                                             transactionRef="{$transactionOid}"
                                                             transactionEffectiveDate="{$transactionEffectiveDate}"
                                                             prefix="cio-"
                                                             language="nl-NL">
            <xsl:attribute name="title">Generated from HL7v3 potentiële contraindicaties 6.12 xml</xsl:attribute>
            <xsl:attribute name="id"
                           select="tokenize(base-uri(), '/')[last()]"/>
            <xsl:copy-of select="$patients/patient_information/*[local-name() = $elmPatient]"/>
            <xsl:for-each select="hl7:ControlActProcess[hl7:subject[hl7:Condition]]">
               <xsl:call-template name="HandleConditions"/>
            </xsl:for-each>
         </beschikbaarstellen_allergie_intolerantie_vertaling>
      </xsl:for-each>
   </xsl:variable>
   <xd:doc>
      <xd:desc>Template for converting 6.12 ICA XML</xd:desc>
   </xd:doc>
   <xsl:template match="/">
      <xsl:if test="$ica612Root">
         <xsl:if test="$debug">
            <xsl:result-document href="{concat('../debug/', $ica612Root/hl7:id/@extension, '.xml')}">
               <xsl:copy-of select="$transactionResult"/>
            </xsl:result-document>
         </xsl:if>
         <adaxml xsi:noNamespaceSchemaLocation="../ada_schemas/ada_beschikbaarstellen_allergie_intolerantie_vertaling.xsd">
            <meta status="new"
                  created-by="generated"
                  last-update-by="generated">
               <xsl:attribute name="creation-date"
                              select="current-dateTime()"/>
               <xsl:attribute name="last-update-date"
                              select="current-dateTime()"/>
            </meta>
            <data>
               <xsl:for-each select="$transactionResult/beschikbaarstellen_allergie_intolerantie_vertaling">
                  <xsl:copy>
                     <!-- attributen kopiëren -->
                     <xsl:apply-templates select="@*"
                                          mode="adaOutput"/>
                     <!-- patient is first element in dataset, output the HCIM first -->
                     <xsl:apply-templates select="patient"
                                          mode="adaOutputHcim"/>
                     <xsl:apply-templates select="node()"
                                          mode="adaOutput"/>
                     <!-- output other HCIMs in the correct order -->
                     <!-- output healthprofessionals -->
                     <xsl:apply-templates select="                                     //zibroot/informatiebron//zorgverlener[not(zorgverlener)][@id]                                     | //zibroot/auteur//zorgverlener[@id]"
                                          mode="adaOutputHcim"/>
                     <!-- output health providers -->
                     <xsl:apply-templates select="//zorgaanbieder[@id]"
                                          mode="adaOutputHcim"/>
                     <!-- output contact points -->
                     <xsl:apply-templates select="//zibroot/informatiebron//contactpersoon[@id]"
                                          mode="adaOutputHcim"/>
                  </xsl:copy>
               </xsl:for-each>
            </data>
         </adaxml>
      </xsl:if>
   </xsl:template>
   <xd:doc>
      <xd:desc>Handle the HL7 6.12 Condition to determine whether to create an ada alert or an allergy_intolerance HCIM</xd:desc>
   </xd:doc>
   <xsl:template name="HandleConditions"
                 match="hl7:ControlActProcess"
                 mode="HandleConditions">
      <xsl:for-each select="hl7:subject/hl7:Condition[hl7:code/@code = ('DINT', 'DALG', 'DNAINT')][not(@negationInd = 'true')]">
         <xsl:call-template name="tmp-2.16.840.1.113883.2.4.3.11.60.20.77.10.111_20130525000000_2_allergy"/>
      </xsl:for-each>
      <!-- Other Conditions than intolerances are not part of this transaction and thus ignored  -->
   </xsl:template>
</xsl:stylesheet>