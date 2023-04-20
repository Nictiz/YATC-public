<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255693897870200" xmlns:nm="http://www.nictiz.nl/mappings">
    <!-- ================================================================== -->
    <!--
        Converts ada juridische_situatie to FHIR Condition conforming to either profile nl-core-LegalSituation-LegalStatus or nl-core-LegalSituation-Representation
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

    <xsl:template match="juridische_situatie" name="nl-core-LegalSituation-LegalStatus" mode="nl-core-LegalSituation-LegalStatus" as="element(f:Condition)?">
        <!-- Create an nl-core-LegalSituation-LegalStatus FHIR instance from an ada juridische_situatie element. -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="subject" select="patient" as="element()?">
            <!-- The subject as ADA element or reference. -->
        </xsl:param>

        <xsl:for-each select="$in[juridische_status]">
            <Condition xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId">
                    <xsl:with-param name="profile" select="'nl-core-LegalSituation-LegalStatus'"/>
                </xsl:call-template>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-LegalSituation-LegalStatus"/>
                </meta>
                <xsl:if test="datum_einde">
                    <clinicalStatus>
                        <coding>
                            <system value="http://terminology.hl7.org/CodeSystem/condition-clinical"/>
                            <code value="inactive"/>
                            <display value="Inactive"/>
                        </coding>
                    </clinicalStatus>
                </xsl:if>
                <category>
                    <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="303186005"/>
                        <display value="juridische status van patiënt"/>
                    </coding>
                </category>
                <xsl:for-each select="juridische_status">
                    <code>
                        <xsl:call-template name="code-to-CodeableConcept">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </code>
                </xsl:for-each>
                <xsl:call-template name="makeReference">
                    <xsl:with-param name="in" select="$subject"/>
                    <xsl:with-param name="wrapIn" select="'subject'"/>
                </xsl:call-template>
                <xsl:for-each select="datum_aanvang">
                    <onsetDateTime>
                        <xsl:attribute name="value">
                            <xsl:call-template name="format2FHIRDate">
                                <xsl:with-param name="dateTime" select="xs:string(./@value)"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </onsetDateTime>
                </xsl:for-each>
                <xsl:for-each select="datum_einde">
                    <abatementDateTime>
                        <xsl:attribute name="value">
                            <xsl:call-template name="format2FHIRDate">
                                <xsl:with-param name="dateTime" select="xs:string(./@value)"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </abatementDateTime>
                </xsl:for-each>
            </Condition>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="juridische_situatie" name="nl-core-LegalSituation-Representation" mode="nl-core-LegalSituation-Representation" as="element(f:Condition)?">
        <!-- Create an nl-core-LegalSituation-Representation FHIR instance from an ada juridische_situatie element. -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="subject" select="patient" as="element()?">
            <!-- Optional ADA instance or ADA reference element for the patient. -->
        </xsl:param>

        <xsl:for-each select="$in[vertegenwoordiging]">
            <Condition xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId">
                    <xsl:with-param name="profile" select="'nl-core-LegalSituation-Representation'"/>
                </xsl:call-template>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-LegalSituation-Representation"/>
                </meta>
                <xsl:if test="datum_einde">
                    <clinicalStatus>
                        <coding>
                            <system value="http://terminology.hl7.org/CodeSystem/condition-clinical"/>
                            <code value="inactive"/>
                            <display value="Inactive"/>
                        </coding>
                    </clinicalStatus>
                </xsl:if>
                <category>
                    <coding>
                        <system value="{$oidMap[@oid=$oidSNOMEDCT]/@uri}"/>
                        <code value="151701000146105"/>
                        <display value="type voogd"/>
                    </coding>
                </category>
                <xsl:for-each select="vertegenwoordiging">
                    <code>
                        <xsl:call-template name="code-to-CodeableConcept">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </code>
                </xsl:for-each>
                <xsl:call-template name="makeReference">
                    <xsl:with-param name="in" select="$subject"/>
                    <xsl:with-param name="wrapIn" select="'subject'"/>
                </xsl:call-template>
                <xsl:for-each select="datum_aanvang">
                    <onsetDateTime>
                        <xsl:attribute name="value">
                            <xsl:call-template name="format2FHIRDate">
                                <xsl:with-param name="dateTime" select="xs:string(./@value)"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </onsetDateTime>
                </xsl:for-each>
                <xsl:for-each select="datum_einde">
                    <abatementDateTime>
                        <xsl:attribute name="value">
                            <xsl:call-template name="format2FHIRDate">
                                <xsl:with-param name="dateTime" select="xs:string(./@value)"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </abatementDateTime>
                </xsl:for-each>
            </Condition>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="juridische_situatie" mode="_generateDisplay">
        <!-- Template to generate a display that can be shown when referencing this instance. -->
        <xsl:param name="profile" required="yes" as="xs:string">
            <!-- Parameter to indicate for which target profile a display is to be generated. -->
        </xsl:param>

        <xsl:choose>
            <xsl:when test="$profile = 'nl-core-LegalSituation-LegalStatus'">
                <xsl:variable name="parts" as="item()*">
                    <xsl:text>Legal situation</xsl:text>
                    <xsl:if test="juridische_status/@displayName">
                        <xsl:value-of select="concat('legal status: ',juridische_status/@displayName)"/>
                    </xsl:if>
                    <xsl:if test="datum_aanvang[@value]">
                        <xsl:value-of select="concat('from ', datum_aanvang/@value)"/>
                    </xsl:if>
                    <xsl:if test="datum_einde[@value]">
                        <xsl:value-of select="concat('until ', datum_einde/@value)"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
            </xsl:when>
            <xsl:when test="$profile = 'nl-core-LegalSituation-Representation'">
                <xsl:variable name="parts" as="item()*">
                    <xsl:text>Legal situation</xsl:text>
                    <xsl:if test="vertegenwoordiging/@displayName">
                        <xsl:value-of select="concat('representation: ',vertegenwoordiging/@displayName)"/>
                    </xsl:if>
                    <xsl:if test="datum_aanvang[@value]">
                        <xsl:value-of select="concat('from ', datum_aanvang/@value)"/>
                    </xsl:if>
                    <xsl:if test="datum_einde[@value]">
                        <xsl:value-of select="concat('until ', datum_einde/@value)"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
            </xsl:when>
        </xsl:choose>

    </xsl:template>
</xsl:stylesheet>
