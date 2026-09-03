<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/hl7-2-ada/env/zibs/2020/payload/uni-GstdHoeveelheid.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.18; 2026-08-27T17:36:23.96+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:template name="mp9-productQuantityValue">
      <!-- Handle G-standard and UCUM unit stuff with MP product quantity's -->
      <xsl:param name="in"
                 as="element()*">
         <!-- The input hl7 element containing the product quantity -->
      </xsl:param>
      <xsl:param name="inAdaElementName"
                 as="xs:string?">
         <!-- The ada element to be outputted for the in element(s). 
            Allows to override the default assumptions, 
            for example: the center -> nominale_waarde assumption is not valid for MTD, this has to be mapped to 'aantal' -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:variable name="adaElementName"
                       as="xs:string">
            <xsl:choose>
               <xsl:when test="$inAdaElementName">
                  <xsl:value-of select="$inAdaElementName"/>
               </xsl:when>
               <xsl:when test="self::hl7:low">
                  <xsl:value-of select="'minimum_waarde'"/>
               </xsl:when>
               <xsl:when test="self::hl7:center">
                  <xsl:value-of select="'nominale_waarde'"/>
               </xsl:when>
               <xsl:when test="self::hl7:high">
                  <xsl:value-of select="'maximum_waarde'"/>
               </xsl:when>
               <xsl:when test="self::hl7:quantity[parent::hl7:supply]">
                  <xsl:value-of select="'aantal'"/>
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
                  <xsl:when test="hl7:translation[@codeSystem = $oidGStandaardBST902THES2][@code][@value]">
                     <xsl:value-of select="(hl7:translation[@codeSystem = $oidGStandaardBST902THES2][@code][@value])[1]/@value"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- fallback on UCUM -->
                     <xsl:value-of select="@value"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <!-- stick all the original information in extensions, useful for putting it in FHIR or back in HL7v3 later -->
            <!-- first the originalUCUM stuff -->
            <adaextension>
               <originalUCUM value="{@value}">
                  <xsl:attribute name="unit">
                     <xsl:choose>
                        <xsl:when test="@unit">
                           <xsl:value-of select="@unit"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="'1'"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
               </originalUCUM>
               <!-- and the original translations -->
               <xsl:for-each select="hl7:translation">
                  <translation value="{@value}">
                     <xsl:call-template name="mp9-code-attribs">
                        <xsl:with-param name="current-hl7-code"
                                        select="."/>
                     </xsl:call-template>
                  </translation>
               </xsl:for-each>
            </adaextension>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>