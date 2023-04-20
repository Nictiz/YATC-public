<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255691904940200">
    <!-- ================================================================== -->
    <!--
        Converts ada hulp_van_anderen to FHIR CarePlan conforming to profile nl-core-HelpFromOthers.
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

    <xsl:template match="hulp_van_anderen" name="nl-core-HelpFromOthers" mode="nl-core-HelpFromOthers" as="element(f:CarePlan)?">
        <!-- Create an nl-core-HelpFromOthers instance as an Observation FHIR instance from ada hulp_van_anderen element. -->
        <xsl:param name="in" select="." as="element()?">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="subject" select="patient/*" as="element()?">
            <!-- Optional ADA instance or ADA reference element for the patient. -->
        </xsl:param>

        <xsl:for-each select="$in">
            <CarePlan xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId"/>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-HelpFromOthers"/>
                </meta>

                <status value="active"/>
                <intent value="plan"/>

                <category>
                    <coding>
                        <system value="http://snomed.info/sct"/>
                        <code value="243114000"/>
                        <display value="ondersteuning"/>
                    </coding>
                </category>

                <xsl:call-template name="makeReference">
                    <xsl:with-param name="in" select="$subject"/>
                    <xsl:with-param name="wrapIn" select="'subject'"/>
                </xsl:call-template>

                <activity>
                    <detail>
                        <xsl:for-each select="soort_hulp">
                            <code>
                                <xsl:call-template name="code-to-CodeableConcept">
                                    <xsl:with-param name="in" select="."/>
                                </xsl:call-template>
                            </code>
                        </xsl:for-each>

                        <status value="in-progress"/>

                        <xsl:for-each select="frequentie">
                            <scheduledString>
                                <xsl:call-template name="string-to-string">
                                    <xsl:with-param name="in" select="."/>
                                </xsl:call-template>
                            </scheduledString>
                        </xsl:for-each>

                        <xsl:for-each select="hulpverlener/zorgverlener">
                            <performer>
                                <xsl:call-template name="makeReference">
                                    <xsl:with-param name="in" select="zorgverlener"/>
                                    <xsl:with-param name="profile" select="'nl-core-HealthProfessional-PractitionerRole'"/>
                                </xsl:call-template>
                            </performer>
                        </xsl:for-each>
                        <xsl:for-each select="hulpverlener/mantelzorger">
                            <performer>
                                <xsl:call-template name="makeReference">
                                    <xsl:with-param name="in" select="contactpersoon"/>
                                    <xsl:with-param name="profile" select="'nl-core-ContactPerson'"/>
                                </xsl:call-template>
                            </performer>
                        </xsl:for-each>
                        <xsl:for-each select="hulpverlener/zorgaanbieder">
                            <performer>
                                <xsl:call-template name="makeReference">
                                    <xsl:with-param name="in" select="zorgaanbieder"/>
                                    <xsl:with-param name="profile" select="'nl-core-HealthcareProvider-Organization'"/>
                                </xsl:call-template>
                            </performer>
                        </xsl:for-each>

                        <xsl:for-each select="aard">
                            <description>
                                <xsl:call-template name="string-to-string">
                                    <xsl:with-param name="in" select="."/>
                                </xsl:call-template>
                            </description>
                        </xsl:for-each>
                    </detail>
                </activity>

                <xsl:for-each select="toelichting">
                    <note>
                        <text>
                            <xsl:call-template name="string-to-string">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </text>
                    </note>
                </xsl:for-each>
            </CarePlan>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="hulp_van_anderen" mode="_generateDisplay">
        <!-- Template to generate a display that can be shown when referencing this instance. -->
        <xsl:variable name="parts">
            <xsl:text>Help from others: </xsl:text>
            <xsl:if test="aard/@value">
                <xsl:value-of select="aard/@value"/>
            </xsl:if>
            <xsl:if test="frequentie/@value">
                <xsl:value-of select="frequentie/@value"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="string-join($parts, ', ')"/>
    </xsl:template>
</xsl:stylesheet>
