<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255657802690200">
    <!-- ================================================================== -->
    <!--
        Converts ada functie_horen to FHIR Observation conforming to profile nl-core-HearingFunction, FHIR DeviceUseStatement conforming to profile nl-core-HearingFunction.HearingAid and FHIR Device conforming to profile nl-core-HearingFunction.HearingAid.Product
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

    <xsl:template match="functie_horen" name="nl-core-HearingFunction" mode="nl-core-HearingFunction" as="element(f:Observation)?">
        <!-- Create an nl-core-HearingFunction instance as an Observation FHIR instance from ada functie_horen element. -->
        <xsl:param name="in" select="." as="element()?">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="subject" select="patient/*" as="element()?">
            <!-- Optional ADA instance or ADA reference element for the patient. -->
        </xsl:param>

        <xsl:for-each select="$in">
            <Observation xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId">
                    <xsl:with-param name="profile" select="'nl-core-HearingFunction'"/>
                </xsl:call-template>

                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-HearingFunction"/>
                </meta>
                <status value="final"/>
                <code>
                    <coding>
                        <system value="http://snomed.info/sct"/>
                        <code value="47078008"/>
                        <display value="gehoorfunctie"/>
                    </coding>
                </code>
                <xsl:call-template name="makeReference">
                    <xsl:with-param name="in" select="$subject"/>
                    <xsl:with-param name="wrapIn" select="'subject'"/>
                </xsl:call-template>
                <xsl:for-each select="hoor_functie">
                    <valueCodeableConcept>
                        <xsl:call-template name="code-to-CodeableConcept">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </valueCodeableConcept>
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
            </Observation>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="horen_hulpmiddel/medisch_hulpmiddel" name="nl-core-HearingFunction.HearingAid" mode="nl-core-HearingFunction.HearingAid" as="element(f:DeviceUseStatement)?">
        <!-- Create an nl-core-HearingFunction.HearingAid instance as a DeviceUseStatement FHIR instance from ada horen_hulpmiddel/medisch_hulpmiddel element. -->
        <xsl:param name="in" select="." as="element()?">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="subject" select="patient/*" as="element()?">
            <!-- Optional ADA instance or ADA reference element for the patient. -->
        </xsl:param>
        <xsl:param name="reasonReference" select="ancestor::functie_horen">
            <!-- ADA instance used to populate the reasonReference element in the MedicalDevice. -->
        </xsl:param>

        <xsl:call-template name="nl-core-MedicalDevice">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="profile" select="'nl-core-HearingFunction.HearingAid'"/>
            <xsl:with-param name="reasonReference" select="$reasonReference"/>
        </xsl:call-template>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="product" name="nl-core-HearingFunction.HearingAid.Product" mode="nl-core-HearingFunction.HearingAid.Product" as="element(f:Device)?">
        <!-- Create an nl-core-HearingFunction.HearingAid.Product instance as a Device FHIR instance from ada product element. -->
        <xsl:param name="in" select="." as="element()?">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="subject" select="patient/*" as="element()?">
            <!-- Optional ADA instance or ADA reference element for the patient. -->
        </xsl:param>

        <xsl:call-template name="nl-core-MedicalDevice.Product">
            <xsl:with-param name="subject" select="$subject"/>
            <xsl:with-param name="profile" select="'nl-core-HearingFunction.HearingAid.Product'"/>
        </xsl:call-template>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="functie_horen" mode="_generateDisplay">
        <!-- Template to generate a display that can be shown when referencing this instance. -->
        <xsl:variable name="parts" as="item()*">
            <xsl:text>Hearing function observation</xsl:text>
            <xsl:if test="hoor_functie[@displayName]">
                <xsl:value-of select="hoor_functie/@displayName"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
    </xsl:template>
</xsl:stylesheet>
