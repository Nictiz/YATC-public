<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-shared/xsl/util/mp-functions-fhir.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.3.0; 2024-04-09T18:20:47.77+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:nwf="http://www.nictiz.nl/wiki-functions"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="#local.2024020614533847069920100"
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
   <xsl:import href="mp-functions-d788e398.xsl"/>
   <!-- this import should be commented out here, as the import must be chosen in the calling xslt -->
   <!-- give dateT a value when you need conversion of relative T dates, typically only needed for test instances -->
   <!--    <xsl:param name="dateT" as="xs:date?" select="current-date()"/>-->
   <xsl:param name="dateT"
              as="xs:date?"/>
   <!-- ================================================================== -->
   <xsl:template name="adaToedieningsschema2FhirTimingContents"
                 match="toedieningsschema"
                 mode="adaToedieningsschema2FhirTimingContents">
      <!-- Create contents of FHIR timing based on ada toedieningsschema -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- ada element toedieningsschema to be handled, optional but no output if empty, defaults to context -->
      </xsl:param>
      <xsl:param name="inDoseerduur"
                 as="element()?"
                 select="$in/../../doseerduur">
         <!-- the ada element for doseerduur, optional, defaults to $in/../../doseerduur -->
      </xsl:param>
      <xsl:param name="inToedieningsduur"
                 as="element()?"
                 select="$in/../toedieningsduur">
         <!-- the ada element for toedieningsduur, optional, defaults to $in/../toedieningsduur -->
      </xsl:param>
      <xsl:param name="inHerhaalperiodeCyclischschema"
                 as="element()?">
         <!-- the ada element for Herhaalperiode Cyclisch schema. Optional. 
            Does not default, because the extension is not on timing level in normal FHIR resources, but it is on timing level when used in CDA.
            Only fill this parameter here when you need the extension on timing level.
         -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:if test="$inDoseerduur or $inToedieningsduur or .//*[@value or @code]">
            <xsl:for-each select="$inHerhaalperiodeCyclischschema">
               <xsl:call-template name="ext-zib-Medication-RepeatPeriodCyclicalSchedule-2.0">
                  <xsl:with-param name="in"
                                  select="."/>
               </xsl:call-template>
            </xsl:for-each>
            <repeat xmlns="http://hl7.org/fhir">
               <!-- exact / is_flexibel -->
               <xsl:for-each select="is_flexibel[@value | @nullFlavor]">
                  <extension url="http://hl7.org/fhir/StructureDefinition/timing-exact">
                     <valueBoolean>
                        <xsl:choose>
                           <xsl:when test="@value">
                              <xsl:attribute name="value"
                                             select="@value = 'false'"/>
                           </xsl:when>
                           <xsl:when test="@nullFlavor">
                              <extension url="{$urlExtHL7NullFlavor}">
                                 <valueCode value="{@nullFlavor}"/>
                              </extension>
                           </xsl:when>
                        </xsl:choose>
                     </valueBoolean>
                  </extension>
               </xsl:for-each>
               <xsl:if test="not(is_flexibel[@value | @nullFlavor]) and interval[@value | @unit]">
                  <!-- interval is not flexible -->
                  <extension url="http://hl7.org/fhir/StructureDefinition/timing-exact">
                     <valueBoolean value="true"/>
                  </extension>
               </xsl:if>
               <!-- doseerduur -->
               <xsl:for-each select="$inDoseerduur[@value]">
                  <boundsDuration>
                     <xsl:call-template name="hoeveelheid-to-Duration">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </boundsDuration>
               </xsl:for-each>
               <!-- toedieningsduur -->
               <xsl:for-each select="($inToedieningsduur[@value | @unit] | $inToedieningsduur/tijds_duur[@value | @unit])">
                  <duration value="{@value}"/>
                  <durationUnit value="{nf:convertTime_ADA_unit2UCUM_FHIR(@unit)}"/>
               </xsl:for-each>
               <!-- frequentie -->
               <xsl:for-each select="frequentie/aantal/(vaste_waarde | min | nominale_waarde | minimum_waarde)[@value]">
                  <frequency value="{@value}"/>
               </xsl:for-each>
               <xsl:for-each select="frequentie/aantal/(max | maximum_waarde)[@value]">
                  <frequencyMax value="{@value}"/>
               </xsl:for-each>
               <!-- frequentie/tijdseenheid -->
               <xsl:for-each select="frequentie/tijdseenheid">
                  <period value="{@value}"/>
                  <periodUnit value="{nf:convertTime_ADA_unit2UCUM_FHIR(@unit)}"/>
               </xsl:for-each>
               <!-- interval -->
               <xsl:for-each select="interval">
                  <!-- FHIR states: If no frequency is stated, the assumption is that the event occurs once per period, but systems SHOULD always be specific about this -->
                  <!-- so let's be specific -->
                  <frequency value="1"/>
                  <period value="{@value}"/>
                  <periodUnit value="{nf:convertTime_ADA_unit2UCUM_FHIR(@unit)}"/>
               </xsl:for-each>
               <!-- weekdag -->
               <xsl:for-each select="weekdag">
                  <dayOfWeek>
                     <xsl:attribute name="value">
                        <xsl:value-of select="$weekdayMap[@code = current()/@code][@codeSystem = current()/@codeSystem]/@fhirDayOfWeek"/>
                     </xsl:attribute>
                  </dayOfWeek>
               </xsl:for-each>
               <!-- toedientijd -->
               <xsl:for-each select="toedientijd[@value]">
                  <xsl:choose>
                     <xsl:when test="nf:add-Amsterdam-timezone-to-dateTimeString(@value) castable as xs:dateTime">
                        <timeOfDay value="{format-dateTime(xs:dateTime(nf:add-Amsterdam-timezone-to-dateTimeString(@value)), '[H01]:[m01]:[s01]')}"/>
                     </xsl:when>
                     <xsl:when test="nf:add-Amsterdam-timezone-to-dateTimeString(@value) castable as xs:time">
                        <timeOfDay value="{format-time(xs:time(nf:add-Amsterdam-timezone-to-dateTimeString(@value)), '[H01]:[m01]:[s01]')}"/>
                     </xsl:when>
                     <!-- not a dateTime or Time as input, let's check for an ada T date -->
                     <xsl:when test="nf:calculate-t-date(@value, xs:date('1970-01-01')) castable as xs:dateTime">
                        <!-- ada T date as input (T+0D{08:00:00}), lets convert it to a proper dateTime using date 1 Jan 1970, 
                                        this date is not relevant for toedientijd -->
                        <timeOfDay value="{format-dateTime(xs:dateTime(nf:calculate-t-date(@value, xs:date('1970-01-01'))), '[H01]:[m01]:[s01]')}"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <!-- Should not happen, let's at least make it visible and output the unexpected ada value in FHIR timeOfDay -->
                        <!-- Will most likely cause invalid FHIR, but at least that will be noticed -->
                        <timeOfDay value="{@value}"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
               <!-- dagdeel -->
               <xsl:for-each select="dagdeel[@code][not(@codeSystem = $oidHL7NullFlavor)]">
                  <when>
                     <xsl:attribute name="value">
                        <xsl:value-of select="$daypartMap[@code = current()/@code][@codeSystem = current()/@codeSystem]/@fhirWhen"/>
                     </xsl:attribute>
                  </when>
               </xsl:for-each>
            </repeat>
         </xsl:if>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="adaDoseerinstructie2FhirTimingContents"
                 match="doseerinstructie"
                 mode="adaDoseerinstructie2FhirTimingContents">
      <!-- Create contents of FHIR timing based on ada doseerinstructie. Sometimes the doseerinstructie does not have a toedieningsschema, 
            but you still need it for a pause period in a cyclic schedule, so for elements herhaalperiode_cyclisch_schema and doseerduur. 
            Possibly there is a toedieningsduur without a schedule, which is strange, but oh well, sometimes people do strange things. Who are we to judge? -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- ada element doseerinstructie to be handled, optional but no output if empty, defaults to context -->
      </xsl:param>
      <xsl:param name="inHerhaalperiodeCyclischschema"
                 as="element()?">
         <!-- the ada element for Herhaalperiode Cyclisch schema. Optional. 
            Does not default, because the extension is not on timing level in normal FHIR resources, but it is on timing level when used in CDA.
            Only fill this parameter here when you need the extension on timing level.
         -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:variable name="theToedienschema"
                       as="element()?">
            <xsl:choose>
               <xsl:when test="dosering/toedieningsschema[.//(@value | @unit | @code | @nullFlavor)]">
                  <xsl:sequence select="dosering/toedieningsschema"/>
               </xsl:when>
               <xsl:otherwise>
                  <!-- fake input toedieningsschema, but we need the other elements and want to re-use the existing template -->
                  <toedieningsschema/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:call-template name="adaToedieningsschema2FhirTimingContents">
            <xsl:with-param name="in"
                            select="$theToedienschema"/>
            <xsl:with-param name="inHerhaalperiodeCyclischschema"
                            select="$inHerhaalperiodeCyclischschema"/>
            <xsl:with-param name="inDoseerduur"
                            select="$in/doseerduur"/>
            <xsl:with-param name="inToedieningsduur"
                            select="$in/dosering/toedieningsduur"/>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>