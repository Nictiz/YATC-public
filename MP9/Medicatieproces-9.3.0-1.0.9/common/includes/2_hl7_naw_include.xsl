<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/naw/2_hl7_naw_include.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.9; 2025-04-14T13:20:38.56+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:local="#local.2024011810474769048950100"
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
   <!-- Function addEnding is already defined in 2_hl7_hl7_include.xsl. If that source is not included in the project, uncomment this import.   -->
   <!--     <xsl:import href="../hl7/2_hl7_hl7_include.xsl"/>-->
   <!-- Template verouderd: vervangen door ZIB template 2.16.840.1.113883.2.4.3.11.60.3.10.1.101 -->
   <!-- ================================================================== -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.101.10.1_20141106000000"
                 match="naamgegevens"
                 mode="Template_2.16.840.1.113883.2.4.3.11.60.101.10.1_20141106000000">
      <!-- name person NL - generic -->
      <xsl:param name="naamgegevens"
                 select="."/>
      <xsl:for-each select="$naamgegevens[.//(@value | @code | @nullFlavor)]">
         <name>
            <xsl:for-each select="ongestructureerde_naam[@value]">
               <xsl:value-of select="@value"/>
            </xsl:for-each>
            <xsl:for-each select="./voornamen[@value]">
               <given qualifier="BR">
                  <xsl:value-of select="@value"/>
               </given>
            </xsl:for-each>
            <xsl:for-each select="initialen[@value]">
               <given qualifier="IN">
                  <xsl:value-of select="nf:addEnding(@value, '.')"/>
               </given>
            </xsl:for-each>
            <xsl:for-each select="roepnaam[@value]">
               <given qualifier="CL">
                  <xsl:value-of select="@value"/>
               </given>
            </xsl:for-each>
            <xsl:choose>
               <xsl:when test="naamgebruik/@code = 'NL1'">
                  <!-- Eigen geslachtsnaam -->
                  <xsl:for-each select="geslachtsnaam/voorvoegsels[@value]">
                     <prefix qualifier="VV">
                        <xsl:value-of select="./@value"/>
                     </prefix>
                  </xsl:for-each>
                  <xsl:for-each select="geslachtsnaam/achternaam[@value]">
                     <family qualifier="BR">
                        <xsl:value-of select="./@value"/>
                     </family>
                  </xsl:for-each>
               </xsl:when>
               <xsl:when test="naamgebruik/@code = 'NL2'">
                  <!-- 	Geslachtsnaam partner -->
                  <xsl:for-each select="./geslachtsnaam_partner/voorvoegsels_partner[@value]">
                     <prefix qualifier="VV">
                        <xsl:value-of select="./@value"/>
                     </prefix>
                  </xsl:for-each>
                  <xsl:for-each select="geslachtsnaam_partner/achternaam_partner[@value]">
                     <family qualifier="SP">
                        <xsl:value-of select="./@value"/>
                     </family>
                  </xsl:for-each>
               </xsl:when>
               <xsl:when test="naamgebruik/@code = 'NL3'">
                  <!-- Geslachtsnaam partner gevolgd door eigen geslachtsnaam -->
                  <xsl:for-each select="geslachtsnaam_partner/voorvoegsels_partner[@value]">
                     <prefix qualifier="VV">
                        <xsl:value-of select="./@value"/>
                     </prefix>
                  </xsl:for-each>
                  <xsl:for-each select="geslachtsnaam_partner/achternaam_partner[@value]">
                     <family qualifier="SP">
                        <xsl:value-of select="./@value"/>
                     </family>
                  </xsl:for-each>
                  <xsl:for-each select="geslachtsnaam/voorvoegsels[@value]">
                     <prefix qualifier="VV">
                        <xsl:value-of select="./@value"/>
                     </prefix>
                  </xsl:for-each>
                  <xsl:for-each select="geslachtsnaam/achternaam[@value]">
                     <family qualifier="BR">
                        <xsl:value-of select="./@value"/>
                     </family>
                  </xsl:for-each>
               </xsl:when>
               <xsl:when test="naamgebruik/@code = 'NL4'">
                  <!-- Eigen geslachtsnaam gevolgd door geslachtsnaam partner -->
                  <xsl:for-each select="geslachtsnaam/voorvoegsels[@value]">
                     <prefix qualifier="VV">
                        <xsl:value-of select="./@value"/>
                     </prefix>
                  </xsl:for-each>
                  <xsl:for-each select="geslachtsnaam/achternaam[@value]">
                     <family qualifier="BR">
                        <xsl:value-of select="./@value"/>
                     </family>
                  </xsl:for-each>
                  <xsl:for-each select="geslachtsnaam_partner/voorvoegsels_partner[@value]">
                     <prefix qualifier="VV">
                        <xsl:value-of select="./@value"/>
                     </prefix>
                  </xsl:for-each>
                  <xsl:for-each select="geslachtsnaam_partner/achternaam_partner[@value]">
                     <family qualifier="SP">
                        <xsl:value-of select="./@value"/>
                     </family>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <!-- we nemen aan NL1 - alleen de eigen naam -->
                  <xsl:for-each select="geslachtsnaam/voorvoegsels[@value]">
                     <prefix qualifier="VV">
                        <xsl:value-of select="./@value"/>
                     </prefix>
                  </xsl:for-each>
                  <xsl:for-each select="geslachtsnaam/achternaam[@value]">
                     <family qualifier="BR">
                        <xsl:value-of select="./@value"/>
                     </family>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
         </name>
      </xsl:for-each>
      <!-- suffix (nog) niet in gebruik -->
      <!-- validTime (nog) niet in gebruik -->
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.101.10.2_20141106000000">
      <!--Adres-->
      <xsl:param name="adres"
                 select="."/>
      <xsl:variable name="adresgegevens"
                    select="                 if ($adres/adresgegevens) then                     $adres/adresgegevens                 else                     $adres"/>
      <xsl:for-each select="$adresgegevens">
         <addr>
            <xsl:if test="adres_soort[1]/@code">
               <xsl:attribute name="use"
                              select="adres_soort[1]/@code"/>
            </xsl:if>
            <xsl:for-each select="straat">
               <streetName>
                  <xsl:value-of select="./@value"/>
               </streetName>
            </xsl:for-each>
            <xsl:for-each select="huisnummer">
               <houseNumber>
                  <xsl:value-of select="./@value"/>
               </houseNumber>
            </xsl:for-each>
            <xsl:if test="huisnummerletter or huisnummertoevoeging">
               <buildingNumberSuffix>
                  <xsl:value-of select="huisnummerletter/@value"/>
                  <!-- voeg scheidende spatie toe als beide aanwezig -->
                  <xsl:if test="huisnummerletter and huisnummertoevoeging">
                     <xsl:text>
                     </xsl:text>
                  </xsl:if>
                  <xsl:value-of select="huisnummertoevoeging/@value"/>
               </buildingNumberSuffix>
            </xsl:if>
            <xsl:for-each select="aanduiding_bij_nummer">
               <additionalLocator>
                  <xsl:value-of select="@code"/>
               </additionalLocator>
            </xsl:for-each>
            <xsl:for-each select="postcode">
               <postalCode>
                  <xsl:value-of select="@value"/>
               </postalCode>
            </xsl:for-each>
            <xsl:for-each select="woonplaats">
               <city>
                  <xsl:value-of select="@value"/>
               </city>
            </xsl:for-each>
            <xsl:for-each select="gemeente">
               <county>
                  <xsl:value-of select="@value"/>
               </county>
            </xsl:for-each>
            <xsl:for-each select="land">
               <!--TODO:  <county code="0518" codeSystem="2.16.840.1.113883.2.4.6.14" codeSystemName="GBA-33">Den Haag</county> -->
               <country>
                  <xsl:value-of select="@value"/>
               </country>
            </xsl:for-each>
            <!-- Additionele informatie wordt geschrapt uit de definitie
                    <xsl:for-each select="./additioneleinformatie">
                    <unitID><xsl:value-of select="./@value"/></unitID>
                </xsl:for-each>-->
         </addr>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>