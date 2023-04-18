<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:yatcp="https://nictiz.nl/ns/YATC-public" xmlns:local="#local.n2x_bll_jwb" exclude-result-prefixes="#all" expand-text="true">
    <!-- ======================================================================= -->
    <!-- 
       This XSL takes the (pruned and enhanced) application data file for ada-2-fhir-r4
       (as produced by ../../xplmod/ada-2-fhir-r4.mod.xpl) and creates a full list of directories and files 
       to compare against each other.
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

    <xsl:mode on-no-match="shallow-skip"/>

    <xsl:strip-space elements="*"/>

    <xsl:import href="../../../../YATC-shared/xslmod/create-directory-compare-list-for-application-data-setup.mod.xsl"/>

    <!-- ================================================================== -->
    <!-- GLOBAL VARIABLES AND PARAMETER OVERRIDES: -->

    <xsl:param name="repoForComparisonsBaseDir" as="xs:string" select="yatcs:get-original-repo-base-directory($repoHL7Mappings)"/>
    <xsl:param name="repoSubdirName" as="xs:string" required="false" select="'ada_2_fhir-r4'"/>
    <xsl:param name="descriptionSuffix" as="xs:string" required="false" select="'ada-2-fhir-r4'"/>

    <!-- ======================================================================= -->

    <xsl:template match="yatcp:build/yatcp:output-document">
        <xsl:param name="descriptionSuffix" as="xs:string?" required="false" select="()" tunnel="true"/>
        <xsl:param name="baseDirectoryOriginal" as="xs:string" required="true" tunnel="true"/>

        <xsl:variable name="outputDirectory" as="xs:string?" select="xs:string(@directory)"/>
        <xsl:variable name="outputDirectoryRel" as="xs:string?" select="xs:string(@_directory-rel)"/>
        <xsl:variable name="filename" as="xs:string?" select="xs:string(@name)"/>

        <compare-documents href1="{yatcs:href-concat(($outputDirectory, $filename))}" href2="{yatcs:href-concat(($baseDirectoryOriginal, $outputDirectoryRel, $filename))}" description="{$descriptionSuffix} result {$filename}"/>
    </xsl:template>
    
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    
    <xsl:template match="yatcp:build/yatcp:output-documents">
        <xsl:param name="descriptionSuffix" as="xs:string?" required="false" select="()" tunnel="true"/>
        <xsl:param name="baseDirectoryOriginal" as="xs:string" required="true" tunnel="true"/>
        
        <xsl:variable name="outputDirectory" as="xs:string?" select="xs:string(@directory)"/>
        <xsl:variable name="outputDirectoryRel" as="xs:string?" select="xs:string(@_directory-rel)"/>
        
        <compare-directories href1="{$outputDirectory}" href2="{yatcs:href-concat(($baseDirectoryOriginal, $outputDirectoryRel))}" description="{$descriptionSuffix} directory {$outputDirectory}"/>
    </xsl:template>
    
</xsl:stylesheet>
