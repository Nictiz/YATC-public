<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_hl7/zib2017bbr/payload/hl7-CDARecordTargetSDTCNLBSNContactible-20180611.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.1; 2024-03-12T15:03:10.81+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="language"
              as="xs:string?">nl-NL</xsl:param>
   <xd:doc>
      <xd:desc>Mapping of zib nl.zorg.Patient 3.1 concept in ADA to HL7 CDA template 2.16.840.1.113883.2.4.3.11.60.3.10.3</xd:desc>
      <xd:param name="in">ADA Node to consider in the creation of the hl7 element</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.3_20170602000000"
                 match="patient"
                 mode="HandleCDAREcordTargetSDTCNLBSNContactible">
      <xsl:param name="in"
                 select="."/>
      <xsl:for-each select="$in">
         <recordTarget>
            <patientRole>
               <xsl:for-each select="(patient_identificatienummer | identificatienummer)">
                  <xsl:call-template name="makeIIValue">
                     <xsl:with-param name="root"
                                     select="./@root"/>
                     <xsl:with-param name="elemName">id</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- Adres -->
               <xsl:for-each select=".//adresgegevens[not(adresgegevens)][.//(@value | @code | @nullFlavor | @displayName) ]">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.101_20170602000000">
                     <xsl:with-param name="adres"
                                     select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <!--Telecom gegevens-->
               <xsl:call-template name="_CdaTelecom"/>
               <patient>
                  <xsl:call-template name="_CdaPerson"/>
               </patient>
            </patientRole>
         </recordTarget>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>