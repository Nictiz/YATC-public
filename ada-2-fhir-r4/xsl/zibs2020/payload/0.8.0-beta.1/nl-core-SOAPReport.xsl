<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.202304190825569858260200">
    <!-- ================================================================== -->
    <!--
        Converts ada soepverslag to FHIR Composition conforming to profile nl-core-SOAPReport and FHIR Observation conforming to profile nl-core-SOAPReport.SOAPLine
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

    <xsl:template match="soepverslag" name="nl-core-SOAPReport" mode="nl-core-SOAPReport" as="element(f:Composition)?">
        <!-- Create a FHIR Composition instance conforming to profile nl-core-SOAPReport from ada soepverslag element. -->
        <xsl:param name="in" select="." as="element()?">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="subject" select="patient/*" as="element()?">
            <!-- Optional ADA instance or ADA reference element for the patient. -->
        </xsl:param>
        <xsl:param name="author" select="auteur/*" as="element()?">
            <!-- Optional ADA instance or ADA reference element for the author. -->
        </xsl:param>

        <xsl:for-each select="$in">
            <Composition xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId"/>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-SOAPReport"/>
                </meta>
                <!--Unless the status is explicitly recorded it is expected that only _final_ reports are exchanged.-->
                <status value="final"/>
                <type>
                    <coding>
                        <system value="http://snomed.info/sct"/>
                        <code value="11591000146107"/>
                        <display value="patiëntcontactverslag"/>
                    </coding>
                </type>
                <xsl:for-each select="soepverslag_datum_tijd">
                    <date>
                        <xsl:attribute name="value">
                            <xsl:call-template name="format2FHIRDate">
                                <xsl:with-param name="dateTime" select="xs:string(./@value)"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </date>
                </xsl:for-each>
                <xsl:call-template name="makeReference">
                    <xsl:with-param name="in" select="$subject"/>
                    <xsl:with-param name="wrapIn" select="'subject'"/>
                </xsl:call-template>
                <xsl:for-each select="auteur/*">
                    <xsl:call-template name="makeReference">
                        <xsl:with-param name="profile" select="'nl-core-HealthProfessional-PractitionerRole'"/>
                        <xsl:with-param name="wrapIn" select="'author'"/>
                    </xsl:call-template>
                </xsl:for-each>
                <title>
                    <xsl:attribute name="value">
                        <!-- Suggested value is the ICPC display name on the E-entry -->
                        <xsl:choose>
                            <xsl:when test="soepregel[soepregel_naam/@code = '129265001'][1]/soepregel_code/@displayName">
                                <xsl:value-of select="soepregel[soepregel_naam/@code = '129265001'][1]/soepregel_code/@displayName"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>SOEP-verslag</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </title>
                <xsl:for-each select="soepregel">
                    <section>
                        <xsl:for-each select="soepregel_naam">
                            <code>
                                <xsl:call-template name="code-to-CodeableConcept">
                                    <xsl:with-param name="in" select="."/>
                                </xsl:call-template>
                            </code>
                        </xsl:for-each>
                        <xsl:for-each select="soepregel_tekst">
                            <xsl:variable name="parts" as="item()*">
                                <xsl:text>SOAPLineText:</xsl:text>
                                <xsl:value-of select="@value"/>
                                <xsl:if test="preceding-sibling::soepregel_code[@displayName]">
                                    <xsl:value-of select="concat('(SOAPLineCode: ', preceding-sibling::soepregel_code/@displayName, ')')"/>
                                </xsl:if>
                            </xsl:variable>
                            <text>
                                <status value="generated"/>
                                <div xmlns="http://www.w3.org/1999/xhtml">
                                    <xsl:value-of select="string-join($parts[. != ''], ' ')"/>
                                </div>
                            </text>
                        </xsl:for-each>
                        <xsl:call-template name="makeReference">
                            <xsl:with-param name="in" select="."/>
                            <xsl:with-param name="wrapIn" select="'entry'"/>
                        </xsl:call-template>
                    </section>
                </xsl:for-each>
            </Composition>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="soepregel" name="nl-core-SOAPReport.SOAPLine" mode="nl-core-SOAPReport.SOAPLine" as="element(f:Observation)?">
        <xsl:param name="in" select="." as="element()?"/>

        <xsl:for-each select="$in">
            <Observation xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId"/>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-SOAPReport.SOAPLine"/>
                </meta>
                <xsl:for-each select="soepregel_code">
                    <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-SOAPReport.SOAPLineCode">
                        <valueCodeableConcept>
                            <xsl:call-template name="code-to-CodeableConcept">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </valueCodeableConcept>
                    </extension>
                </xsl:for-each>
                <status value="final"/>
                <xsl:for-each select="soepregel_naam">
                    <code>
                        <xsl:call-template name="code-to-CodeableConcept">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </code>
                </xsl:for-each>
                <xsl:for-each select="soepregel_tekst">
                    <valueString>
                        <xsl:call-template name="string-to-string">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </valueString>
                </xsl:for-each>
            </Observation>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="soepverslag" mode="_generateDisplay">
        <!-- Template to generate a display that can be shown when referencing this instance. -->
        <xsl:variable name="parts" as="item()*">
            <xsl:text>SOAP report</xsl:text>
            <xsl:if test="soepverslag_datum_tijd[@value]">
                <xsl:value-of select="concat('date ', soepverslag_datum_tijd/@value)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="soepregel" mode="_generateDisplay">
        <!-- Template to generate a display that can be shown when referencing this instance. -->
        <xsl:variable name="parts" as="item()*">
            <xsl:text>SOAP line observation</xsl:text>
            <xsl:value-of select="soepregel_naam/@displayName"/>
            <xsl:if test="soepregel_code/@displayName">
                <xsl:value-of select="concat('code ', soepregel_code/@displayName)"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
    </xsl:template>
</xsl:stylesheet>
