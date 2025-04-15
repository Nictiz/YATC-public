<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/mp/9.3.0/sturen_antwoord_voorstel_medicatieafspraak/payload/sturen_antwoord_voorstel_medicatieafspraak_2_ada.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-04-08T17:27:28.82+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <!-- ================================================================== -->
   <!--
        TBD
    -->
   <!-- ================================================================== -->
   <!--
        Copyright © Nictiz
        
        This program is free software; you can redistribute it and/or modify it under the terms of the
        GNU Lesser General Public License as published by the Free Software Foundation; either version
        2.1 of the License, or (at your option) any later version.
        
        This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
        without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
        See the GNU Lesser General Public License for more details.
        
        The full text of the license is available at http://www.gnu.org/copyleft/lesser.html
    -->
   <!-- ================================================================== -->
   <xsl:import href="../../payload/mp9_latest_package.xsl"/>
   <xsl:output indent="yes"
               omit-xml-declaration="yes"/>
   <!-- ================================================================== -->
   <xsl:template match="/">
      <!-- Base template for the main interaction. -->
      <xsl:variable name="bouwstenen"
                    as="element()*">
         <!-- zorgverlener -->
         <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:PractitionerRole"
                              mode="resolve-HealthProfessional-PractitionerRole"/>
         <!-- zorgverlener only present in Practitioner and not referenced from PractitionerRole -->
         <xsl:variable name="allEntries"
                       select="f:Bundle/f:entry"/>
         <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Practitioner[not(../preceding-sibling::f:fullUrl/@value = $allEntries//f:reference[ancestor::f:PractitionerRole]/@value)][../preceding-sibling::f:fullUrl/@value = $allEntries//f:reference/@value]"
                              mode="nl-core-HealthProfessional-Practitioner"/>
         <!-- zorgaanbieder -->
         <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Organization"
                              mode="nl-core-HealthcareProvider-Organization"/>
      </xsl:variable>
      <adaxml xsi:noNamespaceSchemaLocation="../ada_schemas/ada_sturen_antwoord_voorstel_medicatieafspraak.xsd"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
         <meta status="new"
               created-by="generated"
               last-update-by="generated"/>
         <data>
            <sturen_antwoord_voorstel_medicatieafspraak app="mp-mp93"
                                                        shortName="sturen_antwoord_voorstel_medicatieafspraak"
                                                        formName="sturen_antwoord_voorstel_medicatieafspraak"
                                                        transactionRef="2.16.840.1.113883.2.4.3.11.60.20.77.4.446"
                                                        transactionEffectiveDate="2022-06-30T00:00:00"
                                                        versionDate=""
                                                        prefix="mp-"
                                                        language="nl-NL">
               <xsl:attribute name="title">Generated from HL7 FHIR sturen_antwoord_voorstel_medicatieafspraak</xsl:attribute>
               <xsl:attribute name="id">
                  <xsl:choose>
                     <xsl:when test="string-length(//f:Bundle[1]/f:id/@value) gt 0">
                        <xsl:value-of select="//f:Bundle[1]/f:id/@value"/>
                     </xsl:when>
                     <xsl:otherwise>DUMMY</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:choose>
                  <xsl:when test="count(f:Bundle/f:entry/f:resource/f:Patient) ge 2 or count(distinct-values(f:Bundle/f:entry/f:resource/(f:MedicationRequest | f:MedicationDispense | f:MedicationStatement)/f:subject/f:reference/@value)) ge 2">
                     <xsl:call-template name="util:logMessage">
                        <xsl:with-param name="level"
                                        select="$logFATAL"/>
                        <xsl:with-param name="msg">Multiple Patients and/or subject references found. Please check.</xsl:with-param>
                        <xsl:with-param name="terminate"
                                        select="true()"/>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Patient"
                                          mode="nl-core-Patient"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:if test="$bouwstenen/*">
                  <bouwstenen>
                     <xsl:copy-of select="$bouwstenen"/>
                  </bouwstenen>
               </xsl:if>
               <xsl:if test="f:Bundle/f:entry/f:resource/f:Communication">
                  <voorstel_gegevens>
                     <!-- should be only one Communication -->
                     <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Communication"
                                          mode="mp-antwoord"/>
                  </voorstel_gegevens>
               </xsl:if>
            </sturen_antwoord_voorstel_medicatieafspraak>
         </data>
      </adaxml>
   </xsl:template>
</xsl:stylesheet>