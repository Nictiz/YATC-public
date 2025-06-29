<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/lab/3.0.0/sturen_laboratoriumresultaten/payload/sturen_laboratoriumresultaten_2_ada.xsl == -->
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
   <xsl:import href="all_zibs-d570e243.xsl"/>
   <xsl:output indent="yes"
               omit-xml-declaration="yes"/>
   <!-- ================================================================== -->
   <xsl:template name="ada_sturen_laboratoriumresultaten"
                 match="/">
      <!-- Base template for the main interaction. -->
      <xsl:variable name="allObservations"
                    select="f:Bundle/f:entry/f:resource/f:Observation[not(f:code//@value = ($bodyHeightLOINCcode, $bodyWeightLOINCcode))]"/>
      <xsl:variable name="topLevelObservations"
                    select="$allObservations[not(ancestor::f:entry/f:fullUrl/@value = $allObservations/f:hasMember/f:reference/@value)]"
                    as="element(f:Observation)*"/>
      <!-- only create ada output when there is actual lab payload -->
      <xsl:if test="count($topLevelObservations) ge 1">
         <adaxml xsi:noNamespaceSchemaLocation="../ada_schemas/ada_sturen_laboratoriumresultaten.xsd"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <meta status="new"
                  created-by="labuitwisselingada"
                  last-update-by="labuitwisselingada"/>
            <data>
               <sturen_laboratoriumresultaten app="lab"
                                              shortName="sturen_laboratoriumresultaten"
                                              formName="sturen_laboratoriumresultaten"
                                              transactionRef="2.16.840.1.113883.2.4.3.11.60.25.4.28"
                                              transactionEffectiveDate="2022-03-03T00:00:00"
                                              prefix="lab-"
                                              language="nl-NL">
                  <xsl:attribute name="title">Generated from HL7 FHIR sturen_laboratoriumresultaten</xsl:attribute>
                  <xsl:attribute name="id">
                     <xsl:choose>
                        <xsl:when test="string-length(//f:Bundle[1]/f:id/@value) gt 0">
                           <xsl:value-of select="//f:Bundle[1]/f:id/@value"/>
                        </xsl:when>
                        <xsl:otherwise>DUMMY</xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:choose>
                     <xsl:when test="count(f:Bundle/f:entry/f:resource/f:Patient) ge 2 or count(distinct-values(f:Bundle/f:entry/f:resource/(f:MedicationRequest | f:MedicationDispense | f:MedicationStatement | f:Observation)/f:subject/f:reference/@value)) ge 2">
                        <xsl:call-template name="util:logMessage">
                           <xsl:with-param name="level"
                                           select="$logFATAL"/>
                           <xsl:with-param name="msg">Multiple Patients and/or subject references found. All entries in the same Bundle SHALL be about the same Patient resource. Please check input.</xsl:with-param>
                           <xsl:with-param name="terminate"
                                           select="true()"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <patientgegevens>
                           <xsl:apply-templates select="f:Bundle/f:entry/f:resource/f:Patient"
                                                mode="nl-core-Patient"/>
                        </patientgegevens>
                     </xsl:otherwise>
                  </xsl:choose>
                  <!-- Bevat de gegevens van de partij die de laboratoriumresultaten als geheel beschikbaar stelt en/of doorstuurt. Dit is de dossierverantwoordelijke.  -->
                  <!--  
						 - if there is a (MedicationRequest, MedicationDispense, MedicationStatement)[1] we expect the custodian to be the author or performer
						 - otherwise we simply don't know from the data what party is passing this Bundle. It is only known at the session level 
					-->
                  <xsl:variable name="custodianReference"
                                select="(f:Bundle/f:entry/f:resource/(f:MedicationRequest/f:requester, f:MedicationDispense/f:performer, f:MedicationStatement/f:extension[@url = 'http://nictiz.nl/fhir/StructureDefinition/ext-MedicationUse2.Author']/f:valueReference))[1]"/>
                  <xsl:variable name="custodianEntry"
                                as="element(f:entry)">
                     <xsl:variable name="custodianTarget"
                                   select="f:Bundle/f:entry[f:fullUrl/@value = $custodianReference/f:reference/@value]/f:resource/f:*"
                                   as="element()*"/>
                     <xsl:choose>
                        <xsl:when test="$custodianTarget[self::f:Organization]">
                           <xsl:copy-of select="$custodianTarget/ancestor::f:entry"/>
                        </xsl:when>
                        <xsl:when test="$custodianTarget[self::f:PractitionerRole]/f:organization">
                           <xsl:copy-of select="f:Bundle/f:entry[f:fullUrl/@value = $custodianTarget/f:organization/f:reference/@value]"/>
                        </xsl:when>
                        <!-- This is awkward ... this hits any organization, and may lead to functional corruption where organizations are misattributed to be a custodian of certain data -->
                        <xsl:when test="f:Bundle/f:entry/f:resource/f:Organization">
                           <xsl:copy-of select="(f:Bundle/f:entry/f:resource/f:Organization)[1]/ancestor::f:entry"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:call-template name="util:logMessage">
                              <xsl:with-param name="level"
                                              select="$logFATAL"/>
                              <xsl:with-param name="msg">Unable to determine custodian (beschikbaarstellende_partij) from incoming data. The custodian is determined based on MedicationRequest/requester, MedicationDispense/performer, or MedicationStatement.extension[author] and constitutes a required piece in the target transaction</xsl:with-param>
                              <xsl:with-param name="terminate"
                                              select="true()"/>
                           </xsl:call-template>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <beschikbaarstellende_partij>
                     <xsl:apply-templates select="$custodianEntry/f:resource/f:Organization"
                                          mode="nl-core-HealthcareProvider-Organization"/>
                  </beschikbaarstellende_partij>
                  <!-- Get top level Observation(s), i.e. Observation that is not a member of another Observation
							 Group top level Observation by edifact_referentienummer and/or Specimen as available
							 
							 create as many onderzoeksresultaat elements as there are (groups of) Observation(s) -->
                  <xsl:variable name="allObservations"
                                select="f:Bundle/f:entry/f:resource/f:Observation[not(f:code//@value = ($bodyHeightLOINCcode, $bodyWeightLOINCcode))]"/>
                  <xsl:variable name="topLevelObservations"
                                select="$allObservations[not(ancestor::f:entry/f:fullUrl/@value = $allObservations/f:hasMember/f:reference/@value)]"
                                as="element(f:Observation)*"/>
                  <xsl:for-each-group select="$topLevelObservations"
                                      group-by="concat(exists(f:hasMember), f:extension[@url = 'http://nictiz.nl/fhir/StructureDefinition/ext-EdifactReferenceNumber']/f:valueString/@value, f:specimen/f:reference/@value)">
                     <onderzoeksresultaat>
                        <xsl:apply-templates select="."
                                             mode="nl-core-LaboratoryTestResult">
                           <xsl:with-param name="laboratoryTests"
                                           select="current-group()"/>
                        </xsl:apply-templates>
                     </onderzoeksresultaat>
                  </xsl:for-each-group>
               </sturen_laboratoriumresultaten>
            </data>
         </adaxml>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>