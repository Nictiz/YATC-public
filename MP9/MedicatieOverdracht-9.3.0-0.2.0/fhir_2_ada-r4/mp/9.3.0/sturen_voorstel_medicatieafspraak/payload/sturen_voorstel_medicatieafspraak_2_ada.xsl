<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/mp/9.3.0/sturen_voorstel_medicatieafspraak/payload/sturen_voorstel_medicatieafspraak_2_ada.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.2.0; 2024-03-14T08:34:46.14+01:00 == -->
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
         <!-- lichaamslengte -->
         <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Observation[f:code/f:coding/f:code/@value = $bodyHeightLOINCcode]"
                              mode="nl-core-BodyHeight"/>
         <!-- lichaamsgewicht -->
         <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Observation[f:code/f:coding/f:code/@value = $bodyWeightLOINCcode]"
                              mode="nl-core-BodyWeight"/>
      </xsl:variable>
      <adaxml xsi:noNamespaceSchemaLocation="../ada_schemas/ada_sturen_voorstel_medicatieafspraak.xsd"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
         <meta status="new"
               created-by="generated"
               last-update-by="generated"/>
         <data>
            <sturen_voorstel_medicatieafspraak app="mp-mp93"
                                               shortName="sturen_voorstel_medicatieafspraak"
                                               formName="sturen_voorstel_medicatieafspraak"
                                               transactionRef="2.16.840.1.113883.2.4.3.11.60.20.77.4.398"
                                               transactionEffectiveDate="2022-06-30T00:00:00"
                                               versionDate=""
                                               prefix="mp-"
                                               language="nl-NL">
               <xsl:attribute name="title">Generated from HL7 FHIR sturen_medicatievoorschrift</xsl:attribute>
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
                                        select="$logERROR"/>
                        <xsl:with-param name="msg">Multiple Patients and/or subject references found. Please check.</xsl:with-param>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Patient"
                                          mode="nl-core-Patient"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:for-each-group select="f:Bundle/f:entry/f:resource/f:MedicationRequest"
                                   group-by="f:extension[@url = $urlExtPharmaceuticalTreatmentIdentifier]/f:valueIdentifier/concat(f:system/@value, f:value/@value)">
                  <medicamenteuze_behandeling id="{f:extension[@url = $urlExtPharmaceuticalTreatmentIdentifier]/f:valueIdentifier/f:value/@value}">
                     <identificatie>
                        <xsl:attribute name="value"
                                       select="f:extension[@url = $urlExtPharmaceuticalTreatmentIdentifier]/f:valueIdentifier/f:value/@value"/>
                        <xsl:attribute name="root"
                                       select="local:getOid(f:extension[@url = $urlExtPharmaceuticalTreatmentIdentifier]/f:valueIdentifier/f:system/@value)"/>
                     </identificatie>
                     <!-- medicatieafspraak -->
                     <xsl:apply-templates select="current-group()[self::f:MedicationRequest/f:category/f:coding/f:code/@value = $maCode]"
                                          mode="mp-MedicationAgreement"/>
                  </medicamenteuze_behandeling>
               </xsl:for-each-group>
               <xsl:if test="f:Bundle/f:entry/f:resource/f:MedicationRequest[not(f:extension[@url = $urlExtPharmaceuticalTreatmentIdentifier])]">
                  <medicamenteuze_behandeling id="NIEUW">
                     <!-- medicatieafspraak -->
                     <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:MedicationRequest[not(f:extension[@url = $urlExtPharmaceuticalTreatmentIdentifier])]"
                                          mode="mp-MedicationAgreement"/>
                  </medicamenteuze_behandeling>
               </xsl:if>
               <xsl:if test="$bouwstenen/*">
                  <bouwstenen>
                     <xsl:copy-of select="$bouwstenen"/>
                  </bouwstenen>
               </xsl:if>
               <xsl:if test="f:Bundle/f:entry/f:resource/f:MedicationRequest[f:intent/@value = 'plan']">
                  <voorstel_gegevens>
                     <!-- should be only one proposal MedicationRequest -->
                     <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:MedicationRequest[f:intent/@value = 'plan']"
                                          mode="mp-voorstel"/>
                  </voorstel_gegevens>
               </xsl:if>
            </sturen_voorstel_medicatieafspraak>
         </data>
      </adaxml>
   </xsl:template>
</xsl:stylesheet>