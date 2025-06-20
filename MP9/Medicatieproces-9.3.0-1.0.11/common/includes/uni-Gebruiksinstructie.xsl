<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/hl7-2-ada/env/zibs/2020/payload/uni-Gebruiksinstructie.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.11; 2025-06-19T11:36:53.19+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:util="urn:hl7:utilities"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:import href="fhir_2_ada_fhir_include-d570e126.xsl"/>
   <xsl:import href="mp-fhir2ada.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:variable name="urlExtRepeatPeriodCyclical"
                 as="xs:string*">
      <!-- zib 2017 version -->
      <xsl:value-of select="concat($urlBaseNictizProfile, 'zib-Medication-RepeatPeriodCyclicalSchedule')"/>
      <!-- zib 2020 version -->
      <xsl:value-of select="concat($urlBaseNictizProfile, 'ext-InstructionsForUse.RepeatPeriodCyclicalSchedule')"/>
   </xsl:variable>
   <!-- toedienschema -->
   <xsl:variable name="templateId-toedienschema"
                 as="xs:string*"
                 select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9359', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9319', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9309', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9149'"/>
   <xd:doc>
      <xd:desc> MP9 3.0 gebruiksperiode handling, including cancellation and criterium </xd:desc>
      <xd:param name="in">HL7 medicatiebouwsteen, typically MA of TA, defaults to context.</xd:param>
   </xd:doc>
   <xsl:template name="mp93-gebruiksperiode">
      <xsl:param name="in"
                 select="."
                 as="element()*"/>
      <xsl:for-each select="$in">
         <xsl:variable name="IVL_TS"
                       select="hl7:effectiveTime[resolve-QName(xs:string(@xsi:type), .) = QName('urn:hl7-org:v3', 'IVL_TS')]"/>
         <xsl:choose>
            <xsl:when test="$IVL_TS instance of element()">
               <xsl:call-template name="mp92-gebruiksperiode">
                  <xsl:with-param name="IVL_TS"
                                  select="($IVL_TS[hl7:low | hl7:width | hl7:high])[1]"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:when test="hl7:effectiveTime[@value]">
               <!-- timestamp, typically a cancellation, we should translate into both gebruiksperiode_start and gebruiksperiode_eind, which have the same value -->
               <gebruiksperiode>
                  <!-- gebruiksperiode_start -->
                  <xsl:call-template name="handleTS">
                     <xsl:with-param name="in"
                                     select="hl7:effectiveTime"/>
                     <xsl:with-param name="elemName">start_datum_tijd</xsl:with-param>
                     <xsl:with-param name="vagueDate"
                                     select="true()"/>
                     <xsl:with-param name="datatype">datetime</xsl:with-param>
                  </xsl:call-template>
                  <!-- gebruiksperiode_eind -->
                  <xsl:call-template name="handleTS">
                     <xsl:with-param name="in"
                                     select="hl7:effectiveTime"/>
                     <xsl:with-param name="elemName">eind_datum_tijd</xsl:with-param>
                     <xsl:with-param name="vagueDate"
                                     select="true()"/>
                     <xsl:with-param name="datatype">datetime</xsl:with-param>
                  </xsl:call-template>
                  <!-- criterium -->
                  <xsl:for-each select="hl7:precondition/hl7:criterion/hl7:text">
                     <criterium value="{text()}"/>
                  </xsl:for-each>
               </gebruiksperiode>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Handles usage period pattern from MP9 2.0 bouwstenen (based on zib2020)</xd:desc>
      <xd:param name="IVL_TS">The HL7 IVL_TS for the usage period</xd:param>
      <xd:param name="elemName">The ada element name to be outputted, defaults to gebruiksperiode</xd:param>
   </xd:doc>
   <xsl:template name="mp92-gebruiksperiode">
      <xsl:param name="IVL_TS"
                 as="element()?"
                 select="."/>
      <xsl:param name="elemName"
                 as="xs:string">gebruiksperiode</xsl:param>
      <!-- do not use the handlePQ template since the mp ada time unit does not comply to the assumptions in that template -->
      <xsl:for-each select="$IVL_TS[hl7:low | hl7:width | hl7:high]">
         <xsl:element name="{$elemName}">
            <!-- gebruiksperiode_start -->
            <xsl:call-template name="handleTS">
               <xsl:with-param name="in"
                               select="$IVL_TS/hl7:low"/>
               <xsl:with-param name="elemName">start_datum_tijd</xsl:with-param>
               <xsl:with-param name="vagueDate"
                               select="true()"/>
               <xsl:with-param name="datatype">datetime</xsl:with-param>
            </xsl:call-template>
            <!-- gebruiksperiode_eind -->
            <xsl:call-template name="handleTS">
               <xsl:with-param name="in"
                               select="$IVL_TS/hl7:high"/>
               <xsl:with-param name="elemName">eind_datum_tijd</xsl:with-param>
               <xsl:with-param name="vagueDate"
                               select="true()"/>
               <xsl:with-param name="datatype">datetime</xsl:with-param>
            </xsl:call-template>
            <!-- duur -->
            <xsl:for-each select="$IVL_TS/hl7:width[@value]">
               <tijds_duur>
                  <xsl:attribute name="value"
                                 select="@value"/>
                  <xsl:attribute name="unit"
                                 select="nf:convertTime_UCUM2ADA_unit(./@unit)"/>
               </tijds_duur>
            </xsl:for-each>
            <!-- criterium -->
            <xsl:for-each select="$IVL_TS/../hl7:precondition/hl7:criterion/hl7:text">
               <criterium value="{text()}"/>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Helper template for hl7 routeCode to ada toedieningsweg</xd:desc>
      <xd:param name="in">HL7 element routeCode. Optional, but no output without it. Defaults to context.</xd:param>
   </xd:doc>
   <xsl:template name="routeCode2toedieningsweg">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:for-each select="$in/hl7:routeCode">
         <xsl:call-template name="handleCV">
            <xsl:with-param name="elemName">toedieningsweg</xsl:with-param>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Helper template for toedieningsweg for MP 9</xd:desc>
      <xd:param name="inHl7">The HL7 element which contains the toedieningssnelheid, typically rateQuantity</xd:param>
   </xd:doc>
   <xsl:template name="toedieningssnelheid9">
      <xsl:param name="inHl7"
                 as="element()*"
                 select="."/>
      <xsl:for-each select="$inHl7">
         <toedieningssnelheid>
            <!-- MP-1535 toedieningssnelheid only exists of zib interval stuff from mp9 3.0-beta.4 -->
            <xsl:for-each select="hl7:low">
               <minimum_waarde value="{@value}"
                               unit="{@unit}"/>
            </xsl:for-each>
            <xsl:for-each select="hl7:center">
               <nominale_waarde value="{@value}"
                                unit="{@unit}"/>
            </xsl:for-each>
            <xsl:for-each select="hl7:high">
               <maximum_waarde value="{@value}"
                               unit="{@unit}"/>
            </xsl:for-each>
         </toedieningssnelheid>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>gebruiksinstructie mp9</xd:desc>
      <xd:param name="in">input hl7 component, such as the hl7 MA/TA/MGB/WDS</xd:param>
   </xd:doc>
   <xsl:template name="mp92-gebruiksinstructie-from-mp9"
                 match="hl7:*"
                 mode="HandleInstructionsforuse">
      <xsl:param name="in"
                 select="."/>
      <xsl:for-each select="$in">
         <!-- still can refactor with new generic functions -->
         <gebruiksinstructie>
            <!-- omschrijving -->
            <xsl:for-each select="hl7:text">
               <omschrijving value="{./text()}"/>
            </xsl:for-each>
            <!-- toedieningsweg -->
            <xsl:call-template name="routeCode2toedieningsweg"/>
            <!-- aanvullende_instructie -->
            <xsl:for-each select="hl7:entryRelationship/*[hl7:templateId/@root = '2.16.840.1.113883.2.4.3.11.60.20.77.10.9085']/hl7:code">
               <xsl:variable name="elemName"
                             select="'aanvullende_instructie'"/>
               <xsl:call-template name="handleCV">
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:variable name="hl7Doseerinstructie"
                          select="hl7:entryRelationship[hl7:substanceAdministration/hl7:templateId/@root = $templateId-toedienschema]"/>
            <!-- herhaalperiode_cyclisch_schema -->
            <!-- er mag er functioneel maar eentje zijn als er technisch herhaald is moet het identiek zijn, we nemen de eerste -->
            <xsl:for-each select="($hl7Doseerinstructie/hl7:substanceAdministration/f:effectiveTime/f:modifierExtension[@url = $urlExtRepeatPeriodCyclical])[1]/f:valueDuration">
               <xsl:call-template name="Duration-to-hoeveelheid">
                  <xsl:with-param name="adaElementName">herhaalperiode_cyclisch_schema</xsl:with-param>
               </xsl:call-template>
            </xsl:for-each>
            <!-- doseerinstructie -->
            <xsl:for-each select="$hl7Doseerinstructie">
               <doseerinstructie>
                  <!-- doseerduur -->
                  <xsl:for-each select="hl7:substanceAdministration/f:effectiveTime/f:repeat/f:boundsDuration">
                     <xsl:call-template name="Duration-to-hoeveelheid">
                        <xsl:with-param name="adaElementName">doseerduur</xsl:with-param>
                     </xsl:call-template>
                  </xsl:for-each>
                  <!-- volgnummer -->
                  <xsl:for-each select="hl7:sequenceNumber">
                     <xsl:call-template name="handleINT">
                        <xsl:with-param name="elemName">volgnummer</xsl:with-param>
                     </xsl:call-template>
                  </xsl:for-each>
                  <!-- dosering -->
                  <xsl:for-each select="hl7:substanceAdministration">
                     <xsl:variable name="elemName"
                                   select="'dosering'"/>
                     <dosering>
                        <!-- keerdosis -->
                        <xsl:for-each select="hl7:doseQuantity">
                           <keerdosis>
                              <!-- aantal -->
                              <aantal>
                                 <xsl:for-each select="hl7:low/hl7:translation[@codeSystem = $oidGStandaardBST902THES2]">
                                    <minimum_waarde value="{@value}"/>
                                 </xsl:for-each>
                                 <xsl:for-each select="hl7:center/hl7:translation[@codeSystem = $oidGStandaardBST902THES2]">
                                    <nominale_waarde value="{@value}"/>
                                 </xsl:for-each>
                                 <xsl:for-each select="hl7:high/hl7:translation[@codeSystem = $oidGStandaardBST902THES2]">
                                    <maximum_waarde value="{@value}"/>
                                 </xsl:for-each>
                              </aantal>
                              <xsl:for-each select="(*/hl7:translation[@codeSystem = $oidGStandaardBST902THES2])[1]">
                                 <eenheid>
                                    <xsl:call-template name="mp9-code-attribs">
                                       <xsl:with-param name="current-hl7-code"
                                                       select="."/>
                                    </xsl:call-template>
                                 </eenheid>
                              </xsl:for-each>
                           </keerdosis>
                        </xsl:for-each>
                        <xsl:call-template name="fhirRepeat2adaToedieningsschema">
                           <xsl:with-param name="in"
                                           select="f:effectiveTime/f:repeat"/>
                        </xsl:call-template>
                        <!-- zo nodig -->
                        <xsl:if test="(hl7:precondition/hl7:criterion/hl7:code | hl7:maxDoseQuantity)[.//(@code | @nullFlavor | @value | @unit)]">
                           <zo_nodig>
                              <xsl:for-each select="hl7:precondition/hl7:criterion/hl7:code">
                                 <!-- from mp9 3.0 beta.3 no more double nesting -->
                                 <!--                                            <criterium>-->
                                 <criterium>
                                    <xsl:call-template name="mp9-code-attribs">
                                       <xsl:with-param name="current-hl7-code"
                                                       select="."/>
                                    </xsl:call-template>
                                 </criterium>
                                 <!-- no use case for omschrijving, omschrijving is in code/@originalText -->
                                 <!--</criterium>-->
                              </xsl:for-each>
                              <xsl:for-each select="hl7:maxDoseQuantity[.//(@value | @unit)]">
                                 <maximale_dosering>
                                    <aantal value="{hl7:numerator/@value}"/>
                                    <xsl:for-each select="(hl7:numerator/hl7:translation[@codeSystem = $oidGStandaardBST902THES2])[1]">
                                       <eenheid>
                                          <xsl:call-template name="mp9-code-attribs">
                                             <xsl:with-param name="current-hl7-code"
                                                             select="."/>
                                          </xsl:call-template>
                                       </eenheid>
                                    </xsl:for-each>
                                    <xsl:for-each select="hl7:denominator[@value | @unit]">
                                       <tijdseenheid value="{@value}"
                                                     unit="{nf:convertTime_UCUM2ADA_unit(@unit)}"/>
                                    </xsl:for-each>
                                 </maximale_dosering>
                              </xsl:for-each>
                           </zo_nodig>
                        </xsl:if>
                        <!-- toedieningssnelheid -->
                        <xsl:call-template name="toedieningssnelheid9">
                           <xsl:with-param name="inHl7"
                                           select="hl7:rateQuantity"/>
                        </xsl:call-template>
                        <!-- toedieningsduur -->
                        <xsl:for-each select="f:effectiveTime/f:repeat[f:duration | f:durationUnit]">
                           <toedieningsduur>
                              <tijds_duur value="{f:duration/@value}"
                                          unit="{nf:convertTime_UCUM_FHIR2ADA_unit(f:durationUnit/@value)}"/>
                           </toedieningsduur>
                        </xsl:for-each>
                     </dosering>
                  </xsl:for-each>
               </doseerinstructie>
            </xsl:for-each>
         </gebruiksinstructie>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>