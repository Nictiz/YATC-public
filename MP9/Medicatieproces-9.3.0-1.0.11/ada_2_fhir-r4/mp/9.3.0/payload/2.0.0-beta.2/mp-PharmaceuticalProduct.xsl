<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/mp/9.3.0/payload/2.0.0-beta.2/mp-PharmaceuticalProduct.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="#local.2024111108545316373120100"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <!-- ================================================================== -->
   <!--
        Converts ADA farmaceutisch_product to FHIR Medication conforming to profile mp-PharmaceuticalProduct.
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
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <!-- ================================================================== -->
   <xsl:template match="farmaceutisch_product"
                 name="mp-PharmaceuticalProduct"
                 mode="mp-PharmaceuticalProduct"
                 as="element(f:Medication)">
      <!-- Create an mp-PharmaceuticalProduct instance as a Medication FHIR instance from ADA farmaceutisch_product. -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <xsl:param name="profile"
                 as="xs:string?">
         <!-- The ADA-element name may or may not be enough to determine the profile from. For Immunization it is not, so allow explicit setting of the profile -->
      </xsl:param>
      <xsl:for-each select="$in">
         <Medication>
            <xsl:call-template name="insertLogicalId"/>
            <meta>
               <xsl:choose>
                  <xsl:when test="empty($profile)">
                     <profile value="{nf:get-full-profilename-from-adaelement(.)}"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <profile value="{$profile}"/>
                  </xsl:otherwise>
               </xsl:choose>
            </meta>
            <xsl:for-each select="product_specificatie/omschrijving">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-PharmaceuticalProduct.Description">
                  <valueString>
                     <xsl:attribute name="value"
                                    select="./@value"/>
                  </valueString>
               </extension>
            </xsl:for-each>
            <!-- more then one product_code is allowed as 'translations' of the main code, even though there is conceptually one main code (as the zib may state) -->
            <!-- FHIR only allows one code element, however within code, coding may be repeated -->
            <!-- the most specific coding will get userselected true, so a receiver can easily recognise the 'main' code -->
            <xsl:variable name="most-specific-product-code"
                          select="nf:get-specific-productcode(product_code)"
                          as="element(product_code)?"/>
            <xsl:choose>
               <xsl:when test="product_code[@codeSystem = $oidsGstandaardMedication][@code]">
                  <code>
                     <xsl:for-each select="product_code[@codeSystem = $oidsGstandaardMedication][@code]">
                        <xsl:choose>
                           <xsl:when test="@codeSystem = $most-specific-product-code/@codeSystem">
                              <xsl:call-template name="code-to-CodeableConcept">
                                 <xsl:with-param name="in"
                                                 select="."/>
                                 <xsl:with-param name="userSelected">true</xsl:with-param>
                              </xsl:call-template>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:call-template name="code-to-CodeableConcept">
                                 <xsl:with-param name="in"
                                                 select="."/>
                              </xsl:call-template>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:for-each>
                     <!-- Gemaakt om product_naam te kunnen toevoegen in code.text -->
                     <xsl:choose>
                        <xsl:when test="product_specificatie/product_naam">
                           <xsl:for-each select="product_specificatie/product_naam">
                              <text value="{@value}"/>
                           </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:for-each select="$most-specific-product-code[@displayName]">
                              <!-- MP-1295, call string function to get rid of leading/trailing spaces which FHIR does not appreciate -->
                              <text>
                                 <xsl:call-template name="string-to-string">
                                    <xsl:with-param name="in"
                                                    select="."/>
                                    <xsl:with-param name="inAttributeName">displayName</xsl:with-param>
                                 </xsl:call-template>
                              </text>
                           </xsl:for-each>
                        </xsl:otherwise>
                     </xsl:choose>
                  </code>
               </xsl:when>
               <!-- magistraal -->
               <xsl:when test="product_code[@codeSystem = $oidHL7NullFlavor]">
                  <code>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="product_code"/>
                        <!-- OTH is part of ValueSet, binding is 'required', so no other nullFlavors allowed -->
                        <xsl:with-param name="treatNullFlavorAsCoding"
                                        select="true()"/>
                     </xsl:call-template>
                     <xsl:if test="not(product_code[@originalText]) and product_specificatie/product_naam/@value">
                        <text value="{product_specificatie/product_naam/@value}"/>
                     </xsl:if>
                  </code>
               </xsl:when>
               <!-- 90 miljoen or any other code, including SNOMED CT -->
               <xsl:when test="product_code[not(@codeSystem = ($oidHL7NullFlavor, $oidsGstandaardMedication))]">
                  <code>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <!-- do not input @originalText -->
                        <xsl:with-param name="in"
                                        as="element()">
                           <product_code>
                              <xsl:copy-of select="product_code/(@code, @codeSystem, @codeSystemName, @displayName)"/>
                           </product_code>
                        </xsl:with-param>
                     </xsl:call-template>
                     <xsl:choose>
                        <xsl:when test="product_specificatie/product_naam/@value">
                           <text value="{product_specificatie/product_naam/@value}"/>
                        </xsl:when>
                        <xsl:when test="product_code[@originalText]">
                           <text value="{product_code[@originalText]}"/>
                        </xsl:when>
                     </xsl:choose>
                  </code>
               </xsl:when>
               <xsl:when test="product_specificatie/product_naam[@value]">
                  <code>
                     <coding>
                        <system value="http://terminology.hl7.org/CodeSystem/v3-NullFlavor"/>
                        <code value="OTH"/>
                        <display value="overig"/>
                     </coding>
                     <text value="{product_specificatie/product_naam/@value}"/>
                  </code>
               </xsl:when>
            </xsl:choose>
            <xsl:for-each select="product_specificatie/farmaceutische_vorm">
               <form>
                  <xsl:call-template name="code-to-CodeableConcept"/>
               </form>
            </xsl:for-each>
            <xsl:for-each select="product_specificatie/ingredient">
               <xsl:variable name="ingredientContent">
                  <xsl:for-each select="ingredient_code">
                     <itemCodeableConcept>
                        <xsl:call-template name="code-to-CodeableConcept"/>
                     </itemCodeableConcept>
                  </xsl:for-each>
                  <xsl:choose>
                     <!-- zib ada dataset -->
                     <xsl:when test="sterkte[ingredient_hoeveelheid/@value or product_hoeveelheid/@value]">
                        <strength>
                           <xsl:for-each select="sterkte/ingredient_hoeveelheid[@value]">
                              <numerator>
                                 <xsl:call-template name="hoeveelheid-to-Quantity"/>
                              </numerator>
                           </xsl:for-each>
                           <xsl:for-each select="sterkte/product_hoeveelheid[@value]">
                              <denominator>
                                 <xsl:call-template name="hoeveelheid-to-Quantity"/>
                              </denominator>
                           </xsl:for-each>
                        </strength>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:for-each select="sterkte[ingredient_hoeveelheid/*//@value or product_hoeveelheid/*//@value]">
                           <strength>
                              <xsl:for-each select="ingredient_hoeveelheid[.//@value]">
                                 <numerator>
                                    <xsl:call-template name="_buildMedicationQuantity">
                                       <xsl:with-param name="adaValue"
                                                       select="waarde"/>
                                       <xsl:with-param name="adaUnit"
                                                       select="eenheid[@codeSystem = $oidGStandaardBST902THES2]"/>
                                    </xsl:call-template>
                                 </numerator>
                              </xsl:for-each>
                              <xsl:for-each select="product_hoeveelheid[.//@value]">
                                 <denominator>
                                    <xsl:call-template name="_buildMedicationQuantity">
                                       <xsl:with-param name="adaValue"
                                                       select="waarde"/>
                                       <xsl:with-param name="adaUnit"
                                                       select="eenheid[@codeSystem = $oidGStandaardBST902THES2]"/>
                                    </xsl:call-template>
                                 </denominator>
                              </xsl:for-each>
                           </strength>
                        </xsl:for-each>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:if test="$ingredientContent">
                  <ingredient>
                     <xsl:copy-of select="$ingredientContent"/>
                  </ingredient>
               </xsl:if>
            </xsl:for-each>
            <xsl:if test="batchnummer">
               <batch>
                  <lotNumber value="{batchnummer/@value}"/>
               </batch>
            </xsl:if>
         </Medication>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="farmaceutisch_product"
                 mode="_generateId">
      <!-- Template to generate a unique id to identify this instance. -->
      <xsl:variable name="uniqueString"
                    as="xs:string?">
         <xsl:choose>
            <xsl:when test="product_code[@codeSystem = ($oidGStandaardZInummer, $oidGStandaardHPK, $oidGStandaardPRK, $oidGStandaardGPK, $oidGStandaardSNK, $oidGStandaardSSK)][@code]">
               <xsl:variable name="most-specific-product-code"
                             select="nf:get-specific-productcode(product_code)"
                             as="element(product_code)?"/>
               <xsl:value-of select="concat(replace($most-specific-product-code/@codeSystem, '\.', ''), '-', $most-specific-product-code/@code)"/>
            </xsl:when>
            <xsl:when test="product_code[not(@codeSystem = $oidHL7NullFlavor)]">
               <!-- own 90-million product-code which will fit in a logicalId -->
               <xsl:variable name="productCode"
                             select="product_code[not(@codeSystem = $oidHL7NullFlavor)][1]"
                             as="element(product_code)?"/>
               <!-- we remove '.' in codeSystem to enlarge the chance of staying in 64 chars -->
               <xsl:value-of select="concat(replace($productCode/@codeSystem, '\.', ''), '-', $productCode/@code)"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- we do not have anything to create a stable logicalId, lets return a UUID -->
               <xsl:value-of select="uuid:get-uuid(.)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="."
                           mode="generateLogicalId">
         <xsl:with-param name="uniqueString"
                         select="string-join($uniqueString, '')"/>
      </xsl:apply-templates>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="farmaceutisch_product"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
      <xsl:variable name="most-specific-product-code"
                    select="nf:get-specific-productcode(product_code)"
                    as="element(product_code)?"/>
      <xsl:choose>
         <xsl:when test="$most-specific-product-code[not(@codeSystem = $oidHL7NullFlavor)][@displayName]">
            <xsl:value-of select="normalize-space($most-specific-product-code/@displayName)"/>
         </xsl:when>
         <xsl:when test="product_code[not(@codeSystem = $oidHL7NullFlavor)][@displayName]">
            <xsl:value-of select="normalize-space((product_code/@displayName)[1])"/>
         </xsl:when>
         <xsl:when test="product_specificatie[product_naam/@value]">
            <xsl:value-of select="product_specificatie/product_naam/@value"/>
         </xsl:when>
         <xsl:when test="product_specificatie[ingredient/ingredient_code/@displayName]">
            <xsl:value-of select="string-join(product_specificatie/ingredient/ingredient_code/@displayName, ', ')"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:get-specific-productcode"
                 as="element()?">
      <!-- Takes a collection of product_codes as input and returns the most specific one according to G-std, otherwise just the first one -->
      <xsl:param name="ada-product-code"
                 as="element()*">
         <!-- Collection of ada product codes to select the most specific one from -->
      </xsl:param>
      <xsl:choose>
         <xsl:when test="$ada-product-code[@codeSystem = $oidGStandaardZInummer]">
            <xsl:copy-of select="($ada-product-code[@codeSystem = $oidGStandaardZInummer])[1]"/>
         </xsl:when>
         <xsl:when test="$ada-product-code[@codeSystem = $oidGStandaardHPK]">
            <xsl:copy-of select="($ada-product-code[@codeSystem = $oidGStandaardHPK])[1]"/>
         </xsl:when>
         <xsl:when test="$ada-product-code[@codeSystem = $oidGStandaardPRK]">
            <xsl:copy-of select="($ada-product-code[@codeSystem = $oidGStandaardPRK])[1]"/>
         </xsl:when>
         <xsl:when test="$ada-product-code[@codeSystem = $oidGStandaardGPK]">
            <xsl:copy-of select="($ada-product-code[@codeSystem = $oidGStandaardGPK])[1]"/>
         </xsl:when>
         <xsl:when test="$ada-product-code[@codeSystem = $oidGStandaardSSK]">
            <xsl:copy-of select="($ada-product-code[@codeSystem = $oidGStandaardSSK])[1]"/>
         </xsl:when>
         <xsl:when test="$ada-product-code[@codeSystem = $oidGStandaardSNK]">
            <xsl:copy-of select="($ada-product-code[@codeSystem = $oidGStandaardSNK])[1]"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- simply return the first product_code element in the xml -->
            <xsl:copy-of select="$ada-product-code[1]"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
</xsl:stylesheet>