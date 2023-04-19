<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255655909030200" xmlns:nm="http://www.nictiz.nl/mappings">
    <!-- ================================================================== -->
    <!--
        Converts ada zorgaanbieder to FHIR resource conforming to profile nl-core-HealthcareProvider
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

    <xsl:variable name="profilenameHealthcareProvider">nl-core-HealthcareProvider</xsl:variable>
    <xsl:variable name="profilenameHealthcareProviderOrganization">nl-core-HealthcareProvider-Organization</xsl:variable>

    <!-- ================================================================== -->

    <xsl:template match="zorgaanbieder[not(zorgaanbieder)]" mode="nl-core-HealthcareProvider" name="nl-core-HealthcareProvider" as="element(f:Location)?">
        <!-- Produces a Location resource based on nl-core-HealthcareProvider -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>

        <xsl:for-each select="$in">
            <Location xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId">
                    <xsl:with-param name="profile" select="$profilenameHealthcareProvider"/>
                </xsl:call-template>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider"/>
                </meta>

                <xsl:for-each select="organisatie_locatie/locatie_naam">
                    <name>
                        <xsl:attribute name="value">
                            <xsl:call-template name="string-to-string"/>
                        </xsl:attribute>
                    </name>
                </xsl:for-each>

                <xsl:for-each select="organisatie_locatie/locatie_nummer">
                    <name>
                        <xsl:attribute name="value">
                            <xsl:call-template name="string-to-string"/>
                        </xsl:attribute>
                    </name>
                </xsl:for-each>

                <xsl:call-template name="nl-core-ContactInformation">
                    <xsl:with-param name="in" select="contactgegevens"/>
                </xsl:call-template>

                <xsl:call-template name="nl-core-AddressInformation">
                    <xsl:with-param name="in" select="adresgegevens"/>
                </xsl:call-template>

                <xsl:call-template name="makeReference">
                    <xsl:with-param name="in" select="."/>
                    <xsl:with-param name="profile" select="'nl-core-HealthcareProvider-Organization'"/>
                    <xsl:with-param name="wrapIn" select="'managingOrganization'"/>
                </xsl:call-template>
            </Location>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="zorgaanbieder[not(zorgaanbieder)]" mode="nl-core-HealthcareProvider-Organization" name="nl-core-HealthcareProvider-Organization" as="element(f:Organization)?">
        <!-- Produces an Organization resource based on nl-core-HealthcareProvider-Organization -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>

        <xsl:for-each select="$in">
            <Organization xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId">
                    <xsl:with-param name="profile" select="$profilenameHealthcareProviderOrganization"/>
                </xsl:call-template>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-HealthcareProvider-Organization"/>
                </meta>
                <xsl:for-each select="zorgaanbieder_identificatienummer[@value]">
                    <identifier>
                        <xsl:call-template name="id-to-Identifier">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </identifier>
                </xsl:for-each>

                <xsl:for-each select="organisatie_type | afdeling_specialisme">
                    <type>
                        <xsl:call-template name="code-to-CodeableConcept">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </type>
                </xsl:for-each>

                <xsl:for-each select="organisatie_naam">
                    <name>
                        <xsl:attribute name="value">
                            <xsl:call-template name="string-to-string"/>
                        </xsl:attribute>
                    </name>
                </xsl:for-each>

                <xsl:call-template name="nl-core-ContactInformation">
                    <xsl:with-param name="in" select="contactgegevens"/>
                </xsl:call-template>

                <xsl:call-template name="nl-core-AddressInformation">
                    <xsl:with-param name="in" select="adresgegevens"/>
                </xsl:call-template>
            </Organization>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="zorgaanbieder" mode="_generateDisplay">
        <!-- Template to generate a display that can be shown when referencing a HealthcareProvider, both to a Location and an Organization resource -->
        <xsl:param name="profile" required="yes" as="xs:string">
            <!-- Parameter to indicate for which target profile a display is to be generated. -->
        </xsl:param>

        <xsl:choose>
            <xsl:when test="$profile = $profilenameHealthcareProvider">
                <xsl:variable name="parts" as="item()*">
                    <xsl:text>Healthcare provider (location)</xsl:text>
                    <xsl:value-of select="organisatie_naam/@value"/>
                    <xsl:value-of select="organisatie_locatie/locatie_naam/@value"/>
                    <xsl:if test="not(organisatie_naam/@value | organisatie_locatie/locatie_naam/@value)">
                        <xsl:value-of select="concat('organisation-id ', zorgaanbieder_identificatienummer/@value, ' in system ', zorgaanbieder_identificatienummer/@root)"/>
                    </xsl:if>
                    <xsl:value-of select="toelichting/@value"/>
                </xsl:variable>
                <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
            </xsl:when>
            <xsl:when test="$profile = $profilenameHealthcareProviderOrganization">
                <xsl:variable name="parts" as="item()*">
                    <xsl:text>Healthcare provider (organization)</xsl:text>
                    <xsl:value-of select="organisatie_naam/@value"/>
                    <xsl:if test="not(organisatie_naam/@value)">
                        <xsl:value-of select="concat('organisation-id ', zorgaanbieder_identificatienummer/@value, ' in system ', zorgaanbieder_identificatienummer/@root)"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="zorgaanbieder" mode="_generateId">
        <!-- Template to generate a unique id to identify a HealthProfessional present in a (set of) ada-instance(s) -->
        <xsl:param name="profile" required="yes" as="xs:string">
            <!-- Parameter to indicate for which target profile an id is to be generated. -->
        </xsl:param>
        <xsl:param name="partNumber" as="xs:integer" select="0">
            <!-- The sequence number of the ADA instance being passed in the total collection of ADA instances of this kind. This sequence number is needed for uniqueness of ids in resources. -->
        </xsl:param>
        <xsl:param name="fullUrl" tunnel="yes">
            <!-- If the HealthProvider is identified by fullUrl, this optional parameter can be used as fallback for an id -->
        </xsl:param>

        <xsl:variable name="organizationLocation" select="(organisatie_locatie/locatie_naam/@value[not(. = '')], 'Location')[1]"/>

        <!-- we can use zorgaanbieder_identificatienummer as logicalId, from partNumber 2 onwards, we append the partNumber for uniqueness purposes -->
        <xsl:variable name="currentZaId" select="nf:ada-healthprovider-id(zorgaanbieder_identificatienummer)"/>

        <xsl:variable name="uniqueString" as="xs:string*">
            <xsl:choose>
                <xsl:when test="$currentZaId[@value | @root]">
                    <xsl:for-each select="($currentZaId[@value | @root])[1]">
                        <!-- use append for Organization to also create stable id based on identifier, but make it unique cause Location uses the same -->
                        <xsl:if test="$profile = $profilenameHealthcareProviderOrganization">Org-</xsl:if>
                        <!-- we remove '.' in root oid and '_' in extension to enlarge the chance of staying in 64 chars -->
                        <xsl:value-of select="concat(replace(@root, '\.', ''), '-', replace(@value, '_', ''))"/>
                        <xsl:if test="$partNumber gt 1">
                            <xsl:value-of select="concat('-', $partNumber)"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:next-match>
                        <xsl:with-param name="profile" select="$profile"/>
                    </xsl:next-match>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:apply-templates select="." mode="generateLogicalId">
            <xsl:with-param name="uniqueString" select="string-join($uniqueString, '')"/>
            <xsl:with-param name="profile" select="$profile"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:function name="nf:ada-healthprovider-id" as="element()?">
        <!-- Selects the most appropriate health provider identification. For example to do deduplication of organizations or to base a logicalId on. -->
        <xsl:param name="healthcareProviderIdentification" as="element()*">
            <!-- ADA element containing the healthcare provider organization identification -->
        </xsl:param>
        <xsl:choose>
            <xsl:when test="$healthcareProviderIdentification[@root = $oidURAOrganizations]">
                <xsl:copy-of select="$healthcareProviderIdentification[@root = $oidURAOrganizations][1]"/>
            </xsl:when>
            <xsl:when test="$healthcareProviderIdentification[@root = $oidAGB]">
                <xsl:copy-of select="$healthcareProviderIdentification[@root = $oidAGB][1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$healthcareProviderIdentification[1]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
