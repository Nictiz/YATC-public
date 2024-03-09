<?xml version="1.0" encoding="UTF-8"?>

<!-- == Flattened from: /Users/ahenket/Development/GitHub/Nictiz/HL7-mappings/hl7_2_ada/ketenzorg/3.0.2/beschikbaarstellen/payload/beschikbaarstellen_algemene_bepalingen_2_ada.xsl == -->
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
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:pharm="urn:ihe:pharm:medication"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xd:doc>
      <xd:desc>Conversie van 
<xd:a href="https://decor.nictiz.nl/ketenzorg/kz-html-20190110T164948/tmp-2.16.840.1.113883.2.4.3.11.60.66.10.8-2018-04-18T000000.html">Organizer AlgemeneBepalingen</xd:a> id: 2.16.840.1.113883.2.4.3.11.60.66.10.8 versie 2018-04-18T00:00:00 naar ADA formaat </xd:desc>
      <xd:desc>Documentatie voor deze mapping staat op de wikipagina 
<xd:a href="https://informatiestandaarden.nictiz.nl/wiki/Mappings/KZ302BeschikbaarstellenAlgemeneBepalingenCDA_2_ADA">https://informatiestandaarden.nictiz.nl/wiki/Mappings/KZ302BeschikbaarstellenAlgemeneBepalingenCDA_2_ADA</xd:a>
      </xd:desc>
   </xd:doc>
   <xsl:output method="xml"
               indent="yes"
               omit-xml-declaration="yes"/>
   <xsl:include href="../../../../common/include/hl7_2_ada_ketenzorg_include.xsl"/>
   <xd:doc>
      <xd:desc> if this xslt is used stand alone the template below could be used. </xd:desc>
   </xd:doc>
   <xsl:template match="/">
      <xsl:call-template name="doGeneratedComment"/>
      <adaxml xsi:noNamespaceSchemaLocation="../ada_schemas/ada_general_measurements_response.xsd">
         <meta status="new"
               created-by="generated"
               last-update-by="generated">
            <xsl:attribute name="creation-date"
                           select="current-dateTime()"/>
            <xsl:attribute name="last-update-date"
                           select="current-dateTime()"/>
         </meta>
         <data>
            <xsl:for-each select="//hl7:organizer[hl7:templateId/@root = $oidOrganizerAlgemeneBepalingen]">
               <xsl:call-template name="BeschikbaarstellenAlgemeneBepalingen-ADA">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="author"
                                  select="(ancestor::hl7:ControlActProcess/hl7:authorOrPerformer//*[hl7:id])[1]"/>
               </xsl:call-template>
            </xsl:for-each>
         </data>
      </adaxml>
   </xsl:template>
</xsl:stylesheet>