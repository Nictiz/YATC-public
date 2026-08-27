<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/mp/9.3.0/payload/2.0.0-rc.4/mp-GstdQuantity.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.18; 2026-08-27T17:36:23.96+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
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
   <xsl:template name="GstdProductQuantityValue">
      <!-- Handle G-standard and UCUM unit stuff with MP product quantity's -->
      <xsl:param name="in"
                 as="element()*">
         <!-- The input hl7 element containing the product quantity -->
      </xsl:param>
      <xsl:param name="inAdaElementName"
                 as="xs:string?">
         <!-- The ada element to be outputted for the in element(s). 
            Allows to override the default assumptions -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:variable name="adaElementName"
                       as="xs:string">
            <xsl:choose>
               <xsl:when test="$inAdaElementName">
                  <xsl:value-of select="$inAdaElementName"/>
               </xsl:when>
               <xsl:when test="self::f:low">
                  <xsl:value-of select="'minimum_waarde'"/>
               </xsl:when>
               <xsl:when test="self::f:doseQuantity">
                  <xsl:value-of select="'nominale_waarde'"/>
               </xsl:when>
               <xsl:when test="self::f:high">
                  <xsl:value-of select="'maximum_waarde'"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="'aantal'"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:element name="{$adaElementName}">
            <xsl:attribute name="value">
               <!-- give preference to G-std value if present -->
               <xsl:choose>
                  <xsl:when test="f:extension[@url = $ext-iso21090-PQ-translation]/f:valueQuantity[contains(f:system/@value, $oidGStandaardBST902THES2)]">
                     <xsl:value-of select="f:extension[@url = $ext-iso21090-PQ-translation]/f:valueQuantity[contains(f:system/@value, $oidGStandaardBST902THES2)]/f:value/@value"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- fallback on UCUM -->
                     <xsl:value-of select="f:value/@value"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <!-- stick all the original information in extensions, useful for putting it in FHIR or back in HL7v3 later -->
            <!-- first the originalUCUM stuff -->
            <xsl:variable name="UcumQuantity"
                          select=".[f:system/@value = $oidMap[@oid = $oidUCUM]/@uri][f:code[@value]]"/>
            <xsl:if test="$UcumQuantity | f:extension[@url = $ext-iso21090-PQ-translation]/f:valueQuantity">
               <adaextension>
                  <xsl:if test="$UcumQuantity">
                     <originalUCUM value="{$UcumQuantity/f:value/@value}">
                        <xsl:attribute name="unit">
                           <xsl:value-of select="$UcumQuantity/f:code/@value"/>
                        </xsl:attribute>
                     </originalUCUM>
                  </xsl:if>
                  <!-- and the original translations @code | @codeSystem | @codeSystemName | @codeSystemVersion | @displayName-->
                  <xsl:for-each select="f:extension[@url = $ext-iso21090-PQ-translation]/f:valueQuantity">
                     <translation value="{f:value/@value}"
                                  code="{f:code/@value}"
                                  codeSystem="{local:getOid(f:system/@value)}"
                                  displayName="{f:unit/@value}"/>
                  </xsl:for-each>
               </adaextension>
            </xsl:if>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>