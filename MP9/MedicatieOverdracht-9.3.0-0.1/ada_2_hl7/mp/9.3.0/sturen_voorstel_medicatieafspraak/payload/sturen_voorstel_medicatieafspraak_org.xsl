<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_hl7/mp/9.3.0/sturen_voorstel_medicatieafspraak/payload/sturen_voorstel_medicatieafspraak_org.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.1; 2024-03-12T15:03:10.81+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="nf xd xs xsl"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:import href="../../2_hl7_mp_include_930.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <!-- Generates a HL7 message based on ADA input -->
   <!-- give dateT a value when you need conversion of relative T dates, typically only needed for test instances -->
   <!--    <xsl:param name="dateT" as="xs:date?" select="current-date()"/>-->
   <xsl:param name="dateT"
              as="xs:date?"
              select="xs:date('2021-03-24')"/>
   <!--    <xsl:param name="dateT" as="xs:date?"/>-->
   <!-- whether to generate a user instruction description text from the structured information, typically only needed for test instances  -->
   <xsl:param name="generateInstructionText"
              as="xs:boolean?"
              select="false()"/>
   <!-- param to influence whether to output schematron references, typically only needed for test instances -->
   <xsl:param name="schematronRef"
              as="xs:boolean"
              select="false()"/>
   <xsl:template match="/">
      <xsl:call-template name="SturenVoorstelMA-930">
         <xsl:with-param name="in"
                         select="adaxml/data/sturen_voorstel_medicatieafspraak"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="SturenVoorstelMA-930">
      <xsl:param name="in"
                 select="adaxml/data/sturen_voorstel_medicatieafspraak"/>
      <xsl:variable name="patient"
                    select="$in/patient"/>
      <xsl:variable name="mbh"
                    select="$in/medicamenteuze_behandeling"/>
      <xsl:if test="$schematronRef">
         <xsl:processing-instruction name="nictiz">status="example"</xsl:processing-instruction>
         <xsl:processing-instruction name="xml-model">phase="#ALL" href="../../schematron_closed_warnings/mp-mp93_vma.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron" phase="#ALL"</xsl:processing-instruction>
      </xsl:if>
      <xsl:comment>Generated from ada instance with title: "
<xsl:value-of select="$mbh/../@title"/>" and id: "
<xsl:value-of select="$mbh/../@id"/>".</xsl:comment>
      <organizer xsi:schemaLocation="urn:hl7-org:v3 file:/C:/SVN/AORTA/branches/Onderhoud_Mp_v90/XML/schemas/organizer.xsd"
                 classCode="CLUSTER"
                 moodCode="EVN"
                 xmlns:cda="urn:hl7-org:v3">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9436"/>
         <xsl:for-each-group select="$in/voorstel_gegevens/voorstel/identificatie[@value | @root]"
                             group-by="concat(@root,@value)">
            <xsl:call-template name="makeIIValue">
               <xsl:with-param name="elemName">id</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each-group>
         <code code="107"
               displayName="Sturen voorstel medicatieafspraak"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.4"
               codeSystemName="ART DECOR transacties"/>
         <statusCode nullFlavor="NI"/>
         <!-- Patient -->
         <xsl:for-each select="$patient">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1_20210701000000"/>
         </xsl:for-each>
         <!-- Medicamenteuze behandeling -->
         <xsl:for-each select="$mbh">
            <!-- medicatieafspraak -->
            <xsl:for-each select="medicatieafspraak[.//(@value | @code)]">
               <component typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9434_20221122135830"/>
               </component>
            </xsl:for-each>
         </xsl:for-each>
         <!-- Toelichting -->
         <xsl:for-each-group select="$in/voorstel_gegevens/voorstel/toelichting[@value]"
                             group-by="@value">
            <component typeCode="COMP">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.32_20180611000000"/>
            </component>
         </xsl:for-each-group>
         <!-- Lichaamslengte -->
         <xsl:for-each select="$in/bouwstenen/lichaamslengte[.//(@value | @code)]">
            <component typeCode="COMP">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.30_20210701000000"/>
            </component>
         </xsl:for-each>
         <!-- Lichaamsgewicht -->
         <xsl:for-each select="$in/bouwstenen/lichaamsgewicht[.//(@value | @code)]">
            <component typeCode="COMP">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.19_20210701000000"/>
            </component>
         </xsl:for-each>
      </organizer>
   </xsl:template>
</xsl:stylesheet>