<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-hl7/env/mp/2_hl7_mp_include.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.2.0; 2024-03-14T08:34:46.14+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:hl7-org:v3"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="#local.2024011509165723983560100"
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
        Mapping xslt for creating HL7 for Medicatieproces. To be imported or included from another xslt. 
        Only templateswhich are shared by more then one version of the information standard.
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
   <!-- these imports are needed to handle the FHIR Timing datatype in HL7v3 substanceAdministration -->
   <xsl:import href="mp-functions-fhir.xsl"/>
   <xsl:import href="2_fhir_fhir_include-d794e398.xsl"/>
   <xsl:import href="ext-zib-medication-repeat-period-cyclical-schedule-2.0.xsl"/>
   <!-- ======================================================================= -->
   <!-- whether to generate a user instruction description text from the structured information, typically only needed for test instances  -->
   <xsl:param name="generateInstructionText"
              as="xs:boolean?"
              select="false()"/>
   <xsl:output method="xml"
               indent="yes"/>
   <!-- ================================================================== -->
   <xsl:template name="_handleDoseerinstructie">
      <!-- Helper template for doseerinstructie -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- ada element doseerinstructie, defaults to context -->
      </xsl:param>
      <xsl:for-each select="$in">
         <!-- make the HL7 stuff -->
         <xsl:choose>
            <!-- geen dosering: pauze periode of 'gebruik bekend' of iets dergelijks -->
            <xsl:when test="not(dosering[.//(@value | @code | @nullFlavor)])">
               <entryRelationship typeCode="COMP">
                  <xsl:for-each select="volgnummer[.//(@value | @code)]">
                     <sequenceNumber>
                        <xsl:attribute name="value"
                                       select="@value"/>
                     </sequenceNumber>
                  </xsl:for-each>
                  <!-- Als helemaal geen volgnummer opgegeven: zelf 1 invullen -->
                  <xsl:if test="not(volgnummer[.//(@value | @code)])">
                     <sequenceNumber>
                        <xsl:attribute name="value"
                                       select="1"/>
                     </sequenceNumber>
                  </xsl:if>
                  <!-- pauze periode -->
                  <xsl:if test="doseerduur[.//(@value | @unit)]">
                     <substanceAdministration classCode="SBADM"
                                              moodCode="RQO">
                        <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9359"/>
                        <effectiveTime xsi:type="Timing"
                                       xmlns="http://hl7.org/fhir">
                           <xsl:call-template name="adaDoseerinstructie2FhirTimingContents">
                              <xsl:with-param name="in"
                                              select="."/>
                              <xsl:with-param name="inHerhaalperiodeCyclischschema"
                                              select="../herhaalperiode_cyclisch_schema"/>
                           </xsl:call-template>
                        </effectiveTime>
                        <consumable xsi:nil="true"/>
                     </substanceAdministration>
                  </xsl:if>
               </entryRelationship>
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="dosering[.//(@value | @code | @nullFlavor)]">
                  <entryRelationship typeCode="COMP">
                     <xsl:for-each select="../volgnummer[.//(@value | @code)]">
                        <sequenceNumber>
                           <xsl:attribute name="value"
                                          select="./@value"/>
                        </sequenceNumber>
                     </xsl:for-each>
                     <!-- Als helemaal geen volgnummer opgegeven: zelf 1 invullen -->
                     <xsl:if test="not(../volgnummer[.//(@value | @code)])">
                        <sequenceNumber>
                           <xsl:attribute name="value"
                                          select="1"/>
                        </sequenceNumber>
                     </xsl:if>
                     <xsl:for-each select=".">
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9359_20210517141255"/>
                     </xsl:for-each>
                  </entryRelationship>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="_handleGebruiksperiode">
      <!-- Handle ada gebruiksperiode for datasets 907, 9.1.0 and from 9 2.0 onwards -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- The parent of the gebruiksperiode elements, for example: medicatieafspraak, toedieningsafspraak, medicatiegebruik. Defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:if test="(gebruiksperiode | gebruiksperiode/tijds_duur | gebruiksperiode_start | gebruiksperiode/start_datum_tijd | gebruiksperiode_eind | gebruiksperiode/eind_datum_tijd)[.//(@value | @code | @unit | @nullFlavor)]">
            <effectiveTime>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9019_20160701155001">
                  <xsl:with-param name="low"
                                  select="gebruiksperiode_start | gebruiksperiode/start_datum_tijd"/>
                  <xsl:with-param name="high"
                                  select="gebruiksperiode_eind | gebruiksperiode/eind_datum_tijd"/>
                  <xsl:with-param name="width"
                                  select="gebruiksperiode[@value | @unit | @nullFlavor] | gebruiksperiode/tijds_duur"/>
               </xsl:call-template>
            </effectiveTime>
         </xsl:if>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="_weekdagComp"
                 match="toedieningsschema"
                 mode="_weekdagComp">
      <!-- Helper template to make weekdag HL7 comp elements -->
      <xsl:param name="aantalPerWeek">
         <!-- The amount of weeks in between -->
      </xsl:param>
      <xsl:choose>
         <!-- Weekdag(en) zonder toedientijd -->
         <xsl:when test="not(./toedientijd[.//(@value | @code)])">
            <xsl:for-each select="./weekdag[.//(@value | @code)]">
               <xsl:variable name="effectiveTimeOperator">
                  <!-- only the first comp has operator 'A', the rest has operator 'I' -->
                  <xsl:choose>
                     <xsl:when test="not(preceding-sibling::weekdag)">
                        <xsl:value-of select="'A'"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="'I'"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <comp>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9155_20160727135123">
                     <xsl:with-param name="operator"
                                     select="$effectiveTimeOperator"/>
                     <xsl:with-param name="aantalPerWeek"
                                     select="$aantalPerWeek"/>
                     <xsl:with-param name="weekdagCode"
                                     select="@code"/>
                  </xsl:call-template>
               </comp>
            </xsl:for-each>
         </xsl:when>
         <!-- Minstens 1 toedientijd en minstens 1 weekdag: voeg alle combinaties toe -->
         <xsl:otherwise>
            <xsl:for-each select="./toedientijd[.//(@value | @code)]">
               <xsl:variable name="curToedientijd"
                             select="."/>
               <!-- Voor de overzichtelijkheid van het resultaat zou het handiger zijn om eerst over weekdagen,
                                   en daarbinnen over toedientijden te itereren, omdat de <comp>'s dan chronologisch staan.
                                   Maar omdat het aangeroepen template de weekdag als context verwacht, is dat nu niet mogelijk
                              -->
               <xsl:for-each select="../weekdag[.//(@value | @code)]">
                  <xsl:variable name="curWeekdag"
                                select="."/>
                  <xsl:variable name="effectiveTimeOperator">
                     <!-- only the first comp has operator 'A', the rest has operator 'I' -->
                     <xsl:choose>
                        <xsl:when test="not($curWeekdag/preceding-sibling::weekdag) and not($curToedientijd/preceding-sibling::toedientijd)">
                           <xsl:value-of select="'A'"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="'I'"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <comp>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9155_20160727135123">
                        <xsl:with-param name="operator"
                                        select="$effectiveTimeOperator"/>
                        <xsl:with-param name="toedientijd"
                                        select="$curToedientijd"/>
                        <xsl:with-param name="aantalPerWeek"
                                        select="$aantalPerWeek"/>
                        <xsl:with-param name="weekdagCode"
                                        select="@code"/>
                     </xsl:call-template>
                  </comp>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="makeDagdeel"
                 match="dagdeel"
                 mode="MakeDagdeel">
      <!-- Helper template to make dagdeel HL7 contents -->
      <xsl:param name="theOperator"
                 select="'A'">
         <!-- Operator. A for intersection(doorsnijden), I voor union (verenigen). -->
      </xsl:param>
      <xsl:choose>
         <!--  's nachts -->
         <xsl:when test="@code = '2546009'">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9159_20160728135022">
               <xsl:with-param name="operator"
                               select="$theOperator"/>
               <xsl:with-param name="frequentieTijdseenheid"
                               select="../frequentie[aantal/(vaste_waarde | nominale_waarde)/@value = '1']/tijdseenheid[.//(@value | @code)]"/>
            </xsl:call-template>
         </xsl:when>
         <!--  's morgens -->
         <xsl:when test="@code = '73775008'">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9156_20160728135021">
               <xsl:with-param name="operator"
                               select="$theOperator"/>
               <xsl:with-param name="frequentieTijdseenheid"
                               select="../frequentie[aantal/(vaste_waarde | nominale_waarde)/@value = '1']/tijdseenheid"/>
            </xsl:call-template>
         </xsl:when>
         <!--  's middags -->
         <xsl:when test="@code = '255213009'">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9157_20160728135022">
               <xsl:with-param name="operator"
                               select="$theOperator"/>
               <xsl:with-param name="frequentieTijdseenheid"
                               select="../frequentie[aantal/(vaste_waarde | nominale_waarde)/@value = '1']/tijdseenheid"/>
            </xsl:call-template>
         </xsl:when>
         <!--  's avonds -->
         <xsl:when test="@code = '3157002'">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9158_20160728135022">
               <xsl:with-param name="operator"
                               select="$theOperator"/>
               <xsl:with-param name="frequentieTijdseenheid"
                               select="../frequentie[aantal/(vaste_waarde | nominale_waarde)/@value = '1']/tijdseenheid"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="makeHoeveelheidContent">
      <!-- Generates the contents of quantity -->
      <xsl:param name="hoeveelheid-ada"/>
      <xsl:for-each select="$hoeveelheid-ada">
         <xsl:choose>
            <xsl:when test="waarde/@nullFlavor">
               <xsl:attribute name="nullFlavor"
                              select="waarde/@nullFlavor"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:variable name="value"
                             select="waarde/@value"/>
               <xsl:attribute name="value"
                              select="$value"/>
               <xsl:choose>
                  <xsl:when test="eenheid/@codeSystem = $oidGStandaardBST902THES2">
                     <!-- should be true from 9.0.6 onwards -->
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9021_20150305000000_2">
                        <xsl:with-param name="Gstd_unit"
                                        select="./eenheid"/>
                        <xsl:with-param name="Gstd_value"
                                        select="$value"/>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- legacy old ADA formats -->
                     <xsl:variable name="UCUMunit"
                                   select="                                     if (./eenheid/@unit) then                                         nf:convertUnit_ADA2UCUM(./eenheid/@unit)                                     else                                         (if (./eenheid/@value) then                                             nf:convertUnit_ADA2UCUM(./eenheid/@value)                                         else                                             (if (./eenheid/@displayName) then                                                 nf:convertUnit_ADA2UCUM(./eenheid/@displayName)                                             else                                                 ''))"/>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9021_20150305000000">
                        <xsl:with-param name="UCUMvalue"
                                        select="$value"/>
                        <xsl:with-param name="UCUMunit"
                                        select="$UCUMunit"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="makeTimePQValueAttribs">
      <!-- Variant van makePQValueAttribs waarbij de unit een tijdseenheid is, en die moet nog geconverteerd worden. -->
      <xsl:attribute name="value"
                     select="./@value"/>
      <xsl:attribute name="unit"
                     select="nf:convertTime_ADA_unit2UCUM(./@unit)"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="makeProductCode"
                 as="element()?">
      <!-- Outputs an hl7 product code with translations based on the GstandaardLevel. -->
      <xsl:param name="productCode"
                 as="element()*">
         <!-- The collection of ada product codes to be converted -->
      </xsl:param>
      <xsl:param name="GstandaardLevel"
                 select="$oidGStandaardZInummer">
         <!-- The Gstandaard level that should be the main level, the other codes are added as translations. Defaults to ZI nummer. -->
      </xsl:param>
      <xsl:param name="elemName"
                 as="xs:string?"
                 select="'code'">
         <!-- Optional. The element name to be created. Defaults to code. -->
      </xsl:param>
      <xsl:if test="count($productCode[@codeSystem eq $GstandaardLevel]) gt 1">
         <xsl:call-template name="util:logMessage">
            <xsl:with-param name="level"
                            select="$logWARN"/>
            <xsl:with-param name="msg">Found more than one productCode for the same G-standaard level. This should not happen. Taking only the first one encountered into account for conversion.</xsl:with-param>
            <xsl:with-param name="terminate"
                            select="false()"/>
         </xsl:call-template>
      </xsl:if>
      <xsl:for-each select="($productCode[@codeSystem eq $GstandaardLevel])[1]">
         <xsl:element name="{$elemName}">
            <xsl:call-template name="makeCodeAttribs"/>
            <xsl:for-each select="$productCode[@codeSystem ne $GstandaardLevel]">
               <translation>
                  <xsl:call-template name="makeCodeAttribs"/>
               </translation>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="makeTimeDenominatorAttribs">
      <!-- Make the denominator attributes for a time in the denominator -->
      <xsl:attribute name="value"
                     select="@value"/>
      <xsl:attribute name="unit"
                     select="nf:convertTime_ADA_unit2UCUM(@unit)"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="chooseOperatorAttrib">
      <xsl:param name="operator"/>
      <xsl:choose>
         <xsl:when test="$operator = 'A' or $operator = 'I'">
            <xsl:attribute name="operator"
                           select="$operator"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- geen attribuut opnemen -->
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="make_UCUM2Gstandard_translation">
      <!-- Produceert een regel met de <translation> van a UCUM unit naar de G-standaard -->
      <xsl:param name="UCUMvalue"/>
      <xsl:param name="UCUMunit"/>
      <xsl:choose>
         <xsl:when test="$UCUMunit eq 'ug'">
            <translation value="{$UCUMvalue}"
                         code="252"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="Microgram"/>
         </xsl:when>
         <xsl:when test="$UCUMunit eq 'mg'">
            <translation value="{$UCUMvalue}"
                         code="229"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="Milligram"/>
         </xsl:when>
         <xsl:when test="$UCUMunit eq 'g'">
            <translation value="{$UCUMvalue}"
                         code="215"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="Gram"/>
         </xsl:when>
         <xsl:when test="$UCUMunit eq 'ul'">
            <translation value="{$UCUMvalue}"
                         code="254"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="Microliter"/>
         </xsl:when>
         <xsl:when test="$UCUMunit eq 'ml'">
            <translation value="{$UCUMvalue}"
                         code="233"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="Milliliter"/>
         </xsl:when>
         <xsl:when test="$UCUMunit eq 'l'">
            <translation value="{$UCUMvalue}"
                         code="222"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="Liter"/>
         </xsl:when>
         <xsl:when test="$UCUMunit eq '[drp]'">
            <translation value="{$UCUMvalue}"
                         code="303"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="Druppel"/>
         </xsl:when>
         <!--
            Tablespoons en teaspoons zijn geschrapt uit de lijst units omdat ze niet nauwkeurig zijn. 
         <xsl:when test="$UCUMunit eq '[tsp_us]'">
            <translation value="{$UCUMvalue * 5}" code="233" codeSystem="{$oidGStandaardBST902THES2}" displayName="Milliliter"/>
         </xsl:when>
         <xsl:when test="$UCUMunit eq '[tbs_us]'">
            <translation value="{$UCUMvalue * 15}" code="233" codeSystem="{$oidGStandaardBST902THES2}" displayName="Milliliter"/> 
         </xsl:when>
         -->
         <xsl:when test="$UCUMunit eq '[iU]'">
            <translation value="{$UCUMvalue}"
                         code="217"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="Internat.eenh."/>
         </xsl:when>
         <xsl:when test="($UCUMunit eq '1')">
            <translation value="{$UCUMvalue}"
                         code="245"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="stuk"/>
         </xsl:when>
         <xsl:when test="(lower-case($UCUMunit) eq 'eenheid')">
            <translation value="{$UCUMvalue}"
                         code="211"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="Eenheid"/>
         </xsl:when>
         <xsl:when test="(lower-case($UCUMunit) eq 'dosis')">
            <translation value="{$UCUMvalue}"
                         code="208"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="dosis"/>
         </xsl:when>
         <xsl:otherwise>
            <translation value="{$UCUMvalue}"
                         code="0"
                         codeSystem="{$oidGStandaardBST902THES2}"
                         displayName="niet ondersteunde UCUM eenheid: {$UCUMunit}"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9019_20160701155001">
      <!--  Usable Period MP 9 -->
      <xsl:param name="low"
                 as="element()?"/>
      <xsl:param name="width"
                 as="element()?"/>
      <xsl:param name="high"
                 as="element()?"/>
      <xsl:choose>
         <!-- if low equals high we must output a timestamp instead of an IVL_TS -->
         <xsl:when test="$low[@value][1] instance of element() and normalize-space($low/@value) = normalize-space($high/@value)">
            <xsl:call-template name="makeTSValueAttr">
               <xsl:with-param name="in"
                               select="$low"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:attribute name="xsi:type">IVL_TS</xsl:attribute>
            <xsl:if test="$low[@value][1] instance of element()">
               <xsl:for-each select="$low">
                  <low>
                     <xsl:call-template name="makeTSValueAttr"/>
                  </low>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="$width[@value | @unit][1] instance of element()">
               <xsl:for-each select="$width">
                  <width>
                     <xsl:call-template name="makeTimePQValueAttribs"/>
                  </width>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="$high[@value | @nullFlavor][1] instance of element()">
               <xsl:for-each select="$high">
                  <high>
                     <xsl:call-template name="makeTSValueAttr"/>
                  </high>
               </xsl:for-each>
            </xsl:if>
            <!-- If no duration or enddate is specified, it is until further notice -->
            <xsl:if test="not($width[1] instance of element()) and not($high[1] instance of element())">
               <high>
                  <xsl:attribute name="nullFlavor"
                                 select="'NI'"/>
               </high>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9021_20150305000000">
      <!-- Quantity unit and translation(s) -->
      <xsl:param name="UCUMvalue"/>
      <xsl:param name="UCUMunit"/>
      <xsl:attribute name="unit"
                     select="$UCUMunit"/>
      <xsl:call-template name="make_UCUM2Gstandard_translation">
         <xsl:with-param name="UCUMvalue"
                         select="$UCUMvalue"/>
         <xsl:with-param name="UCUMunit"
                         select="$UCUMunit"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9021_20150305000000_2">
      <!-- Quantity unit and translation(s) based on Gstd input -->
      <xsl:param name="GstdValueElem"
                 as="element()?"
                 select=".">
         <!-- The ada element containing the Gstd value. Defaults to context. -->
      </xsl:param>
      <xsl:param name="Gstd_value"
                 as="xs:string?">
         <!-- The value converted to Gstd for dose quantity -->
      </xsl:param>
      <xsl:param name="Gstd_unit"
                 as="element()?">
         <!-- The ada element (typically eenheid) that contains the Gstd unit, but may have additional translation elements in adaextension -->
      </xsl:param>
      <xsl:if test="$Gstd_unit">
         <xsl:attribute name="unit"
                        select="nf:convertGstdBasiseenheid2UCUM($Gstd_unit/@code)"/>
         <translation>
            <xsl:attribute name="value"
                           select="$Gstd_value"/>
            <xsl:attribute name="code"
                           select="$Gstd_unit/@code"/>
            <xsl:if test="string-length($Gstd_unit/@displayName) gt 0">
               <xsl:attribute name="displayName"
                              select="$Gstd_unit/@displayName"/>
            </xsl:if>
            <xsl:choose>
               <xsl:when test="string-length($Gstd_unit/@codeSystem) gt 0">
                  <xsl:attribute name="codeSystem"
                                 select="$Gstd_unit/@codeSystem"/>
               </xsl:when>
               <xsl:otherwise>
                  <!-- should not happen -->
                  <xsl:attribute name="codeSystem">
                     <xsl:value-of select="$oidGStandaardBST902THES2"/>
                  </xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="string-length($Gstd_unit/@codeSystemName) gt 0">
               <xsl:attribute name="codeSystemName"
                              select="$Gstd_unit/@codeSystemName"/>
            </xsl:if>
         </translation>
         <xsl:for-each select="($GstdValueElem | $Gstd_unit)/adaextension/translation">
            <translation>
               <!-- default to Gstd value, but ... -->
               <xsl:attribute name="value"
                              select="$Gstd_value"/>
               <!-- ... take the @value from the adaextension if it is there -->
               <xsl:copy-of select="@*"/>
            </translation>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9048_20160614145840">
      <!-- MP CDA Dosering -->
      <doseQuantity>
         <xsl:choose>
            <xsl:when test="aantal[.//@value]">
               <xsl:for-each select="aantal[@value] | aantal/(vaste_waarde | nominale_waarde)[@value]">
                  <center>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9164_20170118000000_2">
                        <xsl:with-param name="Gstd_value"
                                        select="@value"/>
                        <xsl:with-param name="Gstd_unit"
                                        select="../eenheid | ../../eenheid"/>
                     </xsl:call-template>
                  </center>
               </xsl:for-each>
               <xsl:for-each select="aantal/(min | minimum_waarde)[@value]">
                  <low>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9164_20170118000000_2">
                        <xsl:with-param name="Gstd_value"
                                        select="@value"/>
                        <xsl:with-param name="Gstd_unit"
                                        select="../../eenheid"/>
                     </xsl:call-template>
                  </low>
               </xsl:for-each>
               <xsl:for-each select="aantal/(max | maximum_waarde)[@value]">
                  <high>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9164_20170118000000_2">
                        <xsl:with-param name="Gstd_value"
                                        select="@value"/>
                        <xsl:with-param name="Gstd_unit"
                                        select="../../eenheid"/>
                     </xsl:call-template>
                  </high>
               </xsl:for-each>
            </xsl:when>
            <!-- doseQuantity without a value should be converted as well, garbage in, garbage out, we don't omit data from input -->
            <xsl:when test="eenheid[@code]">
               <center>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9164_20170118000000_2">
                     <xsl:with-param name="Gstd_unit"
                                     select="eenheid"/>
                  </xsl:call-template>
               </center>
            </xsl:when>
         </xsl:choose>
      </doseQuantity>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9064_20160601000000">
      <!-- maxDoseQuantity -->
      <numerator>
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9164_20170118000000_2">
            <xsl:with-param name="Gstd_value"
                            select="aantal/@value"/>
            <xsl:with-param name="Gstd_unit"
                            select="eenheid"/>
         </xsl:call-template>
      </numerator>
      <denominator>
         <xsl:attribute name="value"
                        select="./tijdseenheid/@value"/>
         <xsl:attribute name="unit"
                        select="nf:convertTime_ADA_unit2UCUM(./tijdseenheid/@unit)"/>
      </denominator>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9066_20181205174210">
      <!--  MP CDA Author Participation vanaf 9.0.7  -->
      <xsl:param name="authorTime">
         <!-- The ada afspraakdatum -->
      </xsl:param>
      <!-- time is needed for authorTime, but we sometimes get a date 'T' in ada instance without time, we add time 00:00:00 here -->
      <xsl:choose>
         <xsl:when test="$authorTime[1] instance of element()">
            <xsl:for-each select="$authorTime">
               <xsl:variable name="improvedTTime"
                             as="xs:string?">
                  <xsl:choose>
                     <xsl:when test="matches(@value, '^T([+\-]\d+(\.\d+)?[YMD])?$')">
                        <xsl:value-of select="replace(@value, '(^T([+\-]\d+(\.\d+)?[YMD])?)', '$1{00:00:00}')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="@value"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <time>
                  <xsl:call-template name="makeTSValueAttr">
                     <xsl:with-param name="inputValue"
                                     select="$improvedTTime"/>
                     <xsl:with-param name="inputNullFlavor"
                                     select="@nullFlavor"/>
                  </xsl:call-template>
               </time>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <time nullFlavor="NI"/>
         </xsl:otherwise>
      </xsl:choose>
      <assignedAuthor>
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9113_20181205174044"/>
      </assignedAuthor>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9071_20160618204153">
      <!--MP Ingredient quantity-->
      <xsl:for-each select="hoeveelheid_ingredient | ingredient_hoeveelheid">
         <numerator xsi:type="PQ">
            <xsl:call-template name="makeHoeveelheidContent">
               <xsl:with-param name="hoeveelheid-ada"
                               select="."/>
            </xsl:call-template>
         </numerator>
      </xsl:for-each>
      <xsl:for-each select="hoeveelheid_product | product_hoeveelheid">
         <denominator xsi:type="PQ">
            <xsl:call-template name="makeHoeveelheidContent">
               <xsl:with-param name="hoeveelheid-ada"
                               select="."/>
            </xsl:call-template>
         </denominator>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9073_20160618205506">
      <!-- MP CDA Ingredient Material Kind -->
      <xsl:param name="ingredientCode"
                 as="element()*">
         <!-- ada element ingredient_code -->
      </xsl:param>
      <pharm:ingredient classCode="MMAT"
                        determinerCode="KIND">
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9074_20160618205801">
            <xsl:with-param name="ingredientCode"
                            select="$ingredientCode"/>
         </xsl:call-template>
      </pharm:ingredient>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9074_20160618205801">
      <!-- MP CDA Material Code Ext -->
      <xsl:param name="ingredientCode"
                 as="element()*">
         <!-- ada element ingredient_code -->
      </xsl:param>
      <xsl:variable name="productCode"
                    select="$ingredientCode"/>
      <xsl:if test="$productCode[1] instance of element()">
         <xsl:variable name="mainGstdLevel"
                       as="xs:string?">
            <xsl:choose>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardZInummer]">
                  <xsl:value-of select="$oidGStandaardZInummer"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardHPK]">
                  <xsl:value-of select="$oidGStandaardHPK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardPRK]">
                  <xsl:value-of select="$oidGStandaardPRK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardGPK]">
                  <xsl:value-of select="$oidGStandaardGPK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardSSK]">
                  <xsl:value-of select="$oidGStandaardSSK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardSNK]">
                  <xsl:value-of select="$oidGStandaardSNK"/>
               </xsl:when>
            </xsl:choose>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="string-length($mainGstdLevel) gt 0">
               <xsl:call-template name="makeProductCode">
                  <xsl:with-param name="productCode"
                                  select="$productCode"/>
                  <xsl:with-param name="GstandaardLevel"
                                  select="$mainGstdLevel"/>
                  <xsl:with-param name="elemName">pharm:code</xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="$productCode">
                  <xsl:call-template name="makeCode">
                     <xsl:with-param name="elemName">pharm:code</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
      <!-- <pharm:code>
            <xsl:call-template name="makeCodeAttribs"/>
        </pharm:code>-->
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9076_20160619200644"
                 match="toedieningsschema"
                 mode="HandleCDAAdministrationSchedule907">
      <!-- Create an MP CDA administration schedule based on ada toedieningsschema for 9.0.7 -->
      <xsl:if test="(../../../herhaalperiode_cyclisch_schema[.//(@value | @code)]) and (../toedieningsduur[.//(@value | @code)])">
         <xsl:call-template name="util:logMessage">
            <xsl:with-param name="level"
                            select="$logERROR"/>
            <xsl:with-param name="msg">Herhaalperiode cyclisch schema in combinatie met toedienduur wordt niet ondersteund.</xsl:with-param>
            <!-- we don't terminate because free text instruction is still conveyed correctly -->
            <xsl:with-param name="terminate"
                            select="false()"/>
         </xsl:call-template>
      </xsl:if>
      <xsl:choose>
         <!-- Cyclisch schema -->
         <xsl:when test="../../../herhaalperiode_cyclisch_schema[@value | @unit] and ../../doseerduur[@value | @unit]">
            <effectiveTime operator="A"
                           xsi:type="SXPR_TS">
               <xsl:for-each select="frequentie[.//(@value | @code)]">
                  <!-- De frequentie van inname binnen het cyclisch schema. -->
                  <comp>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9080_20160620164239"/>
                  </comp>
               </xsl:for-each>
               <!-- just toedientijd, not weekdag, which is handled in the next call and may or may not be combined with toedientijd -->
               <xsl:for-each select="toedientijd[not(following-sibling::weekdag)][.//(@value | @code)]">
                  <comp xsi:type="hl7nl:PIVL_TS">
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9081_20160620234234">
                        <xsl:with-param name="operator">
                           <!-- only the first comp has operator 'A', the rest has operator 'I' -->
                           <xsl:choose>
                              <xsl:when test="not(./preceding-sibling::toedientijd)">
                                 <xsl:value-of select="'A'"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="'I'"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="isFlexible"
                                        select="'true'"/>
                     </xsl:call-template>
                  </comp>
               </xsl:for-each>
               <!-- MP-99, add support for weekdag with or without toedientijd -->
               <xsl:call-template name="_weekdagComp"/>
               <!-- MP-79, add support for dagdeel  -->
               <xsl:for-each select="dagdeel">
                  <comp>
                     <xsl:call-template name="makeDagdeel">
                        <xsl:with-param name="theOperator"
                                        select="                                         if (position() gt 1) then                                             'I'                                         else                                             'A'"/>
                     </xsl:call-template>
                  </comp>
               </xsl:for-each>
               <!-- cyclisch schema -->
               <comp>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9082_20160621002112">
                     <xsl:with-param name="in"
                                     select="../../doseerduur"/>
                  </xsl:call-template>
               </comp>
            </effectiveTime>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <!-- Eenvoudig doseerschema met alleen één frequentie. -->
               <xsl:when test="frequentie/tijdseenheid[.//(@value | @code)] and not(interval[.//(@value | @code)]) and not(toedientijd[.//(@value | @code)]) and not(../toedieningsduur[.//(@value | @code)]) and not(weekdag[.//(@value | @code)]) and not(dagdeel[.//(@value | @code)])">
                  <xsl:for-each select="frequentie[.//(@value | @code)]">
                     <effectiveTime>
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9080_20160620164239"/>
                     </effectiveTime>
                  </xsl:for-each>
               </xsl:when>
               <!-- Eenvoudig doseerschema met alleen één interval. -->
               <xsl:when test="not(frequentie/tijdseenheid[.//(@value | @code)]) and interval[.//(@value | @code)] and not(toedientijd[.//(@value | @code)]) and not(../toedieningsduur[.//(@value | @code)]) and not(weekdag[.//(@value | @code)]) and not(dagdeel[.//(@value | @code)])">
                  <xsl:for-each select="interval[.//(@value | @code)]">
                     <effectiveTime>
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9079_20160620162955"/>
                     </effectiveTime>
                  </xsl:for-each>
               </xsl:when>
               <!-- Eenvoudig doseerschema met één toedientijd. -->
               <xsl:when test="not(frequentie/tijdseenheid[.//(@value | @code)]) and not(interval[.//(@value | @code)]) and count(toedientijd[.//(@value | @code)]) = 1 and not(../toedieningsduur[.//(@value | @code)]) and not(weekdag[.//(@value | @code)]) and not(dagdeel[.//(@value | @code)])">
                  <xsl:for-each select="toedientijd[.//(@value | @code)]">
                     <effectiveTime>
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9081_20160620234234">
                           <xsl:with-param name="operator"
                                           select="'A'"/>
                           <xsl:with-param name="isFlexible"
                                           select="(../is_flexibel/@value, 'true')[1]"/>
                        </xsl:call-template>
                     </effectiveTime>
                  </xsl:for-each>
               </xsl:when>
               <!-- doseerschema met toedieningsduur en zonder toedientijd/weekdag/dagdeel -->
               <xsl:when test="../toedieningsduur[.//(@value | @code)] and not(toedientijd[.//(@value | @code)]) and not(weekdag[.//(@value | @code)]) and not(dagdeel[.//(@value | @code)])">
                  <effectiveTime>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9161_20161110085716"/>
                  </effectiveTime>
               </xsl:when>
               <!-- doseerschema met toedieningsduur én toedientijd(en), interval kan niet gecombineerd met toedientijd, bij toedientijd moet de frequentie altijd een meervoud zijn van 1 dag 
                        én is er de is_flexibel parameter om aan te geven of de tijden precies zijn bedoeld -->
               <xsl:when test="not(interval[.//(@value | @code)]) and toedientijd[.//(@value | @code)] and ../toedieningsduur[.//(@value | @code)] and not(weekdag[.//(@value | @code)]) and not(dagdeel[.//(@value | @code)])">
                  <effectiveTime>
                     <xsl:choose>
                        <!-- a separate comp for each toedientijd -->
                        <xsl:when test="count(toedientijd[@value]) gt 1">
                           <xsl:attribute name="xsi:type">SXPR_TS</xsl:attribute>
                           <xsl:for-each select="toedientijd[@value]">
                              <comp>
                                 <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9161_20161110085716">
                                    <xsl:with-param name="in"
                                                    select="parent::toedieningsschema"/>
                                    <xsl:with-param name="operator">
                                       <xsl:choose>
                                          <xsl:when test="position() gt 1">I</xsl:when>
                                          <xsl:otherwise>A</xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:with-param>
                                    <xsl:with-param name="inToedientijd"
                                                    select="."/>
                                 </xsl:call-template>
                              </comp>
                           </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9161_20161110085716">
                              <xsl:with-param name="inToedientijd"
                                              select="toedientijd"/>
                           </xsl:call-template>
                        </xsl:otherwise>
                     </xsl:choose>
                  </effectiveTime>
               </xsl:when>
               <!-- Eenvoudig doseerschema met meer dan één concept in de verzameling (frequentie | toedientijd)  -->
               <xsl:when test="not(interval[.//(@value | @code)]) and count(frequentie[.//(@value)] | toedientijd[.//(@value)]) &gt; 1 and not(../toedieningsduur[.//(@value | @code)]) and not(./weekdag[.//(@value | @code)]) and not(./dagdeel[.//(@value | @code)])">
                  <effectiveTime operator="A"
                                 xsi:type="SXPR_TS">
                     <xsl:for-each select="frequentie">
                        <comp>
                           <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9080_20160620164239"/>
                        </comp>
                     </xsl:for-each>
                     <xsl:for-each select="toedientijd[.//(@value | @code)]">
                        <comp xsi:type="hl7nl:PIVL_TS">
                           <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9081_20160620234234">
                              <xsl:with-param name="operator">
                                 <!-- only the first comp has operator 'A', the rest has operator 'I' -->
                                 <xsl:choose>
                                    <xsl:when test="not(preceding-sibling::toedientijd)">
                                       <xsl:value-of select="'A'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:value-of select="'I'"/>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:with-param>
                              <xsl:with-param name="isFlexible"
                                              select="(../is_flexibel/@value, 'true')[1]"/>
                           </xsl:call-template>
                        </comp>
                     </xsl:for-each>
                  </effectiveTime>
               </xsl:when>
               <!-- Eenmalig gebruik. Of een aantal keer zonder verdere aanduiding wanneer -->
               <xsl:when test="frequentie/aantal[.//(@value | @code)] and not(frequentie/tijdseenheid[.//(@value | @code)]) and not(interval[.//(@value | @code)])">
                  <xsl:for-each select="frequentie[.//(@value | @code)]">
                     <effectiveTime>
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9121_20160711104612"/>
                     </effectiveTime>
                  </xsl:for-each>
               </xsl:when>
               <!-- Doseerschema per week op één weekdag. Met evt een toedientijd -->
               <xsl:when test="count(weekdag[.//(@value | @code)]) = 1 and count(toedientijd[.//(@value | @code)]) &lt;= 1 and not(frequentie[tijdseenheid/@value != $ada-unit-week])">
                  <xsl:variable name="aantalPerWeek">
                     <xsl:value-of select="frequentie[tijdseenheid/@value = $ada-unit-week][1]/aantal/(vaste_waarde | nominale_waarde)/@value"/>
                  </xsl:variable>
                  <xsl:for-each select="weekdag[.//(@value | @code)]">
                     <effectiveTime>
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9155_20160727135123">
                           <xsl:with-param name="operator"
                                           select="'A'"/>
                           <xsl:with-param name="toedientijd"
                                           select="../toedientijd"/>
                           <xsl:with-param name="aantalPerWeek"
                                           select="$aantalPerWeek"/>
                           <xsl:with-param name="weekdagCode"
                                           select="@code"/>
                        </xsl:call-template>
                     </effectiveTime>
                  </xsl:for-each>
               </xsl:when>
               <!-- Complexer doseerschema met weekdag(en) eventueel gecombineerd met 0 of meer frequenties en vaste tijd(en) -->
               <xsl:when test="count(weekdag[.//(@value | @code)]) &gt; 1 or (weekdag[.//(@value | @code)] and count(frequentie[tijdseenheid/@value != $ada-unit-week]) &gt;= 1) or (weekdag[.//(@value | @code)] and count(toedientijd[.//(@value | @code)]) &gt; 1)">
                  <xsl:variable name="aantalPerWeek">
                     <!-- voor een keer per twee weken of iets dergelijks -->
                     <xsl:value-of select="frequentie[tijdseenheid/@value = $ada-unit-week][1]/aantal/(vaste_waarde | nominale_waarde)/@value"/>
                  </xsl:variable>
                  <effectiveTime xsi:type="SXPR_TS"
                                 operator="A">
                     <xsl:for-each select="frequentie[tijdseenheid/@value != $ada-unit-week]">
                        <comp>
                           <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9080_20160620164239"/>
                        </comp>
                     </xsl:for-each>
                     <!-- weekdag(en) with or without toedientijd(en) in comp element(s) -->
                     <xsl:call-template name="_weekdagComp">
                        <xsl:with-param name="aantalPerWeek"
                                        select="$aantalPerWeek"/>
                     </xsl:call-template>
                  </effectiveTime>
               </xsl:when>
               <!-- Combinatie dagdeel en weekdag wordt (nog) niet ondersteund. -->
               <!-- één of meerdere dagde(e)l(en) > -->
               <xsl:when test="not(interval[.//(@value | @code)]) and not(toedientijd[.//(@value | @code)]) and not(../toedieningsduur[.//(@value | @code)]) and not(weekdag[.//(@value | @code)]) and dagdeel[.//(@value | @code)]">
                  <xsl:choose>
                     <xsl:when test="count(dagdeel) = 1">
                        <effectiveTime operator="A">
                           <xsl:for-each select="dagdeel">
                              <xsl:call-template name="makeDagdeel"/>
                           </xsl:for-each>
                        </effectiveTime>
                     </xsl:when>
                     <xsl:when test="count(dagdeel) gt 1">
                        <effectiveTime xsi:type="SXPR_TS"
                                       operator="A">
                           <xsl:for-each select="dagdeel">
                              <comp>
                                 <xsl:call-template name="makeDagdeel">
                                    <xsl:with-param name="theOperator"
                                                    select="                                                         if (position() gt 1) then                                                             'I'                                                         else                                                             'A'"/>
                                 </xsl:call-template>
                              </comp>
                           </xsl:for-each>
                        </effectiveTime>
                     </xsl:when>
                  </xsl:choose>
               </xsl:when>
               <!-- dagdeel met toedieningsduur -->
               <xsl:when test="dagdeel[.//(@value | @code)] and (../toedieningsduur[.//(@value | @code)]) and not(interval[.//(@value | @code)]) and not(toedientijd[.//(@value | @code)])">
                  <effectiveTime xsi:type="SXPR_TS"
                                 operator="A">
                     <xsl:for-each select="dagdeel">
                        <comp>
                           <xsl:call-template name="makeDagdeel">
                              <xsl:with-param name="theOperator"
                                              select="                                                 if (position() gt 1) then                                                     'I'                                                 else                                                     'A'"/>
                           </xsl:call-template>
                        </comp>
                     </xsl:for-each>
                     <xsl:for-each select=".[../toedieningsduur[.//(@value | @code)]]">
                        <comp>
                           <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9161_20161110085716"/>
                        </comp>
                     </xsl:for-each>
                  </effectiveTime>
               </xsl:when>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9079_20160620162955"
                 match="interval"
                 mode="HandleInterval9079_20160620162955">
      <!-- HL7NL PIVL_TS Interval -->
      <xsl:attribute name="xsi:type">hl7nl:PIVL_TS</xsl:attribute>
      <xsl:attribute name="operator">A</xsl:attribute>
      <xsl:choose>
         <xsl:when test="../is_flexibel[@value]">
            <xsl:attribute name="isFlexible"
                           select="../is_flexibel/@value"/>
         </xsl:when>
         <xsl:when test="../is_flexibel[@nullFlavor]"/>
         <xsl:otherwise>
            <xsl:attribute name="isFlexible">false</xsl:attribute>
         </xsl:otherwise>
      </xsl:choose>
      <hl7nl:frequency>
         <hl7nl:numerator xsi:type="hl7nl:INT">
            <!-- the numerator for interval is always 1 -->
            <xsl:attribute name="value">1</xsl:attribute>
         </hl7nl:numerator>
         <hl7nl:denominator xsi:type="hl7nl:PQ">
            <xsl:call-template name="makeTimeDenominatorAttribs"/>
         </hl7nl:denominator>
      </hl7nl:frequency>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9080_20160620164239"
                 match="frequentie"
                 mode="HandleFrequencyTempl9080">
      <!-- HL7NL PIVL_TS Frequency -->
      <xsl:attribute name="xsi:type">hl7nl:PIVL_TS</xsl:attribute>
      <xsl:attribute name="operator">A</xsl:attribute>
      <xsl:choose>
         <xsl:when test="../is_flexibel[@value]">
            <xsl:attribute name="isFlexible"
                           select="../is_flexibel/@value"/>
         </xsl:when>
         <xsl:when test="../is_flexibel[@nullFlavor]"/>
         <xsl:otherwise>
            <xsl:attribute name="isFlexible">true</xsl:attribute>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9162_20161110120339"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9081_20160620234234"
                 match="toedientijd"
                 mode="HandleToedientijd9081">
      <!-- HL7NL PIVL_TS Vaste Tijd -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- The input ada element 'toedientijd'. Defaults to context. -->
      </xsl:param>
      <xsl:param name="operator"
                 as="xs:string?">
         <!-- The operator for the PIVL_TS, either A (intersect) or I (join). Normally A for the first 'time' and then I for any following times in a schedule. -->
      </xsl:param>
      <xsl:param name="isFlexible"
                 as="xs:string?">
         <!-- Wether or not the time to be administered is flexible (up to the administering party). Defaults to 'false'. -->
      </xsl:param>
      <xsl:attribute name="xsi:type"
                     select="'hl7nl:PIVL_TS'"/>
      <xsl:call-template name="chooseOperatorAttrib">
         <xsl:with-param name="operator"
                         select="$operator"/>
      </xsl:call-template>
      <xsl:attribute name="isFlexible"
                     select="$isFlexible = 'true'"/>
      <hl7nl:phase>
         <hl7nl:low>
            <xsl:call-template name="makeTSValueAttr">
               <xsl:with-param name="inputDateT"
                               select="xs:date('1970-01-01')"/>
               <xsl:with-param name="precision"
                               select="nf:determine_date_precision_from_ada_datetime($in/@value)"/>
            </xsl:call-template>
         </hl7nl:low>
      </hl7nl:phase>
      <hl7nl:period unit="d"
                    value="1"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9082_20160621002112"
                 match="doseerduur"
                 mode="HandleCyclischSchema9082">
      <!-- HL7NL PIVL_TS Cyclisch schema -->
      <xsl:param name="in"
                 as="element(doseerduur)?"
                 select=".">
         <!-- ada element doseerduur, defaults to context -->
      </xsl:param>
      <xsl:param name="isFlexible"
                 select="'true'">
         <!-- whether or not the schema is flexible, defaults to true -->
      </xsl:param>
      <xsl:attribute name="xsi:type">hl7nl:PIVL_TS</xsl:attribute>
      <xsl:attribute name="operator">A</xsl:attribute>
      <xsl:attribute name="isFlexible"
                     select="$isFlexible"/>
      <xsl:for-each select="$in">
         <hl7nl:phase>
            <hl7nl:width xsi:type="hl7nl:PQ">
               <xsl:call-template name="makeTimePQValueAttribs"/>
            </hl7nl:width>
         </hl7nl:phase>
         <xsl:for-each select="../../herhaalperiode_cyclisch_schema">
            <hl7nl:period>
               <xsl:attribute name="value"
                              select="@value"/>
               <xsl:attribute name="unit"
                              select="@unit"/>
            </hl7nl:period>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9084_20160621103838">
      <xsl:param name="MBHroot"/>
      <!--MP MedBeh identificatie-->
      <procedure classCode="PROC"
                 moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9084"/>
         <id>
            <xsl:choose>
               <xsl:when test="//$MBHroot/identificatie/@value">
                  <xsl:attribute name="root"
                                 select="$MBHroot/identificatie/@root"/>
                  <xsl:attribute name="extension"
                                 select="//$MBHroot/identificatie/@value"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="nullFlavor"
                                 select="'NI'"/>
               </xsl:otherwise>
            </xsl:choose>
         </id>
         <code code="1"
               displayName="Medicamenteuze behandeling"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.3"/>
      </procedure>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9085_20160621114818">
      <xsl:param name="ada-aanvullende-instructie"
                 as="element()*"/>
      <!-- MP CDA Aanvullende gebruiksinstructie -->
      <xsl:for-each select="$ada-aanvullende-instructie">
         <act classCode="ACT"
              moodCode="RQO">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9085"/>
            <xsl:call-template name="makeCode">
               <xsl:with-param name="originalText"
                               select="./@originalText"/>
            </xsl:call-template>
         </act>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9086_20160621122009">
      <xsl:param name="identificatieElement"/>
      <!-- MP Medicatieafspraak identificatie -->
      <substanceAdministration classCode="SBADM"
                               moodCode="RQO">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9086"/>
         <xsl:if test="$identificatieElement[1] instance of element()">
            <xsl:for-each select="$identificatieElement">
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
         </xsl:if>
         <code code="16076005"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"
               displayName="Medicatieafspraak"/>
         <consumable xsi:nil="true"/>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9088_20160621133312">
      <!--MP CDA assigned organisatie-->
      <id nullFlavor="NI"/>
      <representedOrganization>
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9089_20160621134042"/>
      </representedOrganization>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9089_20160621134042">
      <!--MP CDA Organization id name-->
      <xsl:for-each select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)">
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9112_20160710120116"/>
      </xsl:for-each>
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
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9091_20160621153127">
      <!-- Adres Afleverlocatie -->
      <participantRole classCode="SDLOC">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9091"/>
         <addr>
            <!-- Eigenlijk apart template 2.16.840.1.113883.2.4.3.11.60.20.77.10.9092,
                 maar omdat bij de ADA form invoer een enkel adres tekst veld alle info bevat, 
                 stoppen we die maar handmatig in het <desc> veld. -->
            <desc>
               <xsl:value-of select="@value"/>
            </desc>
         </addr>
      </participantRole>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9093_20160623183534">
      <!-- Aanvullende wens -->
      <xsl:param name="in"
                 select=".">
         <!-- Optional. Input element, defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <act classCode="ACT"
              moodCode="RQO">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9093"/>
            <xsl:call-template name="makeCode">
               <xsl:with-param name="elemName">code</xsl:with-param>
            </xsl:call-template>
         </act>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9095_20160623195047">
      <!--Aanschrijfdatum-->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9095"/>
         <code code="4"
               displayName="Aanschrijfdatum"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
               codeSystemName="MP Observaties"/>
         <value xsi:type="TS">
            <xsl:attribute name="value">
               <xsl:call-template name="format2HL7Date">
                  <xsl:with-param name="dateTime"
                                  select="./@value"/>
               </xsl:call-template>
            </xsl:attribute>
         </value>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9097_20160623203415">
      <!-- Distributievorm -->
      <act classCode="ACT"
           moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9097"/>
         <code>
            <xsl:call-template name="makeCodeAttribs"/>
         </code>
      </act>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9101_20160624130316">
      <!-- Template voor relatie TA -->
      <xsl:param name="identificatieElement"/>
      <!-- MP Toedieningsafspraak identificatie -->
      <substanceAdministration classCode="SBADM"
                               moodCode="RQO">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9101"/>
         <xsl:if test="$identificatieElement[1] instance of element()">
            <xsl:for-each select="$identificatieElement">
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
         </xsl:if>
         <code displayName="Toedieningsafspraak"
               code="422037009"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
         <consumable xsi:nil="true"/>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9102_20160624133045">
      <xsl:param name="identificatieElement"/>
      <!--MP Verstrekking identificatie-->
      <supply classCode="SPLY"
              moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9102"/>
         <xsl:if test="$identificatieElement[1] instance of element()">
            <xsl:for-each select="$identificatieElement">
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
         </xsl:if>
         <code code="373784005"
               displayName="Verstrekking"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
      </supply>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9103_20160624141250">
      <xsl:attribute name="classCode">AGNT</xsl:attribute>
      <code code="407542009"
            codeSystem="{$oidSNOMEDCT}"
            displayName="Informal carer (person)"/>
      <relatedPerson classCode="PSN"
                     determinerCode="INSTANCE">
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.100_20170602000000">
            <xsl:with-param name="naamgegevens"
                            select="naamgegevens"/>
         </xsl:call-template>
      </relatedPerson>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9106_20160626164013">
      <!-- MP CDA Ingredient -->
      <xsl:for-each select="./sterkte[.//(@value | @code | @nullFlavor)]">
         <pharm:quantity>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9071_20160618204153"/>
         </pharm:quantity>
      </xsl:for-each>
      <xsl:if test="ingredient_code[.//(@value | @code | @nullFlavor)]">
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9073_20160618205506">
            <xsl:with-param name="ingredientCode"
                            select="ingredient_code"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9112_20160710120116">
      <!-- MP CDA Zorgaanbieder identificaties -->
      <xsl:call-template name="makeIIid"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9113_20160710152506">
      <!--  MP CDA Zorgverlener  -->
      <xsl:for-each select="(zorgverlener_identificatie_nummer | zorgverlener_identificatienummer)[@value]">
         <xsl:call-template name="makeIIid"/>
      </xsl:for-each>
      <xsl:if test="not((zorgverlener_identificatie_nummer | zorgverlener_identificatienummer)[@value])">
         <!-- een id wegschrijven met nullFlavor -->
         <id nullFlavor="NI"/>
      </xsl:if>
      <xsl:for-each select="specialisme[@code]">
         <xsl:call-template name="makeCode"/>
         <!--<code>
                <xsl:call-template name="makeCodeAttribs"/>
            </code>-->
      </xsl:for-each>
      <xsl:for-each select="(zorgverlener_naam | naamgegevens | .)[naamgegevens[not(naamgegevens)][.//(@value | @code | @nullFlavor)]]">
         <assignedPerson>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.100_20170602000000">
               <xsl:with-param name="naamgegevens"
                               select="naamgegevens"/>
               <xsl:with-param name="unstructuredNameElement">ongestructureerde_naam</xsl:with-param>
            </xsl:call-template>
         </assignedPerson>
      </xsl:for-each>
      <xsl:for-each select="(zorgaanbieder | .)/zorgaanbieder[not(zorgaanbieder)][.//(@value | @code | @nullFlavor)]">
         <representedOrganization>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9089_20160621134042"/>
         </representedOrganization>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9113_20181205174044">
      <!--  MP CDA Zorgverlener vanaf 9.0.7. -->
      <xsl:param name="in"
                 select="."
                 as="element()*">
         <!-- Verwacht is een ada zorgverlener. Defaults naar context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:for-each select="(zorgverlener_identificatie_nummer | zorgverlener_identificatienummer)[@value]">
            <xsl:call-template name="makeIIid"/>
         </xsl:for-each>
         <xsl:if test="not((zorgverlener_identificatie_nummer | zorgverlener_identificatienummer)[@value])">
            <!-- een id wegschrijven met nullFlavor -->
            <id nullFlavor="NI"/>
         </xsl:if>
         <!-- specialisme is 1..1 R in this template, let's output a nullFlavor when we don't have any ada input -->
         <xsl:choose>
            <xsl:when test="not(specialisme[@code])">
               <code nullFlavor="NI"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="specialisme[@code]">
                  <code>
                     <xsl:call-template name="makeCodeAttribs"/>
                  </code>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:for-each select=".//naamgegevens[not(naamgegevens)][.//(@value | @code | @nullFlavor)]">
            <assignedPerson>
               <name>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.100_20170602000000">
                     <xsl:with-param name="naamgegevens"
                                     select="."/>
                  </xsl:call-template>
               </name>
            </assignedPerson>
         </xsl:for-each>
         <xsl:variable name="adaZorgaanbieder"
                       as="element()*">
            <xsl:choose>
               <xsl:when test=".//zorgaanbieder[not(zorgaanbieder)][@value]">
                  <!-- we have a reference -->
                  <xsl:sequence select="../zorgaanbieder[@id = current()//zorgaanbieder[not(zorgaanbieder)]/@value]"/>
               </xsl:when>
               <xsl:otherwise>
                  <!-- the pre 9 2.0 datasets, zorgaanbieder is ín the bouwsteen being handled and may have double nesting ... -->
                  <xsl:sequence select=".//zorgaanbieder[not(zorgaanbieder)]"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:for-each select="$adaZorgaanbieder[.//(@value | @code | @nullFlavor)]">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.5_20180611000000"/>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9114_20160710170744">
      <!-- Reden voor medicatiegebruik -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9114"/>
         <code code="6"
               displayName="Reden medicatiegebruik"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
               codeSystemName="Medicatieproces observaties"/>
         <xsl:call-template name="makeText"/>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9120_20161110101947">
      <!-- HL7NL PIVL_TS Frequency NoRange -->
      <xsl:attribute name="xsi:type"
                     select="'hl7nl:PIVL_TS'"/>
      <xsl:attribute name="operator"
                     select="'A'"/>
      <xsl:attribute name="isFlexible"
                     select="'true'"/>
      <hl7nl:frequency>
         <hl7nl:numerator xsi:type="hl7nl:INT">
            <xsl:attribute name="value"
                           select="./aantal/(vaste_waarde | nominale_waarde)/@value"/>
         </hl7nl:numerator>
         <xsl:for-each select="./tijdseenheid[.//(@value | @code | @nullFlavor)]">
            <hl7nl:denominator unit="wk"
                               value="1"
                               xsi:type="hl7nl:PQ">
               <xsl:call-template name="makeTimeDenominatorAttribs"/>
            </hl7nl:denominator>
         </xsl:for-each>
      </hl7nl:frequency>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9121_20160711104612">
      <!-- HL7NL PIVL_TS Aantal keer. -->
      <xsl:attribute name="xsi:type"
                     select="'hl7nl:PIVL_TS'"/>
      <xsl:attribute name="operator"
                     select="'A'"/>
      <xsl:attribute name="isFlexible"
                     select="'true'"/>
      <hl7nl:period nullFlavor="NI"/>
      <xsl:for-each select="aantal/(vaste_waarde | nominale_waarde)[@value]">
         <hl7nl:count>
            <xsl:attribute name="value"
                           select="./@value"/>
         </hl7nl:count>
      </xsl:for-each>
      <xsl:for-each select="aantal[(min | minimum_waarde | max | maximum_waarde)[@value]]">
         <hl7nl:count>
            <hl7nl:uncertainRange>
               <xsl:for-each select="(min | minimum_waarde)[@value]">
                  <hl7nl:low xsi:type="hl7nl:INT"
                             value="{@value}"/>
               </xsl:for-each>
               <xsl:for-each select="(max | maximum_waarde)[@value]">
                  <hl7nl:high xsi:type="hl7nl:INT"
                              value="{@value}"/>
               </xsl:for-each>
            </hl7nl:uncertainRange>
         </hl7nl:count>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9121_20191202152153"
                 match="frequentie"
                 mode="AantalKeer9121">
      <!-- HL7NL PIVL_TS Aantal keer from MP 9.1 -->
      <xsl:param name="in"
                 select=".">
         <!-- The ada input frequentie element. Defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:attribute name="xsi:type"
                        select="'hl7nl:PIVL_TS'"/>
         <xsl:attribute name="operator"
                        select="'A'"/>
         <xsl:attribute name="isFlexible"
                        select="'true'"/>
         <hl7nl:period nullFlavor="NI"/>
         <xsl:for-each select="aantal/(vaste_waarde | nominale_waarde)[@value]">
            <hl7nl:count>
               <xsl:attribute name="value"
                              select="./@value"/>
            </hl7nl:count>
         </xsl:for-each>
         <xsl:for-each select="aantal[(min | minimum_waarde | max | maximum_waarde)[@value]]">
            <hl7nl:count>
               <hl7nl:uncertainRange>
                  <xsl:for-each select="(min | minimum_waarde)[@value]">
                     <hl7nl:low xsi:type="hl7nl:INT"
                                value="{@value}"/>
                  </xsl:for-each>
                  <xsl:for-each select="(max | maximum_waarde)[@value]">
                     <hl7nl:high xsi:type="hl7nl:INT"
                                 value="{@value}"/>
                  </xsl:for-each>
               </hl7nl:uncertainRange>
            </hl7nl:count>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9150_20160726150449">
      <!-- MP CDA Toedieningssnelheid -->
      <rateQuantity>
         <xsl:variable name="speedUnit">
            <xsl:value-of select="nf:convertGstdBasiseenheid2UCUM(eenheid/@code)"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="nf:convertTime_ADA_unit2UCUM(tijdseenheid/@unit)"/>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="waarde/(vaste_waarde | nominale_waarde)/@value">
               <center>
                  <xsl:choose>
                     <xsl:when test="tijdseenheid/@value">
                        <xsl:attribute name="value"
                                       select="waarde/(vaste_waarde | nominale_waarde)/@value div tijdseenheid/@value"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:attribute name="value"
                                       select="waarde/(vaste_waarde | nominale_waarde)/@value"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:attribute name="unit"
                                 select="$speedUnit"/>
               </center>
            </xsl:when>
            <xsl:when test="waarde/(min | minimum_waarde)/@value or waarde/(max | maximum_waarde)/@value">
               <xsl:for-each select="waarde/(min | minimum_waarde)">
                  <!-- min can occur 0 or 1 time -->
                  <low>
                     <xsl:choose>
                        <xsl:when test="../../tijdseenheid/@value">
                           <xsl:attribute name="value"
                                          select="@value div ../../tijdseenheid/@value"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:attribute name="value"
                                          select="@value"/>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:attribute name="unit"
                                    select="$speedUnit"/>
                  </low>
               </xsl:for-each>
               <xsl:for-each select="waarde/(max | maximum_waarde)">
                  <!-- max can occur 0 or 1 time -->
                  <high>
                     <xsl:choose>
                        <xsl:when test="../../tijdseenheid/@value">
                           <xsl:attribute name="value"
                                          select="@value div ../../tijdseenheid/@value"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:attribute name="value"
                                          select="@value"/>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:attribute name="unit"
                                    select="$speedUnit"/>
                  </high>
               </xsl:for-each>
            </xsl:when>
         </xsl:choose>
      </rateQuantity>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9155_20160727135123"
                 match="weekdag"
                 mode="PIVLTSWeekdag9155">
      <!-- HL7NL PIVL_TS Weekdag. Expected context is ada weekdag element -->
      <xsl:param name="in"
                 as="element(weekdag)?"
                 select=".">
         <!-- The ada weekdag element, defaults to context. -->
      </xsl:param>
      <xsl:param name="operator">
         <!-- The operator (for example A or I) for the PIVL -->
      </xsl:param>
      <xsl:param name="toedientijd"
                 as="element(toedientijd)?">
         <!-- The ada element with time to administer -->
      </xsl:param>
      <xsl:param name="aantalPerWeek">
         <!-- The amount of weeks in between -->
      </xsl:param>
      <xsl:param name="weekdagCode"
                 select="./@code">
         <!-- The ada code for week day, which is in SNOMED. Defaults to context element @code attribute -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:attribute name="xsi:type"
                        select="'hl7nl:PIVL_TS'"/>
         <xsl:call-template name="chooseOperatorAttrib">
            <xsl:with-param name="operator"
                            select="$operator"/>
         </xsl:call-template>
         <xsl:choose>
            <xsl:when test="../is_flexibel[@value]">
               <xsl:attribute name="isFlexible"
                              select="../is_flexibel/@value"/>
            </xsl:when>
            <xsl:when test="../is_flexibel[@nullFlavor]"/>
            <xsl:otherwise>
               <xsl:attribute name="isFlexible">true</xsl:attribute>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:attribute name="alignment"
                        select="'DW'"/>
         <xsl:variable name="date4DayOfWeek">
            <xsl:choose>
               <xsl:when test="$weekdagCode = '307145004'">
                  <!-- maandag -->
                  <xsl:value-of select="'19700601'"/>
               </xsl:when>
               <xsl:when test="$weekdagCode = '307147007'">
                  <!-- dinsdag -->
                  <xsl:value-of select="'19700602'"/>
               </xsl:when>
               <xsl:when test="$weekdagCode = '307148002'">
                  <!-- woensdag -->
                  <xsl:value-of select="'19700603'"/>
               </xsl:when>
               <xsl:when test="$weekdagCode = '307149005'">
                  <!-- donderdag -->
                  <xsl:value-of select="'19700604'"/>
               </xsl:when>
               <xsl:when test="$weekdagCode = '307150005'">
                  <!-- vrijdag -->
                  <xsl:value-of select="'19700605'"/>
               </xsl:when>
               <xsl:when test="$weekdagCode = '307151009'">
                  <!-- zaterdag -->
                  <xsl:value-of select="'19700606'"/>
               </xsl:when>
               <xsl:when test="$weekdagCode = '307146003'">
                  <!-- zondag -->
                  <xsl:value-of select="'19700607'"/>
               </xsl:when>
            </xsl:choose>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$toedientijd instance of element() and $toedientijd/@value">
               <xsl:variable name="toedienDatumtijd">
                  <xsl:call-template name="format2HL7Date">
                     <xsl:with-param name="dateTime"
                                     select="$toedientijd/@value"/>
                     <!-- the function needs a dateT to calculate time in case of a relative ada datetime, 
                            let's give it something random, the date is not relevant for toedientijd anyhow  -->
                     <xsl:with-param name="inputDateT">1970-01-01</xsl:with-param>
                  </xsl:call-template>
               </xsl:variable>
               <xsl:variable name="toedienTijd">
                  <xsl:value-of select="substring($toedienDatumtijd, 9)"/>
               </xsl:variable>
               <xsl:variable name="dateTime4DoW">
                  <xsl:value-of select="concat($date4DayOfWeek, $toedienTijd)"/>
               </xsl:variable>
               <hl7nl:phase>
                  <hl7nl:low>
                     <xsl:attribute name="value"
                                    select="$dateTime4DoW"/>
                  </hl7nl:low>
                  <xsl:for-each select="../../toedieningsduur[@value]">
                     <xsl:call-template name="makePQValue">
                        <xsl:with-param name="elemName">hl7nl:width</xsl:with-param>
                        <xsl:with-param name="xsiType">hl7nl:PQ</xsl:with-param>
                     </xsl:call-template>
                  </xsl:for-each>
               </hl7nl:phase>
            </xsl:when>
            <xsl:otherwise>
               <hl7nl:phase>
                  <hl7nl:low>
                     <xsl:attribute name="value"
                                    select="$date4DayOfWeek"/>
                  </hl7nl:low>
                  <xsl:for-each select="../../toedieningsduur[@value]">
                     <xsl:call-template name="makePQValue">
                        <xsl:with-param name="elemName">hl7nl:width</xsl:with-param>
                        <xsl:with-param name="xsiType">hl7nl:PQ</xsl:with-param>
                     </xsl:call-template>
                  </xsl:for-each>
               </hl7nl:phase>
            </xsl:otherwise>
         </xsl:choose>
         <hl7nl:period unit="wk">
            <xsl:choose>
               <xsl:when test="$aantalPerWeek castable as xs:integer">
                  <xsl:attribute name="value"
                                 select="$aantalPerWeek"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="value"
                                 select="'1'"/>
               </xsl:otherwise>
            </xsl:choose>
         </hl7nl:period>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9156_20160728135021">
      <!--  HL7NL PIVL_TS Ochtend -->
      <xsl:param name="operator"/>
      <xsl:param name="frequentieTijdseenheid"/>
      <xsl:attribute name="xsi:type"
                     select="'hl7nl:PIVL_TS'"/>
      <xsl:call-template name="chooseOperatorAttrib">
         <xsl:with-param name="operator"
                         select="$operator"/>
      </xsl:call-template>
      <xsl:attribute name="isFlexible"
                     select="'true'"/>
      <xsl:attribute name="alignment"
                     select="'HD'"/>
      <hl7nl:phase>
         <hl7nl:low value="1970010106"/>
         <hl7nl:high value="1970010112"/>
      </hl7nl:phase>
      <hl7nl:period>
         <xsl:choose>
            <xsl:when test="$frequentieTijdseenheid/@value castable as xs:integer">
               <xsl:attribute name="value"
                              select="$frequentieTijdseenheid/@value"/>
               <xsl:attribute name="unit"
                              select="nf:convertTime_ADA_unit2UCUM($frequentieTijdseenheid/@unit)"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- assume once a day -->
               <xsl:attribute name="value"
                              select="'1'"/>
               <xsl:attribute name="unit"
                              select="'d'"/>
            </xsl:otherwise>
         </xsl:choose>
      </hl7nl:period>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9157_20160728135022">
      <!--  HL7NL PIVL_TS Middag -->
      <xsl:param name="operator"/>
      <xsl:param name="frequentieTijdseenheid"/>
      <xsl:attribute name="xsi:type"
                     select="'hl7nl:PIVL_TS'"/>
      <xsl:call-template name="chooseOperatorAttrib">
         <xsl:with-param name="operator"
                         select="$operator"/>
      </xsl:call-template>
      <xsl:attribute name="isFlexible"
                     select="'true'"/>
      <xsl:attribute name="alignment"
                     select="'HD'"/>
      <hl7nl:phase>
         <hl7nl:low value="1970010112"/>
         <hl7nl:high value="1970010118"/>
      </hl7nl:phase>
      <hl7nl:period>
         <xsl:choose>
            <xsl:when test="$frequentieTijdseenheid/@value castable as xs:integer">
               <xsl:attribute name="value"
                              select="$frequentieTijdseenheid/@value"/>
               <xsl:attribute name="unit"
                              select="nf:convertTime_ADA_unit2UCUM($frequentieTijdseenheid/@unit)"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- assume once a day -->
               <xsl:attribute name="value"
                              select="'1'"/>
               <xsl:attribute name="unit"
                              select="'d'"/>
            </xsl:otherwise>
         </xsl:choose>
      </hl7nl:period>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9158_20160728135022">
      <!--  HL7NL PIVL_TS Avond -->
      <xsl:param name="operator"/>
      <xsl:param name="frequentieTijdseenheid"/>
      <xsl:attribute name="xsi:type"
                     select="'hl7nl:PIVL_TS'"/>
      <xsl:call-template name="chooseOperatorAttrib">
         <xsl:with-param name="operator"
                         select="$operator"/>
      </xsl:call-template>
      <xsl:attribute name="isFlexible"
                     select="'true'"/>
      <xsl:attribute name="alignment"
                     select="'HD'"/>
      <hl7nl:phase>
         <hl7nl:low value="1970010118"/>
         <hl7nl:high value="1970010200"/>
      </hl7nl:phase>
      <hl7nl:period>
         <xsl:choose>
            <xsl:when test="$frequentieTijdseenheid/@value castable as xs:integer">
               <xsl:attribute name="value"
                              select="$frequentieTijdseenheid/@value"/>
               <xsl:attribute name="unit"
                              select="nf:convertTime_ADA_unit2UCUM($frequentieTijdseenheid/@unit)"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- assume once a day -->
               <xsl:attribute name="value"
                              select="'1'"/>
               <xsl:attribute name="unit"
                              select="'d'"/>
            </xsl:otherwise>
         </xsl:choose>
      </hl7nl:period>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9159_20160728135022">
      <!-- HL7NL PIVL_TS Dagdeel. The HL7 templates are 9156 - 9159, but we make one xslt template here, because handling is mostly the same. -->
      <xsl:param name="operator"/>
      <xsl:param name="frequentieTijdseenheid"
                 as="element()?">
         <!-- The ada frequentie/tijdseenheid element. -->
      </xsl:param>
      <xsl:attribute name="xsi:type"
                     select="'hl7nl:PIVL_TS'"/>
      <xsl:call-template name="chooseOperatorAttrib">
         <xsl:with-param name="operator"
                         select="$operator"/>
      </xsl:call-template>
      <xsl:attribute name="isFlexible"
                     select="'true'"/>
      <xsl:attribute name="alignment"
                     select="'HD'"/>
      <hl7nl:phase>
         <hl7nl:low value="1970010100"/>
         <hl7nl:high value="1970010106"/>
      </hl7nl:phase>
      <hl7nl:period>
         <xsl:choose>
            <xsl:when test="$frequentieTijdseenheid/@value castable as xs:float">
               <xsl:attribute name="value"
                              select="$frequentieTijdseenheid/@value"/>
               <xsl:attribute name="unit"
                              select="nf:convertTime_ADA_unit2UCUM($frequentieTijdseenheid/@unit)"/>
            </xsl:when>
            <xsl:otherwise>
               <!-- assume once a day -->
               <xsl:attribute name="value"
                              select="'1'"/>
               <xsl:attribute name="unit"
                              select="'d'"/>
            </xsl:otherwise>
         </xsl:choose>
      </hl7nl:period>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9160_20161109134526">
      <!-- Reden van voorschrijven -->
      <xsl:param name="originalText"
                 as="element()"/>
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9160"/>
         <code code="10"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
               codeSystemName="Medicatieproces observaties"
               displayName="Reden van voorschrijven."/>
         <xsl:call-template name="makeCEValue"/>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9161_20161110085716"
                 match="toedieningsschema"
                 mode="HandleCDAToedieningsduur">
      <!-- HL7NL PIVL_TS Toedieningsduur. Creates contents of a PIVL_TS element (such as effectiveTime or effectiveTime/comp). Assumed context is toedieningsschema -->
      <xsl:param name="in"
                 as="element(toedieningsschema)?"
                 select=".">
         <!-- Input node (should be one ada element toedieningsschema). Defaults to context element. -->
      </xsl:param>
      <xsl:param name="operator"
                 as="xs:string?"
                 select="'A'">
         <!-- HL7 operator, optional. Defaults to A. -->
      </xsl:param>
      <xsl:param name="inToedientijd"
                 as="element()?">
         <!-- Optional. The administration time (toedientijd) belonging to this administration duration (toedieningsduur). This param is needed because in HL7 there may be one start time per PIVL_TS where the dataset allows for multiple. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:attribute name="xsi:type">hl7nl:PIVL_TS</xsl:attribute>
         <xsl:attribute name="operator"
                        select="$operator"/>
         <xsl:choose>
            <xsl:when test="is_flexibel[@value]">
               <xsl:attribute name="isFlexible"
                              select="is_flexibel/@value"/>
            </xsl:when>
            <xsl:when test="is_flexibel[@nullFlavor]"/>
            <xsl:when test="interval[@value | @unit]">
               <xsl:attribute name="isFlexible">false</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
               <xsl:attribute name="isFlexible">true</xsl:attribute>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:for-each select="../toedieningsduur">
            <hl7nl:phase>
               <xsl:for-each select="$inToedientijd">
                  <hl7nl:low>
                     <xsl:call-template name="makeTSValueAttr">
                        <xsl:with-param name="precision"
                                        select="nf:determine_date_precision_from_ada_datetime(@value)"/>
                     </xsl:call-template>
                  </hl7nl:low>
               </xsl:for-each>
               <hl7nl:width xsi:type="hl7nl:PQ">
                  <xsl:call-template name="makeTimePQValueAttribs"/>
               </hl7nl:width>
            </hl7nl:phase>
         </xsl:for-each>
         <xsl:variable name="adaFrequency"
                       as="element(frequentie)*">
            <xsl:choose>
               <xsl:when test="./toedientijd[@value] and not(frequentie[.//(@value | @unit)])">
                  <!--  toedientijd is given but not frequentie than a frequency of once per day is intended -->
                  <frequentie xmlns="">
                     <aantal>
                        <vaste_waarde value="1"/>
                     </aantal>
                     <tijdseenheid value="1"
                                   unit="dag"/>
                  </frequentie>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:sequence select="frequentie"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:for-each select="$adaFrequency">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9162_20161110120339"/>
         </xsl:for-each>
         <xsl:for-each select="interval[@value | @unit]">
            <hl7nl:frequency>
               <hl7nl:numerator xsi:type="hl7nl:INT">
                  <!-- the numerator for interval is always 1 -->
                  <xsl:attribute name="value">1</xsl:attribute>
               </hl7nl:numerator>
               <hl7nl:denominator xsi:type="hl7nl:PQ">
                  <xsl:call-template name="makeTimeDenominatorAttribs"/>
               </hl7nl:denominator>
            </hl7nl:frequency>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9162_20161110120339"
                 match="frequentie"
                 mode="HandleFrequencyTempl9080">
      <!-- HL7NL Frequency -->
      <hl7nl:frequency>
         <xsl:for-each select="./aantal">
            <hl7nl:numerator xsi:type="hl7nl:INT">
               <xsl:choose>
                  <xsl:when test="./vaste_waarde">
                     <xsl:attribute name="value"
                                    select="./vaste_waarde/@value"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- variabele frequentie -->
                     <hl7nl:uncertainRange>
                        <xsl:for-each select="./min">
                           <hl7nl:low xsi:type="hl7nl:INT">
                              <xsl:attribute name="value"
                                             select="./@value"/>
                           </hl7nl:low>
                        </xsl:for-each>
                        <xsl:for-each select="./max">
                           <hl7nl:high xsi:type="hl7nl:INT">
                              <xsl:attribute name="value"
                                             select="./@value"/>
                           </hl7nl:high>
                        </xsl:for-each>
                     </hl7nl:uncertainRange>
                  </xsl:otherwise>
               </xsl:choose>
            </hl7nl:numerator>
         </xsl:for-each>
         <xsl:for-each select="./tijdseenheid">
            <hl7nl:denominator xsi:type="hl7nl:PQ">
               <xsl:call-template name="makeTimeDenominatorAttribs"/>
            </hl7nl:denominator>
         </xsl:for-each>
      </hl7nl:frequency>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9164_20170118000000_2">
      <!-- DoseQuantity and translation(s)obv Gstd input -->
      <xsl:param name="Gstd_value"
                 as="xs:string?">
         <!-- The value converted to Gstd for dose quantity -->
      </xsl:param>
      <xsl:param name="Gstd_unit"
                 as="element()?">
         <!-- The ada element (typically eenheid) that contains the Gstd unit, but may have additional translation elements in adaextension -->
      </xsl:param>
      <xsl:attribute name="value"
                     select="$Gstd_value"/>
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9021_20150305000000_2">
         <xsl:with-param name="Gstd_value"
                         select="$Gstd_value"/>
         <xsl:with-param name="Gstd_unit"
                         select="$Gstd_unit"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9165_20170118000000"
                 match="verstrekte_hoeveelheid | te_verstrekken_hoeveelheid"
                 mode="handleLogisticQuantity">
      <!-- verstrekte_hoeveelheid and te verstrekken hoeveelheid in verstrekking(sverzoek)  -->
      <xsl:attribute name="value"
                     select="aantal/@value"/>
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9021_20150305000000_2">
         <xsl:with-param name="Gstd_unit"
                         select="eenheid"/>
         <xsl:with-param name="Gstd_value"
                         select="aantal/@value"/>
      </xsl:call-template>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9166_20170516000000"
                 match="zorgverlener"
                 mode="HandleRel2MAVoorschrijver">
      <!-- MP MA Voorschrijver -->
      <substanceAdministration classCode="SBADM"
                               moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9166"/>
         <code code="16076005"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"
               displayName="Medicatieafspraak"/>
         <consumable xsi:nil="true"/>
         <author>
            <time nullFlavor="NI"/>
            <assignedAuthor>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9113_20160710152506"/>
            </assignedAuthor>
         </author>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9167_20170516000000">
      <!-- MP Gebruik Voorschrijver of informant zorgverlener -->
      <!--<templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9167"/>-->
      <xsl:for-each select="zorgverlener_identificatie_nummer | zorgverlener_identificatienummer">
         <xsl:call-template name="makeIIid"/>
      </xsl:for-each>
      <xsl:for-each select="specialisme">
         <code>
            <xsl:call-template name="makeCodeAttribs"/>
         </code>
      </xsl:for-each>
      <xsl:for-each select="zorgverlener_naam[naamgegevens] | naamgegevens[naamgegevens] | .[naamgegevens[not(naamgegevens)]]">
         <assignedPerson>
            <name>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.100_20170602000000">
                  <xsl:with-param name="naamgegevens"
                                  select="naamgegevens"/>
               </xsl:call-template>
            </name>
         </assignedPerson>
      </xsl:for-each>
      <xsl:for-each select=".//zorgaanbieder[not(zorgaanbieder)][*] | ../zorgaanbieder[@id = current()//zorgaanbieder[not(zorgaanbieder)]/@value]">
         <representedOrganization>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9089_20160621134042"/>
         </representedOrganization>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9169_20170521195457">
      <!-- MP CDA Organization Medicatieoverzicht -->
      <!--Zorgaanbieder identificatie-->
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9089_20160621134042"/>
      <!-- Telecom gegevens -->
      <xsl:for-each select="telefoon_email | contactgegevens">
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9172_20170522143706"/>
      </xsl:for-each>
      <!-- Adres -->
      <xsl:for-each select="adres | adresgegevens">
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1.101_20170602000000">
            <xsl:with-param name="adres"
                            select="."/>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9171_20180111143827"
                 match="auteur"
                 mode="HandleDocGegAuteur">
      <!-- MP CDA author medicatieoverzicht - vanaf versie 9.0.5  -->
      <xsl:param name="auteur"
                 select="."/>
      <xsl:for-each select="$auteur">
         <author>
            <xsl:choose>
               <!-- use the document date if available -->
               <xsl:when test="../document_datum[@value | @nullFlavor]">
                  <xsl:for-each select="../document_datum[@value | @nullFlavor]">
                     <xsl:call-template name="makeTSValue">
                        <xsl:with-param name="elemName">time</xsl:with-param>
                     </xsl:call-template>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <time nullFlavor="NI"/>
               </xsl:otherwise>
            </xsl:choose>
            <assignedAuthor>
               <xsl:for-each select="auteur_is_zorgaanbieder/zorgaanbieder">
                  <!--identificatie-->
                  <id nullFlavor="NI"/>
                  <!--Zorgaanbieder-->
                  <representedOrganization>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9169_20170521195457"/>
                  </representedOrganization>
               </xsl:for-each>
               <!--Patient-->
               <xsl:if test="auteur_is_patient">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.52_20170825000000">
                     <xsl:with-param name="ada_patient_identificatienummer"
                                     select="ancestor::adaxml/data/*/patient/(patient_identificatienummer | identificatienummer)"/>
                  </xsl:call-template>
               </xsl:if>
            </assignedAuthor>
         </author>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9172_20170522143706">
      <!-- Telecom gegevens for ada contactgegevens -->
      <xsl:call-template name="_CdaTelecom"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9175_20170522171022">
      <!-- MP CDA TA Aanvullende informatie  -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9175"/>
         <code code="12"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
               displayName="Aanvullende informatie Toedieningsafspraak"/>
         <xsl:call-template name="makeCEValue"/>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9176_20170522183626">
      <!-- MP Medicatiegebruik identificatie -->
      <xsl:param name="identificatieElement"/>
      <substanceAdministration classCode="SBADM"
                               moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9176"/>
         <xsl:if test="$identificatieElement[1] instance of element()">
            <xsl:for-each select="$identificatieElement">
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
         </xsl:if>
         <code code="6"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.3"
               displayName="Medicatiegebruik"/>
         <consumable xsi:nil="true"/>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9177_20170523084315">
      <!--  MP CDA MA Aanvullende informatie  -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9177"/>
         <code code="11"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
               displayName="Aanvullende informatie Medicatieafspraak"/>
         <xsl:call-template name="makeCEValue"/>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9178_20170523091005">
      <!--  MP CDA VS Aanvullende informatie  -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9178"/>
         <code code="13"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
               displayName="Aanvullende informatie Verstrekking"/>
         <xsl:call-template name="makeCEValue"/>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9179_20170523115538">
      <!-- MP organizer verifier patiënt -->
      <!-- Als er niet geverifieerd is, dan ook niet opnemen. -->
      <xsl:if test="./geverifieerd_met_patientq/@value = 'true'">
         <participant typeCode="VRF">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9179"/>
            <xsl:for-each select="./verificatie_datum">
               <time>
                  <xsl:call-template name="makeTSValueAttr"/>
               </time>
            </xsl:for-each>
            <participantRole classCode="PAT"/>
         </participant>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9180_20170523115753">
      <!-- MP organizer verifier zorgverlener, used in medication overview -->
      <!-- Als er niet geverifieerd is, dan ook niet opnemen. -->
      <xsl:if test="./geverifieerd_met_zorgverlenerq/@value = 'true'">
         <participant typeCode="VRF">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9180"/>
            <xsl:for-each select="./verificatie_datum">
               <time>
                  <xsl:call-template name="makeTSValueAttr"/>
               </time>
            </xsl:for-each>
            <participantRole classCode="ASSIGNED"/>
         </participant>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9182_20170601000000">
      <!--  Zo nodig criterium  -->
      <xsl:param name="inCode"
                 as="xs:string?"
                 select="@code">
         <!-- the code string -->
      </xsl:param>
      <xsl:param name="inCodeSystem"
                 as="xs:string?"
                 select="@codeSystem">
         <!-- the codeSystem string -->
      </xsl:param>
      <xsl:param name="inDisplayName"
                 as="xs:string?"
                 select="@displayName">
         <!-- the displayName string -->
      </xsl:param>
      <xsl:param name="elOriginalText"
                 as="element()*"/>
      <xsl:param name="strOriginalText"
                 as="xs:string?"
                 select="./@originalText"/>
      <criterion>
         <xsl:call-template name="makeCEValue">
            <xsl:with-param name="code"
                            select="$inCode"/>
            <xsl:with-param name="codeSystem"
                            select="$inCodeSystem"/>
            <xsl:with-param name="displayName"
                            select="$inDisplayName"/>
            <xsl:with-param name="elemName">code</xsl:with-param>
            <xsl:with-param name="originalText"
                            select="$elOriginalText"/>
            <xsl:with-param name="strOriginalText"
                            select="$strOriginalText"/>
            <xsl:with-param name="xsiType"
                            select="''"/>
         </xsl:call-template>
      </criterion>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9184_20191121170300"
                 match="medicatieafspraak | medication_agreement">
      <!-- Template for Medicatieafspraak resuable parts 1 for MP 9.1.0 due to https://bits.nictiz.nl/browse/MP-57: cancelled indicator (geannuleerd indicator) has been removed -->
      <!-- MP CDA Medicatieafspraak onderdelen 1 -->
      <xsl:for-each select="identificatie[.//(@value | @code)]">
         <xsl:call-template name="makeIIid"/>
      </xsl:for-each>
      <code code="16076005"
            displayName="Medicatieafspraak"
            codeSystem="{$oidSNOMEDCT}"
            codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
      <xsl:choose>
         <xsl:when test="$generateInstructionText">
            <text mediaType="text/plain">
               <xsl:value-of select="nf:gebruiksintructie-string(gebruiksinstructie)"/>
            </text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:for-each select="gebruiksinstructie/omschrijving[.//(@value | @code)]">
               <text mediaType="text/plain">
                  <xsl:value-of select="@value"/>
               </text>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
      <!-- statusCode: voor foutcorrectie -->
      <!-- uitgefaseerd in 9.1.0, maar voor backwards compatibility hier nog niet verwijderd -->
      <xsl:if test="geannuleerd_indicator/@value = 'true'">
         <statusCode code="nullified"/>
      </xsl:if>
      <!-- Gebruiksperiode -->
      <xsl:call-template name="_handleGebruiksperiode"/>
      <xsl:for-each select="gebruiksinstructie/toedieningsweg[.//(@value | @code)]">
         <routeCode>
            <xsl:call-template name="makeCodeAttribs"/>
         </routeCode>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9187_20181205180828">
      <!-- MP CDA author zorgverlener of patient -->
      <xsl:param name="ada-auteur"
                 as="element()*"
                 select="."/>
      <xsl:param name="authorTime"
                 as="element()?"/>
      <xsl:choose>
         <xsl:when test="$ada-auteur/auteur_is_patient/@value = 'true'">
            <author>
               <xsl:call-template name="makeTSValue">
                  <xsl:with-param name="elemName">time</xsl:with-param>
                  <xsl:with-param name="inputValue"
                                  select="$authorTime/@value"/>
               </xsl:call-template>
               <assignedAuthor>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.52_20170825000000">
                     <xsl:with-param name="ada_patient_identificatienummer"
                                     select="ancestor::adaxml/data/*/patient/(patient_identificatienummer | identificatienummer)"/>
                  </xsl:call-template>
               </assignedAuthor>
            </author>
         </xsl:when>
         <xsl:when test="$ada-auteur/auteur_is_zorgverlener">
            <author>
               <xsl:call-template name="makeTSValue">
                  <xsl:with-param name="elemName">time</xsl:with-param>
                  <xsl:with-param name="inputValue"
                                  select="$authorTime/@value"/>
               </xsl:call-template>
               <assignedAuthor>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9113_20181205174044">
                     <xsl:with-param name="in"
                                     select="$ada-auteur/ancestor::adaxml/data/*/bouwstenen/zorgverlener[@id = $ada-auteur/auteur_is_zorgverlener/zorgverlener/@value] | $ada-auteur/auteur_is_zorgverlener/zorgverlener[not(@value)][.//(@value | @code)]"/>
                  </xsl:call-template>
               </assignedAuthor>
               <!--<xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.32_20210701000000">
                        <xsl:with-param name="in" select="$ada-auteur/ancestor::adaxml/data/*/bouwstenen/zorgverlener[@id = $ada-auteur/auteur_is_zorgverlener/zorgverlener/@value] | $ada-auteur/auteur_is_zorgverlener/zorgverlener[not(@value)][.//(@value | @code)]"/>
                        <xsl:with-param name="theTime" select="$authorTime"/>
                    </xsl:call-template>-->
            </author>
         </xsl:when>
         <xsl:when test="$authorTime">
            <author>
               <xsl:call-template name="makeTSValue">
                  <xsl:with-param name="elemName">time</xsl:with-param>
                  <xsl:with-param name="inputValue"
                                  select="$authorTime/@value"/>
               </xsl:call-template>
               <assignedAuthor>
                  <id nullFlavor="NI"/>
               </assignedAuthor>
            </author>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9188_20170825000000">
      <!--  MP CDA author of informant patient  -->
      <xsl:param name="in"
                 select="//(patient[patient_identificatienummer | identificatienummer])[1]/(patient_identificatienummer | identificatienummer)">
         <!-- ada element for patient identification, defaults to first patient found in // context -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:call-template name="makeIIid"/>
      </xsl:for-each>
      <code code="ONESELF"
            displayName="Self"
            codeSystem="{$oidHL7RoleCode}"
            codeSystemName="HL7 Role code"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9189_20171026161543">
      <!-- Gebruikindicator -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9189"/>
         <code displayName="Gebruikindicator"
               code="15"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"/>
         <xsl:call-template name="makeBLValue">
            <xsl:with-param name="elemName">value</xsl:with-param>
            <xsl:with-param name="xsiType">BL</xsl:with-param>
         </xsl:call-template>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9200_20180112101847">
      <!-- Creates the observation fo kopie-indicator -->
      <xsl:param name="kopie-ind"
                 as="element()?"
                 select=".">
         <!-- ada kopie-indicator -->
      </xsl:param>
      <xsl:for-each select="$kopie-ind">
         <observation classCode="OBS"
                      moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9200"/>
            <code displayName="Kopie-indicator"
                  code="16"
                  codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"/>
            <xsl:call-template name="makeBLValue"/>
         </observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9212_20180420174745"
                 match="antwoord"
                 mode="HandleAvvv">
      <!-- Creates the response to a proposed dispense request -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- the ada element for antwoord -->
      </xsl:param>
      <xsl:for-each select="$in">
         <act classCode="ACT"
              moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9212"/>
            <code code="9"
                  codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.3"
                  codeSystemName="Medicatieproces acts"
                  displayName="Antwoord voorstel verstrekkingsverzoek"/>
            <xsl:for-each select="./auteur[.//(@value | @code)]">
               <author>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.32_20210701000000">
                     <xsl:with-param name="in"
                                     select="ancestor::adaxml/data/*/bouwstenen/zorgverlener[@id = current()/zorgverlener/@value] | current()/zorgverlener[not(@value)][.//(@value | @code)]"/>
                     <xsl:with-param name="theTime"
                                     select="../antwoord_datum"/>
                  </xsl:call-template>
               </author>
            </xsl:for-each>
            <xsl:for-each select="antwoord_verstrekkingsverzoek[@code]">
               <entryRelationship typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9213_20180420181642"/>
               </entryRelationship>
            </xsl:for-each>
            <xsl:for-each select="relatie_voorstel_gegevens/identificatie[@value]">
               <entryRelationship typeCode="SUBJ">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9214_20180423130606"/>
               </entryRelationship>
            </xsl:for-each>
         </act>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9213_20180420181642">
      <!-- Observatie met het inhoudelijke antwoord op voorstel verstrekkingsverzoek -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- the ada element for antwoord_verstrekkingsverzoek, defaults to context -->
      </xsl:param>
      <xsl:for-each select="$in">
         <observation classCode="OBS"
                      moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9213"/>
            <code code="17"
                  codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
                  codeSystemName="Medicatieproces observaties"
                  displayName="Antwoord voorstel verstrekkingsverzoek"/>
            <xsl:call-template name="makeCEValue"/>
         </observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9214_20180423130606">
      <!-- Observatie met het inhoudelijke antwoord op voorstel verstrekkingsverzoek -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- the ada element for antwoord_verstrekkingsverzoek, defaults to context -->
      </xsl:param>
      <xsl:for-each select="$in">
         <organizer classCode="CLUSTER"
                    moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9214"/>
            <xsl:call-template name="makeIIValue">
               <xsl:with-param name="elemName">id</xsl:with-param>
            </xsl:call-template>
            <code code="104"
                  displayName="Sturen voorstel verstrekkingsverzoek"
                  codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.4"
                  codeSystemName="ART DECOR transacties"/>
            <statusCode nullFlavor="NI"/>
         </organizer>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9247_20181205102329">
      <!-- MP CDA author zorgverlener of patient vanaf 9.0.7. Also compatible with 9 2.0 dataset structure. Used in medicatiegebruik  -->
      <xsl:param name="ada-auteur"
                 as="element()*"
                 select=".">
         <!-- Input ada auteur element to be handled -->
      </xsl:param>
      <xsl:param name="authorTime"
                 as="element()*">
         <!-- The registration date/timd -->
      </xsl:param>
      <xsl:choose>
         <xsl:when test="$ada-auteur[.//(@value | @code | @nullFlavor)]">
            <xsl:for-each select="$ada-auteur">
               <author>
                  <!-- Voorstel- of Registratiedatum -->
                  <xsl:choose>
                     <xsl:when test="$authorTime">
                        <xsl:for-each select="$authorTime">
                           <time>
                              <xsl:call-template name="makeTSValueAttr"/>
                           </time>
                        </xsl:for-each>
                     </xsl:when>
                     <xsl:otherwise>
                        <!-- time is required -->
                        <time nullFlavor="NI"/>
                     </xsl:otherwise>
                  </xsl:choose>
                  <!-- auteur -->
                  <xsl:for-each select="auteur_is_zorgaanbieder/zorgaanbieder[*//(@value | @code)] | ../../../bouwstenen/zorgaanbieder[@id = current()/auteur_is_zorgaanbieder/zorgaanbieder/@value]">
                     <assignedAuthor>
                        <id nullFlavor="NI"/>
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.5_20180611000000"/>
                     </assignedAuthor>
                  </xsl:for-each>
                  <xsl:for-each select="auteur_is_zorgverlener/zorgverlener[*//(@value | @code)] | ../../../bouwstenen/zorgverlener[@id = current()/auteur_is_zorgverlener/zorgverlener/@value]">
                     <assignedAuthor>
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9113_20181205174044"/>
                     </assignedAuthor>
                  </xsl:for-each>
                  <xsl:if test="auteur_is_patient/@value = 'true'">
                     <assignedAuthor>
                        <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.52_20170825000000"/>
                     </assignedAuthor>
                  </xsl:if>
               </author>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <author>
               <!-- Voorstel- of Registratiedatum -->
               <xsl:choose>
                  <xsl:when test="$authorTime">
                     <xsl:for-each select="$authorTime">
                        <time>
                           <xsl:call-template name="makeTSValueAttr"/>
                        </time>
                     </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                     <!-- time is required -->
                     <time nullFlavor="NI"/>
                  </xsl:otherwise>
               </xsl:choose>
               <assignedAuthor>
                  <id nullFlavor="NI"/>
               </assignedAuthor>
            </author>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9253_20181206133041">
      <!--  MP CDA Medication Code vanaf 9.0.7  -->
      <xsl:param name="productCode"
                 as="element(product_code)*"/>
      <xsl:if test="$productCode[1] instance of element()">
         <xsl:variable name="mainGstdLevel"
                       as="xs:string?">
            <xsl:choose>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardZInummer]">
                  <xsl:value-of select="$oidGStandaardZInummer"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardHPK]">
                  <xsl:value-of select="$oidGStandaardHPK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardPRK]">
                  <xsl:value-of select="$oidGStandaardPRK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardGPK]">
                  <xsl:value-of select="$oidGStandaardGPK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardSSK]">
                  <xsl:value-of select="$oidGStandaardSSK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardSNK]">
                  <xsl:value-of select="$oidGStandaardSNK"/>
               </xsl:when>
            </xsl:choose>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="string-length($mainGstdLevel) gt 0">
               <xsl:call-template name="makeProductCode">
                  <xsl:with-param name="productCode"
                                  select="$productCode"/>
                  <xsl:with-param name="GstandaardLevel"
                                  select="$mainGstdLevel"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="$productCode">
                  <xsl:call-template name="makeCode"/>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9254_20181206143451">
      <!-- MP CDA Medication Information -->
      <xsl:param name="product"/>
      <xsl:if test="$product[1] instance of element()">
         <xsl:for-each select="$product">
            <manufacturedProduct>
               <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9254"/>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9264_20181211154905"/>
            </manufacturedProduct>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9263_20181211154012">
      <!-- MP CDA Medication Information (Proposal) vanaf 9.0.7  -->
      <xsl:param name="product"
                 as="element()?"/>
      <xsl:for-each select="$product">
         <manufacturedProduct classCode="MANU">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9263"/>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9264_20181211154905"/>
         </manufacturedProduct>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9264_20181211154905">
      <!--  MP CDA Medication Contents 9.1  -->
      <manufacturedMaterial classCode="MMAT"
                            determinerCode="KIND">
         <xsl:if test="product_code[.//(@value | @code)]">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9253_20181206133041">
               <xsl:with-param name="productCode"
                               select="product_code"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:if test="./product_specificatie[.//(@value | @code)]">
            <!-- magistrale medicatie -->
            <xsl:for-each select="./product_specificatie/product_naam[@value]">
               <name>
                  <xsl:value-of select="./@value"/>
               </name>
            </xsl:for-each>
            <xsl:for-each select="./product_specificatie/omschrijving[@value]">
               <pharm:desc>
                  <xsl:value-of select="./@value"/>
               </pharm:desc>
            </xsl:for-each>
            <xsl:for-each select="./product_specificatie/farmaceutische_vorm[.//(@value | @code)]">
               <pharm:formCode>
                  <xsl:call-template name="makeCodeAttribs">
                     <xsl:with-param name="originalText"
                                     select="."/>
                  </xsl:call-template>
               </pharm:formCode>
            </xsl:for-each>
            <xsl:for-each select="./product_specificatie/ingredient[.//(@value | @code)]">
               <pharm:ingredient classCode="INGR">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9106_20160626164013"/>
               </pharm:ingredient>
            </xsl:for-each>
         </xsl:if>
      </manufacturedMaterial>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9271_20181218112127">
      <!-- Reden voor wijzigen/stoppen medicatiegebruik vanaf 9.0.7  -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9271"/>
         <code code="7"
               displayName="Reden stoppen/wijzigen medicatiegebruik"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
               codeSystemName="Medicatieproces observaties"/>
         <value xsi:type="CE">
            <xsl:call-template name="makeCodeAttribs"/>
         </value>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9278_20191121124933">
      <!--  MP CDA (proposition) medication agreement ( (voorstel) Medicatieafspraak) reusable part from 9.1.0 -->
      <xsl:param name="ma">
         <!-- The input ada medication agreement -->
      </xsl:param>
      <xsl:for-each select="$ma">
         <xsl:for-each select="stoptype[.//(@value | @code)]">
            <entryRelationship typeCode="COMP">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9313_20200116154100"/>
            </entryRelationship>
         </xsl:for-each>
         <xsl:for-each select="(reden_afspraak | reden_wijzigen_of_staken)[.//(@value | @code)]">
            <entryRelationship typeCode="RSON">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9314_20200120115920"/>
            </entryRelationship>
         </xsl:for-each>
         <xsl:for-each select="reden_van_voorschrijven/probleem/probleem_naam[.//(@value | @code | @nullFlavor | @originalText)]">
            <entryRelationship typeCode="RSON">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9316_20200120135516"/>
            </entryRelationship>
         </xsl:for-each>
         <xsl:for-each select="gebruiksinstructie/aanvullende_instructie[.//(@value | @code)]">
            <entryRelationship typeCode="SPRT">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9085_20160621114818">
                  <xsl:with-param name="ada-aanvullende-instructie"
                                  select="."/>
               </xsl:call-template>
            </entryRelationship>
         </xsl:for-each>
         <!-- aanvullende_informatie -->
         <xsl:for-each select="aanvullende_informatie[.//(@value | @code)]">
            <entryRelationship typeCode="COMP">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9177_20170523084315"/>
            </entryRelationship>
         </xsl:for-each>
         <!-- toelichting -->
         <xsl:for-each select="toelichting[.//(@value | @code)]">
            <entryRelationship typeCode="SUBJ"
                               inversionInd="true">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.32_20180611000000"/>
            </entryRelationship>
         </xsl:for-each>
         <!--Doseerinstructie-->
         <xsl:for-each select="gebruiksinstructie/doseerinstructie[.//(@value | @code | @nullFlavor)]">
            <xsl:choose>
               <!-- geen dosering: pauze periode of 'gebruik bekend' of iets dergelijks -->
               <xsl:when test="not(./dosering[.//(@value | @code | @nullFlavor)])">
                  <entryRelationship typeCode="COMP">
                     <xsl:for-each select="volgnummer[.//(@value | @code)]">
                        <sequenceNumber>
                           <xsl:attribute name="value"
                                          select="@value"/>
                        </sequenceNumber>
                     </xsl:for-each>
                     <!-- Als helemaal geen volgnummer opgegeven: zelf 1 invullen -->
                     <xsl:if test="not(volgnummer[.//(@value | @code)])">
                        <sequenceNumber>
                           <xsl:attribute name="value"
                                          select="1"/>
                        </sequenceNumber>
                     </xsl:if>
                     <!-- pauze periode -->
                     <xsl:if test="../herhaalperiode_cyclisch_schema[.//(@value | @code)]">
                        <substanceAdministration classCode="SBADM"
                                                 moodCode="RQO">
                           <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9309"/>
                           <xsl:for-each select="./doseerduur[.//(@value | @code)]">
                              <effectiveTime xsi:type="hl7nl:PIVL_TS"
                                             operator="A"
                                             isFlexible="true">
                                 <hl7nl:phase>
                                    <hl7nl:width xsi:type="hl7nl:PQ">
                                       <xsl:call-template name="makeTimePQValueAttribs"/>
                                    </hl7nl:width>
                                 </hl7nl:phase>
                                 <xsl:for-each select="../../herhaalperiode_cyclisch_schema">
                                    <hl7nl:period>
                                       <xsl:call-template name="makeTimePQValueAttribs"/>
                                    </hl7nl:period>
                                 </xsl:for-each>
                              </effectiveTime>
                           </xsl:for-each>
                           <consumable xsi:nil="true"/>
                        </substanceAdministration>
                     </xsl:if>
                  </entryRelationship>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:for-each select="./dosering[.//(@value | @code)]">
                     <entryRelationship typeCode="COMP">
                        <xsl:for-each select="../volgnummer[.//(@value | @code)]">
                           <sequenceNumber>
                              <xsl:attribute name="value"
                                             select="./@value"/>
                           </sequenceNumber>
                        </xsl:for-each>
                        <!-- Als helemaal geen volgnummer opgegeven: zelf 1 invullen -->
                        <xsl:if test="not(../volgnummer[.//(@value | @code)])">
                           <sequenceNumber>
                              <xsl:attribute name="value"
                                             select="1"/>
                           </sequenceNumber>
                        </xsl:if>
                        <xsl:for-each select=".">
                           <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9309_20191125164900"/>
                        </xsl:for-each>
                     </entryRelationship>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
         <!-- Relatie naar afspraak of gebruik -->
         <xsl:for-each select="relatie_naar_afspraak_of_gebruik">
            <!-- Relatie naar MA -->
            <xsl:for-each select="./identificatie[@value]">
               <!-- kunnen er 0 of 1 zijn -->
               <entryRelationship typeCode="REFR">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9086_20160621122009">
                     <xsl:with-param name="identificatieElement"
                                     select="."/>
                  </xsl:call-template>
               </entryRelationship>
            </xsl:for-each>
            <!-- Relatie naar TA -->
            <xsl:for-each select="./identificatie_23288[@value]">
               <!-- kunnen er 0 of 1 zijn -->
               <entryRelationship typeCode="REFR">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9101_20160624130316">
                     <xsl:with-param name="identificatieElement"
                                     select="."/>
                  </xsl:call-template>
               </entryRelationship>
            </xsl:for-each>
            <!-- Relatie naar GB -->
            <xsl:for-each select="./identificatie_23289[@value]">
               <!-- kunnen er 0 of 1 zijn -->
               <entryRelationship typeCode="REFR">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9176_20170522183626">
                     <xsl:with-param name="identificatieElement"
                                     select="."/>
                  </xsl:call-template>
               </entryRelationship>
            </xsl:for-each>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9293_20191121174723">
      <!-- MP CDA assigned organisatie -->
      <xsl:param name="in"
                 as="element()*"
                 select=".">
         <!-- ada zorgaanbieder, defaults to context -->
      </xsl:param>
      <xsl:for-each select="$in">
         <id nullFlavor="NI"/>
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.5_20180611000000">
            <xsl:with-param name="deZorgaanbieder"
                            select="."/>
         </xsl:call-template>
         <!--        <representedOrganization>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9089_20160621134042"/>
        </representedOrganization>
-->
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9294_20191121175237"
                 match="verstrekking"
                 mode="handleMVE910">
      <!--  Verstrekking vanaf 9.1.0 -->
      <xsl:param name="in"
                 as="element()*"
                 select=".">
         <!-- ada verstrekking -->
      </xsl:param>
      <xsl:for-each select="$in">
         <supply classCode="SPLY"
                 moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9294"/>
            <!-- identificatie -->
            <xsl:for-each select="identificatie[@value | @nullFlavor]">
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
            <code displayName="Verstrekking"
                  code="373784005"
                  codeSystem="{$oidSNOMEDCT}"
                  codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
            <!-- (uitreik-)datum   (Aanschrijfdatum zit in EntityRelation) -->
            <xsl:for-each select="datum[@value | @nullFlavor]">
               <effectiveTime>
                  <xsl:call-template name="makeTSValueAttr"/>
               </effectiveTime>
            </xsl:for-each>
            <!-- verstrekte_hoeveelheid -->
            <xsl:for-each select="verstrekte_hoeveelheid[.//(@value | @unit | @nullFlavor)]">
               <quantity>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9165_20170118000000"/>
               </quantity>
            </xsl:for-each>
            <!-- verbruiks_duur  -->
            <xsl:for-each select="(verbruiks_duur | verbruiksduur)[@value]">
               <expectedUseTime>
                  <!-- Tijdseenheid is verplicht in dagen -->
                  <width value="{nf:calculate_Duur_In_Dagen(./@value,nf:convertTime_ADA_unit2UCUM(./@unit))}"
                         unit="d"/>
               </expectedUseTime>
            </xsl:for-each>
            <!-- verstrekt_geneesmiddel -->
            <xsl:for-each select="verstrekt_geneesmiddel/product[.//(@value | @code | @nullFlavor)]">
               <product>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9254_20181206143451">
                     <xsl:with-param name="product"
                                     select="."/>
                  </xsl:call-template>
               </product>
            </xsl:for-each>
            <!-- verstrekker/zorgaanbieder -->
            <xsl:for-each select="verstrekker/zorgaanbieder[.//(@value | @code | @nullFlavor)]">
               <performer>
                  <assignedEntity>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9088_20160621133312"/>
                  </assignedEntity>
               </performer>
            </xsl:for-each>
            <!-- afleverlocatie -->
            <xsl:for-each select="afleverlocatie[.//(@value | @code | @nullFlavor)]">
               <participant typeCode="DST">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9091_20160621153127"/>
               </participant>
            </xsl:for-each>
            <!-- aanschrijfdatum -->
            <xsl:for-each select="(aanschrijfdatum | aanschrijf_datum)[.//(@value | @code | @nullFlavor)]">
               <entryRelationship typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9095_20160623195047"/>
               </entryRelationship>
            </xsl:for-each>
            <!-- Distributievorm -->
            <xsl:for-each select="distributievorm[.//(@value | @code | @nullFlavor)]">
               <entryRelationship typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9097_20160623203415"/>
               </entryRelationship>
            </xsl:for-each>
            <!-- Aanvullende informatie bij verstrekking. -->
            <xsl:for-each select="aanvullende_informatie[.//(@value | @code | @nullFlavor)]">
               <entryRelationship typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9178_20170523091005"/>
               </entryRelationship>
            </xsl:for-each>
            <!-- Toelichting -->
            <xsl:for-each select="toelichting[.//(@value | @code | @nullFlavor)]">
               <entryRelationship typeCode="SUBJ"
                                  inversionInd="true">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.32_20180611000000"/>
               </entryRelationship>
            </xsl:for-each>
            <!-- relatie naar Verstrekkingsverzoek -->
            <xsl:for-each select="relatie_naar_verstrekkingsverzoek[.//(@value | @code | @nullFlavor)]">
               <entryRelationship typeCode="REFR">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9312_20191223150301"/>
               </entryRelationship>
            </xsl:for-each>
            <!--Relatie naar medicamenteuze behandeling - wordt automatisch gegenereerd -->
            <entryRelationship typeCode="COMP"
                               inversionInd="true">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9084_20160621103838">
                  <xsl:with-param name="MBHroot"
                                  select=".."/>
               </xsl:call-template>
            </entryRelationship>
         </supply>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9301_20191125141436"
                 match="verstrekkingsverzoek"
                 mode="HandleVV910">
      <!--  Verstrekkingsverzoek vanaf 9.1.0 -->
      <xsl:param name="in"
                 select=".">
         <!-- ada verstrekkingsverzoek to be converted -->
      </xsl:param>
      <xsl:for-each select="$in[.//(@value | @code)]">
         <supply classCode="SPLY"
                 moodCode="RQO">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9301"/>
            <!-- identificatie -->
            <xsl:for-each select="identificatie[@value]">
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
            <code code="52711000146108"
                  displayName="Verstrekkingsverzoek"
                  codeSystem="{$oidSNOMEDCT}"
                  codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
            <!-- aantal herhalingen -->
            <xsl:for-each select="aantal_herhalingen[@value]">
               <repeatNumber>
                  <xsl:attribute name="value"
                                 select="xs:integer(./@value) + 1"/>
               </repeatNumber>
            </xsl:for-each>
            <!-- Te verstrekken hoeveelheid -->
            <xsl:for-each select="te_verstrekken_hoeveelheid[.//@value]">
               <quantity>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9165_20170118000000"/>
               </quantity>
            </xsl:for-each>
            <!-- verbruiksperiode -->
            <xsl:for-each select="verbruiksperiode[.//(@value | @code)]">
               <expectedUseTime>
                  <xsl:for-each select="ingangsdatum">
                     <low>
                        <xsl:call-template name="makeTSValueAttr"/>
                     </low>
                  </xsl:for-each>
                  <xsl:for-each select="duur">
                     <width>
                        <xsl:call-template name="makeTimePQValueAttribs"/>
                     </width>
                  </xsl:for-each>
                  <xsl:for-each select="einddatum">
                     <high>
                        <xsl:call-template name="makeTSValueAttr"/>
                     </high>
                  </xsl:for-each>
               </expectedUseTime>
            </xsl:for-each>
            <!-- Te verstrekken geneesmiddel -->
            <xsl:for-each select="te_verstrekken_geneesmiddel/product[.//(@value | @code)]">
               <product>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9254_20181206143451">
                     <xsl:with-param name="product"
                                     select="."/>
                  </xsl:call-template>
               </product>
            </xsl:for-each>
            <!-- beoogd verstrekker -->
            <xsl:for-each select="beoogd_verstrekker/zorgaanbieder[.//(@value | @code)]">
               <performer>
                  <assignedEntity>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9088_20160621133312"/>
                  </assignedEntity>
               </performer>
            </xsl:for-each>
            <!-- Auteur / zorgverlener -->
            <xsl:for-each select="./auteur/zorgverlener[.//(@value | @code)]">
               <author>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9066_20181205174210">
                     <xsl:with-param name="authorTime"
                                     select="../../datum"/>
                  </xsl:call-template>
               </author>
            </xsl:for-each>
            <!-- afleverlocatie -->
            <xsl:for-each select="afleverlocatie[.//(@value | @code)]">
               <participant typeCode="DST">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9091_20160621153127"/>
               </participant>
            </xsl:for-each>
            <!-- aanvullende wensen -->
            <xsl:for-each select="aanvullende_wensen[@value | @code | @nullFlavor | @originalText]">
               <!-- kunnen er 0 of meer zijn -->
               <entryRelationship typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9093_20160623183534"/>
               </entryRelationship>
            </xsl:for-each>
            <!-- Toelichting -->
            <xsl:for-each select="./toelichting[@value]">
               <entryRelationship typeCode="SUBJ"
                                  inversionInd="true">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.32_20180611000000"/>
               </entryRelationship>
            </xsl:for-each>
            <!-- relatie naar MA -->
            <xsl:for-each select="./relatie_naar_medicatieafspraak[.//(@value | @code)]">
               <!-- kunnen er 0 of meer zijn -->
               <entryRelationship typeCode="REFR">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9086_20160621122009">
                     <xsl:with-param name="identificatieElement"
                                     select="./identificatie"/>
                  </xsl:call-template>
               </entryRelationship>
            </xsl:for-each>
            <!--Relatie naar medicamenteuze behandeling - wordt automatisch gegenereerd -->
            <entryRelationship typeCode="COMP"
                               inversionInd="true">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9084_20160621103838">
                  <xsl:with-param name="MBHroot"
                                  select="./.."/>
               </xsl:call-template>
            </entryRelationship>
         </supply>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9309_20191125164900"
                 match="dosering"
                 mode="HandleDosering910">
      <!-- Template for dosage from MP 9.1.0 -->
      <!-- MP CDA Dosering -->
      <substanceAdministration classCode="SBADM"
                               moodCode="RQO">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9309"/>
         <xsl:if test="not(../../herhaalperiode_cyclisch_schema[.//(@value | @code)])">
            <!-- Alleen bij een NIET cyclisch schema -->
            <xsl:for-each select="../doseerduur[.//(@value | @code)]">
               <effectiveTime xsi:type="IVL_TS">
                  <width>
                     <xsl:call-template name="makeTimePQValueAttribs"/>
                  </width>
               </effectiveTime>
            </xsl:for-each>
         </xsl:if>
         <!-- cyclisch schema, doseerinstructie zonder toedieningsschema -->
         <xsl:if test="../../herhaalperiode_cyclisch_schema[.//(@value | @code)] and not(./toedieningsschema[.//(@value | @code)])">
            <!-- pauze periode -->
            <xsl:for-each select="../doseerduur[.//(@value | @code)]">
               <effectiveTime xsi:type="hl7nl:PIVL_TS"
                              operator="A"
                              isFlexible="true">
                  <hl7nl:phase>
                     <hl7nl:width xsi:type="hl7nl:PQ">
                        <xsl:call-template name="makeTimePQValueAttribs"/>
                     </hl7nl:width>
                  </hl7nl:phase>
                  <xsl:for-each select="../../herhaalperiode_cyclisch_schema">
                     <hl7nl:period>
                        <xsl:call-template name="makeTimePQValueAttribs"/>
                     </hl7nl:period>
                  </xsl:for-each>
               </effectiveTime>
            </xsl:for-each>
         </xsl:if>
         <xsl:for-each select=".">
            <xsl:for-each select="toedieningsschema[.//(@value | @code)]">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9076_20160619200644"/>
            </xsl:for-each>
            <!-- just in case there is a toedieningsduur and no toedieningsschema, this really should not happen, but who are we to filter out the toedieningsduur in that case,
                so let't at least output the given toedieningsduur-->
            <!-- doseerschema met toedieningsduur zonder toedieningsschema -->
            <xsl:if test="toedieningsduur[.//(@value | @code)] and not(toedieningsschema[.//(@value | @code)])">
               <effectiveTime>
                  <xsl:attribute name="xsi:type">hl7nl:PIVL_TS</xsl:attribute>
                  <xsl:attribute name="operator">A</xsl:attribute>
                  <xsl:attribute name="isFlexible">true</xsl:attribute>
                  <xsl:for-each select="toedieningsduur">
                     <hl7nl:phase>
                        <hl7nl:width xsi:type="hl7nl:PQ">
                           <xsl:call-template name="makeTimePQValueAttribs"/>
                        </hl7nl:width>
                     </hl7nl:phase>
                  </xsl:for-each>
               </effectiveTime>
            </xsl:if>
            <xsl:for-each select="keerdosis[.//(@value | @code)]">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9048_20160614145840"/>
            </xsl:for-each>
            <xsl:for-each select="toedieningssnelheid[.//(@value | @code)]">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9150_20160726150449"/>
            </xsl:for-each>
            <xsl:for-each select="zo_nodig/maximale_dosering[.//(@value | @code)]">
               <maxDoseQuantity>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9064_20160601000000"/>
               </maxDoseQuantity>
            </xsl:for-each>
         </xsl:for-each>
         <!-- Altijd verplicht op deze manier aanwezig in de HL7 -->
         <consumable xsi:nil="true"/>
         <xsl:for-each select="zo_nodig/criterium[.//(@value | @code)]">
            <precondition>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9182_20170601000000">
                  <xsl:with-param name="inCode"
                                  select="code/@code"/>
                  <xsl:with-param name="inCodeSystem"
                                  select="code/@codeSystem"/>
                  <xsl:with-param name="inDisplayName"
                                  select="code/@displayName"/>
                  <xsl:with-param name="strOriginalText"
                                  select="code/@originalText"/>
               </xsl:call-template>
            </precondition>
         </xsl:for-each>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9312_20191223150301">
      <!-- Relatie naar verstrekkingsverzoek vanaf 9.1.0 -->
      <supply classCode="SPLY"
              moodCode="RQO">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9312"/>
         <xsl:for-each select="identificatie">
            <xsl:call-template name="makeIIid"/>
         </xsl:for-each>
         <code code="52711000146108"
               displayName="Request to dispense medication to patient"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
      </supply>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9313_20200116154100">
      <!-- Stoptype -->
      <xsl:param name="in"
                 select=".">
         <!-- Optional. Input ada element, defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <observation classCode="OBS"
                      moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9313"/>
            <code code="274512008"
                  displayName="behandeling met geneesmiddel stopgezet"
                  codeSystem="{$oidSNOMEDCT}"
                  codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
            <xsl:call-template name="makeCEValue"/>
         </observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9314_20200120115920"
                 match="reden_afspraak"
                 mode="HandleRedenAfspraak91">
      <!--  Reden voor medicatieafspraak vanaf 9.1.0 -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9314"/>
         <code code="112241000146101"
               displayName="Reason for prescription"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
         <xsl:call-template name="makeCEValue"/>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9315_20200120125612">
      <!-- Reden voor toedieningsafspraak vanaf 9.1 -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9315"/>
         <code code="112231000146109"
               displayName="Reason for administration instructions (observable entity)"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
         <text>
            <xsl:value-of select="@value"/>
         </text>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9316_20200120135516">
      <!-- Reden van voorschrijven -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9316"/>
         <code code="112201000146104"
               displayName="Medical reason for prescription (observable entity)"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
         <xsl:call-template name="makeCEValue"/>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9317_20200120141110">
      <!-- Volgens afspraak indicator from 9.1 -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9317"/>
         <code displayName="patient takes medication as prescribed (finding)"
               code="112221000146107"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
         <xsl:call-template name="makeBLValue">
            <xsl:with-param name="elemName">value</xsl:with-param>
            <xsl:with-param name="xsiType">BL</xsl:with-param>
         </xsl:call-template>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9358_20210517124213"
                 match="toedieningsschema"
                 mode="HandleFHIRinCDAAdministrationSchedule9x">
      <!-- Create an MP CDA administration schedule based on ada toedieningsschema. Version FHIR. Override of version in 2_hl7_mp_include_9x.xsl -->
      <xsl:param name="in"
                 as="element()*"
                 select=".">
         <!-- The ada input element: toedieningsschema. Defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <effectiveTime xsi:type="Timing"
                        xmlns="http://hl7.org/fhir">
            <xsl:call-template name="adaToedieningsschema2FhirTimingContents">
               <xsl:with-param name="in"
                               select="."/>
               <xsl:with-param name="inHerhaalperiodeCyclischschema"
                               select="../../../herhaalperiode_cyclisch_schema"/>
            </xsl:call-template>
         </effectiveTime>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9359_20210517141255"
                 match="dosering"
                 mode="HandleDosering920">
      <!-- Template for dosage from MP 9 2.0 -->
      <!-- MP CDA Dosering -->
      <substanceAdministration classCode="SBADM"
                               moodCode="RQO">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9359"/>
         <xsl:for-each select=".">
            <xsl:for-each select="toedieningsschema[.//(@value | @code)]">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9358_20210517124213"/>
            </xsl:for-each>
            <xsl:for-each select="keerdosis[.//(@value | @code )]">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9048_20160614145840"/>
            </xsl:for-each>
            <xsl:for-each select="toedieningssnelheid[.//(@value | @code)]">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9150_20160726150449"/>
            </xsl:for-each>
            <xsl:for-each select="zo_nodig/maximale_dosering[.//(@value | @code)]">
               <maxDoseQuantity>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9064_20160601000000"/>
               </maxDoseQuantity>
            </xsl:for-each>
         </xsl:for-each>
         <!-- Altijd verplicht op deze manier aanwezig in de HL7 substanceAdministration -->
         <consumable xsi:nil="true"/>
         <xsl:for-each select="zo_nodig/criterium[.//(@value | @code)]">
            <precondition>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9182_20170601000000">
                  <xsl:with-param name="inCode"
                                  select="(code | criterium)/@code"/>
                  <xsl:with-param name="inCodeSystem"
                                  select="(code | criterium)/@codeSystem"/>
                  <xsl:with-param name="inDisplayName"
                                  select="(code | criterium)/@displayName"/>
                  <xsl:with-param name="strOriginalText"
                                  select="(code | criterium)/@originalText"/>
               </xsl:call-template>
            </precondition>
         </xsl:for-each>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9360_20210602150453">
      <!--  MP CDA Medication Code vanaf 9.2  -->
      <xsl:param name="productCode"
                 as="element(product_code)*">
         <!-- ada elements containing product_code -->
      </xsl:param>
      <xsl:variable name="mainGstdLevel"
                    as="xs:string?">
         <xsl:choose>
            <xsl:when test="$productCode[@codeSystem = $oidGStandaardZInummer]">
               <xsl:value-of select="$oidGStandaardZInummer"/>
            </xsl:when>
            <xsl:when test="$productCode[@codeSystem = $oidGStandaardHPK]">
               <xsl:value-of select="$oidGStandaardHPK"/>
            </xsl:when>
            <xsl:when test="$productCode[@codeSystem = $oidGStandaardPRK]">
               <xsl:value-of select="$oidGStandaardPRK"/>
            </xsl:when>
            <xsl:when test="$productCode[@codeSystem = $oidGStandaardGPK]">
               <xsl:value-of select="$oidGStandaardGPK"/>
            </xsl:when>
            <xsl:when test="$productCode[@codeSystem = $oidGStandaardSSK]">
               <xsl:value-of select="$oidGStandaardSSK"/>
            </xsl:when>
            <xsl:when test="$productCode[@codeSystem = $oidGStandaardSNK]">
               <xsl:value-of select="$oidGStandaardSNK"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="string-length($mainGstdLevel) gt 0">
            <xsl:call-template name="makeProductCode">
               <xsl:with-param name="productCode"
                               select="$productCode"/>
               <xsl:with-param name="GstandaardLevel"
                               select="$mainGstdLevel"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:for-each select="$productCode">
               <xsl:call-template name="makeCode"/>
            </xsl:for-each>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9361_20210602154629">
      <!--  MP CDA Medication Contents vanaf 9.2  -->
      <manufacturedMaterial classCode="MMAT"
                            determinerCode="KIND">
         <xsl:if test="product_code[.//(@value | @code)]">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9360_20210602150453">
               <xsl:with-param name="productCode"
                               select="product_code"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:if test="./product_specificatie[.//(@value | @code)]">
            <!-- magistrale medicatie -->
            <xsl:for-each select="./product_specificatie/product_naam[@value]">
               <name>
                  <xsl:value-of select="./@value"/>
               </name>
            </xsl:for-each>
            <xsl:for-each select="./product_specificatie/omschrijving[@value]">
               <pharm:desc>
                  <xsl:value-of select="./@value"/>
               </pharm:desc>
            </xsl:for-each>
            <xsl:for-each select="./product_specificatie/farmaceutische_vorm[.//(@value | @code)]">
               <pharm:formCode>
                  <xsl:call-template name="makeCodeAttribs">
                     <xsl:with-param name="originalText"
                                     select="."/>
                  </xsl:call-template>
               </pharm:formCode>
            </xsl:for-each>
            <xsl:for-each select="./product_specificatie/ingredient[.//(@value | @code)]">
               <pharm:ingredient classCode="INGR">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9367_20210602171147"/>
               </pharm:ingredient>
            </xsl:for-each>
         </xsl:if>
      </manufacturedMaterial>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9362_20210602154632">
      <!-- MP CDA Medication Information vanaf 9.2 -->
      <xsl:param name="product"/>
      <xsl:if test="$product[1] instance of element()">
         <xsl:for-each select="$product">
            <manufacturedProduct>
               <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9362"/>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9361_20210602154629"/>
            </manufacturedProduct>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9363_20210602155855">
      <!-- MP CDA Medication Information for proposal or medication use vanaf 9.2 -->
      <xsl:param name="product"
                 as="element()*">
         <!-- input ada product -->
      </xsl:param>
      <xsl:choose>
         <xsl:when test="$product[.//(@value | @unit | @code | @nullFlavor)]">
            <xsl:for-each select="$product">
               <manufacturedProduct>
                  <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9363"/>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9361_20210602154629"/>
               </manufacturedProduct>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:attribute name="xsi:nil">true</xsl:attribute>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9364_20210602161935"
                 match="verstrekking"
                 mode="handleMVE910">
      <!--  Verstrekking vanaf 9.1.0 -->
      <xsl:param name="in"
                 as="element()*"
                 select=".">
         <!-- ada verstrekking -->
      </xsl:param>
      <xsl:for-each select="$in">
         <supply classCode="SPLY"
                 moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9364"/>
            <!-- identificatie -->
            <xsl:for-each select="identificatie[@value | @nullFlavor]">
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
            <code displayName="Verstrekking"
                  code="373784005"
                  codeSystem="{$oidSNOMEDCT}"
                  codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
            <!-- (uitreik-)datum   (Aanschrijfdatum zit in EntityRelation) -->
            <xsl:for-each select="(datum | medicatieverstrekkings_datum_tijd)[@value | @nullFlavor]">
               <effectiveTime>
                  <xsl:call-template name="makeTSValueAttr"/>
               </effectiveTime>
            </xsl:for-each>
            <!-- verstrekte_hoeveelheid -->
            <xsl:for-each select="verstrekte_hoeveelheid[.//(@value | @unit | @nullFlavor)]">
               <quantity>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9165_20170118000000"/>
               </quantity>
            </xsl:for-each>
            <!-- verbruiks_duur  -->
            <xsl:for-each select="(verbruiks_duur | verbruiksduur)[(@value | @unit)]">
               <expectedUseTime>
                  <width>
                     <xsl:call-template name="makeTimePQValueAttribs"/>
                  </width>
               </expectedUseTime>
            </xsl:for-each>
            <!-- verstrekt_geneesmiddel -->
            <xsl:for-each select="../../bouwstenen/farmaceutisch_product[@id = current()/verstrekt_geneesmiddel/farmaceutisch_product/@value]">
               <product>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9362_20210602154632">
                     <xsl:with-param name="product"
                                     select="."/>
                  </xsl:call-template>
               </product>
            </xsl:for-each>
            <!-- verstrekker/zorgaanbieder -->
            <xsl:for-each select="../../bouwstenen/zorgaanbieder[@id = current()/verstrekker/zorgaanbieder/@value]">
               <performer>
                  <assignedEntity>
                     <id nullFlavor="NI"/>
                     <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.33_20210701000000"/>
                  </assignedEntity>
               </performer>
            </xsl:for-each>
            <!-- afleverlocatie -->
            <xsl:for-each select="afleverlocatie[.//(@value | @code | @nullFlavor)]">
               <participant typeCode="DST">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9091_20160621153127"/>
               </participant>
            </xsl:for-each>
            <!-- aanschrijfdatum -->
            <xsl:for-each select="(aanschrijfdatum | aanschrijf_datum)[.//(@value | @code | @nullFlavor)]">
               <entryRelationship typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9095_20160623195047"/>
               </entryRelationship>
            </xsl:for-each>
            <!-- Distributievorm -->
            <xsl:for-each select="distributievorm[.//(@value | @code | @nullFlavor)]">
               <entryRelationship typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9097_20160623203415"/>
               </entryRelationship>
            </xsl:for-each>
            <!-- Aanvullende informatie bij verstrekking. -->
            <xsl:for-each select="(aanvullende_informatie | medicatieverstrekking_aanvullende_informatie)[.//(@value | @code | @nullFlavor)]">
               <entryRelationship typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9178_20170523091005"/>
               </entryRelationship>
            </xsl:for-each>
            <!-- Toelichting -->
            <xsl:for-each select="toelichting[.//(@value | @code | @nullFlavor)]">
               <entryRelationship typeCode="SUBJ"
                                  inversionInd="true">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.0.32_20180611000000"/>
               </entryRelationship>
            </xsl:for-each>
            <!-- relatie naar Verstrekkingsverzoek -->
            <xsl:for-each select="(relatie_naar_verstrekkingsverzoek | relatie_verstrekkingsverzoek)[.//(@value | @code | @nullFlavor)]">
               <entryRelationship typeCode="REFR">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9312_20191223150301"/>
               </entryRelationship>
            </xsl:for-each>
            <!--Relatie naar medicamenteuze behandeling -->
            <entryRelationship typeCode="COMP"
                               inversionInd="true">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9084_20160621103838">
                  <xsl:with-param name="MBHroot"
                                  select=".."/>
               </xsl:call-template>
            </entryRelationship>
         </supply>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9367_20210602171147">
      <!-- MP CDA Ingredient from MP 9.2 onwards -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- Expected is an ada ingredient element. Defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:for-each select="sterkte[.//(@value | @code | @nullFlavor)]">
            <pharm:quantity>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9071_20160618204153"/>
            </pharm:quantity>
         </xsl:for-each>
         <xsl:if test="ingredient_code[.//(@value | @code | @nullFlavor)]">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9368_20210602171340">
               <xsl:with-param name="ingredientCode"
                               select="ingredient_code"/>
            </xsl:call-template>
         </xsl:if>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9368_20210602171340">
      <!-- MP CDA Ingredient Material Kind -->
      <xsl:param name="ingredientCode"
                 as="element()*">
         <!-- ada element ingredient_code -->
      </xsl:param>
      <pharm:ingredient classCode="MMAT"
                        determinerCode="KIND">
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9369_20210602171615">
            <xsl:with-param name="ingredientCode"
                            select="$ingredientCode"/>
         </xsl:call-template>
      </pharm:ingredient>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9369_20210602171615">
      <!-- MP CDA Material Code Ext -->
      <xsl:param name="ingredientCode"
                 as="element()*">
         <!-- ada element ingredient_code -->
      </xsl:param>
      <xsl:variable name="productCode"
                    select="$ingredientCode"/>
      <xsl:if test="$productCode[1] instance of element()">
         <xsl:variable name="mainGstdLevel"
                       as="xs:string?">
            <xsl:choose>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardZInummer]">
                  <xsl:value-of select="$oidGStandaardZInummer"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardHPK]">
                  <xsl:value-of select="$oidGStandaardHPK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardPRK]">
                  <xsl:value-of select="$oidGStandaardPRK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardGPK]">
                  <xsl:value-of select="$oidGStandaardGPK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardSSK]">
                  <xsl:value-of select="$oidGStandaardSSK"/>
               </xsl:when>
               <xsl:when test="$productCode[@codeSystem = $oidGStandaardSNK]">
                  <xsl:value-of select="$oidGStandaardSNK"/>
               </xsl:when>
            </xsl:choose>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="string-length($mainGstdLevel) gt 0">
               <xsl:call-template name="makeProductCode">
                  <xsl:with-param name="productCode"
                                  select="$productCode"/>
                  <xsl:with-param name="GstandaardLevel"
                                  select="$mainGstdLevel"/>
                  <xsl:with-param name="elemName">pharm:code</xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:for-each select="$productCode">
                  <xsl:call-template name="makeCode">
                     <xsl:with-param name="elemName">pharm:code</xsl:with-param>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
      <!-- <pharm:code>
            <xsl:call-template name="makeCodeAttribs"/>
        </pharm:code>-->
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9372_20210616133243">
      <!-- Stoptype -->
      <xsl:param name="in"
                 select=".">
         <!-- Optional. Input ada element, defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <observation classCode="OBS"
                      moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9372"/>
            <code code="274512008"
                  displayName="behandeling met geneesmiddel stopgezet"
                  codeSystem="{$oidSNOMEDCT}"
                  codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
            <xsl:call-template name="makeCEValue"/>
         </observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9375_20210616173557"
                 match="medicatie_toediening_reden_van_afwijken"
                 mode="HandleMtdRedenVanAfwijken92">
      <!--  Reden van afwijken medicatietoediening -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9375"/>
         <code code="153631000146105"
               displayName="reden voor afwijken in toedienen van medicatie (waarneembare entiteit)"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
         <xsl:call-template name="makeCEValue"/>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9376_20210617000000">
      <!-- Afgesproken datum tijd en/of keerdosis -->
      <xsl:param name="datumTijdElement"
                 as="element()?"
                 select=".">
         <!-- The ada datumtijd element. Defaults to context. -->
      </xsl:param>
      <xsl:param name="keerdosisElement"
                 as="element()?"
                 select="../afgesproken_hoeveelheid">
         <!-- The ada keerdosis element. Defaults to context. -->
      </xsl:param>
      <substanceAdministration classCode="SBADM"
                               moodCode="RQO">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9376"/>
         <xsl:for-each select="$datumTijdElement">
            <effectiveTime>
               <xsl:call-template name="makeTSValueAttr"/>
            </effectiveTime>
         </xsl:for-each>
         <xsl:for-each select="$keerdosisElement">
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9048_20160614145840"/>
         </xsl:for-each>
         <consumable xsi:nil="true"/>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9381_20210617181505">
      <!-- Relatie wisselend_doseerschema -->
      <xsl:param name="identificatieElement"
                 select="."
                 as="element()*">
         <!-- The ada identificatie element. Defaults to context. -->
      </xsl:param>
      <!-- MP wisselend_doseerschema identificatie -->
      <substanceAdministration classCode="SBADM"
                               moodCode="RQO">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9381"/>
         <xsl:for-each select="$identificatieElement">
            <xsl:call-template name="makeIIid"/>
         </xsl:for-each>
         <code code="395067002"
               displayName="optimaliseren van dosering van medicatie (verrichting)"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
         <consumable xsi:nil="true"/>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9384_20210618">
      <!-- Relatie medicatieafspraak -->
      <xsl:param name="identificatieElement"
                 select=".">
         <!-- The ada identificatie element. Defaults to context. -->
      </xsl:param>
      <!-- MP Medicatieafspraak identificatie -->
      <substanceAdministration classCode="SBADM"
                               moodCode="RQO">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9384"/>
         <xsl:if test="$identificatieElement[1] instance of element()">
            <xsl:for-each select="$identificatieElement">
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
         </xsl:if>
         <code code="33633005"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"
               displayName="Medicatieafspraak"/>
         <consumable xsi:nil="true"/>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9386_20210629170021">
      <!-- MP Medicatiegebruik identificatie -->
      <xsl:param name="identificatieElement">
         <!-- The ada element identificatie -->
      </xsl:param>
      <substanceAdministration classCode="SBADM"
                               moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9386"/>
         <xsl:if test="$identificatieElement[1] instance of element()">
            <xsl:for-each select="$identificatieElement">
               <xsl:call-template name="makeIIid"/>
            </xsl:for-each>
         </xsl:if>
         <code code="422979000"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"
               displayName="bevinding betreffende gedrag met betrekking tot medicatieregime (bevinding)"/>
         <consumable xsi:nil="true"/>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9393_20210701">
      <!-- Template voor relatie MTD -->
      <xsl:param name="identificatieElement"
                 select=".">
         <!-- ada identificatie element -->
      </xsl:param>
      <xsl:for-each select="$identificatieElement">
         <substanceAdministration classCode="SBADM"
                                  moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9393"/>
            <xsl:if test=".[1] instance of element()">
               <xsl:for-each select=".">
                  <xsl:call-template name="makeIIid"/>
               </xsl:for-each>
            </xsl:if>
            <code displayName="toediening van medicatie (verrichting)"
                  code="18629005"
                  codeSystem="{$oidSNOMEDCT}"
                  codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
            <consumable xsi:nil="true"/>
         </substanceAdministration>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9387_20210701000000">
      <!-- MP CDA author zorgverlener of patient vanaf 9.0.7. Also compatible with 9 2.0 dataset structure. Used in medicatiegebruik  -->
      <xsl:param name="adaAuteur"
                 as="element()?"
                 select=".">
         <!-- Input ada auteur element to be handled -->
      </xsl:param>
      <xsl:param name="authorTime"
                 as="element()?">
         <!-- The registration date/time -->
      </xsl:param>
      <xsl:choose>
         <xsl:when test="$adaAuteur/auteur_is_zorgaanbieder">
            <author>
               <xsl:call-template name="makeTSValue">
                  <xsl:with-param name="elemName">time</xsl:with-param>
                  <xsl:with-param name="inputValue"
                                  select="$authorTime/@value"/>
               </xsl:call-template>
               <assignedAuthor>
                  <id nullFlavor="NI"/>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.33_20210701000000">
                     <xsl:with-param name="in"
                                     select="$adaAuteur/ancestor::adaxml/data/*/bouwstenen/zorgaanbieder[@id = $adaAuteur/auteur_is_zorgaanbieder/zorgaanbieder/@value]"/>
                  </xsl:call-template>
               </assignedAuthor>
            </author>
         </xsl:when>
         <xsl:when test="$adaAuteur/auteur_is_patient[@value = 'true']">
            <author>
               <xsl:call-template name="makeTSValue">
                  <xsl:with-param name="elemName">time</xsl:with-param>
                  <xsl:with-param name="inputValue"
                                  select="$authorTime/@value"/>
               </xsl:call-template>
               <assignedAuthor>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.52_20170825000000">
                     <xsl:with-param name="ada_patient_identificatienummer"
                                     select="ancestor::adaxml/data/*/patient/(patient_identificatienummer | identificatienummer)"/>
                  </xsl:call-template>
               </assignedAuthor>
            </author>
         </xsl:when>
         <xsl:when test="$adaAuteur/auteur_is_zorgverlener">
            <author>
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.32_20210701000000">
                  <xsl:with-param name="in"
                                  select="$adaAuteur/ancestor::adaxml/data/*/bouwstenen/zorgverlener[@id = $adaAuteur/auteur_is_zorgverlener/zorgverlener/@value]"/>
                  <xsl:with-param name="theTime"
                                  select="$authorTime"/>
               </xsl:call-template>
            </author>
         </xsl:when>
         <xsl:when test="$authorTime">
            <author>
               <xsl:call-template name="makeTSValue">
                  <xsl:with-param name="elemName">time</xsl:with-param>
                  <xsl:with-param name="inputValue"
                                  select="$authorTime/@value"/>
               </xsl:call-template>
               <assignedAuthor>
                  <id nullFlavor="NI"/>
               </assignedAuthor>
            </author>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9388_20210709160923"
                 match="zorgverlener"
                 mode="HandleRel2MAVoorschrijver">
      <!-- MP MA Voorschrijver -->
      <substanceAdministration classCode="SBADM"
                               moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9388"/>
         <code code="33633005"
               codeSystem="{$oidSNOMEDCT}"
               codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"
               displayName="Medicatieafspraak"/>
         <consumable xsi:nil="true"/>
         <author>
            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.32_20210701000000"/>
         </author>
      </substanceAdministration>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9389_20210701000000"
                 match="auteur"
                 mode="HandleDocGegAuteur920">
      <!-- MP CDA author medicatieoverzicht - vanaf versie 9 2.0  -->
      <xsl:param name="auteur"
                 select="."/>
      <xsl:for-each select="$auteur">
         <author>
            <xsl:choose>
               <!-- use the document date if available -->
               <xsl:when test="../document_datum[@value | @nullFlavor]">
                  <xsl:for-each select="../document_datum[@value | @nullFlavor]">
                     <xsl:call-template name="makeTSValue">
                        <xsl:with-param name="elemName">time</xsl:with-param>
                     </xsl:call-template>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <time nullFlavor="NI"/>
               </xsl:otherwise>
            </xsl:choose>
            <assignedAuthor>
               <xsl:for-each select="auteur_is_zorgaanbieder/zorgaanbieder">
                  <!--identificatie-->
                  <id nullFlavor="NI"/>
                  <!--Zorgaanbieder-->
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.33_20210701000000"/>
               </xsl:for-each>
               <!--Patient-->
               <xsl:if test="auteur_is_patient">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.7.10.52_20170825000000">
                     <xsl:with-param name="ada_patient_identificatienummer"
                                     select="ancestor::adaxml/data/*/patient/(patient_identificatienummer | identificatienummer)"/>
                  </xsl:call-template>
               </xsl:if>
            </assignedAuthor>
         </author>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9390_20210816074229">
      <!-- Reden voor medicatiegebruik -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- ada element containing text for reason medication use, defaults to context -->
      </xsl:param>
      <xsl:for-each select="$in">
         <observation classCode="OBS"
                      moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9390"/>
            <code code="11611000146100"
                  displayName="Reden medicatiegebruik"
                  codeSystem="{$oidSNOMEDCT}"
                  codeSystemName="{$oidMap[@oid=$oidSNOMEDCT]/@displayName}"/>
            <xsl:call-template name="makeText"/>
         </observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9396_20220315000000"
                 match="antwoord"
                 mode="HandleAvma">
      <!-- Creates the response to a proposed dispense request -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- the ada element for antwoord -->
      </xsl:param>
      <xsl:for-each select="$in">
         <act classCode="ACT"
              moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9396"/>
            <code code="10"
                  codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.3"
                  codeSystemName="Medicatieproces acts"
                  displayName="Antwoord voorstel medicatieafspraak"/>
            <xsl:for-each select="./auteur[.//(@value | @code)]">
               <author>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.32_20210701000000">
                     <xsl:with-param name="in"
                                     select="ancestor::adaxml/data/*/bouwstenen/zorgverlener[@id = current()/zorgverlener/@value] | current()/zorgverlener[not(@value)][.//(@value | @code)]"/>
                     <xsl:with-param name="theTime"
                                     select="../antwoord_datum"/>
                  </xsl:call-template>
               </author>
            </xsl:for-each>
            <xsl:for-each select="antwoord_medicatieafspraak[@code]">
               <entryRelationship typeCode="COMP">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9397_20220315000000"/>
               </entryRelationship>
            </xsl:for-each>
            <xsl:for-each select="relatie_voorstel_gegevens/identificatie[@value]">
               <entryRelationship typeCode="SUBJ">
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9398_2022031500000"/>
               </entryRelationship>
            </xsl:for-each>
         </act>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9397_20220315000000">
      <!-- Observatie met het inhoudelijke antwoord op voorstel medicatieafspraak -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- the ada element for antwoord_medicatieafspraak, defaults to context -->
      </xsl:param>
      <xsl:for-each select="$in">
         <observation classCode="OBS"
                      moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9397"/>
            <code code="17"
                  codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
                  codeSystemName="Medicatieproces observaties"
                  displayName="Antwoord op voorstel"/>
            <xsl:call-template name="makeCEValue"/>
         </observation>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9398_2022031500000">
      <!-- Create an MP CDA administration schedule based on ada toedieningsschema. Version 9.x but is a temporary backup. Should be deleted after 9349 has been approved. -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- The ada input element: toedieningsschema. Defaults to context. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <organizer classCode="CLUSTER"
                    moodCode="EVN">
            <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9398"/>
            <xsl:call-template name="makeIIValue">
               <xsl:with-param name="elemName">id</xsl:with-param>
            </xsl:call-template>
            <code code="107"
                  displayName="Sturen voorstel medicatieafspraak"
                  codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.4"
                  codeSystemName="ART DECOR transacties"/>
            <statusCode nullFlavor="NI"/>
         </organizer>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9401_20220315000000">
      <!--  MP CDA MA Aanvullende informatie  -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9401"/>
         <code code="11"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
               displayName="Aanvullende informatie Medicatieafspraak"/>
         <xsl:choose>
            <xsl:when test="@code">
               <xsl:call-template name="makeCEValue"/>
            </xsl:when>
            <!-- this should not happen in MP9 2.0.0, but let's output whatever was in @value when there is no @code -->
            <xsl:when test="not(@code) and @value">
               <xsl:call-template name="makeSTValue">
                  <xsl:with-param name="elemName">text</xsl:with-param>
               </xsl:call-template>
            </xsl:when>
         </xsl:choose>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9402_20220315000000">
      <!--  MP CDA TA Aanvullende informatie  -->
      <observation classCode="OBS"
                   moodCode="EVN">
         <templateId root="2.16.840.1.113883.2.4.3.11.60.20.77.10.9402"/>
         <code code="12"
               codeSystem="2.16.840.1.113883.2.4.3.11.60.20.77.5.2"
               displayName="Aanvullende informatie Toedieningsafspraak"/>
         <xsl:choose>
            <xsl:when test="not(@code) and @value">
               <xsl:call-template name="makeSTValue">
                  <xsl:with-param name="elemName">text</xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <!-- for backward compatibility reasons let's output a code if it's there, should not happen in MP9 2.0.0 -->
            <xsl:when test="@code">
               <xsl:call-template name="makeCEValue"/>
            </xsl:when>
         </xsl:choose>
      </observation>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:convertUnit_ADA2UCUM"
                 as="xs:string">
      <xsl:param name="ADAunit"
                 as="xs:string"/>
      <!-- In ADA forms wordt stuk/dosis/eenheid/tablet gebruikt, wat in UCUM '1' is -->
      <xsl:choose>
         <xsl:when test="lower-case($ADAunit) eq 'eenheid'">1</xsl:when>
         <xsl:when test="lower-case($ADAunit) eq 'stuk'">1</xsl:when>
         <xsl:when test="lower-case($ADAunit) eq 'dosis'">1</xsl:when>
         <xsl:when test="lower-case($ADAunit) eq 'tablet'">1</xsl:when>
         <xsl:when test="lower-case($ADAunit) = $ada-unit-druppel">[drp]</xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$ADAunit"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:replaceTDateString"
                 as="xs:string?">
      <!-- Converts a string like $T-12D (date T minus 12 days) to an actual date in a nice formatted string -->
      <xsl:param name="in"
                 as="xs:string?">
         <!-- Total input string potentially containing a string like $T-12D -->
      </xsl:param>
      <xsl:param name="inputDateT"
                 as="xs:date?">
         <!-- The input date T to be used. Optional, but nothing is converted if not given. -->
      </xsl:param>
      <xsl:choose>
         <xsl:when test="not(empty($inputDateT))">
            <xsl:variable name="tString"
                          select="replace($in, '.*?\$(T[+\-]\d+(\.\d+)?[YMD](\{([0|1]\d|2[0-3]):(0\d|[1-5]\d)(:(0\d|[1-5]\d))?\})?).*', '$1')"/>
            <xsl:variable name="newDateTime"
                          select="nf:calculate-t-date($tString, $inputDateT)"/>
            <xsl:variable name="formattedDateTime"
                          select="nf:datetime-2-timestring($newDateTime)"/>
            <!-- Fix me, this is wrong, only the tString should be replaced with proper date -->
            <xsl:value-of select="$tString"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$in"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
</xsl:stylesheet>