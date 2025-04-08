<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/mp/2_hl7_mp_include_612.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.8; 2025-04-08T17:27:28.82+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="#local.2024011810474684204880100"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:util="urn:hl7:utilities"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pharm="urn:ihe:pharm:medication">
   <!-- ================================================================== -->
   <!--
        
            Created on: Oct 16, 2018
            Author: nictiz
            Mapping xslt for creating HL7 for Medicatieproces 6.12. To be imported or included from another xslt. Only templates for 6.12 which are not shared by other versions.
        
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
   <xsl:import href="2_hl7_mp_include.xsl"/>
   <!-- link to 2020 needed for 2_hl7_mp_include.xsl -->
   <xsl:import href="ada2hl7_all-zibs-d551e262.xsl"/>
   <xsl:import href="2_hl7_naw_include.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <!-- ================================================================== -->
   <xsl:template name="makeCyclischComp">
      <!--  Cyclisch schema comp  -->
      <xsl:param name="operator"
                 select="'A'"/>
      <xsl:param name="theDoseerduur"/>
      <xsl:param name="doseerduur-startdatum"
                 as="xs:string?"/>
      <xsl:param name="herhaalperiode"/>
      <!-- in een cyclisch schema moet in 6.12 de doseerduur in dagen  -->
      <xsl:variable name="doseerduur_in_dagen"
                    select="nf:calculate_Duur_In_Dagen($theDoseerduur/@value, nf:convertTime_ADA_unit2UCUM($theDoseerduur/@unit))"/>
      <xsl:attribute name="operator"
                     select="$operator"/>
      <xsl:for-each select="$theDoseerduur[@value and @unit]">
         <phase>
            <xsl:for-each select="$doseerduur-startdatum[. castable as xs:dateTime or . castable as xs:date]">
               <xsl:call-template name="makeTSValue">
                  <xsl:with-param name="elemName">low</xsl:with-param>
                  <xsl:with-param name="inputValue"
                                  select="."/>
                  <xsl:with-param name="xsiType"/>
                  <xsl:with-param name="inputNullFlavor"/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:call-template name="makePQValue">
               <xsl:with-param name="inputValue"
                               select="$doseerduur_in_dagen"/>
               <xsl:with-param name="elemName">width</xsl:with-param>
               <xsl:with-param name="unit"
                               select="'d'"/>
               <xsl:with-param name="xsiType"
                               select="''"/>
            </xsl:call-template>
         </phase>
      </xsl:for-each>
      <xsl:for-each select="$herhaalperiode[. instance of element()]">
         <xsl:call-template name="makePQValue">
            <xsl:with-param name="inputValue"
                            select="./@value"/>
            <xsl:with-param name="elemName">period</xsl:with-param>
            <xsl:with-param name="unit"
                            select="nf:convertTime_ADA_unit2UCUM(./@unit)"/>
            <xsl:with-param name="xsiType"
                            select="''"/>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="makeTherapeuticAgentOf_4_template_2.16.840.1.113883.2.4.3.11.60.20.77.10.100_20130521000000">
      <!-- Helper template to make TherapeuticAgentOf -->
      <xsl:param name="adaBouwsteen"
                 as="element()?">
         <!-- The ada bouwsteen which has gebruiksinstructie, so for example medicatieafspraak, toedieningsafspraak. No default -->
      </xsl:param>
      <xsl:param name="frequentie_value"
                 as="xs:integer?"/>
      <xsl:param name="zonodig"
                 as="xs:boolean?"/>
      <xsl:param name="dosering"
                 select="."
                 as="element()*">
         <!-- The ada dosering, defaults to context -->
      </xsl:param>
      <xsl:variable name="herhaalperiode"
                    select="$adaBouwsteen/gebruiksinstructie/herhaalperiode_cyclisch_schema"/>
      <xsl:variable name="doseerinstructies"
                    select="$adaBouwsteen//doseerinstructie"/>
      <xsl:variable name="gebruiksperiode-start"
                    select="$adaBouwsteen/(gebruiksperiode_start | gebruiksperiode/start_datum_tijd)"/>
      <!-- een niet-cyclisch schema met meerdere doseerinstructies zonder startdatum gebruiksperiode kan niet
                 gestructureerd in 6.12 omdat de volgorde dan niet overgebracht kan worden -->
      <!-- tenzij er geen verschillende doseerduur én geen verschillend sequencenummer in zit, dan zijn ze gewoon parallel naast elkaar, dat kan in 6.12 ook -->
      <xsl:variable name="niet-cyclisch-zonder-start"
                    select="not($herhaalperiode/@value) and count($adaBouwsteen//doseerinstructie) gt 1 and not($gebruiksperiode-start/@value)"/>
      <!-- een niet-cyclisch schema met meerdere doseerinstructies mét startdatum gebruiksperiode kan wel
           gestructureerd in 6.12 omdat de volgorde dan dus wel overgebracht kan worden in meerdere MAR's
           dit gaat mbv de IVL_TS gebruiksperiode -->
      <xsl:variable name="niet-cyclisch-met-start"
                    select="not($herhaalperiode/@value) and count($adaBouwsteen//doseerinstructie) gt 1 and $gebruiksperiode-start/@value"/>
      <!-- bij een niet-cyclisch schema met startdatum gebruik, en doseerduur in alle doseerinstructies de juiste startdatum berekenen, 
         de doseerduur gebruiken als gebruiksduur in deze MAR en de eventuele einddatum gebruik negeren -->
      <xsl:variable name="gebruiksperiode-start-value"
                    as="xs:string?">
         <xsl:choose>
            <xsl:when test="$niet-cyclisch-met-start and count($doseerinstructies) = count($doseerinstructies[./doseerduur])">
               <xsl:value-of select="nf:calculate_Doseerinstructie_Startdate(xs:date(substring($gebruiksperiode-start/@value, 1, 10)), $dosering, $doseerinstructies)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$gebruiksperiode-start/@value"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="gebruiksperiode-duur"
                    as="element()?">
         <xsl:choose>
            <xsl:when test="not($niet-cyclisch-met-start) and not($niet-cyclisch-zonder-start)">
               <xsl:sequence select="$adaBouwsteen/(gebruiksperiode | gebruiksperiode/tijds_duur)[@value]"/>
            </xsl:when>
            <!-- if none of the doseerinstructies have doseerduur then all of them are applicable during the gebruiksperiode  -->
            <xsl:when test="not($doseerinstructies[./doseerduur])">
               <xsl:sequence select="$adaBouwsteen/(gebruiksperiode | gebruiksperiode/tijds_duur)[@value]"/>
            </xsl:when>
            <!-- if all of the doseerinstructies have doseerduur and startdate then we can use the current doseerduur in 6.12 IVL_TS -->
            <xsl:when test="$niet-cyclisch-met-start and count($doseerinstructies) = count($doseerinstructies[./doseerduur])">
               <xsl:sequence select="$dosering/../doseerduur"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="gebruiksperiode-eind"
                    select="$adaBouwsteen[not($niet-cyclisch-met-start)]/(gebruiksperiode_eind | gebruiksperiode/eind_datum_tijd)"
                    as="element()*"/>
      <xsl:variable name="gebruiksperiode_exists"
                    select="$gebruiksperiode-duur/@value or $gebruiksperiode-start/@value or $gebruiksperiode-eind/@value"/>
      <xsl:variable name="toedieningsschema"
                    select="$dosering/toedieningsschema"/>
      <xsl:variable name="schema_in_1_pivlts"
                    as="xs:boolean">
         <xsl:choose>
            <!-- TODO uitbreiden met mogelijkheden -->
            <xsl:when test="$adaBouwsteen//herhaalperiode_cyclisch_schema">
               <xsl:value-of select="false()"/>
            </xsl:when>
            <xsl:when test="count($toedieningsschema/toedientijd[@value]) &gt; 1">
               <xsl:value-of select="false()"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="true()"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="eenmalig_gebruik"
                    select="$toedieningsschema/frequentie/aantal/(vaste_waarde | nominale_waarde)/@value and not($toedieningsschema/frequentie/tijdseenheid/@value)"/>
      <xsl:variable name="doseerduur-in-uren"
                    select="$dosering/../doseerduur[@unit = $ada-unit-hour]"/>
      <xsl:variable name="toedieningsschema612_exists"
                    as="xs:boolean?">
         <xsl:choose>
            <!-- een cyclisch schema met doseerduur in uren kunnen we niet gestructureerd overbrengen in 6.12 -->
            <xsl:when test="$herhaalperiode and $doseerduur-in-uren">false</xsl:when>
            <!-- een niet-cyclisch schema met meerdere doseerinstructies zonder startdatum gebruiksperiode kan niet
                 gestructureerd in 6.12 omdat de volgorde dan niet overgebracht kan worden, tenzij ze allemaal parallel zijn -->
            <xsl:when test="$niet-cyclisch-zonder-start and $doseerinstructies[./doseerduur]">false</xsl:when>
            <!-- dagdelen worden niet ondersteund in 6.12. Alleen de tekst en gebruiksperiode worden overgenomen. -->
            <xsl:when test="$toedieningsschema//dagdeel[@value or @code]">false</xsl:when>
            <!-- het converteren van weekdagen wordt niet ondersteund van ada naar 6.12. Alleen de tekst en gebruiksperiode worden overgenomen. -->
            <xsl:when test="$toedieningsschema//weekdag[@value or @code]">false</xsl:when>
            <xsl:when test="exists($toedieningsschema//*[local-name(.) != 'dagdeel']/@value)">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <therapeuticAgentOf>
         <medicationAdministrationRequest classCode="SBADM"
                                          moodCode="RQO">
            <!-- Item(s) :: omschrijving -->
            <xsl:for-each select="$adaBouwsteen/gebruiksinstructie/omschrijving[@value]">
               <text mediaType="text/plain">
                  <xsl:value-of select="@value"/>
               </text>
            </xsl:for-each>
            <statusCode code="active"/>
            <xsl:choose>
               <!-- Gebruiksperiode en toedieningsschema, maar géén eenmalig gebruik -->
               <xsl:when test="$gebruiksperiode_exists and $toedieningsschema612_exists and not($eenmalig_gebruik)">
                  <effectiveTime>
                     <xsl:attribute name="xsi:type"
                                    select="'SXPR_TS'"/>
                     <!-- Gebruiksperiode in een IVL_TS comp -->
                     <xsl:for-each select="$adaBouwsteen">
                        <comp>
                           <xsl:attribute name="xsi:type"
                                          select="'IVL_TS'"/>
                           <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9019_20130521000000">
                              <xsl:with-param name="begindatum"
                                              select="$gebruiksperiode-start-value"/>
                              <xsl:with-param name="duur"
                                              select="$gebruiksperiode-duur"/>
                              <xsl:with-param name="einddatum"
                                              select="$gebruiksperiode-eind/@value"/>
                           </xsl:call-template>
                        </comp>
                     </xsl:for-each>
                     <!-- doseerschema, in PIVL_TS('en) te vangen -->
                     <xsl:call-template name="schema_in_comps">
                        <xsl:with-param name="dosering"
                                        select="."/>
                        <xsl:with-param name="frequentie_value"
                                        select="$frequentie_value"/>
                        <xsl:with-param name="herhaalperiode"
                                        select="$herhaalperiode"/>
                        <xsl:with-param name="adaBouwsteen"
                                        select="$adaBouwsteen"/>
                     </xsl:call-template>
                  </effectiveTime>
               </xsl:when>
               <!-- Gebruiksperiode zonder toedieningsschema: alleen een IVL_TS in effectiveTime -->
               <xsl:when test="$gebruiksperiode_exists and not($toedieningsschema612_exists)">
                  <xsl:for-each select="$adaBouwsteen">
                     <effectiveTime>
                        <xsl:attribute name="xsi:type"
                                       select="'IVL_TS'"/>
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9019_20130521000000">
                           <xsl:with-param name="begindatum"
                                           select="$gebruiksperiode-start/@value"/>
                           <xsl:with-param name="duur"
                                           select="$gebruiksperiode-duur"/>
                           <xsl:with-param name="einddatum"
                                           select="$gebruiksperiode-eind/@value"/>
                        </xsl:call-template>
                     </effectiveTime>
                  </xsl:for-each>
               </xsl:when>
               <!-- Géén gebruiksperiode, wel een eenvoudig toedieningsschema in één PIVL_TS in effectiveTime, géén eenmalig gebruik-->
               <xsl:when test="not($gebruiksperiode_exists) and $toedieningsschema612_exists and $schema_in_1_pivlts and not($eenmalig_gebruik)">
                  <!-- "eenvoudig" doseerschema, in één PIVL_TS('en) te vangen -->
                  <xsl:for-each select="./toedieningsschema">
                     <effectiveTime>
                        <xsl:attribute name="xsi:type"
                                       select="'PIVL_TS'"/>
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9020_20150305134139">
                           <xsl:with-param name="theDoseerduur"
                                           select="./../../doseerduur[@value]"/>
                           <xsl:with-param name="interval"
                                           select="./interval"/>
                           <xsl:with-param name="operator"/>
                           <xsl:with-param name="toedieningsschema"
                                           select="."/>
                           <xsl:with-param name="toedientijd"
                                           select="./toedientijd/@value"/>
                           <xsl:with-param name="vaste_frequentie"
                                           select="$frequentie_value"/>
                           <xsl:with-param name="vaste_freq_tijd"
                                           select="./frequentie/tijdseenheid"/>
                        </xsl:call-template>
                     </effectiveTime>
                  </xsl:for-each>
               </xsl:when>
               <!-- Géén gebruiksperiode, maar een toedieningsschema dat niet in één PIVL_TS te vangen is -->
               <xsl:when test="not($gebruiksperiode_exists) and not($schema_in_1_pivlts)">
                  <effectiveTime>
                     <xsl:attribute name="xsi:type"
                                    select="'SXPR_TS'"/>
                     <!-- doseerschema, in PIVL_TS('en) te vangen -->
                     <xsl:call-template name="schema_in_comps">
                        <xsl:with-param name="dosering"
                                        select="."/>
                        <xsl:with-param name="frequentie_value"
                                        select="$frequentie_value"/>
                        <xsl:with-param name="herhaalperiode"
                                        select="$herhaalperiode"/>
                        <xsl:with-param name="adaBouwsteen"
                                        select="$adaBouwsteen"/>
                     </xsl:call-template>
                  </effectiveTime>
               </xsl:when>
               <!-- eenmalig gebruik -->
               <xsl:when test="$eenmalig_gebruik">
                  <xsl:variable name="aantal_keer"
                                select="./toedieningsschema/frequentie/aantal/(vaste_waarde | nominale_waarde)/@value"/>
                  <!-- 6.12 ondersteunt alleen eenmalig gebruik -->
                  <xsl:choose>
                     <xsl:when test="$aantal_keer = 1">
                        <!-- Neem startdatum van gebruik als dat beschikbaar is, anders nemen we aan: de datum van vandaag -->
                        <xsl:variable name="date_eenmalig_gebruik">
                           <xsl:choose>
                              <xsl:when test="$adaBouwsteen/gebruiksperiode/start">
                                 <xsl:call-template name="format2HL7Date">
                                    <xsl:with-param name="dateTime"
                                                    select="./@value"/>
                                 </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:call-template name="format2HL7Date">
                                    <xsl:with-param name="dateTime"
                                                    select="string(current-date())"/>
                                 </xsl:call-template>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:variable>
                        <effectiveTime>
                           <xsl:attribute name="value"
                                          select="$date_eenmalig_gebruik"/>
                        </effectiveTime>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:comment>Voorschrift 6.12 ondersteunt alleen eenmalig gebruik (en dus niet gebruik x keer, waarbij x &gt; 1). 
Gevonden is een x van "
<xsl:value-of select="$aantal_keer"/>". Dit kan niet gestructureerd worden meegegeven.</xsl:comment>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
            </xsl:choose>
            <xsl:if test="$herhaalperiode and $doseerduur-in-uren">
               <xsl:comment>Let op! Er is in de input een herhaalperiode voor een cyclisch schema aangetroffen in combinatie met een doseerduur in uren. Dit kan in een 6.12 niet gestructureerd worden opgenomen.</xsl:comment>
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logWARN"/>
                  <xsl:with-param name="msg">Let op! Er is in de input een herhaalperiode voor een cyclisch schema aangetroffen in combinatie met een doseerduur in uren. Dit kan in een 6.12 niet gestructureerd worden opgenomen.</xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <xsl:if test="$niet-cyclisch-zonder-start and $doseerinstructies[./doseerduur]">
               <xsl:comment>Let op! Er is in de input een niet-cyclisch schema met meerdere doseerinstructies zonder startdatum gebruiksperiode. Dit kan in 6.12 niet gestructureerd worden opgenomen omdat de volgorde dan niet overgebracht kan worden.</xsl:comment>
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logWARN"/>
                  <xsl:with-param name="msg">Let op! Er is in de input een niet-cyclisch schema met meerdere doseerinstructies zonder startdatum gebruiksperiode. Dit kan in 6.12 niet gestructureerd worden opgenomen omdat de volgorde dan niet overgebracht kan worden.</xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <xsl:if test="$toedieningsschema//dagdeel[@value or @code]">
               <xsl:comment>Let op! Er is in de input een toedieningsschema met een of meerdere dagdelen aangetroffen. Dit kan in 6.12 niet gestructureerd worden opgenomen, daarom vindt u alleen de eventuele gebruiksperiode en tekstuele omschrijving terug.</xsl:comment>
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logWARN"/>
                  <xsl:with-param name="msg">Let op! Er is in de input een toedieningsschema met een of meerdere dagdelen aangetroffen. Dit kan in 6.12 niet gestructureerd worden opgenomen, daarom vindt u alleen de eventuele gebruiksperiode en tekstuele omschrijving terug.</xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <xsl:if test="$toedieningsschema//weekdag[@value or @code]">
               <xsl:comment>Let op! Er is in de input een toedieningsschema met een of meerdere weekdagen aangetroffen. Dit kan in 6.12 niet gestructureerd worden opgenomen, daarom vindt u alleen de eventuele gebruiksperiode en tekstuele omschrijving terug.</xsl:comment>
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logWARN"/>
                  <xsl:with-param name="msg">Let op! Er is in de input een toedieningsschema met een of meerdere weekdagen aangetroffen. Dit kan in 6.12 niet gestructureerd worden opgenomen, daarom vindt u alleen de eventuele gebruiksperiode en tekstuele omschrijving terug.</xsl:with-param>
               </xsl:call-template>
            </xsl:if>
            <!-- Item(s) :: toedieningsweg, not allowed with nullFlavor, but allowed to omit-->
            <xsl:for-each select="$adaBouwsteen/gebruiksinstructie/toedieningsweg[@value | @code][not(@codeSystem = $oidHL7NullFlavor)]">
               <xsl:call-template name="makeCEValue">
                  <xsl:with-param name="xsiType"
                                  select="''"/>
                  <xsl:with-param name="elemName">routeCode</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- Item(s) :: keerdosis-->
            <xsl:for-each select="$dosering/keerdosis[.//(@value | @code)]">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9048_20150724151109"/>
            </xsl:for-each>
            <!-- <doseCheckQuantity><!-\- MP 9 kent geen elementen in de dataset die mappen op doseCheckQuantity -\-> </doseCheckQuantity>-->
            <!-- Item(s) :: maximale_dosering max_dosering_per_periode-->
            <xsl:for-each select="$dosering/zo_nodig/maximale_dosering[.//@value]">
               <maxDoseQuantity>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9064_20160601000000"/>
               </maxDoseQuantity>
            </xsl:for-each>
            <xsl:for-each select="$adaBouwsteen/gebruiksinstructie/aanvullende_instructie">
               <xsl:variable name="code">
                  <xsl:choose>
                     <xsl:when test="@codeSystem = $oidNHGTabel25BCodesNumeriek">
                        <xsl:value-of select="@code"/>
                     </xsl:when>
                     <xsl:otherwise>OTH</xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="codeSystem"
                             select="@codeSystem"/>
               <!-- TODO de plek van originalText moet nog verbeterd, dit gaat niet goed werken -->
               <xsl:variable name="strOriginalText">
                  <xsl:choose>
                     <xsl:when test="@codeSystem = $oidNHGTabel25BCodesNumeriek">
                        <!-- leeg -->
                     </xsl:when>
                     <xsl:when test="@originalText">
                        <xsl:value-of select="@originalText"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="@displayName"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <support2 typeCode="SPRT">
                  <!-- Template :: Medication Administration Instruction -->
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.101_20130521000000">
                     <xsl:with-param name="code"
                                     select="$code"/>
                     <xsl:with-param name="codeSystem"
                                     select="$codeSystem"/>
                     <xsl:with-param name="displayName"
                                     select="./@displayName"/>
                     <xsl:with-param name="strOriginalText"
                                     select="$strOriginalText"/>
                  </xsl:call-template>
               </support2>
            </xsl:for-each>
            <xsl:for-each select="$dosering/zo_nodig/criterium">
               <precondition>
                  <!-- Template :: Observation Event Criterion -->
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9001_20130521000000">
                     <xsl:with-param name="code"
                                     select="(. | code | criterium)/@code"/>
                     <xsl:with-param name="codeSystem"
                                     select="(. | code | criterium)/@codeSystem"/>
                     <xsl:with-param name="displayName"
                                     select="(. | code | criterium)/@displayName"/>
                     <xsl:with-param name="strOriginalText"
                                     select="(. | code | criterium)/@originalText"/>
                  </xsl:call-template>
               </precondition>
            </xsl:for-each>
            <xsl:if test="$zonodig and not($dosering/zo_nodig/criterium/(. | code | criterium)[@code = '1137'])">
               <precondition>
                  <observationEventCriterion>
                     <code code="1137"
                           codeSystem="{$oidNHGTabel25BCodesNumeriek}"
                           displayName="zo nodig"/>
                  </observationEventCriterion>
               </precondition>
            </xsl:if>
         </medicationAdministrationRequest>
      </therapeuticAgentOf>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="schema_in_comps">
      <!--  Helping template for toedieningsschema in comp elements  -->
      <xsl:param name="dosering"
                 select=".">
         <!-- The ada dosage (dosering) -->
      </xsl:param>
      <xsl:param name="frequentie_value"
                 as="xs:integer?">
         <!-- The ada frequency value -->
      </xsl:param>
      <xsl:param name="herhaalperiode"
                 select="../../herhaalperiode_cyclisch_schema">
         <!-- The ada repeat period cyclic schedule -->
      </xsl:param>
      <xsl:param name="adaBouwsteen"
                 select="../../..">
         <!-- The ada therapeutic building block -->
      </xsl:param>
      <xsl:param name="toedieningsschema"
                 select="$dosering/toedieningsschema">
         <!-- The ada administering schedule -->
      </xsl:param>
      <xsl:variable name="doseerinstructies"
                    select="$adaBouwsteen//doseerinstructie"/>
      <xsl:variable name="theDoseerduur"
                    select="$dosering/../doseerduur[@value]"/>
      <xsl:variable name="cyclisch-schema"
                    as="xs:boolean"
                    select="exists($herhaalperiode/@value)"/>
      <xsl:variable name="startdatum-dosering-1"
                    as="xs:date">
         <xsl:choose>
            <xsl:when test="$adaBouwsteen/(gebruiksperiode_start | gebruiksperiode/start_datum_tijd)[@value castable as xs:date]">
               <xsl:value-of select="xs:date($adaBouwsteen/(gebruiksperiode_start | gebruiksperiode/start_datum_tijd)/@value)"/>
            </xsl:when>
            <xsl:when test="$adaBouwsteen/(gebruiksperiode_start | gebruiksperiode/start_datum_tijd)[@value castable as xs:dateTime]">
               <xsl:value-of select="xs:date(substring-before($adaBouwsteen/(gebruiksperiode_start | gebruiksperiode/start_datum_tijd)/@value, 'T'))"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="current-date()"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="doseerduur-startdatum"
                    select="nf:calculate_Doseerinstructie_Startdate($startdatum-dosering-1, $dosering, $doseerinstructies)"/>
      <!-- doseerduur voor niet-cyclische PIVL_TS'en -->
      <xsl:variable name="doseerduur-niet-cyclisch"
                    select="$theDoseerduur[not($cyclisch-schema)]"/>
      <!-- de startdatum voor geankerd interval is 
            bij meerdere doseerinstructies verplicht omdat volgorde in 6.12 moet worden afgeleid met deze datums 
            bij 1 doseerinstructie niet op te nemen in 6.12 omdat ook daar dan impliciet de gebruiksperiode geldt, indien aanwezig. 
            Zonder gebruiksperiode zweeft het interval überhaupt ergens - niemand weet waar (behalve misschien via de tekst "te gebruiken bij start vakantie").
            als toedieningsschema weekdagen heeft vallen we terug op alleen vrije tekst in 6.12 -->
      <xsl:if test="($frequentie_value or $toedieningsschema/interval[@value]) and not($toedieningsschema/toedientijd[@value]) and not($toedieningsschema/weekdag[@code])">
         <xsl:for-each select="$toedieningsschema">
            <comp>
               <xsl:attribute name="xsi:type"
                              select="'PIVL_TS'"/>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9020_20150305134139">
                  <xsl:with-param name="theDoseerduur"
                                  select="$doseerduur-niet-cyclisch"/>
                  <xsl:with-param name="interval"
                                  select="./interval"/>
                  <xsl:with-param name="operator">A</xsl:with-param>
                  <xsl:with-param name="toedieningsschema"
                                  select="."/>
                  <xsl:with-param name="vaste_frequentie"
                                  select="$frequentie_value"/>
                  <xsl:with-param name="vaste_freq_tijd"
                                  select="./frequentie/tijdseenheid"/>
               </xsl:call-template>
            </comp>
         </xsl:for-each>
      </xsl:if>
      <!-- the comp elementen met toedientijden -->
      <xsl:for-each select="$toedieningsschema/toedientijd[@value]">
         <xsl:variable name="currentToedientijd"
                       select="."/>
         <xsl:variable name="operator">
            <xsl:choose>
               <!-- De eerste toedientijd moet met operator A (doorsnijden van de gebruiksperiode), die daarna met I (verenigen) omdat toedientijden elkaar per definitie uitsluiten -->
               <xsl:when test="index-of($toedieningsschema/toedientijd/@value, $currentToedientijd/@value) = 1">A</xsl:when>
               <xsl:otherwise>I</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <comp>
            <xsl:attribute name="xsi:type"
                           select="'PIVL_TS'"/>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9020_20150305134139">
               <xsl:with-param name="theDoseerduur"/>
               <xsl:with-param name="interval"
                               select="./interval"/>
               <xsl:with-param name="operator"
                               select="$operator"/>
               <xsl:with-param name="toedieningsschema"
                               select=".."/>
               <xsl:with-param name="toedientijd"
                               select="@value"/>
               <xsl:with-param name="vaste_frequentie"
                               select="$frequentie_value"/>
               <xsl:with-param name="vaste_freq_tijd"
                               select="../frequentie/tijdseenheid"/>
            </xsl:call-template>
         </comp>
      </xsl:for-each>
      <xsl:if test="$cyclisch-schema">
         <xsl:choose>
            <xsl:when test="$theDoseerduur">
               <comp>
                  <xsl:attribute name="xsi:type"
                                 select="'PIVL_TS'"/>
                  <xsl:call-template name="makeCyclischComp">
                     <xsl:with-param name="herhaalperiode"
                                     select="$herhaalperiode"/>
                     <xsl:with-param name="doseerduur-startdatum"
                                     select="string($doseerduur-startdatum)"/>
                     <xsl:with-param name="theDoseerduur"
                                     select="$theDoseerduur"/>
                     <xsl:with-param name="operator">A</xsl:with-param>
                  </xsl:call-template>
               </comp>
            </xsl:when>
            <xsl:otherwise>
               <!-- Herhaalperiode zonder doseerduur, dat is illegaal -->
               <xsl:comment>In de input een herhaalperiode_cyclisch_schema aangetroffen (
<xsl:value-of select="$herhaalperiode/@value"/>
                  <xsl:value-of select="' '"/>
                  <xsl:value-of select="$herhaalperiode/@unit"/>), maar geen doseerduur. Dat is illegaal. Check de input!</xsl:comment>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9020_20150305134139">
      <!--  Frequency  -->
      <xsl:param name="theDoseerduur"/>
      <xsl:param name="doseerduur-startdatum"/>
      <xsl:param name="interval"/>
      <xsl:param name="operator"
                 select="'I'"/>
      <xsl:param name="toedieningsschema"
                 as="element(toedieningsschema)"/>
      <xsl:param name="toedientijd"
                 as="xs:string?"/>
      <xsl:param name="vaste_frequentie"
                 as="xs:integer?"/>
      <xsl:param name="vaste_freq_tijd"/>
      <xsl:if test="string-length($operator) gt 0">
         <xsl:attribute name="operator"
                        select="$operator"/>
      </xsl:if>
      <xsl:if test="($vaste_frequentie or $interval[. instance of element()]) and not($toedientijd castable as xs:dateTime)">
         <xsl:variable name="unit">
            <xsl:choose>
               <xsl:when test="$vaste_frequentie and $vaste_freq_tijd[@unit]">
                  <xsl:value-of select="$vaste_freq_tijd/@unit"/>
               </xsl:when>
               <xsl:when test="$interval[@unit]">
                  <xsl:value-of select="$interval/@unit"/>
               </xsl:when>
               <xsl:otherwise>ERROR_UNIT</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="value">
            <xsl:choose>
               <xsl:when test="$vaste_frequentie and $vaste_freq_tijd[@value]">
                  <xsl:value-of select="format-number(xs:integer($vaste_freq_tijd/@value) div $vaste_frequentie, '0.####')"/>
               </xsl:when>
               <xsl:when test="$interval[@value]">
                  <xsl:value-of select="$interval/@value"/>
               </xsl:when>
               <xsl:otherwise>ERROR_VALUE</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:call-template name="makePQValue">
            <xsl:with-param name="inputValue"
                            select="$value"/>
            <xsl:with-param name="elemName">period</xsl:with-param>
            <xsl:with-param name="unit"
                            select="nf:convertTime_ADA_unit2UCUM($unit)"/>
            <xsl:with-param name="xsiType"
                            select="''"/>
         </xsl:call-template>
      </xsl:if>
      <!-- Toedientijd -->
      <xsl:if test="$toedientijd castable as xs:dateTime or $toedientijd castable as xs:time">
         <xsl:variable name="dateTimeToedientijd"
                       as="xs:dateTime">
            <xsl:choose>
               <xsl:when test="$toedientijd castable as xs:dateTime">
                  <xsl:value-of select="$toedientijd"/>
               </xsl:when>
               <xsl:when test="$toedientijd castable as xs:time">
                  <xsl:value-of select="xs:dateTime(concat('1970-01-01T', $toedientijd))"/>
               </xsl:when>
            </xsl:choose>
         </xsl:variable>
         <!-- het doseerinterval, meestal 1 dag bij toedientijd -->
         <xsl:variable name="unit">
            <!-- default is 'd', in 6.12 is het zelfs verplicht 'd', maar als de frequentie/tijdseenheid in de input is ingevuld nemen we die -->
            <xsl:choose>
               <xsl:when test="$vaste_freq_tijd[@unit]">
                  <xsl:value-of select="$vaste_freq_tijd/@unit"/>
               </xsl:when>
               <xsl:otherwise>d</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="value">
            <!-- default is '1', maar als de frequentie/tijdseenheid is ingevuld nemen we die -->
            <xsl:choose>
               <xsl:when test="$vaste_freq_tijd[@value]">
                  <xsl:value-of select="format-number(xs:integer($vaste_freq_tijd/@value), '0.####')"/>
               </xsl:when>
               <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <phase>
            <center>
               <xsl:attribute name="value">
                  <xsl:call-template name="format2HL7Date">
                     <xsl:with-param name="dateTime"
                                     select="string($dateTimeToedientijd)"/>
                     <xsl:with-param name="precision">minute</xsl:with-param>
                  </xsl:call-template>
               </xsl:attribute>
            </center>
         </phase>
         <xsl:call-template name="makePQValue">
            <xsl:with-param name="inputValue"
                            select="$value"/>
            <xsl:with-param name="elemName">period</xsl:with-param>
            <xsl:with-param name="unit"
                            select="nf:convertTime_ADA_unit2UCUM($unit)"/>
            <xsl:with-param name="xsiType"
                            select="''"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9022_20130521000000">
      <!--  Aanvullende gebruiksinstructie NHG Tabel 25 B-codes  -->
      <xsl:param name="code"
                 as="xs:string?"
                 select="./@code"/>
      <xsl:param name="codeSystem"
                 as="xs:string?"
                 select="./@codeSystem"/>
      <xsl:param name="displayName"
                 as="xs:string?"
                 select="@displayName"/>
      <xsl:param name="strOriginalText"
                 as="xs:string?"/>
      <xsl:call-template name="makeCEValue">
         <xsl:with-param name="xsiType"
                         select="''"/>
         <xsl:with-param name="elemName">code</xsl:with-param>
         <xsl:with-param name="code"
                         select="$code"/>
         <xsl:with-param name="codeSystem"
                         select="$codeSystem"/>
         <xsl:with-param name="displayName"
                         select="$displayName"/>
         <xsl:with-param name="strOriginalText"
                         select="$strOriginalText"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9026_20150318000000">
      <!-- Template  MedicationDispenseListResponse Payload. ada_2_hl7 -->
      <xsl:param name="patient"
                 as="element()?">
         <!-- Thea ada patient to be converted -->
      </xsl:param>
      <xsl:param name="toedieningsafspraak"
                 as="element()*">
         <!-- The ada toedieningsafspraken to be converted -->
      </xsl:param>
      <MedicationDispenseList>
         <code code="MEDLIST"
               codeSystem="2.16.840.1.113883.5.4"/>
         <xsl:for-each select="$patient">
            <subject>
               <Patient>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.816_20130521000000"/>
               </Patient>
            </subject>
         </xsl:for-each>
         <xsl:for-each select="$toedieningsafspraak">
            <component>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.110_20130521000000"/>
            </component>
         </xsl:for-each>
      </MedicationDispenseList>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9043_20150715173504">
      <!--  Assigned Person IdentifiedConfirmable MedicationCombinedOrder  -->
      <xsl:attribute name="classCode">ASSIGNED</xsl:attribute>
      <xsl:for-each select="zorgverlener_identificatie_nummer | zorgverlener_identificatienummer">
         <xsl:choose>
            <xsl:when test="(@root = $oidUZIPersons) or (@root = $oidAGB)">
               <xsl:call-template name="makeIIValue">
                  <xsl:with-param name="elemName">id</xsl:with-param>
                  <xsl:with-param name="root"
                                  select="@root"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <id nullFlavor="NI"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
      <xsl:for-each select="specialisme">
         <xsl:call-template name="makeCEValue">
            <xsl:with-param name="elemName">code</xsl:with-param>
            <xsl:with-param name="xsiType"
                            select="''"/>
         </xsl:call-template>
      </xsl:for-each>
      <assignee>
         <assigneePerson classCode="PSN"
                         determinerCode="INSTANCE">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.101.10.1_20141106000000">
               <xsl:with-param name="naamgegevens"
                               select="zorgverlener_naam/naamgegevens | naamgegevens"/>
            </xsl:call-template>
         </assigneePerson>
      </assignee>
      <xsl:for-each select="zorgaanbieder/zorgaanbieder[*] | ../zorgaanbieder[@id = current()//zorgaanbieder[not(zorgaanbieder)]/@value]">
         <!-- this is an error in the template:  representedOrganization is not in the xsd -->
         <!-- so Organization is the correct xml element name -->
         <xsl:comment>The message template (9043) incorrectly defines representedOrganization, however the xsd only accepts Organization</xsl:comment>
         <xsl:comment>Closed warnings schematron messages for this element should be ignored.</xsl:comment>
         <Organization classCode="ORG"
                       determinerCode="INSTANCE">
            <xsl:for-each select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)[@value]">
               <xsl:call-template name="makeIIValue">
                  <xsl:with-param name="elemName">id</xsl:with-param>
                  <xsl:with-param name="xsiType"
                                  select="''"/>
                  <xsl:with-param name="root"
                                  select="@root"/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="organisatie_naam[@value]">
               <name>
                  <xsl:value-of select="@value"/>
               </name>
            </xsl:for-each>
            <xsl:for-each select=".//adresgegevens[not(adresgegevens)][*]">
               <addr>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.101_20180611000000"/>
               </addr>
            </xsl:for-each>
         </Organization>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9048_20150724151109">
      <!-- Dosering -->
      <doseQuantity>
         <xsl:for-each select="./aantal/(min | minimum_waarde)[@value]">
            <low>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9164_20170118000000_2">
                  <xsl:with-param name="Gstd_value"
                                  select="./@value"/>
                  <xsl:with-param name="Gstd_unit"
                                  select="./../../eenheid"/>
               </xsl:call-template>
            </low>
         </xsl:for-each>
         <xsl:for-each select="./aantal/(vaste_waarde | nominale_waarde)[@value]">
            <center>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9164_20170118000000_2">
                  <xsl:with-param name="Gstd_value"
                                  select="./@value"/>
                  <xsl:with-param name="Gstd_unit"
                                  select="./../../eenheid"/>
               </xsl:call-template>
            </center>
         </xsl:for-each>
         <xsl:for-each select="./aantal/(max | maximum_waarde)[@value]">
            <high>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9164_20170118000000_2">
                  <xsl:with-param name="Gstd_value"
                                  select="@value"/>
                  <xsl:with-param name="Gstd_unit"
                                  select="../../eenheid"/>
               </xsl:call-template>
            </high>
         </xsl:for-each>
      </doseQuantity>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9063_20160217000000">
      <!--  Afleverlocatie  -->
      <destination>
         <serviceDeliveryLocation>
            <code nullFlavor="NI"/>
            <!-- Item(s) :: afleverlocatie-->
            <addr>
               <desc>
                  <xsl:value-of select="@value"/>
               </desc>
            </addr>
         </serviceDeliveryLocation>
      </destination>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9164_20170118000000">
      <!--DoseQuantity and translation(s)-->
      <xsl:param name="UCUMvalue"/>
      <xsl:param name="UCUMunit"/>
      <xsl:attribute name="value"
                     select="$UCUMvalue"/>
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9021_20150305000000">
         <xsl:with-param name="UCUMvalue"
                         select="$UCUMvalue"/>
         <xsl:with-param name="UCUMunit"
                         select="$UCUMunit"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.100_20130521000000">
      <!--  therapeuticAgentOf - Medication Administration Request  -->
      <xsl:param name="adaBouwsteen"
                 as="element()?"
                 select=".">
         <!-- The ada bouwsteen which has gebruiksinstructie, so for example medicatieafspraak, toedieningsafspraak. Defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$adaBouwsteen/gebruiksinstructie/doseerinstructie/dosering">
         <xsl:variable name="adaToedieningsschema"
                       select="./toedieningsschema"/>
         <!-- support for variable frequency: 1 to 2 times a day -->
         <xsl:variable name="frequentie_in_first_MAR"
                       as="xs:integer?">
            <xsl:choose>
               <xsl:when test="$adaToedieningsschema/frequentie/aantal/(min | minimum_waarde)[@value castable as xs:integer]">
                  <xsl:value-of select="xs:integer($adaToedieningsschema/frequentie/aantal/(min | minimum_waarde)/@value)"/>
               </xsl:when>
               <xsl:when test="$adaToedieningsschema/frequentie/aantal/(vaste_waarde | nominale_waarde)[@value castable as xs:integer]">
                  <xsl:value-of select="xs:integer($adaToedieningsschema/frequentie/aantal/(vaste_waarde | nominale_waarde)/@value)"/>
               </xsl:when>
               <xsl:when test="not($adaToedieningsschema/frequentie/aantal/(min | minimum_waarde)[@value]) and $adaToedieningsschema/frequentie/aantal/(max | maximum_waarde)[@value castable as xs:integer]">
                  <xsl:value-of select="xs:integer($adaToedieningsschema/frequentie/aantal/(max | maximum_waarde)/@value)"/>
               </xsl:when>
            </xsl:choose>
         </xsl:variable>
         <!-- if there is no min frequency, but there is a max, then there must be a 'zo nodig' instruction in the first MAR (medicationAdministrationRequest) -->
         <xsl:variable name="zonodig_in_first_MAR"
                       select="not($adaToedieningsschema/frequentie/(min | minimum_waarde)[@value]) and $adaToedieningsschema/frequentie/(max | maximum_waarde)[@value]"/>
         <xsl:call-template name="makeTherapeuticAgentOf_4_template_2.16.840.1.113883.2.4.3.11.60.20.77.10.100_20130521000000">
            <xsl:with-param name="adaBouwsteen"
                            select="$adaBouwsteen"/>
            <xsl:with-param name="dosering"
                            select="."/>
            <xsl:with-param name="frequentie_value"
                            select="$frequentie_in_first_MAR"/>
            <xsl:with-param name="zonodig"
                            select="$zonodig_in_first_MAR"/>
         </xsl:call-template>
         <!-- the zo nodig frequency (max frequency minus min frequency with 'as needed' precondition -->
         <xsl:if test="$adaToedieningsschema/frequentie/aantal/(min | minimum_waarde)[@value castable as xs:integer] and $adaToedieningsschema/frequentie/aantal/(max | maximum_waarde)[@value castable as xs:integer]">
            <xsl:call-template name="makeTherapeuticAgentOf_4_template_2.16.840.1.113883.2.4.3.11.60.20.77.10.100_20130521000000">
               <xsl:with-param name="adaBouwsteen"
                               select="$adaBouwsteen"/>
               <xsl:with-param name="dosering"
                               select="."/>
               <xsl:with-param name="frequentie_value"
                               select="xs:integer($adaToedieningsschema/frequentie/aantal/(max | maximum_waarde)/@value - $adaToedieningsschema/frequentie/aantal/(min | minimum_waarde)/@value)"/>
               <xsl:with-param name="zonodig"
                               select="true()"/>
            </xsl:call-template>
         </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="$adaBouwsteen/gebruiksinstructie[not(doseerinstructie)]">
         <xsl:call-template name="makeTherapeuticAgentOf_4_template_2.16.840.1.113883.2.4.3.11.60.20.77.10.100_20130521000000">
            <xsl:with-param name="adaBouwsteen"
                            select="$adaBouwsteen"/>
            <!-- empty the dosering -->
            <xsl:with-param name="dosering"
                            select="/.."/>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.101_20130521000000">
      <!--  Medication Administration Instruction  -->
      <xsl:param name="code"
                 as="xs:string?"
                 select="./@code"/>
      <xsl:param name="codeSystem"
                 as="xs:string?"
                 select="./@codeSystem"/>
      <xsl:param name="displayName"
                 as="xs:string?"
                 select="@displayName"/>
      <xsl:param name="strOriginalText"
                 as="xs:string?"/>
      <medicationAdministrationInstruction>
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9022_20130521000000">
            <xsl:with-param name="code"
                            select="$code"/>
            <xsl:with-param name="codeSystem"
                            select="$codeSystem"/>
            <xsl:with-param name="displayName"
                            select="$displayName"/>
            <xsl:with-param name="strOriginalText"
                            select="$strOriginalText"/>
         </xsl:call-template>
      </medicationAdministrationInstruction>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.103_20130521000000">
      <!--  Medication Dispense Request  -->
      <xsl:param name="verstrekkingsverzoek"
                 select="."/>
      <!-- ma needed to compute quantity with verbruiksperiode -->
      <xsl:param name="ma"
                 as="element()?"/>
      <medicationDispenseRequest>
         <xsl:for-each select="identificatie">
            <xsl:call-template name="makeIIid"/>
         </xsl:for-each>
         <statusCode nullFlavor="NA"/>
         <xsl:for-each select="aantal_herhalingen">
            <xsl:if test="@value castable as xs:integer">
               <repeatNumber>
                  <xsl:attribute name="value"
                                 select="xs:integer(@value) + 1"/>
               </repeatNumber>
            </xsl:if>
         </xsl:for-each>
         <xsl:choose>
            <xsl:when test="not(te_verstrekken_hoeveelheid[.//(@value | @code)])">
               <!-- bad news, required element and we don't want to calculate using (potentially) complex schema's -->
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logERROR"/>
                  <xsl:with-param name="msg">Medicationrequest quantity not filled, but this is required in 6.12. This needs investigation.</xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="te_verstrekken_hoeveelheid[.//(@value | @code)]">
                  <quantity value="{aantal/@value}"
                            unit="{nf:convertGstdBasiseenheid2UCUM(eenheid/@code)}">
                     <xsl:for-each select="eenheid[.//(@value | @code)]">
                        <translation>
                           <xsl:attribute name="value"
                                          select="../aantal/@value"/>
                           <xsl:attribute name="code"
                                          select="@code"/>
                           <xsl:attribute name="codeSystem"
                                          select="@codeSystem"/>
                           <xsl:attribute name="displayName"
                                          select="@displayName"/>
                        </translation>
                     </xsl:for-each>
                  </quantity>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
         <!-- verbruiksperiode, really not expected since we need the verstrekken hoeveelheid, but we'll convert when encountered -->
         <xsl:for-each select="verbruiksperiode[.//(@value | @unit)]">
            <!-- we output in days -->
            <xsl:variable name="verbruiksduurInDagen"
                          as="xs:decimal?"
                          select="nf:duur-in-dagen4tijdsinterval(.)"/>
            <xsl:if test="exists($verbruiksduurInDagen)">
               <expectedUseTime>
                  <width value="{nf:duur-in-dagen4tijdsinterval(.)}"
                         unit="d"/>
               </expectedUseTime>
            </xsl:if>
         </xsl:for-each>
         <xsl:for-each select="afleverlocatie">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9063_20160217000000"/>
         </xsl:for-each>
         <xsl:for-each select="beoogd_verstrekker">
            <performer typeCode="PRF">
               <!-- Template :: Beoogde verstrekker -->
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9017_20130521000000"/>
            </performer>
         </xsl:for-each>
      </medicationDispenseRequest>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.104_20130521000000">
      <!--  Medication Combined Order  -->
      <xsl:param name="patient"/>
      <xsl:param name="verstrekkingsverzoek"
                 as="element()?"/>
      <!-- There may be more than one medicatiafspraak in this param -->
      <xsl:param name="medicatieafspraak"
                 as="element()*"
                 select="$verstrekkingsverzoek/../medicatieafspraak[not(medicatieafspraak_stop_type[@code][@codeSystem = $oidSNOMEDCT])]"/>
      <!-- find the ma to use in this prescription -->
      <xsl:variable name="referencedMA"
                    as="element()*"
                    select="$medicatieafspraak[identificatie[@value = $verstrekkingsverzoek/relatie_medicatieafspraak/identificatie/@value][@root = $verstrekkingsverzoek/relatie_medicatieafspraak/identificatie/@root]]"/>
      <xsl:variable name="theMA"
                    as="element()?">
         <xsl:choose>
            <xsl:when test="count($referencedMA) gt 1">
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logERROR"/>
                  <xsl:with-param name="msg"
                                  select="'Encountered more than one related MA in the input VV. This is not supported.'"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:when test="count($referencedMA) = 1">
               <xsl:sequence select="$referencedMA"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- MA not found as reference in VV, let's see if we can find one from the parameter -->
               <xsl:choose>
                  <xsl:when test="count($medicatieafspraak) = 1">
                     <xsl:sequence select="$medicatieafspraak"/>
                  </xsl:when>
                  <xsl:when test="count($medicatieafspraak) gt 1">
                     <xsl:call-template name="util:logMessage">
                        <xsl:with-param name="level"
                                        select="$logERROR"/>
                        <xsl:with-param name="msg"
                                        select="'No related MA in the input VV. More than one eligible MA in message. We are lost. This is not supported.'"/>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="util:logMessage">
                        <xsl:with-param name="level"
                                        select="$logERROR"/>
                        <xsl:with-param name="msg"
                                        select="'No related MA in the input VV. No eligible MA in message. We are lost. This is not supported.'"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <prescription classCode="SBADM"
                    moodCode="RQO">
         <!-- Item(s) :: identificatie-->
         <!-- https://nictiz.atlassian.net/browse/MP-1455 : new way of building 6.12 prescription id for a migrated MP9 system -->
         <xsl:choose>
            <xsl:when test="$verstrekkingsverzoek/identificatie and $theMA/identificatie">
               <xsl:variable name="concatIds"
                             select="concat($theMA/identificatie[1]/@value, '!', $verstrekkingsverzoek/identificatie[1]/@value)"/>
               <xsl:element name="id">
                  <xsl:attribute name="root"
                                 select="concat('1.3.6.1.4.1.58606.1.3.', $theMA/identificatie[1]/@root)"/>
                  <xsl:attribute name="extension">
                     <xsl:choose>
                        <xsl:when test="string-length($concatIds) lt 65">
                           <xsl:value-of select="$concatIds"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <!-- max length is 64 in AORTA -->
                           <xsl:variable name="currentHL7Date">
                              <xsl:call-template name="format2HL7Date">
                                 <xsl:with-param name="dateTime"
                                                 select="xs:string(current-dateTime())"/>
                              </xsl:call-template>
                           </xsl:variable>
                           <xsl:variable name="maIdTimestamp"
                                         select="concat($theMA/identificatie[1]/@value, '!', $currentHL7Date)"/>
                           <xsl:choose>
                              <xsl:when test="string-length($maIdTimestamp) lt 65">
                                 <xsl:value-of select="$maIdTimestamp"/>
                              </xsl:when>
                              <xsl:when test="string-length($maIdTimestamp) lt 70">
                                 <!-- let's remove the timezone -->
                                 <xsl:value-of select="substring($maIdTimestamp, 1, string-length($maIdTimestamp) - 5)"/>
                              </xsl:when>
                              <xsl:when test="string-length($maIdTimestamp) lt 74">
                                 <!-- okay, okay, we'll remove the milliseonds -->
                                 <xsl:value-of select="substring($maIdTimestamp, 1, string-length($maIdTimestamp) - 9)"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <!-- we give up -->
                                 <xsl:call-template name="util:logMessage">
                                    <xsl:with-param name="level"
                                                    select="$logERROR"/>
                                    <xsl:with-param name="msg">Could not make a proper unique id for prescription using MA/VV id or MA timestamp. Generating a UUID which will not help the hybrid situation. Please investigate this.</xsl:with-param>
                                 </xsl:call-template>
                                 <xsl:value-of select="uuid:get-uuid($verstrekkingsverzoek)"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
               </xsl:element>
            </xsl:when>
         </xsl:choose>
         <statusCode code="active"/>
         <xsl:for-each select="$patient">
            <subject typeCode="SBJ">
               <Patient>
                  <!-- Template :: PatientNL -->
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.800_20130521000000"/>
               </Patient>
            </subject>
         </xsl:for-each>
         <xsl:variable name="vvAuteur"
                       select="$verstrekkingsverzoek/../../bouwstenen/zorgverlener[@id = $verstrekkingsverzoek/auteur/zorgverlener/@value] | $verstrekkingsverzoek/auteur/zorgverlener[*]"/>
         <xsl:if test="$vvAuteur or $verstrekkingsverzoek/(datum | verstrekkingsverzoek_datum_tijd)">
            <author typeCode="AUT">
               <xsl:for-each select="$verstrekkingsverzoek/(datum | verstrekkingsverzoek_datum_tijd)">
                  <time>
                     <xsl:call-template name="makeTSValueAttr"/>
                  </time>
               </xsl:for-each>
               <xsl:for-each select="$vvAuteur">
                  <AssignedPerson>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9043_20150715173504"/>
                  </AssignedPerson>
               </xsl:for-each>
            </author>
         </xsl:if>
         <directTarget typeCode="DIR">
            <prescribedMedication>
               <xsl:for-each select="$verstrekkingsverzoek/te_verstrekken_geneesmiddel/product[*] | $verstrekkingsverzoek/../../bouwstenen/farmaceutisch_product[@id = $verstrekkingsverzoek/te_verstrekken_geneesmiddel/farmaceutisch_product/@value]">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.106_20130521000000"/>
               </xsl:for-each>
               <productOf>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.103_20130521000000">
                     <xsl:with-param name="verstrekkingsverzoek"
                                     select="$verstrekkingsverzoek"/>
                     <xsl:with-param name="ma"
                                     select="$theMA"/>
                  </xsl:call-template>
               </productOf>
               <!-- gebruiksinstructie -->
               <xsl:for-each select="$theMA">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.100_20130521000000">
                     <xsl:with-param name="adaBouwsteen"
                                     select="."/>
                  </xsl:call-template>
               </xsl:for-each>
            </prescribedMedication>
         </directTarget>
         <xsl:for-each select="$theMA/reden_van_voorschrijven/probleem/probleem_naam">
            <xsl:variable name="codeSystem">
               <xsl:choose>
                  <xsl:when test="./@codeSystem">
                     <xsl:value-of select="./@codeSystem"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="$oidHL7NullFlavor"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <!-- TODO de plek van originalText moet nog verbeterd, dit gaat waarschijnlijk niet goed werken -->
            <xsl:variable name="strOriginalText">
               <xsl:choose>
                  <xsl:when test="$codeSystem = $oidHL7NullFlavor">
                     <xsl:value-of select="./@displayName"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- leeg -->
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <reason typeCode="RSON">
               <diagnosisEvent>
                  <code code="DX"
                        codeSystem="{$oidHL7ActCode}"/>
                  <xsl:call-template name="makeCEValue">
                     <xsl:with-param name="code"
                                     select="./@code"/>
                     <xsl:with-param name="codeSystem"
                                     select="$codeSystem"/>
                     <xsl:with-param name="displayName"
                                     select="./@displayName"/>
                     <xsl:with-param name="elemName">value</xsl:with-param>
                     <xsl:with-param name="strOriginalText"
                                     select="$strOriginalText"/>
                     <xsl:with-param name="xsiType">CE</xsl:with-param>
                  </xsl:call-template>
               </diagnosisEvent>
            </reason>
         </xsl:for-each>
      </prescription>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.106_20130521000000">
      <!--  Medication Kind  -->
      <MedicationKind classCode="MMAT"
                      determinerCode="KIND">
         <xsl:choose>
            <xsl:when test="product_code[@value | @code][not(@codeSystem = $oidHL7NullFlavor)]">
               <xsl:call-template name="makeProductCode">
                  <xsl:with-param name="productCode"
                                  select="product_code"/>
                  <xsl:with-param name="GstandaardLevel"
                                  select="nf:get-main-gstd-level(product_code)"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <code nullFlavor="OTH">
                  <xsl:for-each select="product_specificatie/product_naam">
                     <originalText>
                        <xsl:value-of select="@value"/>
                     </originalText>
                  </xsl:for-each>
               </code>
               <xsl:for-each select="product_specificatie/omschrijving">
                  <desc>
                     <xsl:value-of select="@value"/>
                  </desc>
               </xsl:for-each>
               <xsl:for-each select="product_specificatie/farmaceutische_vorm">
                  <xsl:call-template name="makeCode">
                     <xsl:with-param name="elemName">formCode</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
               <xsl:for-each select="product_specificatie/ingredient">
                  <activeIngredient>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.107_20130521000000"/>
                  </activeIngredient>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
         <!-- Item(s) :: omschrijving omschrijving-->
         <xsl:for-each select="omschrijving">
            <xsl:call-template name="makeEDValue">
               <xsl:with-param name="xsiType"
                               select="''"/>
               <xsl:with-param name="elemName">desc</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <!--            <xsl:for-each select="sterkte | sterkte | sterkte | ingredienten">
               <activeIngredient classCode="ACTI">
                  <!-\- Template :: Active Ingredient -\->
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.107_20130521000000"/>
               </activeIngredient>
            </xsl:for-each>
            <xsl:for-each select="sterkte">
               <otherIngredient classCode="INGR">
                  <!-\- Template :: Other Ingredient -\->
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.109_20130521000000"/>
               </otherIngredient>
            </xsl:for-each>-->
      </MedicationKind>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.107_20130521000000">
      <!--  Active Ingredient  -->
      <!-- Item(s) :: sterkte-->
      <xsl:for-each select="sterkte">
         <quantity>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.122_20130521000000"/>
         </quantity>
      </xsl:for-each>
      <activeIngredientMaterialKind>
         <!-- Template :: Ingredient Material Kind -->
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.108_20130521000000"/>
      </activeIngredientMaterialKind>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.108_20130521000000">
      <!--  Ingredient Material Kind  -->
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9018_20130521000000"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.110_20130521000000">
      <!-- Template  Medication Dispense Event -->
      <medicationDispenseEvent>
         <xsl:for-each select="identificatie">
            <xsl:call-template name="makeIIValue">
               <xsl:with-param name="elemName">id</xsl:with-param>
               <xsl:with-param name="root"
                               select="replace(@root, $concatOidTA, '')"/>
            </xsl:call-template>
         </xsl:for-each>
         <statusCode code="completed"/>
         <xsl:for-each select="toedieningsafspraak_datum_tijd">
            <xsl:call-template name="makeTSValue">
               <xsl:with-param name="elemName">effectiveTime</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <quantity nullFlavor="NA"/>
         <performer>
            <assignedPerson>
               <id nullFlavor="MSK"/>
            </assignedPerson>
         </performer>
         <product>
            <dispensedMedication>
               <xsl:for-each select="ancestor::*/bouwstenen/farmaceutisch_product[@id = current()/geneesmiddel_bij_toedieningsafspraak/farmaceutisch_product/@value]">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.106_20130521000000"/>
               </xsl:for-each>
               <xsl:for-each select="relatie_medicatieafspraak">
                  <directTargetOf typeCode="DIR">
                     <prescription>
                        <xsl:for-each select="identificatie">
                           <xsl:call-template name="makeIIid"/>
                        </xsl:for-each>
                        <statusCode nullFlavor="UNK"/>
                     </prescription>
                  </directTargetOf>
               </xsl:for-each>
               <!-- therapeuticAgentOf gebruiksinstructie-->
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.100_20130521000000"/>
            </dispensedMedication>
         </product>
         <xsl:variable name="theAdaPerformer"
                       as="element(zorgaanbieder)?">
            <xsl:choose>
               <xsl:when test="verstrekker//zorgaanbieder[not(zorgaanbieder)][@value][not(*)]">
                  <xsl:sequence select="(ancestor::*/bouwstenen/zorgaanbieder[@id = current()/verstrekker//zorgaanbieder[not(zorgaanbieder)]/@value])[1]"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:sequence select="(current()/verstrekker//zorgaanbieder[not(zorgaanbieder)])[1]"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:for-each select="$theAdaPerformer">
            <responsibleParty>
               <assignedCareProvider>
                  <!-- zorgverlener is not part of MP9 TA -->
                  <id nullFlavor="NI"/>
                  <!-- Default apotheker is not always right, may be 01.004 apotheekhoudende huisarts. But since this is mandatory in 6.12 we'll use a default anyhow. -->
                  <code code="17.000"
                        codeSystem="2.16.840.1.113883.2.4.15.111"
                        displayName="Apotheker"/>
                  <representedOrganization>
                     <xsl:for-each select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)">
                        <xsl:call-template name="makeIIid"/>
                     </xsl:for-each>
                     <xsl:for-each select="organisatie_naam[@value]">
                        <name>
                           <xsl:value-of select="@value"/>
                        </name>
                     </xsl:for-each>
                     <xsl:for-each select=".//adresgegevens[not(adresgegevens)][*]">
                        <addr>
                           <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.101_20180611000000"/>
                        </addr>
                     </xsl:for-each>
                  </representedOrganization>
               </assignedCareProvider>
            </responsibleParty>
         </xsl:for-each>
      </medicationDispenseEvent>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.122_20130521000000">
      <!--  Ingredient quantity  -->
      <xsl:for-each select="hoeveelheid_ingredient | ingredient_hoeveelheid">
         <numerator>
            <xsl:attribute name="xsi:type"
                           select="'PQ'"/>
            <xsl:call-template name="makeHoeveelheidContent">
               <xsl:with-param name="hoeveelheid-ada"
                               select="."/>
            </xsl:call-template>
         </numerator>
      </xsl:for-each>
      <xsl:for-each select="hoeveelheid_product | product_hoeveelheid">
         <denominator>
            <xsl:attribute name="xsi:type"
                           select="'PQ'"/>
            <xsl:call-template name="makeHoeveelheidContent">
               <xsl:with-param name="hoeveelheid-ada"
                               select="."/>
            </xsl:call-template>
         </denominator>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.800_20130521000000">
      <!--  PatientNL  -->
      <!-- Item(s) :: persoonsidentificatie-->
      <xsl:for-each select="patient_identificatienummer | identificatienummer">
         <xsl:call-template name="makeII.NL.BSNValue">
            <xsl:with-param name="xsiType"
                            select="''"/>
            <xsl:with-param name="elemName">id</xsl:with-param>
         </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select=".//adresgegevens[not(adresgegevens)]">
         <addr>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.101_20180611000000"/>
         </addr>
      </xsl:for-each>
      <statusCode code="active"/>
      <Person>
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.805_20130521000000"/>
      </Person>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.805_20130521000000">
      <!--  PersonNL  -->
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.101.10.1_20141106000000">
         <xsl:with-param name="naamgegevens"
                         select="naamgegevens"/>
      </xsl:call-template>
      <!-- Item(s) :: geslacht-->
      <xsl:for-each select="./geslacht[@code]">
         <xsl:call-template name="makeCVValue">
            <xsl:with-param name="code"
                            select="./@code"/>
            <xsl:with-param name="codeSystem"
                            select="./@codeSystem"/>
            <xsl:with-param name="displayName"
                            select="./@displayName"/>
            <xsl:with-param name="elemName">administrativeGenderCode</xsl:with-param>
            <xsl:with-param name="xsiType"
                            select="''"/>
         </xsl:call-template>
      </xsl:for-each>
      <!-- Item(s) :: geboortedatum-->
      <xsl:for-each select="./geboortedatum[@value]">
         <xsl:call-template name="makeTSValue">
            <xsl:with-param name="inputValue"
                            select="./@value"/>
            <xsl:with-param name="xsiType"
                            select="''"/>
            <xsl:with-param name="elemName">birthTime</xsl:with-param>
         </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="./meerling_indicator[@value]">
         <multipleBirthInd>
            <xsl:call-template name="makeBLAttribute">
               <xsl:with-param name="inputValue"
                               select="./@value"/>
            </xsl:call-template>
         </multipleBirthInd>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.816_20130521000000">
      <!--  PatientNL in verstrekking  -->
      <!-- assumption is that template 800 covers the necessary patient stuff as well -->
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.800_20130521000000"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9001_20130521000000">
      <!--  Observation Event Criterion  -->
      <xsl:param name="code"
                 as="xs:string?"
                 select="./@code"/>
      <xsl:param name="codeSystem"
                 as="xs:string?"
                 select="./@codeSystem"/>
      <xsl:param name="displayName"
                 as="xs:string?"
                 select="@displayName"/>
      <xsl:param name="elOriginalText"
                 as="element()*"/>
      <xsl:param name="strOriginalText"
                 as="xs:string?"/>
      <observationEventCriterion>
         <xsl:call-template name="makeCEValue">
            <xsl:with-param name="code"
                            select="$code"/>
            <xsl:with-param name="codeSystem"
                            select="$codeSystem"/>
            <xsl:with-param name="displayName"
                            select="$displayName"/>
            <xsl:with-param name="elemName">code</xsl:with-param>
            <xsl:with-param name="originalText"
                            select="$elOriginalText"/>
            <xsl:with-param name="strOriginalText"
                            select="$strOriginalText"/>
            <xsl:with-param name="xsiType"
                            select="''"/>
         </xsl:call-template>
      </observationEventCriterion>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9005_20130521000000">
      <!--  Medication Code  -->
      <xsl:call-template name="makeCEValue">
         <xsl:with-param name="xsiType"
                         select="''"/>
         <xsl:with-param name="elemName">code</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9017_20130521000000">
      <!--  Beoogde verstrekker  -->
      <xsl:for-each select="zorgaanbieder[*] | ../../../bouwstenen/zorgaanbieder[@id = current()/zorgaanbieder/@value]">
         <assignedPerson>
            <representedOrganization>
               <xsl:for-each select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)">
                  <xsl:call-template name="makeIIid"/>
               </xsl:for-each>
               <xsl:for-each select="organisatie_naam">
                  <name>
                     <xsl:value-of select="@value"/>
                  </name>
               </xsl:for-each>
            </representedOrganization>
         </assignedPerson>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9019_20130521000000">
      <!-- Usable Period MP 6.12  -->
      <xsl:param name="begindatum"
                 select="begindatum/@value"
                 as="xs:string*">
         <!-- begindatum -->
      </xsl:param>
      <xsl:param name="duur"
                 select="./duur"
                 as="element()?">
         <!-- ada element for duur -->
      </xsl:param>
      <xsl:param name="einddatum"
                 select="einddatum/@value"
                 as="xs:string*">
         <!-- einddatum -->
      </xsl:param>
      <!-- gebruiksduur kan in MP 9 dataset ook in uren, weken en jaren, maar moet in een 6.12 voorschrift altijd in dagen -->
      <!-- omrekenen dus -->
      <xsl:variable name="duur_in_dagen"
                    select="nf:calculate_Duur_In_Dagen($duur/@value, nf:convertTime_ADA_unit2UCUM($duur/@unit))"/>
      <!-- Item(s) :: begindatum -->
      <xsl:for-each select="$begindatum[. castable as xs:date or . castable as xs:dateTime]">
         <xsl:call-template name="makeTSValue">
            <xsl:with-param name="inputValue"
                            select="."/>
            <xsl:with-param name="inputNullFlavor"/>
            <xsl:with-param name="xsiType"
                            select="''"/>
            <xsl:with-param name="elemName">low</xsl:with-param>
            <xsl:with-param name="precision">minute</xsl:with-param>
         </xsl:call-template>
      </xsl:for-each>
      <!-- Item(s) :: gebruiksduur -->
      <xsl:for-each select="$duur[. instance of element()][@value]">
         <xsl:call-template name="makePQValue">
            <xsl:with-param name="inputValue"
                            select="$duur_in_dagen"/>
            <xsl:with-param name="xsiType"
                            select="''"/>
            <xsl:with-param name="elemName">width</xsl:with-param>
            <xsl:with-param name="unit"
                            select="'d'"/>
         </xsl:call-template>
      </xsl:for-each>
      <!-- Item(s) :: einddatum -->
      <xsl:for-each select="$einddatum[. castable as xs:date or . castable as xs:dateTime]">
         <xsl:call-template name="makeTSValue">
            <xsl:with-param name="inputValue"
                            select="."/>
            <xsl:with-param name="inputNullFlavor"/>
            <xsl:with-param name="xsiType"
                            select="''"/>
            <xsl:with-param name="elemName">high</xsl:with-param>
            <xsl:with-param name="precision">minute</xsl:with-param>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9018_20130521000000">
      <!--  Material Code  -->
      <xsl:call-template name="makeProductCode">
         <xsl:with-param name="productCode"
                         select="ingredient_code"/>
         <xsl:with-param name="GstandaardLevel"
                         select="nf:get-main-gstd-level(ingredient_code)"/>
      </xsl:call-template>
      <!--        
        <xsl:for-each select="ingredient_code">
            <xsl:call-template name="makeCEValue">
                <xsl:with-param name="elemName">code</xsl:with-param>
                <xsl:with-param name="xsiType"/>
            </xsl:call-template>
        </xsl:for-each>
-->
   </xsl:template>
   <!-- Calculates the start date of a dosage instruction -->
   <xsl:function name="nf:calculate_Doseerinstructie_Startdate"
                 as="xs:date?">
      <xsl:param name="startdatum-dosering-1"
                 as="xs:date?"/>
      <xsl:param name="theDosering"/>
      <xsl:param name="doseerinstructies"/>
      <xsl:choose>
         <xsl:when test="count($doseerinstructies) gt 1">
            <xsl:variable name="current-volgnummer"
                          select="$theDosering/../volgnummer/@value"/>
            <xsl:variable name="offset-in-days">
               <!-- doseerduur mag in uur, dag, week, jaar in MP 9-->
               <!-- uur kan niet vertaald naar 6.12, want in 6.12 moet het vertaald worden naar hele dagen bij een cyclisch schema, 
              uur moet daarom uitgesloten zijn in de aanroepende template(s)! -->
               <xsl:variable name="weeks2days"
                             select="sum($doseerinstructies[volgnummer/@value lt $current-volgnummer]/doseerduur[@unit = $ada-unit-week]/@value) * 7"/>
               <xsl:variable name="years2days"
                             select="sum($doseerinstructies[volgnummer/@value lt $current-volgnummer]/doseerduur[@unit = $ada-unit-year]/@value) * 365"/>
               <xsl:value-of select="sum($doseerinstructies[volgnummer/@value lt $current-volgnummer]/doseerduur[@unit = $ada-unit-day]/@value) + $weeks2days + $years2days"/>
            </xsl:variable>
            <xsl:variable name="string-add-days"
                          select="concat('P', $offset-in-days, 'D')"/>
            <xsl:value-of select="$startdatum-dosering-1 + xs:dayTimeDuration($string-add-days)"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- als er maar één doseerinstructie is dan wordt deze begrensd door de gebruiksperiode en hoeft er geen volgorde bepaald te worden,
                 een doseerstartdatum is dan dus niet nodig -->
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xsl:function name="nf:duur-in-dagen4tijdsinterval"
                 as="xs:decimal?">
      <!-- ada element for tijdsinterval -->
      <xsl:param name="tijdsinterval"
                 as="element()?"/>
      <xsl:for-each select="$tijdsinterval[.//@value | @unit]">
         <xsl:choose>
            <xsl:when test="tijds_duur[@value | @unit]">
               <xsl:value-of select="nf:calculate_Duur_In_Dagen(tijds_duur/@value, nf:convertTime_ADA_unit2UCUM(tijds_duur/@unit))"/>
            </xsl:when>
            <xsl:when test="start_datum_tijd[@value] and eind_datum_tijd[@value]">
               <xsl:value-of select="nf:duur-in-dagen(xs:dateTime(start_datum_tijd/@value), xs:dateTime(eind_datum_tijd/@value))"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logINFO"/>
                  <xsl:with-param name="msg">Encountered infinite tijdsinterval, could not compute duration (nf:duur-in-dagen4tijdsinterval).</xsl:with-param>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:function>
   <xsl:function name="nf:duur-in-dagen"
                 as="xs:decimal?">
      <xsl:param name="startDateTime"
                 as="xs:dateTime?"/>
      <xsl:param name="enddateTime"
                 as="xs:dateTime?"/>
      <xsl:if test="exists($startDateTime) and exists($enddateTime)">
         <xsl:variable name="duur"
                       select="xs:dayTimeDuration(xs:dateTime($enddateTime) - xs:dateTime($startDateTime))"/>
         <!-- more precision than hours really not needed for expressing this in days -->
         <xsl:variable name="duurInDagen"
                       select="round(days-from-duration($duur) + hours-from-duration($duur) div 24, 1)"/>
         <xsl:value-of select="$duurInDagen"/>
      </xsl:if>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
</xsl:stylesheet>