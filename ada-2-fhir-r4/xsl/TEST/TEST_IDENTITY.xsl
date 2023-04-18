<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:local="#local.zrd_ntj_2xb" exclude-result-prefixes="#all" expand-text="true">
    <!-- ======================================================================= -->
    <!-- 
       TEST_IDENTITY.xsl
       
       Does nothing except adding a remark
       
       TBD
    -->
    <!-- ======================================================================= -->
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
    <!-- ======================================================================= -->
    <!-- SETUP: -->

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:mode on-no-match="shallow-copy"/>

    <!-- ================================================================== -->

    <xsl:template match="/">
        <xsl:comment> == Processed by <xsl:value-of select="static-base-uri()"/> on <xsl:value-of select="current-dateTime()"/> == </xsl:comment>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
