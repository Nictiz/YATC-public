<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/mp/9.3.0/sturen_medicatievoorschrift/payload/sturen_medicatievoorschrift_2_ada.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.14; 2026-03-09T10:51:25.02+01:00 == -->
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
   <xsl:template name="ada_sturen_medicatievoorschrift"
                 match="/">
      <!-- Base template for the main interaction. -->
      <!-- only make output if there is at least one MedicationRequest -->
      <xsl:if test="f:Bundle/f:entry/f:resource/f:MedicationRequest">
         <!-- secondary resources only when referenced from a MedicationRequest, BodyHeight or BodyWeight, we add this complexity since the lab stuff may be included in the same Bundle -->
         <xsl:variable name="allPrimaryEntries"
                       select="f:Bundle/f:entry[f:resource/(f:MedicationRequest | f:Observation[f:code/f:coding/f:code/@value = $bodyHeightLOINCcode] | f:Observation[f:code/f:coding/f:code/@value = $bodyWeightLOINCcode])]"/>
         <xsl:variable name="bouwstenen"
                       as="element()*">
            <!--  contactpersoon -->
            <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:RelatedPerson[../preceding-sibling::f:fullUrl/@value = $allPrimaryEntries//f:reference/@value]"
                                 mode="nl-core-ContactPerson"/>
            <!-- farmaceutisch_product -->
            <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Medication[../preceding-sibling::f:fullUrl/@value = $allPrimaryEntries//f:reference/@value]"
                                 mode="nl-core-PharmaceuticalProduct"/>
            <!-- zorgverlener -->
            <!-- we store the referenced PractitionerRoles in a variable, we need those for Organization later on -->
            <xsl:variable name="allPractitionerRoles"
                          select="f:Bundle/f:entry/f:resource/f:PractitionerRole[../preceding-sibling::f:fullUrl/@value = $allPrimaryEntries//f:reference/@value]"/>
            <xsl:apply-templates select="$allPractitionerRoles"
                                 mode="resolve-HealthProfessional-PractitionerRole"/>
            <!-- zorgverlener only present in Practitioner and not referenced from PractitionerRole -->
            <xsl:variable name="allEntries"
                          select="f:Bundle/f:entry"/>
            <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Practitioner[not(../preceding-sibling::f:fullUrl/@value = $allPractitionerRoles//f:reference/@value)][../preceding-sibling::f:fullUrl/@value = $allPrimaryEntries//f:reference/@value]"
                                 mode="nl-core-HealthProfessional-Practitioner"/>
            <!-- zorgaanbieder, is typically referenced from PractitionerRole from PractitionerRole, so we use allPractitionerRoles -->
            <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Organization[../preceding-sibling::f:fullUrl/@value = $allPractitionerRoles//f:reference/@value]"
                                 mode="nl-core-HealthcareProvider-Organization"/>
            <!-- zorgaanbieder only present in Organization and referenced from a primary entry and not referenced from PractitionerRole -->
            <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Organization[not(../preceding-sibling::f:fullUrl/@value = $allPractitionerRoles//f:reference/@value)][../preceding-sibling::f:fullUrl/@value = $allPrimaryEntries//f:reference/@value]"
                                 mode="nl-core-HealthcareProvider-Organization"/>
            <!-- lichaamslengte -->
            <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Observation[f:code/f:coding/f:code/@value = $bodyHeightLOINCcode]"
                                 mode="nl-core-BodyHeight"/>
            <!-- lichaamsgewicht -->
            <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Observation[f:code/f:coding/f:code/@value = $bodyWeightLOINCcode]"
                                 mode="nl-core-BodyWeight"/>
         </xsl:variable>
         <adaxml xsi:noNamespaceSchemaLocation="../ada_schemas/ada_sturen_medicatievoorschrift.xsd"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <meta status="new"
                  created-by="generated"
                  last-update-by="generated"/>
            <data>
               <sturen_medicatievoorschrift app="mp-mp93"
                                            shortName="sturen_medicatievoorschrift"
                                            formName="sturen_medicatievoorschrift"
                                            transactionRef="2.16.840.1.113883.2.4.3.11.60.20.77.4.395"
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
                     <xsl:when test="count(distinct-values(f:Bundle/f:entry/f:resource/(f:MedicationRequest | f:MedicationDispense | f:Condition)/f:subject/f:reference/@value)) gt 1">
                        <xsl:call-template name="util:logMessage">
                           <xsl:with-param name="level"
                                           select="$logERROR"/>
                           <xsl:with-param name="msg">Multiple subject references found. Please check.</xsl:with-param>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <!-- patient, since there may be more than one due to lab, we select the first we encounter in primary mp resources -->
                        <xsl:apply-templates select="nf:resolveRefInBundle((f:Bundle/f:entry/f:resource/(f:MedicationRequest | f:MedicationDispense | f:Condition)/f:subject[f:reference/@value])[1])/*"
                                             mode="nl-core-Patient"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:for-each-group select="f:Bundle/f:entry/f:resource/f:MedicationRequest"
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
                     </medicamenteuze_behandeling>
                  </xsl:for-each-group>
                  <xsl:if test="$bouwstenen/*">
                     <bouwstenen>
                        <xsl:copy-of select="$bouwstenen"/>
                     </bouwstenen>
                  </xsl:if>
               </sturen_medicatievoorschrift>
            </data>
         </adaxml>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>