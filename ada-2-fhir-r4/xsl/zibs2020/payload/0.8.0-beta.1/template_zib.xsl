<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255701790360200">
    <!-- ================================================================== -->
    <!--
        Converts ADA [...] to FHIR [...] conforming to profile [...]
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

    <xsl:template name="nl-core-[zib name]" mode="nl-core-[zib name]" as="element(f:[resource name])">
        <!-- Create a nl-core-[zib name] instance as a [resource name] FHIR instance from ADA [ADA instance name]. -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- ADA element as input. Defaults to self. -->
        </xsl:param>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="[ada_element]" mode="_generateId"><!-- Template to generate a unique id to identify this instance. -->
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="[ada_element]" mode="_generateDisplay"><!-- Template to generate a display that can be shown when referencing this instance. -->
    </xsl:template>
</xsl:stylesheet>
