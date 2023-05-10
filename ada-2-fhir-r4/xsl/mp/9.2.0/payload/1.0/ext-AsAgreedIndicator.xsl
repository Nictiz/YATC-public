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

    <!-- ================================================================== -->

    <xsl:template name="ext-AsAgreedIndicator" match="*" as="element()?" mode="ext-AsAgreedIndicator">
        <!-- Template for shared extension http://nictiz.nl/fhir/StructureDefinition/ext-AsAgreedIndicator -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- Optional. Ada element containing the copy indicator. Defaults to context. -->
        </xsl:param>
        <!-- TODO: use correct extension, this is not an existing extension at the moment -->
        <extension url="{$urlExtAsAgreedIndicator}" xmlns="http://hl7.org/fhir">
            <valueBoolean>
                <xsl:call-template name="boolean-to-boolean"/>
            </valueBoolean>
        </extension>
    </xsl:template>
    
</xsl:stylesheet>
