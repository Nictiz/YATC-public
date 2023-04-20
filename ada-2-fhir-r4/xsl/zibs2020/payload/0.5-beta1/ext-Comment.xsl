<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255636099650200">
    <!-- ================================================================== -->
    <!--
        Converts ada string to FHIR extension conforming to profile ext-Comment
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

    <xsl:template match="*" name="ext-Comment" mode="ext-Comment" as="element()?">
        <!-- Template for shared extension http://nictiz.nl/fhir/StructureDefinition/ext-Comment -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- Optional. Ada element containing a string -->
        </xsl:param>
        <xsl:for-each select="$in[string-length(@value) gt 0]">
            <extension url="{$urlExtComment}" xmlns="http://hl7.org/fhir">
                <valueString value="{@value}"/>
            </extension>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
