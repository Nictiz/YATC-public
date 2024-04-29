<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/zib2017bbr/2_hl7_zib2017bbr_include.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 1.0.0; 2024-04-17T17:00:31.15+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="#local.2024011509165874102830100"
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
   <xsl:import href="2_hl7_zib1bbr_include.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <!-- ================================================================== -->
   <xsl:template name="_prefix">
      <!-- Helper template for name prefix trailing space -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- The ada element which has the prefix (voorvoegsel), defaults to context -->
      </xsl:param>
      <xsl:for-each select="$in">
         <prefix qualifier="VV">
            <xsl:choose>
               <xsl:when test="@value = ('de', 'in ''t', 'te', 'ten', 'van', 'van den', 'den', 'van der', 'van de', 'van ''t')">
                  <!-- let's add a trailing space when we know we should -->
                  <xsl:value-of select="concat(@value, ' ')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="@value"/>
               </xsl:otherwise>
            </xsl:choose>
         </prefix>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.5_20180611000000"
                 match="zorgaanbieder | healthcare_provider">
      <!-- Creates HL7 performing healthcare provider (uitvoerende zorgaanbieder)  -->
      <xsl:param name="deZorgaanbieder"
                 select="."
                 as="element()*">
         <!-- ada zorgaanbieder, defaults to context element -->
      </xsl:param>
      <xsl:for-each select="$deZorgaanbieder">
         <representedOrganization>
            <!--MP CDA Organization id name-->
            <xsl:for-each select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)[@value | @root][not(@nullFlavor and not(@value))]">
               <!-- MP CDA Zorgaanbieder identificaties -->
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
            <!-- if no proper value, still output nullFlavor if applicable -->
            <xsl:if test="not((zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)[@value | @root][not(@nullFlavor and not(@value))]) and (zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)[@nullFlavor]">
               <!-- MP CDA Zorgaanbieder identificaties -->
               <xsl:call-template name="makeIIid"/>
            </xsl:if>
            <xsl:for-each select="organisatie_naam[.//(@value | @nullFlavor)]">
               <xsl:element name="name">
                  <xsl:choose>
                     <xsl:when test="./@value">
                        <xsl:value-of select="./@value"/>
                     </xsl:when>
                     <xsl:when test="./@nullFlavor">
                        <xsl:attribute name="nullFlavor">
                           <xsl:value-of select="./@nullFlavor"/>
                        </xsl:attribute>
                     </xsl:when>
                  </xsl:choose>
               </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="contactgegevens/telefoonnummers[.//(@value | @nullFlavor)]">
               <telecom>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.103_20180611000000"/>
               </telecom>
            </xsl:for-each>
            <xsl:for-each select="contactgegevens/email_adressen[.//(@value | @nullFlavor)]">
               <telecom>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.104_20180611000000"/>
               </telecom>
            </xsl:for-each>
            <xsl:for-each select="adresgegevens[.//(@value | @nullFlavor)]">
               <addr>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.101_20180611000000"/>
               </addr>
            </xsl:for-each>
            <xsl:for-each select="organisatie_type">
               <standardIndustryClassCode>
                  <xsl:call-template name="makeCodeAttribs"/>
               </standardIndustryClassCode>
            </xsl:for-each>
            <xsl:for-each select="./afdeling_specialisme">
               <asOrganizationPartOf>
                  <xsl:call-template name="makeCode"/>
               </asOrganizationPartOf>
            </xsl:for-each>
         </representedOrganization>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.9_20180611000000"
                 match="zorgaanbieder | healthcare_provider"
                 mode="handleScopingEntity">
      <!-- Creates HL7 performing healthcare provider (uitvoerende zorgaanbieder)  -->
      <xsl:param name="deZorgaanbieder"
                 select=".">
         <!-- ada zorgaanbieder, defaults to context element -->
      </xsl:param>
      <xsl:for-each select="$deZorgaanbieder">
         <scopingEntity>
            <!--MP CDA Organization id name-->
            <!-- id -->
            <xsl:for-each select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)">
               <!-- MP CDA Zorgaanbieder identificaties -->
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
            <xsl:for-each select="organisatie_type">
               <code>
                  <xsl:call-template name="makeCodeAttribs"/>
               </code>
            </xsl:for-each>
            <!-- desc -->
            <xsl:for-each select="organisatie_naam[.//(@value | @nullFlavor)]">
               <xsl:element name="desc">
                  <xsl:choose>
                     <xsl:when test="./@value">
                        <xsl:value-of select="./@value"/>
                     </xsl:when>
                     <xsl:when test="./@nullFlavor">
                        <xsl:attribute name="nullFlavor">
                           <xsl:value-of select="./@nullFlavor"/>
                        </xsl:attribute>
                     </xsl:when>
                  </xsl:choose>
               </xsl:element>
            </xsl:for-each>
         </scopingEntity>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.100_20170602000000"
                 match="naamgegevens">
      <!--  name person NL - generic  -->
      <xsl:param name="naamgegevens"
                 select=".">
         <!-- ada naamgegevens element -->
      </xsl:param>
      <xsl:param name="unstructuredNameElement"
                 as="xs:string?"
                 select="'ongestructureerde_naam'">
         <!-- if your ada definition has an unstructuredNameElement, give the name of it, defaults to ongestructureerde_naam -->
      </xsl:param>
      <xsl:variable name="varNaamgegevens"
                    select="                 if ($naamgegevens/naamgegevens) then                     $naamgegevens/naamgegevens                 else                     $naamgegevens"/>
      <xsl:for-each select="$varNaamgegevens[.//(@value | @code | @nullFlavor)]">
         <xsl:variable name="structuredContent"
                       as="xs:boolean"
                       select="string-length(string-join(*[not(local-name() = $unstructuredNameElement)]//(@value | @code), '')) gt 0"/>
         <xsl:choose>
            <xsl:when test="not($structuredContent) and string-length(*[local-name() = $unstructuredNameElement]/@value) gt 0">
               <!-- we only have an unstructured name -->
               <xsl:value-of select="*[local-name() = $unstructuredNameElement]/@value"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="voornamen[.//(@value | @code | @nullFlavor)]">
                  <given qualifier="BR">
                     <xsl:value-of select="@value"/>
                  </given>
               </xsl:for-each>
               <xsl:for-each select="initialen[@value | @nullFlavor]">
                  <!-- in HL7v3 mogen de initialen van officiële voornamen niet herhaald / gedupliceerd worden in het initialen veld -->
                  <!-- https://hl7.nl/wiki/index.php?title=DatatypesR1:PN -->
                  <!-- in de zib moeten de initialen juist compleet zijn, dus de initialen hier verwijderen van de officiële voornamen -->
                  <!-- "Esther" "E.F.A." of "Esther" "E F A" wordt "Esther" "F.A.",
                     "Esther Feline" "E.F.A." wordt "Esther Feline" "A." -->
                  <!-- Een voornaam met een streepje wordt gezien als één naam met één bijbehorend initiaal
                     "Albert-Jan" "A.D." wordt "Albert-Jan" "D.",
                     "Albert-Jan" "A.J.D." wordt "Albert-Jan" "J.D.", 
                     "Albert-Jan" "A.J." wordt "Albert-Jan" "J.",
                     "Albert-Jan" "A." wordt "Albert-Jan" ""
                -->
                  <!-- Als de ada instance niet correct is gevuld en het initiaal van de ook doorgegeven voornamen niet in de juiste volgorde in de initialen staat, 
                     dan lukt het verwijderen van initialen niet goed. 
                     We zijn dus sterk afhankelijk van de kwaliteit van implementaties. -->
                  <xsl:variable name="adaFirstNameInitials"
                                as="xs:string?">
                     <xsl:variable name="init"
                                   as="xs:string*">
                        <xsl:for-each select="../voornamen/tokenize(normalize-space(@value), '\s')">
                           <xsl:value-of select="concat(substring(., 1, 1), '.')"/>
                        </xsl:for-each>
                     </xsl:variable>
                     <xsl:value-of select="string-join($init, '')"/>
                  </xsl:variable>
                  <xsl:variable name="adaInitials"
                                as="xs:string">
                     <xsl:variable name="init"
                                   as="xs:string*">
                        <xsl:for-each select="tokenize(normalize-space(replace(@value, '\.', ' ')), '\s')">
                           <xsl:value-of select="concat(., '.')"/>
                        </xsl:for-each>
                     </xsl:variable>
                     <xsl:value-of select="string-join($init, '')"/>
                  </xsl:variable>
                  <xsl:variable name="hl7Initials"
                                as="xs:string?">
                     <xsl:choose>
                        <xsl:when test="string-length($adaFirstNameInitials) gt 0 and string-length($adaInitials) gt 0">
                           <xsl:value-of select="replace($adaInitials, concat('^', $adaFirstNameInitials), '')"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="$adaInitials"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="$hl7Initials">
                     <given qualifier="IN">
                        <xsl:value-of select="nf:addEnding($hl7Initials, '.')"/>
                     </given>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="roepnaam[.//(@value | @code | @nullFlavor)]">
                  <given qualifier="CL">
                     <xsl:value-of select="@value"/>
                  </given>
               </xsl:for-each>
               <xsl:choose>
                  <!-- Eigen geslachtsnaam -->
                  <xsl:when test="naamgebruik/@code = 'NL1'">
                     <xsl:for-each select="geslachtsnaam/voorvoegsels[.//(@value | @code | @nullFlavor)]">
                        <xsl:call-template name="_prefix"/>
                     </xsl:for-each>
                     <xsl:for-each select="geslachtsnaam/achternaam[.//(@value | @code | @nullFlavor)]">
                        <family qualifier="BR">
                           <xsl:value-of select="./@value"/>
                        </family>
                     </xsl:for-each>
                  </xsl:when>
                  <!-- 	Geslachtsnaam partner -->
                  <xsl:when test="naamgebruik/@code = 'NL2'">
                     <xsl:for-each select="geslachtsnaam_partner/voorvoegsels_partner[.//(@value | @code | @nullFlavor)]">
                        <xsl:call-template name="_prefix"/>
                     </xsl:for-each>
                     <xsl:for-each select="geslachtsnaam_partner/achternaam_partner[.//(@value | @code | @nullFlavor)]">
                        <family qualifier="SP">
                           <xsl:value-of select="./@value"/>
                        </family>
                     </xsl:for-each>
                  </xsl:when>
                  <!-- Geslachtsnaam partner gevolgd door eigen geslachtsnaam -->
                  <xsl:when test="naamgebruik/@code = 'NL3'">
                     <xsl:for-each select="geslachtsnaam_partner/voorvoegsels_partner[.//(@value | @code | @nullFlavor)]">
                        <xsl:call-template name="_prefix"/>
                     </xsl:for-each>
                     <xsl:for-each select="geslachtsnaam_partner/achternaam_partner[.//(@value | @code | @nullFlavor)]">
                        <family qualifier="SP">
                           <xsl:value-of select="./@value"/>
                        </family>
                     </xsl:for-each>
                     <xsl:for-each select="geslachtsnaam/voorvoegsels[.//(@value | @code | @nullFlavor)]">
                        <xsl:call-template name="_prefix"/>
                     </xsl:for-each>
                     <xsl:for-each select="geslachtsnaam/achternaam[.//(@value | @code | @nullFlavor)]">
                        <family qualifier="BR">
                           <xsl:value-of select="./@value"/>
                        </family>
                     </xsl:for-each>
                  </xsl:when>
                  <!-- Eigen geslachtsnaam gevolgd door geslachtsnaam partner -->
                  <xsl:when test="naamgebruik/@code = 'NL4'">
                     <xsl:for-each select="geslachtsnaam/voorvoegsels[.//(@value | @code | @nullFlavor)]">
                        <xsl:call-template name="_prefix"/>
                     </xsl:for-each>
                     <xsl:for-each select="geslachtsnaam/achternaam[.//(@value | @code | @nullFlavor)]">
                        <family qualifier="BR">
                           <xsl:value-of select="./@value"/>
                        </family>
                     </xsl:for-each>
                     <xsl:for-each select="geslachtsnaam_partner/voorvoegsels_partner[.//(@value | @code | @nullFlavor)]">
                        <xsl:call-template name="_prefix"/>
                     </xsl:for-each>
                     <xsl:for-each select="geslachtsnaam_partner/achternaam_partner[.//(@value | @code | @nullFlavor)]">
                        <family qualifier="SP">
                           <xsl:value-of select="./@value"/>
                        </family>
                     </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- we nemen aan NL1 - alleen de eigen naam -->
                     <xsl:for-each select="geslachtsnaam/voorvoegsels[.//(@value | @code | @nullFlavor)]">
                        <xsl:call-template name="_prefix"/>
                     </xsl:for-each>
                     <xsl:for-each select="geslachtsnaam/achternaam[.//(@value | @code | @nullFlavor)]">
                        <family qualifier="BR">
                           <xsl:value-of select="./@value"/>
                        </family>
                     </xsl:for-each>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
      <!-- suffix (nog) niet in gebruik -->
      <!-- validTime (nog) niet in gebruik -->
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.101_20180611000000"
                 match="adresgegevens">
      <!--  address NL - generic  -->
      <xsl:param name="in"
                 select=".">
         <!-- The input ada adresgegevens -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:if test="adres_soort[1]/@code">
            <xsl:attribute name="use"
                           select="./adres_soort[1]/@code"/>
         </xsl:if>
         <xsl:for-each select="straat[@value | @nullFlavor]">
            <xsl:call-template name="makeText">
               <xsl:with-param name="elemName">streetName</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:for-each select="huisnummer[@value | @nullFlavor]">
            <xsl:call-template name="makeText">
               <xsl:with-param name="elemName">houseNumber</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="(huisnummerletter | huisnummertoevoeging)[@value]">
            <buildingNumberSuffix>
               <xsl:value-of select="huisnummerletter/@value"/>
               <!-- voeg scheidende spatie toe als beide aanwezig -->
               <xsl:if test="huisnummerletter/@value and huisnummertoevoeging/@value">
                  <xsl:text>
                  </xsl:text>
               </xsl:if>
               <xsl:value-of select="./huisnummertoevoeging/@value"/>
            </buildingNumberSuffix>
         </xsl:if>
         <xsl:for-each select="aanduiding_bij_nummer[@value | @nullFlavor]">
            <xsl:call-template name="makeText">
               <xsl:with-param name="elemName">additionalLocator</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:for-each select="postcode[@value | @nullFlavor]">
            <postalCode>
               <xsl:choose>
                  <xsl:when test="string-length(@value) gt 0">
                     <xsl:value-of select="nf:convertAdaNlPostcode(@value)"/>
                  </xsl:when>
                  <xsl:when test="@nullFlavor">
                     <xsl:copy-of select="@nullFlavor"/>
                  </xsl:when>
               </xsl:choose>
            </postalCode>
         </xsl:for-each>
         <xsl:for-each select="gemeente[@value | @code | @nullFlavor]">
            <xsl:choose>
               <xsl:when test="@code">
                  <county>
                     <xsl:call-template name="makeCodeAttribs"/>
                  </county>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="makeText">
                     <xsl:with-param name="elemName">county</xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
         <xsl:for-each select="woonplaats[@value | @code | @nullFlavor]">
            <xsl:choose>
               <xsl:when test="@code">
                  <city>
                     <xsl:call-template name="makeCodeAttribs"/>
                  </city>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="makeText">
                     <xsl:with-param name="elemName">city</xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
         <xsl:for-each select="land[@value | @code | @nullFlavor]">
            <xsl:choose>
               <xsl:when test="@code">
                  <country>
                     <xsl:call-template name="makeCodeAttribs"/>
                  </country>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="makeText">
                     <xsl:with-param name="elemName">country</xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
         <!-- Additionele informatie niet gemapt op het template... -->
         <!--<xsl:for-each select="./additionele_informatie">
            <unitID>
                <xsl:value-of select="./@value"/>
            </unitID>
        </xsl:for-each>-->
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.103_20180611000000"
                 match="telefoonnummers"
                 mode="HandleTelNrs">
      <!--  phone number - generic  -->
      <xsl:if test="nummer_soort[@code] or telecom_type/@code = 'MC'">
         <xsl:variable name="hl7Use"
                       as="xs:string*">
            <xsl:if test="nummer_soort[@code]">
               <xsl:value-of select="nummer_soort/@code"/>
            </xsl:if>
            <xsl:if test="telecom_type/@code = 'MC'">
               <xsl:value-of select="telecom_type/@code"/>
            </xsl:if>
         </xsl:variable>
         <xsl:attribute name="use"
                        select="string-join($hl7Use, ' ')"/>
      </xsl:if>
      <xsl:attribute name="value">
         <xsl:choose>
            <xsl:when test="telecom_type/@code = 'FAX' and not(starts-with(telefoonnummer/@value, 'fax:'))">fax:</xsl:when>
            <xsl:when test="starts-with(telefoonnummer/@value, 'tel:')"/>
            <xsl:otherwise>tel:</xsl:otherwise>
         </xsl:choose>
         <xsl:value-of select="translate(telefoonnummer/@value, ' ', '')"/>
      </xsl:attribute>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.104_20180611000000"
                 match="email_adressen"
                 mode="HandleEmailAdressen">
      <!--  email address - generic  -->
      <xsl:if test="email_soort[@code]">
         <xsl:attribute name="use">
            <xsl:value-of select="email_soort/@code"/>
         </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="value">
         <xsl:choose>
            <xsl:when test="starts-with(email_adres/@value, 'mailto:')">
               <xsl:value-of select="translate(email_adres/@value, ' ', '')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="concat('mailto:', translate(email_adres/@value, ' ', ''))"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:attribute>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.3.23_20171025000000"
                 match="verrichting | procedure"
                 mode="HandleProcedureActivity">
      <!-- procedure_activity based on ada verrichting, only supports type and start/end date -->
      <procedure classCode="PROC"
                 moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.7.10.3.23"/>
         <!-- verrichting_type -->
         <xsl:for-each select="verrichting_type | procedure_type">
            <xsl:call-template name="makeCode"/>
         </xsl:for-each>
         <!-- verrichting_start_datum en verrichting_eind_datum -->
         <xsl:variable name="theStartDate"
                       select="verrichting_start_datum | procedure_start_date"/>
         <xsl:variable name="theEndDate"
                       select="verrichting_eind_datum | procedure_end_date"/>
         <xsl:if test="$theStartDate[@value | @nullFlavor] or $theEndDate[@value | @nullFlavor]">
            <effectiveTime xsi:type="IVL_TS">
               <xsl:for-each select="$theStartDate[@value | @nullFlavor]">
                  <xsl:call-template name="makeTSValue">
                     <xsl:with-param name="elemName">low</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
               <xsl:for-each select="$theEndDate[@value | @nullFlavor]">
                  <xsl:call-template name="makeTSValue">
                     <xsl:with-param name="elemName">high</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
            </effectiveTime>
         </xsl:if>
         <!-- indicatie -->
         <xsl:for-each select="indicatie | indication">
            <!-- we may need to find the appropriate problem in the ada instance -->
            <xsl:variable name="adaProblem"
                          as="element()*">
               <xsl:variable name="theProblem"
                             select="problem | probleem"/>
               <xsl:choose>
                  <xsl:when test="$theProblem/*">
                     <xsl:sequence select="$theProblem"/>
                  </xsl:when>
                  <xsl:when test="$theProblem[not(@datatype) or @datatype = 'reference'][@value]">
                     <xsl:sequence select="ancestor::data//(problem | probleem)[@id = $theProblem/@value]"/>
                  </xsl:when>
                  <xsl:when test="$theProblem[@datatype = 'reference'][not(@value)][@nullFlavor]">
                     <probleem conceptId="{$theProblem[1]/@conceptId}"
                               xmlns="">
                        <probleem_naam code="{($theProblem[@datatype = 'reference'][not(@value)][@nullFlavor])[1]/@nullFlavor}"
                                       codeSystem="{$oidHL7NullFlavor}"/>
                     </probleem>
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            <xsl:for-each select="$adaProblem">
               <entryRelationship typeCode="RSON">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.3.19_20171025000000"/>
               </entryRelationship>
            </xsl:for-each>
         </xsl:for-each>
      </procedure>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.3.18_20180611000000"
                 match="ernst"
                 mode="HandleErnst">
      <!-- severity observation -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.3.10.3.18"/>
         <code code="SEV"
               displayName="Severity Observation"
               codeSystem="2.16.840.1.113883.5.4"
               codeSystemName="ActCode"/>
         <xsl:call-template name="makeCDValue"/>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.3.19_20180611000000"
                 match="probleem"
                 mode="HandleProblemObservationDiagnose">
      <!-- problem observation diagnose based on ada element probleem, defaults to problem type diagnosis -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.3.10.3.19"/>
         <!-- probleem type -->
         <xsl:choose>
            <xsl:when test="probleem_type[@code | @nullFlavor]">
               <xsl:call-template name="makeCode"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- default to diagnose -->
               <code code="282291009"
                     displayName="Diagnose"
                     codeSystem="{$oidSNOMEDCT}"/>
            </xsl:otherwise>
         </xsl:choose>
         <!-- start en einddatum -->
         <xsl:variable name="theStartDate"
                       select="probleem_begin_datum | problem_start_date"/>
         <xsl:variable name="theEndDate"
                       select="probleem_eind_datum | problem_end_date"/>
         <xsl:if test="$theStartDate[@value | @nullFlavor] or $theEndDate[@value | @nullFlavor]">
            <effectiveTime xsi:type="IVL_TS">
               <xsl:for-each select="$theStartDate[@value | @nullFlavor]">
                  <xsl:call-template name="makeTSValue">
                     <xsl:with-param name="elemName">low</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
               <xsl:for-each select="$theEndDate[@value | @nullFlavor]">
                  <xsl:call-template name="makeTSValue">
                     <xsl:with-param name="elemName">high</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
            </effectiveTime>
         </xsl:if>
         <xsl:for-each select="probleem_naam[.//(@value | @code | @nullFlavor)]">
            <xsl:call-template name="makeCDValue"/>
         </xsl:for-each>
         <!--  verificatiestatus -->
         <xsl:for-each select="verificatie_status[.//(@value | @code | @nullFlavor)]">
            <entryRelationship typeCode="SPRT">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.3.11.60.7.10.54"/>
                  <code code="408729009"
                        displayName="Finding context (attribute)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- because we need a "union" template which caters for all use cases some concepts have been added here -->
         <!-- this is not yet in the zib template (there is no such thing as 'union' template yet), but it does help to put it here for conversion -->
         <!-- aanvang -->
         <xsl:for-each select="aanvang[@code | @nullFlavor]">
            <entryRelationship typeCode="COMP">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.6.10.90.901155"/>
                  <code code="58891000146105"
                        displayName="Location of patient at start of disorder (observable entity)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- ernst -->
         <!-- Ernst encefalopathie -->
         <xsl:for-each select="(ernst | ernst_encefalopathie)[@code | @nullFlavor]">
            <entryRelationship typeCode="SUBJ"
                               inversionInd="true">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.3.11.60.3.10.3.18"/>
                  <code code="SEV"
                        displayName="Severity Observation"
                        codeSystem="2.16.840.1.113883.5.4"
                        codeSystemName="ActCode"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- Microorganisme  -->
         <xsl:for-each select="microorganisme[@code | @nullFlavor]">
            <entryRelationship typeCode="CAUS">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.6.10.90.901222"/>
                  <!-- GZ-754  deprecated code vervangen -->
                  <!--                        <code code="264395009" displayName="Microorganism (organism)" codeSystem="{$oidSNOMEDCT}" codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>-->
                  <code code="410607006"
                        displayName="organisme (organisme)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- microorganisme_sepsis_meningitis -->
         <!-- microorganisme_congenitale_infectie, TODO nieuw template -->
         <xsl:for-each select="(microorganisme_sepsis_meningitis | microorganisme_congenitale_infectie)[@code | @nullFlavor]">
            <entryRelationship typeCode="CAUS">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.6.10.90.901222"/>
                  <!-- GZ-754  deprecated code vervangen -->
                  <!--                        <code code="264395009" displayName="Microorganism (organism)" codeSystem="{$oidSNOMEDCT}" codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>-->
                  <code code="410607006"
                        displayName="organisme (organisme)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- lijnsepsis -->
         <xsl:for-each select="lijnsepsisq[.//(@value | @code | @nullFlavor)]">
            <entryRelationship typeCode="COMP">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.3.19_20180611000000_YN">
                  <xsl:with-param name="code">736152001</xsl:with-param>
                  <xsl:with-param name="displayName">bloedbaaninfectie gelijktijdig met en door centraal veneuze katheter in situ (aandoening)</xsl:with-param>
               </xsl:call-template>
            </entryRelationship>
         </xsl:for-each>
         <!-- onset -->
         <xsl:for-each select="onset[@value | @code | @nullFlavor]">
            <entryRelationship typeCode="COMP">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.6.10.90.901223"/>
                  <code code="246454002"
                        displayName="levensperiode (attribuut)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.3.19_20180611000000_YN"
                 match="element()"
                 mode="HandleProblemObservationYN">
      <!-- Handles a Yes/No for a problem observation (which has observation/code for diagnosis) based on context ada boolean element. Uses the @value attribute from context for target observation/@negationInd or the @nullFlavor from context for target observation/@nullFlavor. -->
      <xsl:param name="code"
                 as="xs:string?">
         <!-- The code for code attribute in observation/value. Must have value in order to output valid HL7. -->
      </xsl:param>
      <xsl:param name="codeSystem"
                 as="xs:string?">
         <!-- The codeSystem for code attribute in observation/value. Must have value in order to output valid HL7. -->
      </xsl:param>
      <xsl:param name="codeSystemName"
                 as="xs:string?">
         <!-- The codeSystemName for code attribute in observation/value. Optional. -->
      </xsl:param>
      <xsl:param name="displayName"
                 as="xs:string?">
         <!-- The displayName for code attribute in observation/value. Optional but should be there. -->
      </xsl:param>
      <observation classCode="OBS"
                   moodCode="EVN">
         <xsl:choose>
            <xsl:when test="@value = 'false'">
               <xsl:attribute name="negationInd">true</xsl:attribute>
            </xsl:when>
            <xsl:when test="@nullFlavor">
               <xsl:attribute name="nullFlavor"
                              select="@nullFlavor"/>
            </xsl:when>
         </xsl:choose>
         <templateId root="2.16.840.1.113883.2.4.3.11.60.3.10.3.19"/>
         <code code="282291009"
               displayName="Diagnose"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
         <value xsi:type="CD"
                code="{$code}"
                codeSystem="{$codeSystem}">
            <xsl:if test="$displayName">
               <xsl:attribute name="displayName"
                              select="$displayName"/>
            </xsl:if>
            <xsl:if test="$codeSystemName">
               <xsl:attribute name="codeSystemName"
                              select="$codeSystemName"/>
            </xsl:if>
         </value>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.3.19_20171025000000"
                 match="probleem"
                 mode="HandleProblemObservationDiagnoseActive">
      <!-- problem observation active diagnose based on ada element probleem, defaults to problem type diagnosis -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.7.10.3.19"/>
         <!-- probleem type -->
         <xsl:choose>
            <xsl:when test="probleem_type[@code | @nullFlavor]">
               <xsl:call-template name="makeCode"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- default to diagnose -->
               <code code="282291009"
                     displayName="Diagnose"
                     codeSystem="{$oidSNOMEDCT}"/>
            </xsl:otherwise>
         </xsl:choose>
         <!-- start en einddatum -->
         <xsl:variable name="theStartDate"
                       select="probleem_begin_datum | problem_start_date"/>
         <xsl:variable name="theEndDate"
                       select="probleem_eind_datum | problem_end_date"/>
         <xsl:if test="$theStartDate[@value | @nullFlavor] or $theEndDate[@value | @nullFlavor]">
            <effectiveTime xsi:type="IVL_TS">
               <xsl:for-each select="$theStartDate[@value | @nullFlavor]">
                  <xsl:call-template name="makeTSValue">
                     <xsl:with-param name="elemName">low</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
               <xsl:for-each select="$theEndDate[@value | @nullFlavor]">
                  <xsl:call-template name="makeTSValue">
                     <xsl:with-param name="elemName">high</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
            </effectiveTime>
         </xsl:if>
         <xsl:for-each select="probleem_naam[.//(@value | @code | @nullFlavor)]">
            <xsl:call-template name="makeCDValue"/>
         </xsl:for-each>
         <!-- probleemstatus, hier altijd active -->
         <entryRelationship typeCode="REFR"
                            inversionInd="true">
            <observation classCode="OBS"
                         moodCode="EVN">
               <templateId root="2.16.840.1.113883.2.4.3.11.60.7.10.3.20"/>
               <code code="33999-4"
                     codeSystem="2.16.840.1.113883.6.1"/>
               <value xsi:type="CD"
                      code="55561003"
                      codeSystem="{$oidSNOMEDCT}"
                      displayName="Active"/>
            </observation>
         </entryRelationship>
         <!--  verificatiestatus -->
         <xsl:for-each select="verificatie_status[.//(@value | @code | @nullFlavor)]">
            <entryRelationship typeCode="SPRT">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.3.11.60.7.10.54"/>
                  <code code="408729009"
                        displayName="Finding context (attribute)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- because we need a "union" template which caters for all use cases some concepts have been added here -->
         <!-- this is not yet in the zib template (there is no such thing as 'union' template yet), but it does help to put it here for conversion -->
         <!-- aanvang -->
         <xsl:for-each select="aanvang[@code | @nullFlavor]">
            <entryRelationship typeCode="COMP">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.6.10.90.901155"/>
                  <code code="58891000146105"
                        displayName="Location of patient at start of disorder (observable entity)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- ernst -->
         <!-- Ernst encefalopathie -->
         <xsl:for-each select="(ernst | ernst_encefalopathie)[@code | @nullFlavor]">
            <entryRelationship typeCode="SUBJ"
                               inversionInd="true">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.3.11.60.3.10.3.18"/>
                  <code code="SEV"
                        displayName="Severity Observation"
                        codeSystem="2.16.840.1.113883.5.4"
                        codeSystemName="ActCode"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- onset -->
         <xsl:for-each select="onset[@value | @code | @nullFlavor]">
            <entryRelationship typeCode="COMP">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.6.10.90.901223"/>
                  <code code="450426006"
                        displayName="foetale of neonatale periode (kwalificatiewaarde)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- Microorganisme  -->
         <xsl:for-each select="microorganisme[@code | @nullFlavor]">
            <entryRelationship typeCode="CAUS">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.6.10.90.901222"/>
                  <!-- GZ-754  deprecated code vervangen -->
                  <!--                        <code code="264395009" displayName="Microorganism (organism)" codeSystem="{$oidSNOMEDCT}" codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>-->
                  <code code="410607006"
                        displayName="organisme (organisme)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- microorganisme_sepsis_meningitis, TODO nieuw template -->
         <xsl:for-each select="microorganisme_sepsis_meningitis[@code | @nullFlavor]">
            <entryRelationship typeCode="CAUS">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.6.10.90.901222"/>
                  <!-- GZ-754  deprecated code vervangen -->
                  <!--                        <code code="264395009" displayName="Microorganism (organism)" codeSystem="{$oidSNOMEDCT}" codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>-->
                  <code code="410607006"
                        displayName="organisme (organisme)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
         <!-- microorganisme_congenitale_infectie, TODO nieuw template -->
         <xsl:for-each select="microorganisme_sepsis_meningitis[@code | @nullFlavor]">
            <entryRelationship typeCode="CAUS">
               <observation classCode="OBS"
                            moodCode="EVN">
                  <templateId root="2.16.840.1.113883.2.4.6.10.90.901222"/>
                  <!-- GZ-754  deprecated code vervangen -->
                  <!--                        <code code="264395009" displayName="Microorganism (organism)" codeSystem="{$oidSNOMEDCT}" codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>-->
                  <code code="410607006"
                        displayName="organisme (organisme)"
                        codeSystem="{$oidSNOMEDCT}"
                        codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
                  <xsl:call-template name="makeCDValue"/>
               </observation>
            </entryRelationship>
         </xsl:for-each>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.27_20180611000000"
                 match="health_professional | zorgverlener"
                 mode="HandleHealthProfessionalRole">
      <!--  zorgverlener-participantRole based on ada health professional -->
      <xsl:param name="in"
                 select=".">
         <!-- The input ada health professional element -->
      </xsl:param>
      <xsl:for-each select="$in">
         <participantRole classCode="ROL">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.3.10.3.27"/>
            <!-- id -->
            <xsl:for-each select="(zorgverlener_identificatie_nummer | zorgverlener_identificatienummer)[@value]">
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
            <xsl:if test="not((zorgverlener_identificatie_nummer | zorgverlener_identificatienummer)[@value])">
               <!-- een id wegschrijven met nullFlavor -->
               <id nullFlavor="NI"/>
            </xsl:if>
            <!-- code -->
            <xsl:for-each select="specialisme[@code]">
               <code>
                  <xsl:call-template name="makeCodeAttribs"/>
               </code>
            </xsl:for-each>
            <!-- addr -->
            <xsl:for-each select="adresgegevens[.//(@value | @code | @nullFlavor)]">
               <addr>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.101_20180611000000"/>
               </addr>
            </xsl:for-each>
            <!-- telecom -->
            <xsl:for-each select="contactgegevens/telefoonnummers[.//(@value | @nullFlavor)]">
               <telecom>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.103_20180611000000"/>
               </telecom>
            </xsl:for-each>
            <xsl:for-each select="contactgegevens/email_adressen[.//(@value | @nullFlavor)]">
               <telecom>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.104_20180611000000"/>
               </telecom>
            </xsl:for-each>
            <!-- playingEntity -->
            <xsl:for-each select="((zorgverlener_naam/naamgegevens) | (.//naamgegevens[not(child::naamgegevens)]))[.//(@value | @code | @nullFlavor)]">
               <playingEntity>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.100_20170602000000">
                     <xsl:with-param name="naamgegevens"
                                     select="."/>
                  </xsl:call-template>
               </playingEntity>
            </xsl:for-each>
            <!-- scopingEntity -->
            <xsl:for-each select="(zorgaanbieder/zorgaanbieder | zorgaanbieder[not(zorgaanbieder)])[.//(@value | @code | @nullFlavor)]">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.9_20180611000000"/>
            </xsl:for-each>
         </participantRole>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.32_20171221123947">
      <!--  part Encounter reference  -->
      <entryRelationship typeCode="REFR">
         <encounter classCode="ENC"
                    moodCode="EVN">
            <xsl:call-template name="makeIIid"/>
         </encounter>
      </entryRelationship>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.33_20171221124050">
      <!--  part Concern reference  -->
      <entryRelationship typeCode="REFR">
         <act classCode="ACT"
              moodCode="EVN">
            <xsl:call-template name="makeIIid"/>
            <code code="CONC"
                  codeSystem="2.16.840.1.113883.5.6"
                  displayName="Concern"
                  codeSystemName="ActClass"/>
         </act>
      </entryRelationship>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.50_20181217000000"
                 match="zorgaanbieder"
                 mode="zorgaanbieder2CDACustodian">
      <!-- CDA custodian. Context is zorgaanbieder -->
      <!-- zorgaanbieder -->
      <custodian>
         <assignedCustodian>
            <!--Zorgaanbieder-->
            <representedCustodianOrganization>
               <xsl:for-each select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)[@value | @root][not(@nullFlavor and not(@value))]">
                  <!-- MP CDA Zorgaanbieder identificaties -->
                  <xsl:call-template name="makeIIid"/>
               </xsl:for-each>
               <!-- if no proper value, still output nullFlavor if applicable -->
               <xsl:if test="not((zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)[@value | @root][not(@nullFlavor and not(@value))]) and (zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)[@nullFlavor]">
                  <!-- MP CDA Zorgaanbieder identificaties -->
                  <xsl:call-template name="makeIIid"/>
               </xsl:if>
               <xsl:for-each select="organisatie_naam[.//(@value | @nullFlavor)]">
                  <xsl:element name="name">
                     <xsl:choose>
                        <xsl:when test="@value">
                           <xsl:value-of select="@value"/>
                        </xsl:when>
                        <xsl:when test="@nullFlavor">
                           <xsl:attribute name="nullFlavor">
                              <xsl:value-of select="@nullFlavor"/>
                           </xsl:attribute>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:element>
               </xsl:for-each>
               <xsl:for-each select="contactgegevens/telefoonnummers[.//(@value | @nullFlavor)]">
                  <telecom>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.103_20180611000000"/>
                  </telecom>
               </xsl:for-each>
               <xsl:for-each select="contactgegevens/email_adressen[.//(@value | @nullFlavor)]">
                  <telecom>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.104_20180611000000"/>
                  </telecom>
               </xsl:for-each>
               <xsl:for-each select="adresgegevens[.//(@value | @nullFlavor)]">
                  <addr>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.101_20180611000000"/>
                  </addr>
               </xsl:for-each>
            </representedCustodianOrganization>
         </assignedCustodian>
      </custodian>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.51_20181218141008_za"
                 match="zorgaanbieder"
                 mode="zorgaanbieder2CDAAuthor">
      <!-- CDA author. Context can be either zorgverlener or zorgaanbieder -->
      <xsl:param name="authorTime"
                 as="element()?">
         <!-- ada element with author time -->
      </xsl:param>
      <xsl:param name="softwareName"
                 as="element()?">
         <!-- ada element with softwareName -->
      </xsl:param>
      <!-- zorgaanbieder -->
      <author>
         <time>
            <xsl:choose>
               <xsl:when test="$authorTime">
                  <xsl:for-each select="$authorTime">
                     <xsl:call-template name="makeTSValueAttr"/>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="nullFlavor">NI</xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
         </time>
         <assignedAuthor>
            <!--identificatie required but not applicable when author is organization  -->
            <id nullFlavor="NI"/>
            <xsl:for-each select="$softwareName">
               <assignedAuthoringDevice>
                  <softwareName>
                     <xsl:value-of select="@value"/>
                  </softwareName>
               </assignedAuthoringDevice>
            </xsl:for-each>
            <!--Zorgaanbieder-->
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.5_20180611000000"/>
         </assignedAuthor>
      </author>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.51_20181218141008_dev"
                 match="software_naam"
                 mode="software2CDAAuthor">
      <!-- CDA author for software name. Context is expected to be software_naam -->
      <!-- device -->
      <author>
         <time>
            <xsl:attribute name="nullFlavor">NI</xsl:attribute>
         </time>
         <assignedAuthor>
            <!--identificatie required but not applicable when author is device  -->
            <id nullFlavor="NI"/>
            <!--Device-->
            <assignedAuthoringDevice>
               <xsl:call-template name="template_2.16.840.1.113883.10.12.815_20050907000000"/>
            </assignedAuthoringDevice>
         </assignedAuthor>
      </author>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.52_20170825000000">
      <!--  CDA author of informant patient  -->
      <xsl:param name="ada_patient_identificatienummer"
                 select="//patient/(patient_identificatienummer | identificatienummer)">
         <!-- ada patient id -->
      </xsl:param>
      <xsl:for-each select="$ada_patient_identificatienummer">
         <xsl:call-template name="makeIIid"/>
      </xsl:for-each>
      <code code="ONESELF"
            displayName="Self"
            codeSystem="{$oidHL7RoleCode}"
            codeSystemName="RoleCode"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.55_20190708135422"
                 match="schedelomvang | head_circumference"
                 mode="HandleHeadCircumference">
      <!--  MP CDA Head Circumference based on ada head_circumference (schedelomvang) -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.7.10.55"/>
         <code code="363812007"
               displayName="Head circumference"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
         <xsl:for-each select="(schedelomvang_datum_tijd | head_circumference_date)[@value | @nullFlavor]">
            <xsl:call-template name="makeTSValue">
               <xsl:with-param name="elemName">effectiveTime</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:for-each select="(schedelomvang_waarde | head_circumference_measurement)[@value | @nullFlavor]">
            <xsl:call-template name="makePQValue"/>
         </xsl:for-each>
         <xsl:for-each select="(schedelomvang_meetmethode | head_circumference_measuring_method)[@value | @code | @nullFlavor]">
            <xsl:call-template name="makeCode">
               <xsl:with-param name="elemName">methodCode</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <!-- toelichting, text is mandatory in this template so do not output anything when there is no @value in input -->
         <xsl:for-each select="(toelichting | comment)[@value]">
            <entryRelationship typeCode="REFR">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.32_20180611000000"/>
            </entryRelationship>
         </xsl:for-each>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.56_20190916154439"
                 match="lichaamstemperatuur | body_temperature"
                 mode="HandleBodyTemperature">
      <!--  MP CDA Body Temperature based on ada lichaamstemperatuur -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.7.10.56"/>
         <code code="8310-5"
               displayName="Body temperature"
               codeSystem="{$oidLOINC}"
               codeSystemName="{$oidMap[@oid=$oidLOINC]/@displayName}"/>
         <xsl:for-each select="(temperatuur_datum_tijd | temperature_date_time)[@value | @nullFlavor]">
            <xsl:call-template name="makeTSValue">
               <xsl:with-param name="elemName">effectiveTime</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:for-each select="(temperatuur_waarde | temperature_value)[@value | @nullFlavor]">
            <xsl:call-template name="makePQValue"/>
         </xsl:for-each>
         <xsl:for-each select="(temperatuur_type | temperature_type)[@value | @code | @nullFlavor]">
            <xsl:call-template name="makeCode">
               <xsl:with-param name="elemName">methodCode</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <!-- toelichting, text is mandatory in this template so do not output anything when there is no @value in input -->
         <xsl:for-each select="(toelichting | comment)[@value]">
            <entryRelationship typeCode="REFR">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.32_20180611000000"/>
            </entryRelationship>
         </xsl:for-each>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.10.12.815_20050907000000"
                 match="software_naam"
                 mode="software2CDADevice">
      <!-- Creates CDA Device (SDTC) -->
      <xsl:param name="theSoftwareName"
                 select=".">
         <!-- ada softwareName, defaults to context element -->
      </xsl:param>
      <xsl:for-each select="$theSoftwareName">
         <softwareName>
            <xsl:value-of select="@value"/>
         </softwareName>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>