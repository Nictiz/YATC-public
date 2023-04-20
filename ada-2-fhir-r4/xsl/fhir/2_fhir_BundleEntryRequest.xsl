<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="urn:fhir:stu3:functions">
    <!-- ================================================================== -->
    <!--
        TBD
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

    <xsl:import href="2_fhir_BundleEntrySearch.xsl"/>

    <xsl:param name="populateId" select="false()" as="xs:boolean"/>

    <!-- ================================================================== -->

    <xsl:template match="f:resource" mode="addBundleEntrySearchOrRequest">
        <!-- Add Bundle.entry.request -->
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
        <request xmlns="http://hl7.org/fhir">
            <method value="POST"/>
            <url value="{*/local-name()}"/>
        </request>
    </xsl:template>
</xsl:stylesheet>
