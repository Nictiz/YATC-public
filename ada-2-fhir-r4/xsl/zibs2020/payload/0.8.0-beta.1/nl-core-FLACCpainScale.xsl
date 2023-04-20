<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255688914540200">
    <!-- ================================================================== -->
    <!--
        Converts ada flaccpijn_score to FHIR Observation conforming to profile nl-core-FLACCpainScale
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

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- ================================================================== -->

    <xsl:template match="flaccpijn_score" name="nl-core-FLACCpainScale" mode="nl-core-FLACCpainScale" as="element(f:Observation)?">
        <!-- Create an nl-core-FLACCpainScale instance as an Observation FHIR instance from ada flaccpijn_score element. -->
        <xsl:param name="in" select="." as="element()?">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="subject" select="patient/*" as="element()?"/>

        <xsl:for-each select="$in">
            <Observation xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId">
                    <xsl:with-param name="profile" select="'nl-core-FLACCpainScale'"/>
                </xsl:call-template>

                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-FLACCpainScale"/>
                </meta>
                <status value="final"/>
                <code>
                    <coding>
                        <system value="http://snomed.info/sct"/>
                        <code value="108291000146105"/>
                        <display value="FLACC-pijnmeetinstrument"/>
                    </coding>
                </code>
                <xsl:call-template name="makeReference">
                    <xsl:with-param name="in" select="$subject"/>
                    <xsl:with-param name="wrapIn" select="'subject'"/>
                </xsl:call-template>
                <xsl:for-each select="score_datum_tijd">
                    <effectiveDateTime>
                        <xsl:call-template name="date-to-datetime">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </effectiveDateTime>
                </xsl:for-each>
                <xsl:for-each select="totaal_score">
                    <valueInteger>
                        <xsl:attribute name="value">
                            <xsl:value-of select="@value"/>
                        </xsl:attribute>
                    </valueInteger>
                </xsl:for-each>
                <xsl:for-each select="toelichting">
                    <note>
                        <text>
                            <xsl:call-template name="string-to-string">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </text>
                    </note>
                </xsl:for-each>
                <xsl:for-each select="gezicht">
                    <component>
                        <code>
                            <coding>
                                <system value="urn:oid:2.16.840.1.113883.2.4.3.11.60.40.4.0.1"/>
                                <code value="12013003"/>
                                <display value="FLACCpijnScore Gezicht"/>
                            </coding>
                        </code>
                        <valueCodeableConcept>
                            <xsl:call-template name="code-to-CodeableConcept">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </valueCodeableConcept>
                    </component>
                </xsl:for-each>
                <xsl:for-each select="benen">
                    <component>
                        <code>
                            <coding>
                                <system value="urn:oid:2.16.840.1.113883.2.4.3.11.60.40.4.0.1"/>
                                <code value="12013004"/>
                                <display value="FLACCpijnScore Benen"/>
                            </coding>
                        </code>
                        <valueCodeableConcept>
                            <xsl:call-template name="code-to-CodeableConcept">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </valueCodeableConcept>
                    </component>
                </xsl:for-each>
                <xsl:for-each select="activiteit">
                    <component>
                        <code>
                            <coding>
                                <system value="urn:oid:2.16.840.1.113883.2.4.3.11.60.40.4.0.1"/>
                                <code value="12013005"/>
                                <display value="FLACCpijnScore Activiteit"/>
                            </coding>
                        </code>
                        <valueCodeableConcept>
                            <xsl:call-template name="code-to-CodeableConcept">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </valueCodeableConcept>
                    </component>
                </xsl:for-each>
                <xsl:for-each select="huilen">
                    <component>
                        <code>
                            <coding>
                                <system value="urn:oid:2.16.840.1.113883.2.4.3.11.60.40.4.0.1"/>
                                <code value="12013006"/>
                                <display value="FLACCpijnScore Huilen"/>
                            </coding>
                        </code>
                        <valueCodeableConcept>
                            <xsl:call-template name="code-to-CodeableConcept">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </valueCodeableConcept>
                    </component>
                </xsl:for-each>
                <xsl:for-each select="troostbaar">
                    <component>
                        <code>
                            <coding>
                                <system value="urn:oid:2.16.840.1.113883.2.4.3.11.60.40.4.0.1"/>
                                <code value="12013009"/>
                                <display value="FLACCpijnScore Troostbaar"/>
                            </coding>
                        </code>
                        <valueCodeableConcept>
                            <xsl:call-template name="code-to-CodeableConcept">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </valueCodeableConcept>
                    </component>
                </xsl:for-each>
            </Observation>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
