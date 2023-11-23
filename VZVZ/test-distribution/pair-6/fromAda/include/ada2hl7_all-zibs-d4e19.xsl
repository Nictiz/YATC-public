<?xml version="1.0" encoding="UTF-8"?>

<!-- == Flattened from: C:/xdata/Nictiz/HL7-mappings/ada_2_hl7/zib2017bbr/payload/ada2hl7_all-zibs.xsl == -->
<!--
Copyright (c) Nictiz

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
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <!-- Without this import, all depending XSLs need to import it -->
   <xsl:import href="_ada2hl7_zib2017.xsl"/>
   <xsl:import href="hl7-CDARecordTargetSDTCNL-20180611.xsl"/>
   <xsl:import href="hl7-CDARecordTargetSDTCNLBSNContactible-20180611.xsl"/>
   <xsl:import href="hl7-Lichaamsgewicht-20171025.xsl"/>
   <xsl:import href="hl7-Lichaamslengte-20171025.xsl"/>
   <xsl:import href="hl7-LaboratoryObservation-20171205.xsl"/>
   <xsl:import href="hl7-toelichting-20180611.xsl"/>
</xsl:stylesheet>