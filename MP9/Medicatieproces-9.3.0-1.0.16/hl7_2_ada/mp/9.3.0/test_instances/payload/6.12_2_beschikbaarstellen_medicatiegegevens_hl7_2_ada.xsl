<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/hl7-2-ada/env/mp/9.3.0/test_instances/payload/6.12_2_beschikbaarstellen_medicatiegegevens_hl7_2_ada.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.16; 2026-04-29T11:02:12.55+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:util="urn:hl7:utilities"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="#local.202412041518439035630100"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
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
   <xsl:import href="../../6.12_2_beschikbaarstellen_medicatiegegevens/payload/6.12_2_beschikbaarstellen_medicatiegegevens_hl7_2_ada.xsl"/>
   <!-- for generating stable uuids -->
   <xsl:import href="../../../../../common/includes/uuid-stable.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:param name="deduplicateAdaBouwstenen"
              as="xs:boolean?"
              select="true()"/>
   <xsl:param name="creationLastupdate"
              as="xs:dateTime"
              select="xs:dateTime('2026-01-01T00:00:00')"/>
   <xsl:param name="outputMP9Bouwstenen"
              as="xs:string*"
              select="('TA', 'MVE')">
      <!-- parameter to influence which MP9 bouwstenen to output -->
   </xsl:param>
   <xsl:variable name="logLevel"
                 select="$logDEBUG"/>
   <xsl:variable name="transactionName"
                 select="'beschikbaarstellen_medicatiegegevens'"/>
   <xsl:variable name="transactionOid"
                 select="'2.16.840.1.113883.2.4.3.11.60.20.77.4.374'"/>
   <xsl:variable name="transactionEffectiveDate"
                 as="xs:dateTime"
                 select="xs:dateTime('2022-06-30T00:00:00')"/>
   <xsl:variable name="adaFormname"
                 select="'medicatiegegevens'"/>
   <xsl:variable name="mpVersion"
                 select="'mp93'"/>
   <!-- ================================================================== -->
</xsl:stylesheet>