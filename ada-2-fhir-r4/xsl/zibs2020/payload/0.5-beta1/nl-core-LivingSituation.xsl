<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255659397570200" xmlns:nm="http://www.nictiz.nl/mappings">
    <!-- ================================================================== -->
    <!--
        Converts ADA woonsituatie to FHIR Observation conforming to profile nl-core-LivingSituation
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

    <xsl:template match="woonsituatie" name="nl-core-LivingSituation" mode="nl-core-LivingSituation" as="element(f:Observation)">
        <!-- Create an nl-core-LivingSituation instance as an Observation FHIR instance from ADA woonsituatie. -->
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
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-LivingSituation"/>
                </meta>
                <status value="final"/>

                <code>
                    <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="365508006"/>
                        <display value="Residence and accommodation circumstances - finding"/>
                    </coding>
                </code>

                <xsl:call-template name="makeReference">
                    <xsl:with-param name="in" select="$subject"/>
                    <xsl:with-param name="wrapIn">subject</xsl:with-param>
                </xsl:call-template>

                <xsl:for-each select="woning_type">
                    <valueCodeableConcept>
                        <xsl:call-template name="code-to-CodeableConcept"/>
                    </valueCodeableConcept>
                </xsl:for-each>

                <xsl:for-each select="toelichting">
                    <note>
                        <text>
                            <xsl:attribute name="value" select="./@value"/>
                        </text>
                    </note>
                </xsl:for-each>

                <xsl:for-each select="woning_aanpassing">
                    <component>
                        <code>
                            <coding>
                                <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                                <code value="118871000146108"/>
                                <display value="Type of home adaptation"/>
                            </coding>
                        </code>
                        <valueCodeableConcept>
                            <xsl:call-template name="code-to-CodeableConcept"/>
                        </valueCodeableConcept>
                    </component>
                </xsl:for-each>

                <xsl:for-each select="woon_omstandigheid">
                    <component>
                        <code>
                            <coding>
                                <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                                <code value="224249004"/>
                                <display value="Characteristics of home environment"/>
                            </coding>
                        </code>
                        <valueCodeableConcept>
                            <xsl:call-template name="code-to-CodeableConcept"/>
                        </valueCodeableConcept>
                    </component>
                </xsl:for-each>
            </Observation>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="woonsituatie" mode="_generateId">
        <!-- Template to generate a unique id to identify this instance. -->
        <xsl:value-of select="concat('nl-core-LivingSituation-', position())"/>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="woonsituatie" mode="_generateDisplay">
        <!-- Template to generate a display that can be shown when referencing this instance. -->
        <xsl:variable name="parts">
            <xsl:for-each select="(woning_type, woning_aanpassing, woon_omstandigheid)">
                <xsl:value-of select="@displayName"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="concat('Woonsituatie: ', string-join($parts, ', '))"/>
    </xsl:template>
</xsl:stylesheet>
