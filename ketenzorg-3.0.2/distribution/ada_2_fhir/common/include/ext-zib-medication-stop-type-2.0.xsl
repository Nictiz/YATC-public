<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="YATC-internal/ada-2-fhir/env/zibs2017/payload/ext-zib-medication-stop-type-2.0.xsl"?>
<?yatc-distribution-info name="ketenzorg-3.0.2" timestamp="2024-11-15T00:15:11.67+01:00" version="1.4.29"?>
<!-- == Provenance: YATC-internal/ada-2-fhir/env/zibs2017/payload/ext-zib-medication-stop-type-2.0.xsl == -->
<!-- == Distribution: ketenzorg-3.0.2; 1.4.29; 2024-11-15T00:15:11.67+01:00 == -->
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
   <xsl:template name="ext-zib-Medication-StopType-2.0"
                 match="*"
                 as="element()?"
                 mode="doExtZibMedicationStopType-2.0">
      <!-- Template for shared extension http://nictiz.nl/fhir/StructureDefinition/zib-Medication-StopType -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- Optional. Ada element containing the stoptype code -->
      </xsl:param>
      <xsl:for-each select="$in">
         <modifierExtension url="http://nictiz.nl/fhir/StructureDefinition/zib-Medication-StopType">
            <valueCodeableConcept>
               <xsl:call-template name="code-to-CodeableConcept">
                  <xsl:with-param name="in"
                                  select="."/>
               </xsl:call-template>
            </valueCodeableConcept>
         </modifierExtension>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>