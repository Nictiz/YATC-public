<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/fhir_2_ada-r4/mp/9.3.0/payload/2.0.0-beta.2/mp-InstructionsForUse.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 1.0.0; 2024-04-17T17:00:31.15+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="urn:fhir:stu3:functions">
   <xsl:variable name="ext-InstructionsForUse-RepeatPeriodCyclicalSchedule">http://nictiz.nl/fhir/StructureDefinition/ext-InstructionsForUse.RepeatPeriodCyclicalSchedule</xsl:variable>
   <xsl:variable name="ext-RenderedDosageInstruction">http://nictiz.nl/fhir/StructureDefinition/ext-RenderedDosageInstruction</xsl:variable>
   <xsl:variable name="ext-iso21090-PQ-translation">http://hl7.org/fhir/StructureDefinition/iso21090-PQ-translation</xsl:variable>
   <xsl:variable name="extTimingExact">http://hl7.org/fhir/StructureDefinition/timing-exact</xsl:variable>
   <xd:doc>
      <xd:desc>Helper template to output ada gebruiksinstructie based on either f:dosage | f:dosageInstruction or just the f:extension[@url = 
<xd:ref name="ext-RenderedDosageInstruction"
                 type="variable"/>]</xd:desc>
      <xd:param name="in">The FHIR element containing dosage information. Defaults to context item.</xd:param>
   </xd:doc>
   <xsl:template name="mp-InstructionsForUse">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <xsl:for-each select="$in">
         <xsl:choose>
            <xsl:when test="f:dosage | f:dosageInstruction">
               <xsl:apply-templates select="f:dosage | f:dosageInstruction"
                                    mode="mp-InstructionsForUse"/>
            </xsl:when>
            <!-- only omschrijving -->
            <xsl:when test="f:extension[@url = $ext-RenderedDosageInstruction]">
               <gebruiksinstructie>
                  <xsl:apply-templates select="f:extension[@url = $ext-RenderedDosageInstruction]"
                                       mode="mp-InstructionsForUse"/>
               </gebruiksinstructie>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:dosageInstruction or f:dosage to ADA gebruiksinstructie. Multiple following f:dosage(Instruction) siblings are merged into one gebruiksinstructie.</xd:desc>
   </xd:doc>
   <xsl:template match="f:dosageInstruction | f:dosage"
                 mode="mp-InstructionsForUse">
      <xsl:if test="not(preceding-sibling::*[self::f:dosageInstruction] or preceding-sibling::*[self::f:dosage])">
         <gebruiksinstructie>
            <!-- omschrijving -->
            <xsl:apply-templates select="../f:extension[@url = $ext-RenderedDosageInstruction]"
                                 mode="#current"/>
            <!-- toedieningsweg -->
            <xsl:if test="f:route">
               <xsl:apply-templates select="f:route"
                                    mode="#current"/>
            </xsl:if>
            <xsl:if test="not(f:route)">
               <xsl:variable name="nullFlavorDisplayName"
                             select="$hl7NullFlavorMap[@hl7NullFlavor = 'NI']/@displayName"/>
               <xsl:element name="toedieningsweg">
                  <xsl:call-template name="Coding-to-code">
                     <xsl:with-param name="in"
                                     as="element()">
                        <f:coding>
                           <f:system value="{$oidHL7NullFlavor}"/>
                           <f:code value="NI"/>
                           <f:display value="{$nullFlavorDisplayName}"/>
                        </f:coding>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:element>
            </xsl:if>
            <!-- aanvullende_instructie -->
            <xsl:apply-templates select="f:additionalInstruction"
                                 mode="#current"/>
            <!-- TODO, check for MA herhaalperiode_cyclisch_schema -->
            <xsl:apply-templates select="parent::f:*/f:modifierExtension[@url = $ext-InstructionsForUse-RepeatPeriodCyclicalSchedule]"
                                 mode="#current"/>
            <!-- AWE: ideally we make this a bit more smart, dosageInstructions with same sequence/usePeriod may be translated in one doseerinstructie in ada -->
            <xsl:for-each select="(. | following-sibling::*[self::f:dosageInstruction or self::f:dosage])">
               <xsl:if test="f:sequence | f:asNeededCodeableConcept | f:doseAndRate | f:timing | f:asNeededCodeableConcept | f:maxDosePerPeriod">
                  <!-- doseerinstructie -->
                  <doseerinstructie>
                     <!-- doseerduur -->
                     <xsl:apply-templates select="f:timing/f:repeat/f:boundsDuration"
                                          mode="#current"/>
                     <!-- volgnummer -->
                     <xsl:apply-templates select="f:sequence"
                                          mode="#current"/>
                     <!-- dosering -->
                     <dosering>
                        <!-- keerdosis -->
                        <xsl:if test="f:doseAndRate/(f:doseQuantity | f:doseRange)">
                           <keerdosis>
                              <xsl:apply-templates select="f:doseAndRate/f:doseQuantity"
                                                   mode="#current"/>
                              <xsl:apply-templates select="f:doseAndRate/f:doseRange"
                                                   mode="#current"/>
                           </keerdosis>
                        </xsl:if>
                        <!-- toedieningsschema -->
                        <xsl:apply-templates select="f:timing"
                                             mode="#current"/>
                        <!-- zo_nodig -->
                        <xsl:if test="f:asNeededCodeableConcept | f:maxDosePerPeriod">
                           <zo_nodig>
                              <!-- criterium -->
                              <xsl:apply-templates select="f:asNeededCodeableConcept"
                                                   mode="#current"/>
                              <!-- maximale_dosering -->
                              <xsl:apply-templates select="f:maxDosePerPeriod"
                                                   mode="#current"/>
                           </zo_nodig>
                        </xsl:if>
                        <!-- toedieningssnelheid -->
                        <xsl:if test="f:doseAndRate/(f:rateRatio | f:rateRange | f:rateQuantity)">
                           <toedieningssnelheid>
                              <!-- waarde -->
                              <!-- eenheid -->
                              <!-- MP-1390 / ZIB-815 tijdseenheid no longer supported from MP9.3 beta version. See nl-core-InstructionsForUse for the older version.
                                                f:rateRatio is not mapped in mp-InstructionsForUse therefore also not supported and commented out-->
                              <!--  <xsl:apply-templates select="f:doseAndRate/f:rateRatio" mode="#current"/>-->
                              <xsl:apply-templates select="f:doseAndRate/f:rateRange"
                                                   mode="#current"/>
                              <xsl:apply-templates select="f:doseAndRate/f:rateQuantity"
                                                   mode="#current"/>
                           </toedieningssnelheid>
                        </xsl:if>
                        <!-- toedieningsduur -->
                        <xsl:apply-templates select="f:timing/f:repeat/f:duration"
                                             mode="#current"/>
                     </dosering>
                  </doseerinstructie>
               </xsl:if>
            </xsl:for-each>
         </gebruiksinstructie>
      </xsl:if>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:extension[@url=$ext-RenderedDosageInstruction] to omschrijving</xd:desc>
   </xd:doc>
   <xsl:template match="f:extension[@url = $ext-RenderedDosageInstruction]"
                 mode="mp-InstructionsForUse">
      <omschrijving value="{f:valueString/@value}"/>
      <xsl:if test="not(./following-sibling::f:dosageInstruction)">
         <xsl:variable name="nullFlavorDisplayName"
                       select="$hl7NullFlavorMap[@hl7NullFlavor = 'NI']/@displayName"/>
         <xsl:element name="toedieningsweg">
            <xsl:call-template name="Coding-to-code">
               <xsl:with-param name="in"
                               as="element()">
                  <f:coding>
                     <f:system value="{$oidHL7NullFlavor}"/>
                     <f:code value="NI"/>
                     <f:display value="{$nullFlavorDisplayName}"/>
                  </f:coding>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:element>
      </xsl:if>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:additionalInstruction to aanvullende_instructie</xd:desc>
   </xd:doc>
   <xsl:template match="f:additionalInstruction"
                 mode="mp-InstructionsForUse">
      <xsl:call-template name="CodeableConcept-to-code">
         <xsl:with-param name="in"
                         select="."/>
         <xsl:with-param name="originalText"
                         select="f:text/@value"/>
         <xsl:with-param name="adaElementName"
                         select="'aanvullende_instructie'"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:modifierExtension zib-Medication-RepeatPeriodCyclicalSchedule to herhaalperiode_cyclisch_schema</xd:desc>
   </xd:doc>
   <xsl:template match="f:modifierExtension[@url = $ext-InstructionsForUse-RepeatPeriodCyclicalSchedule]"
                 mode="mp-InstructionsForUse">
      <xsl:call-template name="Duration-to-hoeveelheid">
         <xsl:with-param name="in"
                         select="f:valueDuration"/>
         <xsl:with-param name="adaElementName">herhaalperiode_cyclisch_schema</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:route to toedieningsweg</xd:desc>
   </xd:doc>
   <xsl:template match="f:route"
                 mode="mp-InstructionsForUse">
      <xsl:call-template name="CodeableConcept-to-code">
         <xsl:with-param name="in"
                         select="."/>
         <xsl:with-param name="adaElementName">toedieningsweg</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:sequence to volgnummer</xd:desc>
   </xd:doc>
   <xsl:template match="f:sequence"
                 mode="mp-InstructionsForUse">
      <volgnummer value="{@value}"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:boundsDuration to doseerduur</xd:desc>
   </xd:doc>
   <xsl:template match="f:boundsDuration"
                 mode="mp-InstructionsForUse">
      <xsl:call-template name="Duration-to-hoeveelheid">
         <xsl:with-param name="adaElementName">doseerduur</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert FHIR element of type G-standaard (Simple)Quantity to ada aantal (with nominale_waarde child) and eenheid element.</xd:desc>
   </xd:doc>
   <xsl:template match="f:doseQuantity | f:extension[@url = $urlExtMedicationAdministration2AgreedAmount]/f:valueQuantity"
                 mode="mp-InstructionsForUse">
      <xsl:for-each select="f:extension[@url = $ext-iso21090-PQ-translation]/f:valueQuantity[contains(f:system/@value, $oidGStandaardBST902THES2)]">
         <aantal>
            <nominale_waarde value="{f:value/@value}"/>
         </aantal>
         <eenheid code="{f:code/@value}"
                  displayName="{f:unit/@value}"
                  codeSystem="{$oidGStandaardBST902THES2}"
                  codeSystemName="{$oidMap[@oid=$oidGStandaardBST902THES2]/@displayName}"/>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:doseRange to aantal (with min and max children) and eenheid elements.</xd:desc>
   </xd:doc>
   <xsl:template match="f:doseRange"
                 mode="mp-InstructionsForUse">
      <xsl:if test="*/f:extension[@url = $ext-iso21090-PQ-translation]">
         <aantal>
            <xsl:for-each select="f:low/f:extension[@url = $ext-iso21090-PQ-translation]/f:valueQuantity[contains(f:system/@value, $oidGStandaardBST902THES2)]">
               <minimum_waarde value="{f:value/@value}"/>
            </xsl:for-each>
            <xsl:for-each select="f:high/f:extension[@url = $ext-iso21090-PQ-translation]/f:valueQuantity[contains(f:system/@value, $oidGStandaardBST902THES2)]">
               <maximum_waarde value="{f:value/@value}"/>
            </xsl:for-each>
         </aantal>
         <xsl:for-each select="(*/f:extension[@url = $ext-iso21090-PQ-translation]/f:valueQuantity[contains(f:system/@value, $oidGStandaardBST902THES2)])[1]">
            <eenheid code="{f:code/@value}"
                     displayName="{f:unit/@value}"
                     codeSystem="{$oidGStandaardBST902THES2}"
                     codeSystemName="{$oidMap[@oid=$oidGStandaardBST902THES2]/@displayName}"/>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:timing to toedieningsschema</xd:desc>
   </xd:doc>
   <xsl:template match="f:timing"
                 mode="mp-InstructionsForUse">
      <toedieningsschema>
         <xsl:apply-templates select="f:repeat"
                              mode="#current"/>
      </toedieningsschema>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:repeat to frequentie and other siblings</xd:desc>
   </xd:doc>
   <xsl:template match="f:repeat"
                 mode="mp-InstructionsForUse">
      <xsl:variable name="isInterval"
                    as="xs:boolean"
                    select="(f:frequency | f:period | f:periodUnit) and f:extension[@url = $extTimingExact]/f:valueBoolean[@value = 'true']"/>
      <!-- frequentie -->
      <xsl:if test="(f:frequency | f:frequencyMax | f:period | f:periodUnit) and not(f:extension[@url = $extTimingExact]/f:valueBoolean[@value = 'true'])">
         <frequentie>
            <!-- aantal -->
            <aantal>
               <!-- min -->
               <!-- vaste_waarde -->
               <xsl:apply-templates select="f:frequency"
                                    mode="#current"/>
               <!-- max -->
               <xsl:apply-templates select="f:frequencyMax"
                                    mode="#current"/>
            </aantal>
            <xsl:if test="f:period | f:periodUnit">
               <!-- tijdseenheid -->
               <tijdseenheid>
                  <xsl:apply-templates select="f:period"
                                       mode="#current"/>
                  <xsl:apply-templates select="f:periodUnit"
                                       mode="#current"/>
               </tijdseenheid>
            </xsl:if>
         </frequentie>
      </xsl:if>
      <!-- weekdag -->
      <xsl:apply-templates select="f:dayOfWeek"
                           mode="#current"/>
      <!-- dagdeel -->
      <xsl:apply-templates select="f:when"
                           mode="#current"/>
      <!-- toedientijd -->
      <xsl:apply-templates select="f:timeOfDay"
                           mode="#current"/>
      <!-- is_flexibel -->
      <xsl:for-each select="f:extension[not($isInterval)][@url = $extTimingExact]/f:valueBoolean">
         <!-- timing exact has reverse boolean logic with is_flexibel -->
         <is_flexibel>
            <xsl:choose>
               <xsl:when test="f:extension/@url = $urlExtHL7NullFlavor">
                  <xsl:attribute name="nullFlavor"
                                 select="f:extension[@url = $urlExtHL7NullFlavor]/f:valueCode/@value"/>
               </xsl:when>
               <xsl:when test="@value">
                  <xsl:attribute name="value"
                                 select="not(@value = 'true')"/>
               </xsl:when>
            </xsl:choose>
         </is_flexibel>
      </xsl:for-each>
      <!-- interval -->
      <xsl:if test="$isInterval">
         <!-- interval, assumption is that if present f:frequency = 1, maybe raise error of do division if not ... TODO -->
         <interval>
            <xsl:apply-templates select="f:period"
                                 mode="#current"/>
            <xsl:apply-templates select="f:periodUnit"
                                 mode="#current"/>
         </interval>
      </xsl:if>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:duration to toedieningsduur</xd:desc>
   </xd:doc>
   <xsl:template match="f:duration"
                 mode="mp-InstructionsForUse">
      <toedieningsduur>
         <tijds_duur value="{@value}"
                     unit="{nf:convertTime_UCUM_FHIR2ADA_unit(following-sibling::f:durationUnit/@value)}"/>
      </toedieningsduur>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:frequency to either min or vaste_waarde</xd:desc>
   </xd:doc>
   <xsl:template match="f:frequency"
                 mode="mp-InstructionsForUse">
      <xsl:choose>
         <xsl:when test="following-sibling::f:frequencyMax">
            <minimum_waarde value="{@value}"/>
         </xsl:when>
         <xsl:otherwise>
            <nominale_waarde value="{@value}"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:frequencyMax to max</xd:desc>
   </xd:doc>
   <xsl:template match="f:frequencyMax"
                 mode="mp-InstructionsForUse">
      <maximum_waarde value="{@value}"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:periodUnit to @unit attribute</xd:desc>
   </xd:doc>
   <xsl:template match="f:periodUnit"
                 mode="mp-InstructionsForUse">
      <xsl:attribute name="unit"
                     select="nf:convertTime_UCUM_FHIR2ADA_unit(@value)"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:period to @value attribute</xd:desc>
   </xd:doc>
   <xsl:template match="f:period"
                 mode="mp-InstructionsForUse">
      <xsl:attribute name="value"
                     select="@value"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:timeOfDay to toedientijd</xd:desc>
   </xd:doc>
   <xsl:template match="f:timeOfDay"
                 mode="mp-InstructionsForUse">
      <!-- TODO add isFlexible stuff with extension for timing exact -->
      <toedientijd>
         <xsl:variable name="value">
            <xsl:choose>
               <xsl:when test="nf:add-Amsterdam-timezone-to-dateTimeString(@value) castable as xs:dateTime">
                  <xsl:value-of select="format-dateTime(xs:dateTime(nf:add-Amsterdam-timezone-to-dateTimeString(@value)), '[H01]:[m01]:[s01]')"/>
               </xsl:when>
               <xsl:when test="nf:add-Amsterdam-timezone-to-dateTimeString(@value) castable as xs:time">
                  <xsl:value-of select="format-time(xs:time(nf:add-Amsterdam-timezone-to-dateTimeString(@value)), '[H01]:[m01]:[s01]')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="@value"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:attribute name="value"
                        select="$value"/>
         <xsl:attribute name="datatype">time</xsl:attribute>
      </toedientijd>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:dayOfWeek to weekdag</xd:desc>
   </xd:doc>
   <xsl:template match="f:dayOfWeek"
                 mode="mp-InstructionsForUse">
      <weekdag>
         <xsl:call-template name="code-to-code">
            <xsl:with-param name="value"
                            select="@value"/>
            <xsl:with-param name="codeMap"
                            as="element()*">
               <map inValue="mon"
                    code="307145004"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="maandag"/>
               <map inValue="tue"
                    code="307147007"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="dinsdag"/>
               <map inValue="wed"
                    code="307148002"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="woensdag"/>
               <map inValue="thu"
                    code="307149005"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="donderdag"/>
               <map inValue="fri"
                    code="307150005"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="vrijdag"/>
               <map inValue="sat"
                    code="307151009"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="zaterdag"/>
               <map inValue="sun"
                    code="307146003"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="zondag"/>
            </xsl:with-param>
         </xsl:call-template>
      </weekdag>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:when to dagdeel</xd:desc>
   </xd:doc>
   <xsl:template match="f:when"
                 mode="mp-InstructionsForUse">
      <dagdeel>
         <xsl:call-template name="code-to-code">
            <xsl:with-param name="value"
                            select="@value"/>
            <xsl:with-param name="codeMap"
                            as="element()*">
               <map inValue="MORN"
                    code="73775008"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="'s ochtends"/>
               <map inValue="AFT"
                    code="255213009"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="'s middags"/>
               <map inValue="EVE"
                    code="3157002"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="'s avonds"/>
               <map inValue="NIGHT"
                    code="2546009"
                    codeSystem="2.16.840.1.113883.6.96"
                    displayName="'s nachts"/>
            </xsl:with-param>
         </xsl:call-template>
      </dagdeel>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:asNeededCodeableConcept to criterium with code and omschrijving children</xd:desc>
   </xd:doc>
   <xsl:template match="f:asNeededCodeableConcept"
                 mode="mp-InstructionsForUse">
      <criterium>
         <xsl:call-template name="CodeableConcept-to-code">
            <xsl:with-param name="adaElementName">criterium</xsl:with-param>
         </xsl:call-template>
         <!-- criterium heeft een ./omschrijving als uitzondering. -->
         <xsl:if test="f:text/@value">
            <omschrijving value="{f:text/@value}"/>
         </xsl:if>
      </criterium>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:maxDosePerPeriod to maximale_dosering with aantal and eenheid children</xd:desc>
   </xd:doc>
   <xsl:template match="f:maxDosePerPeriod"
                 mode="mp-InstructionsForUse">
      <maximale_dosering>
         <xsl:call-template name="GstdQuantity2ada">
            <xsl:with-param name="in"
                            select="f:numerator"/>
         </xsl:call-template>
         <xsl:call-template name="Duration-to-hoeveelheid">
            <xsl:with-param name="in"
                            select="f:denominator"/>
         </xsl:call-template>
      </maximale_dosering>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:rateRatio to waarde (with vaste_waarde child), eenheid and tijdseenheid</xd:desc>
   </xd:doc>
   <xsl:template match="f:rateRatio"
                 mode="mp-InstructionsForUse">
      <xsl:call-template name="Ratio-to-quotient">
         <xsl:with-param name="withRange"
                         select="true()"/>
         <xsl:with-param name="adaWaarde">waarde</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:rateRange to waarde (with min and max children) and eenheid </xd:desc>
   </xd:doc>
   <!-- MP-1367 / ZIB-815 tijdseenheid no longer a part of toedieningssnelheid from MP9.3 beta and eenheid is NOT in Gstd anymore but UCUM-->
   <xsl:template match="f:rateRange"
                 mode="mp-InstructionsForUse">
      <xsl:variable name="code">
         <xsl:choose>
            <xsl:when test="(*/f:code/@value)[1] = (*/f:code/@value)[2]">
               <xsl:value-of select="(*/f:code/@value)[1]"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <waarde>
         <minimum_waarde value="{f:low/f:value/@value}"/>
         <maximum_waarde value="{f:high/f:value/@value}"/>
      </waarde>
      <eenheid code="{$code}"
               codeSystem="{(*/f:system/@value)[1]}"
               codeSystemName="{local:getDisplayName($oidUCUM)}"
               displayName="{(*/f:unit/@value)[1]}"/>
   </xsl:template>
   <xd:doc>
      <xd:desc>Template to convert f:rateQuantity to waarde (with nominale_waarde child) and eenheid</xd:desc>
   </xd:doc>
   <!-- MP-1367 / ZIB-815 tijdseenheid no longer a part of toedieningssnelheid from MP9.3 beta and eenheid is NOT in Gstd anymore but UCUM-->
   <xsl:template match="f:rateQuantity"
                 mode="mp-InstructionsForUse">
      <waarde>
         <nominale_waarde value="{f:value/@value}"/>
      </waarde>
      <eenheid code="{f:code/@value}"
               codeSystem="{f:system/@value}"
               codeSystemName="{local:getDisplayName($oidUCUM)}"
               displayName="{f:unit/@value}"/>
   </xsl:template>
</xsl:stylesheet>