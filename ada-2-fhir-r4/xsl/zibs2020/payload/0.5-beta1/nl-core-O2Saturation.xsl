<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255662786010200" xmlns:nm="http://www.nictiz.nl/mappings">
    <!-- ================================================================== -->
    <!--
        Converts ADA o2saturatie to FHIR Observation conforming to profile nl-core-o2saturation
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

    <xsl:template match="o2saturatie" name="nl-core-O2Saturation" mode="nl-core-O2Saturation" as="element(f:Observation)">
        <!-- Create a nl-core-O2Saturation instance as a Observation FHIR instance from ADA o2saturatie. -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="subject" as="element()?">
            <!-- The subject as ADA element or reference. -->
        </xsl:param>

        <xsl:for-each select="$in">
            <Observation xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId"/>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-O2Saturation"/>
                </meta>
                <status value="final"/>
                <category>
                    <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/observation-category"/>
                        <code value="vital-signs"/>
                        <display value="Vital Signs"/>
                    </coding>
                </category>
                <code>
                    <coding>
                        <system value="http://loinc.org"/>
                        <code value="2708-6"/>
                        <display value="Oxygen saturation in Arterial blood"/>
                    </coding>
                    <coding>
                        <system value="http://loinc.org"/>
                        <code value="59408-5"/>
                        <display value="Oxygen saturation in Arterial blood by Pulse oximetry"/>
                    </coding>
                </code>
                <xsl:call-template name="makeReference">
                    <xsl:with-param name="in" select="$subject"/>
                    <xsl:with-param name="wrapIn" select="'subject'"/>
                </xsl:call-template>
                <xsl:for-each select="o2saturatie_datum_tijd">
                    <effectiveDateTime>
                        <xsl:call-template name="date-to-datetime">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </effectiveDateTime>
                </xsl:for-each>
                <xsl:for-each select="sp_o2waarde">
                    <valueQuantity>
                        <xsl:call-template name="hoeveelheid-to-Quantity">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </valueQuantity>
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
                <xsl:for-each select="extra_zuurstof_toediening">
                    <component>
                        <code>
                            <coding>
                                <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                                <code value="57485005"/>
                                <display value="zuurstoftherapie"/>
                            </coding>
                        </code>
                        <valueBoolean>
                            <xsl:call-template name="boolean-to-boolean">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </valueBoolean>
                    </component>
                </xsl:for-each>
            </Observation>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="o2saturatie" mode="_generateDisplay">
        <!-- Template to generate a display that can be shown when referencing this instance. -->
        <xsl:variable name="parts" as="item()*">
            <xsl:text>O2 saturation observation</xsl:text>
            <xsl:if test="o2saturatie_datum_tijd[@value]">
                <xsl:value-of select="concat('measurement date ', o2saturatie_datum_tijd/@value)"/>
            </xsl:if>
            <xsl:value-of select="toelichting/@value"/>
        </xsl:variable>
        <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
    </xsl:template>
</xsl:stylesheet>
