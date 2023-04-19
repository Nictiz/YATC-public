<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.202304190825564833440200" xmlns:nm="http://www.nictiz.nl/mappings">
    <!-- ================================================================== -->
    <!--
        Converts ADA zorg_team to FHIR CareTeam conforming to profile
            nl-core-CareTeam
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

    <xsl:template match="zorg_team" name="nl-core-CareTeam" mode="nl-core-CareTeam" as="element(f:CareTeam)">
        <!-- Create a nl-core-CareTeam instance as a CareTeam FHIR instance from ADA zorg_team. -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
        <xsl:param name="subject" as="element()?">
            <!-- Optional ADA instance or ADA reference element for the patient. -->
        </xsl:param>

        <xsl:for-each select="$in">
            <CareTeam xmlns="http://hl7.org/fhir">
                <xsl:call-template name="insertLogicalId"/>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/nl-core-CareTeam"/>
                </meta>

                <xsl:for-each select="zorg_team_naam">
                    <name value="{normalize-space(@value)}"/>
                </xsl:for-each>
                <xsl:for-each select="zorg_team_lid/contactpersoon">
                    <participant>
                        <member>
                            <xsl:call-template name="makeReference">
                                <xsl:with-param name="in" select="contactpersoon"/>
                                <xsl:with-param name="profile" select="'nl-core-ContactPerson'"/>
                            </xsl:call-template>
                        </member>
                    </participant>
                </xsl:for-each>
                <xsl:for-each select="zorg_team_lid/patient">
                    <participant>
                        <member>
                            <xsl:call-template name="makeReference">
                                <xsl:with-param name="in" select="patient"/>
                                <xsl:with-param name="profile" select="'nl-core-Patient'"/>
                            </xsl:call-template>
                        </member>
                    </participant>
                </xsl:for-each>
                <xsl:for-each select="zorg_team_lid/zorgverlener">
                    <participant>
                        <member>
                            <xsl:call-template name="makeReference">
                                <xsl:with-param name="in" select="zorgverlener"/>
                                <xsl:with-param name="profile" select="'nl-core-HealthProfessional-PractitionerRole'"/>
                            </xsl:call-template>
                        </member>
                    </participant>
                </xsl:for-each>
                <xsl:for-each select="probleem">
                    <reasonReference>
                        <xsl:call-template name="makeReference">
                            <xsl:with-param name="in" select="probleem"/>
                            <xsl:with-param name="profile" select="'nl-core-Problem'"/>
                        </xsl:call-template>
                    </reasonReference>
                </xsl:for-each>
            </CareTeam>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="zorg_team" mode="_generateDisplay">
        <!-- Template to generate a display that can be shown when referencing this instance. -->
        <xsl:variable name="parts" as="item()*">
            <xsl:text>Care team</xsl:text>
            <xsl:value-of select="zorg_team_naam/@value"/>
        </xsl:variable>
        <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
    </xsl:template>
</xsl:stylesheet>
