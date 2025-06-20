<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/fhir-2-ada-r4/env/zibs/2020/payload/0.8.0-beta.1/nl-core-PharmaceuticalProduct.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
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
   <xsl:variable name="zibProductDescription"
                 select="'http://nictiz.nl/fhir/StructureDefinition/ext-PharmaceuticalProduct.Description'"/>
   <!-- ================================================================== -->
   <xsl:template match="f:Medication"
                 mode="nl-core-PharmaceuticalProduct">
      <!-- Template to convert f:Medication to ADA product -->
      <farmaceutisch_product>
         <xsl:if test="../../f:fullUrl[@value]">
            <xsl:attribute name="id">
               <xsl:value-of select="nf:convert2NCName(../../f:fullUrl/@value)"/>
            </xsl:attribute>
         </xsl:if>
         <!-- product_code -->
         <xsl:apply-templates select="f:code"
                              mode="#current"/>
         <xsl:if test="f:extension | f:form | f:ingredient                  or (f:code/f:coding/f:system/@value = 'http://terminology.hl7.org/CodeSystem/v3-NullFlavor' and f:code/f:text)                  or (f:code/f:extension/@url = $urlExtHL7NullFlavor and (f:extension | f:form | f:ingredient))">
            <!-- product_specificatie -->
            <product_specificatie>
               <!-- product_naam -->
               <xsl:apply-templates select="f:code/f:text"
                                    mode="#current"/>
               <!-- omschrijving -->
               <xsl:apply-templates select="f:extension[@url = $zibProductDescription]"
                                    mode="#current"/>
               <!-- farmaceutische_vorm -->
               <xsl:apply-templates select="f:form"
                                    mode="#current"/>
               <!-- ingredient -->
               <xsl:apply-templates select="f:ingredient"
                                    mode="#current"/>
            </product_specificatie>
         </xsl:if>
      </farmaceutisch_product>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:code"
                 mode="nl-core-PharmaceuticalProduct">
      <!-- Template to convert f:code to product_code -->
      <xsl:variable name="addOriginalText"
                    select="not(preceding-sibling::f:extension[@url = $zibProductDescription]) and not(following-sibling::f:form | following-sibling::f:ingredient) and not(f:coding/f:display)"/>
      <xsl:variable name="addOriginalTextValue"
                    select="                 if ($addOriginalText) then                     f:text/@value                 else                     ''"/>
      <xsl:choose>
         <xsl:when test="$addOriginalText and not(f:coding/f:display) and not(f:extension/@url = $urlExtHL7NullFlavor)">
            <xsl:call-template name="CodeableConcept-to-code">
               <xsl:with-param name="in"
                               as="element()">
                  <f:code>
                     <f:extension url="http://hl7.org/fhir/StructureDefinition/iso21090-nullFlavor">
                        <f:valueCode value="OTH"/>
                     </f:extension>
                     <xsl:copy-of select="*"/>
                  </f:code>
               </xsl:with-param>
               <xsl:with-param name="adaElementName"
                               select="'product_code'"/>
               <xsl:with-param name="originalText"
                               select="$addOriginalTextValue"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="CodeableConcept-to-code">
               <xsl:with-param name="in"
                               select="."/>
               <xsl:with-param name="adaElementName"
                               select="'product_code'"/>
               <xsl:with-param name="originalText"
                               select="$addOriginalTextValue"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:code/f:text"
                 mode="nl-core-PharmaceuticalProduct">
      <!-- Template to convert f:code/f:text to product_naam -->
      <product_naam>
         <xsl:attribute name="value"
                        select="@value"/>
      </product_naam>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:extension[@url = $zibProductDescription]"
                 mode="nl-core-PharmaceuticalProduct">
      <!-- Template to convert f:extension zib-Product-Description to omschrijving -->
      <omschrijving>
         <xsl:attribute name="value"
                        select="f:valueString/@value"/>
      </omschrijving>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:ingredient"
                 mode="nl-core-PharmaceuticalProduct">
      <!-- Template to convert f:ingredient to ingredient -->
      <ingredient>
         <!-- ingredient_code -->
         <xsl:apply-templates select="f:itemCodeableConcept"
                              mode="nl-core-PharmaceuticalProduct"/>
         <!-- sterkte -->
         <xsl:apply-templates select="f:strength"
                              mode="nl-core-PharmaceuticalProduct"/>
      </ingredient>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:form"
                 mode="nl-core-PharmaceuticalProduct">
      <!-- Template to convert f:form to farmaceutische_vorm -->
      <xsl:call-template name="CodeableConcept-to-code">
         <xsl:with-param name="in"
                         select="."/>
         <xsl:with-param name="adaElementName"
                         select="'farmaceutische_vorm'"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:ingredient/f:itemCodeableConcept"
                 mode="nl-core-PharmaceuticalProduct">
      <!-- Template to convert f:ingredient/f:itemCodeableConcept to ingredient_code -->
      <xsl:call-template name="CodeableConcept-to-code">
         <xsl:with-param name="in"
                         select="."/>
         <xsl:with-param name="adaElementName"
                         select="'ingredient_code'"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="f:ingredient/f:strength"
                 mode="nl-core-PharmaceuticalProduct">
      <!-- Template to convert f:ingredient/f:amount to sterkte with hoeveelheid_ingredient and hoeveelheid_product children, both of which have waarde and eenheid children. -->
      <sterkte>
         <xsl:for-each select="f:numerator">
            <ingredient_hoeveelheid>
               <xsl:call-template name="GstdQuantity2ada">
                  <xsl:with-param name="adaElementNameWaarde">waarde</xsl:with-param>
               </xsl:call-template>
            </ingredient_hoeveelheid>
         </xsl:for-each>
         <xsl:for-each select="f:denominator">
            <product_hoeveelheid>
               <xsl:call-template name="GstdQuantity2ada">
                  <xsl:with-param name="adaElementNameWaarde">waarde</xsl:with-param>
               </xsl:call-template>
            </product_hoeveelheid>
         </xsl:for-each>
      </sterkte>
   </xsl:template>
</xsl:stylesheet>