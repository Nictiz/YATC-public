<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-shared/xsl/util/mp-fhir2ada.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
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
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <!-- Create ada toedieningsschema based on FHIR repeat element. In use by both HL7v3 and FHIR messages and therefore in YATC-shared -->
   <xsl:template name="fhirRepeat2adaToedieningsschema"
                 match="f:repeat"
                 mode="fhirRepeat2adaToedieningsschema">
      <xsl:param name="in"
                 as="element(f:repeat)?"/>
      <xsl:for-each select="$in[*[not(self::f:boundsDuration | self::f:duration | self::f:durationUnit | self::modifierExtension[@url = $urlExtRepeatPeriodCyclical])]]">
         <!-- toedieningsschema, create for f:repeat if it has stuf other then doseerduur / toedieningsduur / herhaalperiode_cyclisch_schema -->
         <!-- determine whether to output frequentie or interval or neither -->
         <xsl:variable name="outputFreqInt"
                       as="xs:string">
            <xsl:choose>
               <xsl:when test="(f:frequency[@value = '1'] or not(f:frequency[@value])) and not((f:frequencyMax | f:dayOfWeek | f:timeOfDay | f:when)[@value]) and f:period and f:periodUnit and f:extension[@url = $urlTimingExact]/f:valueBoolean/@value = 'true'">interval</xsl:when>
               <xsl:when test="f:period[@value]">frequentie</xsl:when>
               <xsl:otherwise>geen</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <toedieningsschema>
            <xsl:if test="$outputFreqInt = 'frequentie'">
               <frequentie>
                  <xsl:choose>
                     <xsl:when test="not(f:frequency[@value]) and not(f:frequencyMax[@value])">
                        <!-- if there is no frequency(Max), don't output aantal -->
                     </xsl:when>
                     <xsl:otherwise>
                        <aantal>
                           <xsl:if test="f:frequencyMax[@value] and f:frequency[@value]">
                              <minimum_waarde value="{f:frequency/@value}"/>
                           </xsl:if>
                           <xsl:if test="not(f:frequencyMax[@value]) and f:frequency[@value]">
                              <nominale_waarde value="{f:frequency/@value}"/>
                           </xsl:if>
                           <xsl:if test="f:frequencyMax[@value]">
                              <maximum_waarde value="{f:frequencyMax/@value}"/>
                           </xsl:if>
                           <!-- if there is not frequency(Max), assume 1 -->
                           <xsl:if test="not(f:frequency[@value]) and not(f:frequencyMax[@value])">
                              <nominale_waarde value="1"/>
                           </xsl:if>
                        </aantal>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="(f:period | f:periodUnit)[@value]">
                     <tijdseenheid value="{f:period/@value}"
                                   unit="{nf:convertTime_UCUM_FHIR2ADA_unit(f:periodUnit/@value)}"/>
                  </xsl:if>
               </frequentie>
            </xsl:if>
            <!-- weekdag -->
            <xsl:for-each select="f:dayOfWeek[@value]">
               <xsl:for-each select="$weekdayMap[@fhirDayOfWeek = current()/@value]">
                  <weekdag code="{@code}"
                           displayName="{@displayName}"
                           codeSystem="{@codeSystem}"/>
               </xsl:for-each>
            </xsl:for-each>
            <!-- dagdeel -->
            <xsl:for-each select="f:when[@value]">
               <xsl:for-each select="$daypartMap[@fhirWhen = current()/@value]">
                  <dagdeel code="{@code}"
                           displayName="{@displayName}"
                           codeSystem="{@codeSystem}"/>
               </xsl:for-each>
            </xsl:for-each>
            <!-- toedientijd -->
            <xsl:for-each select="f:timeOfDay[@value]">
               <toedientijd value="{@value}"
                            datatype="time"/>
            </xsl:for-each>
            <!-- is_flexibel -->
            <xsl:for-each select="f:extension[@url = $urlTimingExact]/f:valueBoolean">
               <is_flexibel value="{not(@value='true')}"/>
            </xsl:for-each>
            <!-- interval -->
            <xsl:if test="$outputFreqInt = 'interval'">
               <interval value="{f:period/@value}"
                         unit="{nf:convertTime_UCUM_FHIR2ADA_unit(f:periodUnit/@value)}"/>
            </xsl:if>
            <!-- finally simply copy the FHIR Timing element as is present in the HL7v3 message -->
            <adaextension>
               <!-- MP-1965: due to an obscure Saxon 9.7 bug we prefer to not use copy-of here, however sequence works fine -->
               <xsl:sequence select=".."/>
            </adaextension>
         </toedieningsschema>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
</xsl:stylesheet>