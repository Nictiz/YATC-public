<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/mp/6.12/opleveren_verstrekkingenlijst/payload/opleveren_verstrekkingenlijst_2_612.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.14; 2026-03-09T10:51:25.02+01:00 == -->
<xsl:stylesheet version="2.0"
                exclude-result-prefixes="#all"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="#local.2024011810474693145980100"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <!-- ================================================================== -->
   <!--
        Dit is een conversie van ADA MP9 beschikbaarstellen_medicatiegegevens naar MP 6.12 verstrekkingenlijst payload.
        Aanname is 1 TA en 1 MVE per MBH/product, anders geen 6.12 verstrekking in output.
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
   <xsl:import href="../../../../../common/includes/2_hl7_mp_include_612.xsl"/>
   <xsl:output method="xml"
               indent="yes"
               exclude-result-prefixes="#all"/>
   <xsl:param name="logLevel"
              select="$logERROR"/>
   <!-- Dit is een conversie van ADA MP9 beschikbaarstellen_medicatiegegevens naar MP 6.12 verstrekkingenlijst payload -->
   <!-- ================================================================== -->
   <xsl:template match="/">
      <xsl:variable name="transaction"
                    select="//beschikbaarstellen_medicatiegegevens"/>
      <!-- only payload, the vzvz wrappers (if needed) are done separately -->
      <xsl:for-each select="$transaction">
         <subject>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9026_20150318000000">
               <xsl:with-param name="patient"
                               select="patient"/>
               <xsl:with-param name="mbh"
                               select="medicamenteuze_behandeling"/>
            </xsl:call-template>
         </subject>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>