<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/mp/9.3.0/sturen_medicatiegegevens/payload/sturen_medicatiegegevens_2_ada.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
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
   <!-- MP-1596: The XSLT stylesheets make the assumption that all resources which are referred to by a literal reference are present in the bundle.
        For more information regarding literal references, see the R4 FHIR spec https://hl7.org/fhir/R4/references.html#literal.   -->
   <xsl:template match="/">
      <!-- Base template for the main interaction. -->
      <xsl:variable name="bouwstenen"
                    as="element()*">
         <!--  contactpersoon -->
         <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:RelatedPerson"
                              mode="nl-core-ContactPerson"/>
         <!-- farmaceutisch_product -->
         <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Medication"
                              mode="nl-core-PharmaceuticalProduct"/>
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
      <adaxml xsi:noNamespaceSchemaLocation="../ada_schemas/ada_sturen_medicatiegegevens.xsd"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
         <meta status="new"
               created-by="generated"
               last-update-by="generated"/>
         <data>
            <sturen_medicatiegegevens app="mp-mp93"
                                      shortName="sturen_medicatiegegevens"
                                      formName="medicatiegegevens"
                                      transactionRef="2.16.840.1.113883.2.4.3.11.60.20.77.4.376"
                                      transactionEffectiveDate="2022-06-30T00:00:00"
                                      prefix="mp-"
                                      language="nl-NL">
               <xsl:attribute name="title">Generated from HL7 FHIR medicatiegegevens</xsl:attribute>
               <xsl:attribute name="id">
                  <xsl:value-of select="f:Bundle/f:id/@value"/>
               </xsl:attribute>
               <xsl:choose>
                  <xsl:when test="count(f:Bundle/f:entry/f:resource/f:Patient) ge 2 or count(distinct-values(f:Bundle/f:entry/f:resource/(f:MedicationRequest | f:MedicationDispense | f:MedicationStatement)/f:subject/f:reference/@value)) ge 2">
                     <xsl:call-template name="util:logMessage">
                        <xsl:with-param name="level"
                                        select="$logERROR"/>
                        <xsl:with-param name="msg">Multiple Patients and/or subject references found. Please check.</xsl:with-param>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Patient"
                                          mode="nl-core-Patient"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:for-each-group select="f:Bundle/f:entry/f:resource/(f:MedicationRequest | f:MedicationDispense | f:MedicationStatement | f:MedicationAdministration)"
                                   group-by="f:extension[@url = $urlExtPharmaceuticalTreatmentIdentifier]/f:valueIdentifier/concat(f:system/@value, f:value/@value)">
                  <medicamenteuze_behandeling>
                     <identificatie>
                        <xsl:attribute name="value"
                                       select="f:extension[@url = $urlExtPharmaceuticalTreatmentIdentifier]/f:valueIdentifier/f:value/@value"/>
                        <xsl:attribute name="root"
                                       select="local:getOid(f:extension[@url = $urlExtPharmaceuticalTreatmentIdentifier]/f:valueIdentifier/f:system/@value)"/>
                     </identificatie>
                     <!-- medicatieafspraak -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationRequest/f:category/f:coding/f:code/@value = $maCode]"
                                          mode="mp-MedicationAgreement"/>
                     <!--WisselendDoseerschema in f:MedicationRequest-->
                     <xsl:apply-templates select="current-group()[self::f:MedicationRequest/f:category/f:coding/f:code/@value = $wdsCode]"
                                          mode="mp-VariableDosingRegimen"/>
                     <!-- verstrekkingsverzoek -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationRequest/f:category/f:coding/f:code/@value = $vvCode]"
                                          mode="nl-core-DispenseRequest"/>
                     <!-- toedieningsafspraak -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationDispense/f:category/f:coding/f:code/@value = $taCode]"
                                          mode="mp-AdministrationAgreement"/>
                     <!-- verstrekking -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationDispense/f:category/f:coding/f:code/@value = $mveCode]"
                                          mode="nl-core-MedicationDispense"/>
                     <!-- medicatie_gebruik -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationStatement/f:category/f:coding/f:code/@value = $mgbCode]"
                                          mode="mp-MedicationUse2"/>
                     <!-- medicatietoediening -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationAdministration]"
                                          mode="mp-MedicationAdministration"/>
                  </medicamenteuze_behandeling>
               </xsl:for-each-group>
               <!--xxxwim bouwstenen -->
               <xsl:if test="$bouwstenen/element()">
                  <bouwstenen>
                     <xsl:for-each select="$bouwstenen">
                        <xsl:copy-of select="."/>
                     </xsl:for-each>
                  </bouwstenen>
               </xsl:if>
            </sturen_medicatiegegevens>
         </data>
      </adaxml>
   </xsl:template>
</xsl:stylesheet>