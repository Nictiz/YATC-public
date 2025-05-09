<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/HL7-mappings/ada_2_hl7/lab/3.0.0/sturen_laboratoriumresultaten/payload/sturen_laboratoriumresultaten_org.xsl"?>
<?yatc-distribution-info name="VZVZ-test-distribution-drop-in" timestamp="2024-01-25T12:13:11.57+01:00" version="0.2"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/HL7-mappings/ada_2_hl7/lab/3.0.0/sturen_laboratoriumresultaten/payload/sturen_laboratoriumresultaten_org.xsl == -->
<!-- == Distribution: VZVZ-test-distribution-drop-in; 0.2; 2024-01-25T12:13:11.57+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="nf xd xs xsl"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:lab="urn:oid:1.3.6.1.4.1.19376.1.3.2"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:import href="_ada2hl7_zib2017.xsl"/>
   <xsl:import href="hl7-toelichting-20180611.xsl"/>
   <xsl:import href="2_hl7_lab_include_300.xsl"/>
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
              select="true()"/>
   <!-- param to influence whether to output schematron references, typically only needed for test instances -->
   <xsl:param name="schematronRef"
              as="xs:boolean"
              select="false()"/>
   <xsl:template name="lu-sturenLaboratoriumresultaten"
                 match="/">
      <xsl:call-template name="SturenLaboratoriumresultaten-300">
         <xsl:with-param name="in"
                         select="adaxml/data/sturen_laboratoriumresultaten"/>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="SturenLaboratoriumresultaten-300">
      <xsl:param name="in"
                 select="adaxml/data/sturen_laboratoriumresultaten"/>
      <xsl:for-each select="$in">
         <xsl:variable name="patient"
                       select="patientgegevens/patient"/>
         <xsl:if test="$schematronRef">
            <xsl:processing-instruction name="nictiz">status="example"</xsl:processing-instruction>
            <xsl:processing-instruction name="xml-model">phase="#ALL" href="../../../../../aorta/branches/Onderhoud_Lu/XML/schematron_closed_warnings/lu-sturenLaboratoriumresultaten.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron" phase="#ALL"</xsl:processing-instruction>
         </xsl:if>
         <xsl:comment>Generated from ada instance with title: "
<xsl:value-of select="replace(@title, '--', '-\\-')"/>" and id: "
<xsl:value-of select="replace(@id, '--', '-\\-')"/>".</xsl:comment>
         <organizer xsi:schemaLocation="urn:hl7-org:v3 ../hl7_schemas/organizer.xsd"
                    classCode="CLUSTER"
                    moodCode="EVN"
                    xmlns:cda="urn:hl7-org:v3">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.66.10.77"/>
            <code code="26436-6"
                  displayName="Laboratory studies"
                  codeSystem="2.16.840.1.113883.6.1"
                  codeSystemName="LOINC"/>
            <statusCode code="completed"/>
            <!-- Patient -->
            <xsl:for-each select="$patient">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1_20210701000000"/>
            </xsl:for-each>
            <!-- Beschikbaarstellende partij -->
            <xsl:for-each select="beschikbaarstellende_partij/zorgaanbieder">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.66.10.9032_20141113000000"/>
            </xsl:for-each>
            <xsl:for-each select="onderzoeksresultaat/laboratorium_uitslag">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.66.10.77_20220330000000"/>
            </xsl:for-each>
         </organizer>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>