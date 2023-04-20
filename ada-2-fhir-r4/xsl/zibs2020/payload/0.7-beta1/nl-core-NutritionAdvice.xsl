<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255677624290200">
    <!-- ================================================================== -->
    <!--
        Converts ada voedingsadvies to FHIR NutritionOrder conforming to profile nl-core-NutritionAdvice
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

    <xsl:template match="voedingsadvies" name="nl-core-NutritionAdvice" mode="nl-core-NutritionAdvice" as="element(f:NutritionOrder)?">
        <!-- Create an nl-core-NutritionAdvice instance as a NutritionOrder FHIR instance from ada voedingsadvies element. -->
        <xsl:param name="in" select="." as="element()?">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="patient" select="patient/*" as="element()?">
            <!-- Optional ADA instance or ADA reference element for the patient. -->
        </xsl:param>

        <xsl:for-each select="$in">
            <NutritionOrder xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId"/>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-NutritionAdvice"/>
                </meta>
                <xsl:for-each select="indicatie">
                    <extension url="http://hl7.org/fhir/StructureDefinition/workflow-reasonReference">
                        <valueReference>
                            <xsl:call-template name="makeReference">
                                <xsl:with-param name="in" select="probleem"/>
                                <xsl:with-param name="profile" select="'nl-core-Problem'"/>
                            </xsl:call-template>
                        </valueReference>
                    </extension>
                </xsl:for-each>
                <status value="active"/>
                <intent value="order"/>
                <xsl:call-template name="makeReference">
                    <xsl:with-param name="in" select="$patient"/>
                    <xsl:with-param name="wrapIn" select="'patient'"/>
                </xsl:call-template>
                <!--No suitable field to map to dateTime is present in the ada instance, hence current-dateTime is used instead. See https://github.com/Nictiz/Nictiz-R4-zib2020/issues/179.-->
                <dateTime>
                    <xsl:attribute name="value">
                        <xsl:value-of select="current-dateTime()"/>
                    </xsl:attribute>
                </dateTime>
                <oralDiet>
                    <xsl:for-each select="dieet_type">
                        <type>
                            <text>
                                <xsl:call-template name="string-to-string">
                                    <xsl:with-param name="in" select="."/>
                                </xsl:call-template>
                            </text>
                        </type>
                    </xsl:for-each>
                    <xsl:call-template name="util:logMessage">
                        <xsl:with-param name="msg">The zib doesn't provide enough information to determine the right mapping of consistency, as it depends on the type of food (BITS ticket ZIB-1617). Therefore the mapping for solid food is used which may not be right for the information that is transformed.</xsl:with-param>
                        <xsl:with-param name="level">WARN</xsl:with-param>
                        <xsl:with-param name="terminate">false</xsl:with-param>
                    </xsl:call-template>
                    <xsl:for-each select="consistentie">
                        <texture>
                            <modifier>
                                <text>
                                    <xsl:call-template name="string-to-string">
                                        <xsl:with-param name="in" select="."/>
                                    </xsl:call-template>
                                </text>
                            </modifier>
                        </texture>
                        <!--<fluidConsistencyType>
                            <text>
                                <xsl:call-template name="string-to-string">
                                    <xsl:with-param name="in" select="."/>
                                </xsl:call-template>
                            </text>
                        </fluidConsistencyType>-->
                    </xsl:for-each>
                </oralDiet>
                <xsl:for-each select="toelichting">
                    <note>
                        <text>
                            <xsl:call-template name="string-to-string">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </text>
                    </note>
                </xsl:for-each>
            </NutritionOrder>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
