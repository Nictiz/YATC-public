<?xml version="1.0" encoding="UTF-8"?>

<!-- == Flattened from: C:/Data/Erik/work/Nictiz/new/HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/ext-CopyIndicator.xsl == -->
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
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <xd:doc>
      <xd:desc>Template to convert f:extension zib-Medication-CopyIndicator to kopie_indicator element.</xd:desc>
   </xd:doc>
   <xsl:template match="f:extension[@url = $urlExtCopyIndicator]"
                 mode="ext-CopyIndicator">
      <kopie_indicator>
         <xsl:attribute name="value"
                        select="f:valueBoolean/@value"/>
      </kopie_indicator>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:extension zib-Medication-CopyIndicator to kopie_indicator element.</xd:desc>
   </xd:doc>
   <xsl:template match="f:reportedBoolean"
                 mode="ext-CopyIndicator">
      <kopie_indicator>
         <xsl:attribute name="value"
                        select="@value"/>
      </kopie_indicator>
   </xsl:template>
</xsl:stylesheet>