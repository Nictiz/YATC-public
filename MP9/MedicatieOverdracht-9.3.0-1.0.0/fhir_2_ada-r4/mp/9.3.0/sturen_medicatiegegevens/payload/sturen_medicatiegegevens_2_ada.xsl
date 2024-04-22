<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/mp/9.3.0/sturen_medicatiegegevens/payload/sturen_medicatiegegevens_2_ada.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 1.0.0; 2024-04-17T17:00:31.15+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <xsl:import href="../../payload/mp9_latest_package.xsl"/>
   <xsl:output indent="yes"
               omit-xml-declaration="yes"/>
   <xd:doc>
      <xd:desc>Base template for the main interaction.</xd:desc>
   </xd:doc>
   <xsl:template match="/">
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