<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/mp/9.2.0/payload/1.0/ext-PharmaceuticalTreatmentIdentifier.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
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
   <!--    <xsl:import href="../../fhir/2_fhir_fhir_include.xsl"/>-->
   <!-- ================================================================== -->
   <xsl:template name="ext-PharmaceuticalTreatmentIdentifier"
                 match="*"
                 as="element()?"
                 mode="ext-PharmaceuticalTreatmentIdentifier">
      <!-- Template for shared extension http://nictiz.nl/fhir/StructureDefinition/ext-PharmaceuticalTreatment.Identifier -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- Optional. Ada element containing the identifier -->
      </xsl:param>
      <extension url="{$urlExtPharmaceuticalTreatmentIdentifier}">
         <valueIdentifier>
            <xsl:call-template name="id-to-Identifier">
               <xsl:with-param name="in"
                               select="."/>
            </xsl:call-template>
         </valueIdentifier>
      </extension>
   </xsl:template>
</xsl:stylesheet>