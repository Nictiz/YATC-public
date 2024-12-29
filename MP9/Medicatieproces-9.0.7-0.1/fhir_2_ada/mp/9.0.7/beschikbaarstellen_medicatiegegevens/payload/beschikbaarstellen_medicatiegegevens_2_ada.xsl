<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada/env/mp/9.0.7/beschikbaarstellen_medicatiegegevens/payload/beschikbaarstellen_medicatiegegevens_2_ada.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.0.7; 0.1; 2024-08-26T18:25:33.12+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
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
   <xsl:import href="../../../../../common/includes/fhir_2_ada_mp_include.xsl"/>
   <xsl:output indent="yes"/>
   <!-- ================================================================== -->
   <xsl:template match="/">
      <adaxml>
         <xsl:attribute name="xsi:noNamespaceSchemaLocation"
                        select="'../ada_schemas/ada_beschikbaarstellen_medicatiegegevens.xsd'"/>
         <meta status="new"
               created-by="generated"
               last-update-by="generated">
            <xsl:attribute name="creation-date"
                           select="current-dateTime()"/>
            <xsl:attribute name="last-update-date"
                           select="current-dateTime()"/>
         </meta>
         <data>
            <beschikbaarstellen_medicatiegegevens app="mp-mp907"
                                                  shortName="beschikbaarstellen_medicatiegegevens"
                                                  formName="uitwisselen_medicatiegegevens"
                                                  transactionRef="2.16.840.1.113883.2.4.3.11.60.20.77.4.102"
                                                  transactionEffectiveDate="2016-03-23T16:32:43"
                                                  prefix="mp-"
                                                  language="nl-NL">
               <xsl:attribute name="title">Generated from HL7 FHIR medicatiegegevens 9.0.7 xml</xsl:attribute>
               <xsl:attribute name="id">DUMMY</xsl:attribute>
               <xsl:choose>
                  <xsl:when test="count(f:Bundle/f:entry/f:resource/f:Patient) ge 2 or count(distinct-values(f:Bundle/f:entry/f:resource/(f:MedicationRequest|f:MedicationDispense|f:MedicationStatement)/f:subject/f:reference/@value)) ge 2">
                     <xsl:call-template name="util:logMessage">
                        <xsl:with-param name="level"
                                        select="$logERROR"/>
                        <xsl:with-param name="msg">Multiple Patients and/or subject references found. Please check.</xsl:with-param>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Patient"
                                          mode="nl-core-patient-2.1"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:for-each-group select="f:Bundle/f:entry/f:resource/(f:MedicationRequest|f:MedicationDispense|f:MedicationStatement)"
                                   group-by="f:extension[@url='http://nictiz.nl/fhir/StructureDefinition/zib-Medication-MedicationTreatment']/f:valueIdentifier/concat(f:system/@value,f:value/@value)">
                  <medicamenteuze_behandeling>
                     <identificatie>
                        <xsl:attribute name="value"
                                       select="f:extension[@url='http://nictiz.nl/fhir/StructureDefinition/zib-Medication-MedicationTreatment']/f:valueIdentifier/f:value/@value"/>
                        <xsl:attribute name="root"
                                       select="local:getOid(f:extension[@url='http://nictiz.nl/fhir/StructureDefinition/zib-Medication-MedicationTreatment']/f:valueIdentifier/f:system/@value)"/>
                     </identificatie>
                     <!-- medicatieafspraak -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationRequest/f:category/f:coding/f:code/@value='16076005']"
                                          mode="zib-MedicationAgreement-2.2"/>
                     <!-- verstrekkingsverzoek -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationRequest/f:category/f:coding/f:code/@value='52711000146108']"
                                          mode="zib-DispenseRequest-2.2"/>
                     <!-- toedieningsafspraak -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationDispense/f:category/f:coding/f:code/@value='422037009']"
                                          mode="zib-AdministrationAgreement-2.2"/>
                     <!-- verstrekking -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationDispense/f:category/f:coding/f:code/@value='373784005']"
                                          mode="zib-Dispense-2.2"/>
                     <!-- medicatie_gebruik -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationStatement/f:category/f:coding/f:code/@value='6']"
                                          mode="zib-MedicationUse-2.2"/>
                  </medicamenteuze_behandeling>
               </xsl:for-each-group>
            </beschikbaarstellen_medicatiegegevens>
         </data>
      </adaxml>
   </xsl:template>
</xsl:stylesheet>