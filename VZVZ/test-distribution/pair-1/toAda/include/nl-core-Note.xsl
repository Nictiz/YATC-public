<?xml version="1.0" encoding="UTF-8"?>

<!-- == Flattened from: C:/xdata/Nictiz/HL7-mappings/fhir_2_ada-r4/zibs2020/payload/0.8.0-beta.1/nl-core-Note.xsl == -->
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
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xd:doc>
      <!--ZZZNEW-->
      <xd:desc>Template to convert f:note to Toelichting</xd:desc>
   </xd:doc>
   <xsl:template match="f:note"
                 mode="nl-core-Note">
      <toelichting value="{f:text/@value}"/>
   </xsl:template>
</xsl:stylesheet>