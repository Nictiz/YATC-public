<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/mp/9.3.0/payload/2.0.0-beta.2/_ada2resourceType.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.12; 2026-02-27T13:57:54.56+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="#local.2024102208231507996710200"
                xmlns:nm="http://www.nictiz.nl/mappings">
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
   <!--
        The ada2resourceType variable defined in 2_fhir_fhir_include.xsl maps ADA elements to profile canonicals.
        This file is used across all versions of the package, but mp9 2.0.0-beta.1 introduces a breaking change in the way ada 'farmaceutisch_product' is handled (from nl-core-PharmaceuticalProduct to mp-PharmaceuticalProduct) To override the default behaviour, the static ada2resourceType defined
        here is used. -->
   <xsl:variable name="mpAda2resourceType">
      <xsl:apply-templates select="$ada2resourceType/nm:map"
                           mode="mpAda2resourceType"/>
   </xsl:variable>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="nm:map[@ada='farmaceutisch_product']"
                 mode="mpAda2resourceType">
      <xsl:copy>
         <xsl:apply-templates select="@*"
                              mode="#current"/>
         <xsl:attribute name="profile"
                        select="'mp-PharmaceuticalProduct'"/>
      </xsl:copy>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="@* | node()"
                 mode="mpAda2resourceType">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"
                              mode="#current"/>
      </xsl:copy>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:get-profilename-from-adaelement"
                 as="xs:string?">
      <!-- Returns the last part of the profileName for an ada element, based on $ada2resourceType constant. 
            Selects the first one found, which may be wrong if there is more than one entry. In which case you should not use this function. -->
      <xsl:param name="adaElement"
                 as="element()?">
         <!-- The ada element for which to get the profileName -->
      </xsl:param>
      <xsl:value-of select="$mpAda2resourceType/nm:map[@ada = $adaElement/local-name()][1]/@profile"/>
   </xsl:function>
</xsl:stylesheet>