<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/mp-lab/9.3.0-3.0.0/sturen_medicatievoorschrift_laboratoriumresultaten/payload/sturen_medicatievoorschrift-en-lab.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.12; 2026-02-13T13:07:12.23+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="#local.2024011810474768052330100">
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
   <xsl:import href="../../../../mp/9.3.0/sturen_medicatievoorschrift/payload/sturen_medicatievoorschrift_org.xsl"/>
   <xsl:import href="../../../../../common/includes/sturen_laboratoriumresultaten_org.xsl"/>
   <!-- schema location without hl7-namespace -->
   <xsl:param name="schemaLocation"
              as="xs:string?">../hl7_schemas_flat/master_organizer.xsd</xsl:param>
   <!-- ================================================================== -->
   <xsl:template match="/">
      <organizer xmlns="urn:hl7-org:v3"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
         <xsl:if test="string-length($schemaLocation) gt 0">
            <xsl:attribute name="xsi:schemaLocation"
                           select="'urn:hl7-org:v3', $schemaLocation"/>
         </xsl:if>
         <xsl:call-template name="mp-mp93_vos"/>
         <xsl:call-template name="lu-sturenLaboratoriumresultaten"/>
      </organizer>
   </xsl:template>
</xsl:stylesheet>