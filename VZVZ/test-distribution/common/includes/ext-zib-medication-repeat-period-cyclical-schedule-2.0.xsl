<?xml version="1.0" encoding="UTF-8"?>

<!-- == Flattened from: C:/Data/Erik/work/Nictiz/new/HL7-mappings/ada_2_fhir/zibs2017/payload/ext-zib-medication-repeat-period-cyclical-schedule-2.0.xsl == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <!--    <xsl:import href="../../fhir/2_fhir_fhir_include.xsl"/>-->
   <xd:doc>
      <xd:desc>Template for shared extension http://nictiz.nl/fhir/StructureDefinition/zib-Medication-RepeatPeriodCyclicalSchedule</xd:desc>
      <xd:param name="in">Optional. Ada element containing the repeat period</xd:param>
   </xd:doc>
   <xsl:template name="ext-zib-Medication-RepeatPeriodCyclicalSchedule-2.0"
                 match="*"
                 as="element()?"
                 mode="doExtZibMedicationRepeatPeriodCyclicalSchedule-2.0">
      <xsl:param name="in"
                 as="element()?"
                 select="."/>
      <!-- herhaalperiode cyclisch schema -->
      <xsl:for-each select="$in">
         <modifierExtension url="{$urlExtRepeatPeriodCyclical}">
            <valueDuration>
               <xsl:call-template name="hoeveelheid-to-Duration">
                  <xsl:with-param name="in"
                                  select="."/>
               </xsl:call-template>
            </valueDuration>
         </modifierExtension>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>