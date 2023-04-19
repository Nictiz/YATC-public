<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255062456490200" xmlns:nm="http://www.nictiz.nl/mappings">
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
    
    <xsl:include href="../../../../../xslmod/ada-2-fhir-r4-build-standard-parameters.mod.xsl"/>

    <xsl:import href="../../../../zibs2020/payload/0.6-beta2/all_zibs.xsl"/>

    <xsl:param name="writeOutputToDisk" select="true()" as="xs:boolean"/>
    
    <xsl:param name="dirOutputToDisk" as="xs:string" required="no" select="yatcs:href-concat(($baseDirectory, 'DIROUTPUTTODISKNOTSET'))"/>

    <xsl:param name="referencingStrategy" select="'logicalId'" as="xs:string"/>
    <!-- If the desired output is to be a Bundle, then a self link string of type url is required. 
         See: https://www.hl7.org/fhir/R4/search.html#conformance -->
    <xsl:param name="bundleSelfLink" as="xs:string?"/>

    <!-- Generate metadata for all ADA instances -->
    <xsl:param name="fhirMetadata" as="element()*">
        <xsl:call-template name="buildFhirMetadata">
            <!-- ADA instances for this project start with $zib2020Oid and end in .1, or in 9.*.* in the case of the medication related zibs -->
            <xsl:with-param name="in" select="//(                     
                sturen_laboratoriumresultaten/onderzoeksresultaat/laboratorium_uitslag |                     
                sturen_laboratoriumresultaten/patientgegevens/patient |                      
                sturen_laboratoriumresultaten/beschikbaarstellende_partij/zorgaanbieder |                     
                sturen_laboratoriumresultaten/onderzoeksresultaat/laboratorium_uitslag/uitvoerder/zorgaanbieder |                     
                beschikbaarstellen_laboratoriumresultaten/onderzoeksresultaat/laboratorium_uitslag |                     
                beschikbaarstellen_laboratoriumresultaten/patientgegevens/patient |                      
                beschikbaarstellen_laboratoriumresultaten/beschikbaarstellende_partij/zorgaanbieder |                     
                beschikbaarstellen_laboratoriumresultaten/onderzoeksresultaat/laboratorium_uitslag/uitvoerder/zorgaanbieder             
            )"/>
        </xsl:call-template>
    </xsl:param>

    <!-- ================================================================== -->

    <xsl:template match="sturen_laboratoriumresultaten | beschikbaarstellen_laboratoriumresultaten">
        <!--  -->
        <!--<xsl:message>Parameter writeOutputToDisk has value = <xsl:value-of select="$writeOutputToDisk"/></xsl:message>
        <xsl:message>Parameter dateT has value = <xsl:value-of select="$dateT"/></xsl:message>-->

        <xsl:variable name="resources" as="element(f:entry)*">
            <xsl:apply-templates select="onderzoeksresultaat"/>

            <xsl:variable name="device" as="element()*">
                <xsl:for-each-group select="onderzoeksresultaat/laboratorium_uitslag/monster/bron_monster" group-by="nf:getGroupingKeyDefault(.)">
                    <xsl:call-template name="nl-core-LaboratoryTestResult.Specimen.Source">
                        <xsl:with-param name="in" select="current-group()[1]"/>
                        <xsl:with-param name="subject" select="../../../../patientgegevens/patient"/>
                    </xsl:call-template>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:variable name="specimen" as="element()*">
                <xsl:for-each-group select="onderzoeksresultaat/laboratorium_uitslag/monster" group-by="nf:getGroupingKeyDefault(.)">
                    <xsl:call-template name="nl-core-LaboratoryTestResult.Specimen">
                        <xsl:with-param name="in" select="current-group()[1]"/>
                        <xsl:with-param name="subject" select="../../../patientgegevens/patient"/>
                        <xsl:with-param name="type" select="microorganisme"/>
                    </xsl:call-template>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:variable name="zorgaanbieders" as="element()*">
                <xsl:for-each-group select="beschikbaarstellende_partij/zorgaanbieder | onderzoeksresultaat/laboratorium_uitslag/uitvoerder/zorgaanbieder" group-by="nf:getGroupingKeyDefault(.)">
                    <!--<xsl:if test="afdeling_specialisme">
                        <xsl:call-template name="nl-core-HealthcareProvider">
                            <xsl:with-param name="in" select="current-group()[1]"/>
                        </xsl:call-template>
                    </xsl:if>-->
                    <xsl:call-template name="nl-core-HealthcareProvider-Organization">
                        <xsl:with-param name="in" select="current-group()[1]"/>
                    </xsl:call-template>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:variable name="patient" as="element()?">
                <xsl:for-each select="patientgegevens/patient">
                    <xsl:call-template name="nl-core-Patient"/>
                </xsl:for-each>
            </xsl:variable>

            <xsl:for-each select="$specimen | $device | $zorgaanbieders | $patient">
                <entry xmlns="http://hl7.org/fhir">
                    <xsl:call-template name="_insertFullUrlById"/>
                    <resource>
                        <xsl:copy-of select="."/>
                    </resource>
                </entry>
            </xsl:for-each>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$writeOutputToDisk">
                
               <!-- <OUT timestamp="{current-dateTime()}">
                    <xsl:copy-of select="$resources"/>
                </OUT>-->
                
                <xsl:for-each select="$resources/f:resource/*">
                    <xsl:choose>
                        <xsl:when test="string-length(f:id/@value) gt 0">
                            <xsl:result-document href="{yatcs:href-concat(($dirOutputToDisk, concat(f:id/@value, '.xml')))}">
                                <xsl:copy-of select="."/>
                            </xsl:result-document>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- This happens when transforming a non-saved document in Oxygen -->
                            <xsl:message>Could not output to result-document without Resource.id</xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each><!---->
            </xsl:when>
            <xsl:otherwise>
                <Bundle xmlns="http://hl7.org/fhir">
                    <id value="{nf:assure-logicalid-length(nf:removeSpecialCharacters(@id))}"/>
                    <type value="searchset"/>
                    <!-- What should we count? -->
                    <total value="TODO"/>
                    <!--<total value="{count($resources/f:resource/*)}"/>-->
                    <xsl:choose>
                        <xsl:when test="$bundleSelfLink[not(. = '')]">
                            <link>
                                <relation value="self"/>
                                <url value="{$bundleSelfLink}"/>
                            </link>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="util:logMessage">
                                <xsl:with-param name="level" select="$logWARN"/>
                                <xsl:with-param name="msg">Parameter bundleSelfLink is empty, but server SHALL return the parameters that were actually used to process the search.</xsl:with-param>
                                <xsl:with-param name="terminate" select="false()"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:copy-of select="$resources"/>
                </Bundle>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="onderzoeksresultaat">
        <!--  -->
        <xsl:variable name="laboratoriumresultaten" as="element()*">
            <xsl:for-each select="laboratorium_uitslag[onderzoek]">
                <xsl:call-template name="_nl-core-LaboratoryTestResult-panel">
                    <xsl:with-param name="subject" select="../../patientgegevens/patient"/>
                </xsl:call-template>
                <xsl:for-each select="laboratorium_test">
                    <xsl:call-template name="_nl-core-LaboratoryTestResult-individualTest">
                        <xsl:with-param name="subject" select="../../../patientgegevens/patient"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="laboratorium_uitslag[not(onderzoek)]/laboratorium_test">
                <xsl:call-template name="_nl-core-LaboratoryTestResult-individualTest">
                    <xsl:with-param name="subject" select="../../../patientgegevens/patient"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:for-each select="$laboratoriumresultaten">
            <entry xmlns="http://hl7.org/fhir">
                <xsl:call-template name="_insertFullUrlById"/>
                <resource>
                    <xsl:copy-of select="."/>
                </resource>
            </entry>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="*" mode="_generateId" priority="2">
        <!--  -->
        <xsl:param name="profile" as="xs:string" required="yes">
            <!--  -->
        </xsl:param>
        <xsl:variable name="id" select="replace(tokenize(base-uri(), '/')[last()], '.xml', '')"/>
        <xsl:variable name="baseId" select="replace($id, '-[0-9]{2}$', '')"/>
        <xsl:variable name="localName" select="local-name()"/>
        <xsl:variable name="logicalId">
            <xsl:choose>
                <xsl:when test="$localName = 'laboratorium_uitslag'">
                    <xsl:variable name="kopie_indicator" select="if (kopie_indicator/@value[. = 'true']) then '-C' else ()" as="xs:string?"/>

                    <xsl:value-of select="'labresult-' || (laboratorium_uitslag_identificatie/@value, format-number(count(preceding-sibling::laboratorium_uitslag)+1, '00'))[1] || $kopie_indicator"/>
                </xsl:when>
                <xsl:when test="$localName = 'laboratorium_test'">
                    <!-- The copy-indicator lives at panel level -->
                    <xsl:variable name="kopie_indicator" select="if (../kopie_indicator/@value[. = 'true']) then '-C' else ()" as="xs:string?"/>

                    <xsl:value-of select="'labtest-' || ../laboratorium_uitslag_identificatie/@value || '-' || test_identificatie/@value || $kopie_indicator"/>
                </xsl:when>
                <xsl:when test="$localName = 'monster' and $profile = 'nl-core-LaboratoryTestResult.Specimen.asMicroorganism'">
                    <xsl:value-of select="'organism-' || (@displayName, @code)[1]"/>
                </xsl:when>
                <xsl:when test="$localName = 'monster' and $profile = 'nl-core-LaboratoryTestResult.Specimen'">
                    <xsl:value-of select="'monster-' || string-join((monsternummer/@value, monstervolgnummer/@value, monstermateriaal/@code), '-')"/>
                </xsl:when>
                <xsl:when test="$localName = 'bron_monster' and $profile = 'nl-core-LaboratoryTestResult.Specimen.Source'">
                    <xsl:value-of select="'bron-' || @value"/>
                </xsl:when>
                <xsl:when test="$localName = 'patient'">
                    <xsl:value-of select="'patient-' || string-join((naamgegevens[1]/geslachtsnaam/(voorvoegsels, achternaam)/@value, naamgegevens[1]/geslachtsnaam_partner/(voorvoegsels_partner, achternaam_partner)/@value), '-')"/>
                </xsl:when>
                <xsl:when test="$localName = 'zorgaanbieder' and $profile = 'nl-core-HealthcareProvider'">
                    <xsl:value-of select="'loc-' || (organisatie_locatie/(locatie_nummer, locatie_naam)[1]/@value, afdeling_specialisme/(@displayName, @code))[1] || ((zorgaanbieder_identificatienummer, organisatie_naam)/@value, organisatie_type/(@displayName, @code))[1]"/>
                </xsl:when>
                <xsl:when test="$localName = 'zorgaanbieder' and $profile = 'nl-core-HealthcareProvider-Organization'">
                    <xsl:value-of select="'org-' || ((zorgaanbieder_identificatienummer, organisatie_naam)/@value, organisatie_type/(@displayName, @code))[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$localName"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- Failsafe, ids can get quite long -->
        <xsl:value-of select="nf:assure-logicalid-length(nf:removeSpecialCharacters($logicalId))"/>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template name="_insertFullUrlById">
        <!--  -->
        <xsl:param name="in" select=".">
            <!--  -->
        </xsl:param>
        <xsl:param name="fhirId" select="$in/f:id/@value">
            <!--  -->
        </xsl:param>

        <xsl:variable name="theMetaData" select="$fhirMetadata[nm:logical-id = $fhirId]" as="element()*"/>
        <xsl:choose>
            <xsl:when test="count($theMetaData) = 0">
                <xsl:message terminate="yes">_insertFullUrlById: Nothing found. (<xsl:value-of select="count($fhirId)"/>)</xsl:message>
            </xsl:when>
            <xsl:when test="count($theMetaData) gt 1">
                <xsl:message terminate="no">_insertFullUrlById: Multiple found (<xsl:value-of select="count($theMetaData)"/>): <xsl:value-of select="$fhirId"/> - <xsl:value-of select="$theMetaData/nm:full-url"/></xsl:message>
            </xsl:when>
        </xsl:choose>

        <xsl:variable name="fullUrl" select="$theMetaData/nm:full-url"/>

        <xsl:if test="string-length($fullUrl) gt 0">
            <fullUrl value="{$fullUrl}" xmlns="http://hl7.org/fhir"/>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
