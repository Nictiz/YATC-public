<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/hl7-2-ada/env/zibs/2020/payload/uni-relatieAndereBouwsteen.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.13; 2026-02-26T13:01:29.91+01:00 == -->
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
   <xsl:template name="_relatieBouwsteen">
      <!-- Helper template for the relatie other building block -->
      <xsl:param name="hl7Code"
                 as="xs:string*">
         <!-- The semantic code as is found in hl7:entryRelationship/*/hl7:code/@code to find the appropriate relation. -->
      </xsl:param>
      <xsl:param name="adaElementName"
                 as="xs:string?">
         <!-- The ada element name for the output -->
      </xsl:param>
      <xsl:for-each select="hl7:entryRelationship/*[hl7:code/@code = $hl7Code]/hl7:id[@extension | @root | @nullFlavor]">
         <xsl:element name="{$adaElementName}">
            <xsl:call-template name="handleII">
               <xsl:with-param name="elemName"
                               select="'identificatie'"/>
            </xsl:call-template>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="uni-relatieContact">
      <!-- Helper template for the relatie contact -->
      <xsl:param name="in"
                 select=".">
         <!-- The hl7 building block which has the relations in entryRelationships. Defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <!-- relatie contact -->
         <xsl:for-each select="hl7:entryRelationship[@typeCode = 'REFR']/hl7:encounter">
            <relatie_contact>
               <xsl:call-template name="handleII">
                  <xsl:with-param name="in"
                                  select="hl7:id"/>
                  <xsl:with-param name="elemName">identificatienummer</xsl:with-param>
               </xsl:call-template>
            </relatie_contact>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="uni-relatieZorgepisode">
      <!-- Helper template for the relatie zorgepisode -->
      <xsl:param name="in"
                 select=".">
         <!--The hl7 building block which has the relations in entryRelationships. Defaults to context.-->
      </xsl:param>
      <xsl:for-each select="$in">
         <!-- relatie zorgepisode -->
         <xsl:for-each select="hl7:entryRelationship[@typeCode = 'REFR']/hl7:act[hl7:code[@code = 'CONC'][@codeSystem = '2.16.840.1.113883.5.6']]">
            <relatie_zorgepisode>
               <xsl:call-template name="handleII">
                  <xsl:with-param name="in"
                                  select="hl7:id"/>
                  <xsl:with-param name="elemName">identificatienummer</xsl:with-param>
               </xsl:call-template>
            </relatie_zorgepisode>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>