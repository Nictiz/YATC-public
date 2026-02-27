<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/hl7-2-ada/env/mp/9.3.0/test_instances/payload/6.12_2_beschikbaarstellen_medicatiegegevens_hl7_2_ada.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.12; 2026-02-27T13:57:54.56+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:util="urn:hl7:utilities"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:local="#local.202412041518439035630100"
                xmlns:pharm="urn:ihe:pharm:medication"
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
   <xsl:import href="../../6.12_2_beschikbaarstellen_medicatiegegevens/payload/6.12_2_beschikbaarstellen_medicatiegegevens_hl7_2_ada.xsl"/>
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:param name="deduplicateAdaBouwstenen"
              as="xs:boolean?"
              select="true()"/>
   <xsl:variable name="logLevel"
                 select="$logDEBUG"/>
   <xsl:variable name="transactionName"
                 select="'beschikbaarstellen_medicatiegegevens'"/>
   <xsl:variable name="transactionOid"
                 select="'2.16.840.1.113883.2.4.3.11.60.20.77.4.301'"/>
   <xsl:variable name="transactionEffectiveDate"
                 as="xs:dateTime"
                 select="xs:dateTime('2022-02-07T00:00:00')"/>
   <xsl:variable name="adaFormname"
                 select="'medicatiegegevens'"/>
   <xsl:variable name="mpVersion"
                 select="'mp93'"/>
   <!-- ================================================================== -->
   <!-- override this template, because for the testinstances we want a verstrekking as well to make roundtrip testing possible -->
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.110_20130521000000_2_MP93">
      <!--  Medication Dispense Event 6.12  -->
      <xsl:param name="current-dispense-event"
                 select="."/>
      <xsl:param name="transaction"
                 select="$transactionName">
         <!-- Which transaction is the context of this translation. Currently known: beschikbaarstellen_medicatiegegevens or beschikbaarstellen_verstrekkingenvertaling  -->
      </xsl:param>
      <medicamenteuze_behandeling>
         <!-- mbh id is not known in 6.12. We fake it using https://bits.nictiz.nl/browse/MP-572 -->
         <xsl:variable name="PRK"
                       select="(hl7:product/hl7:dispensedMedication/hl7:MedicationKind/(hl7:code | hl7:code/hl7:translation)[@codeSystem = $oidGStandaardPRK][@code])[1]"/>
         <xsl:variable name="HPK"
                       select="(hl7:product/hl7:dispensedMedication/hl7:MedicationKind/(hl7:code | hl7:code/hl7:translation)[@codeSystem = $oidGStandaardHPK][@code])[1]"/>
         <identificatie>
            <xsl:choose>
               <xsl:when test="$PRK">
                  <xsl:attribute name="value"
                                 select="$PRK/@code"/>
                  <xsl:attribute name="root"
                                 select="$genericMBHidPRK"/>
               </xsl:when>
               <xsl:when test="$HPK">
                  <xsl:attribute name="value"
                                 select="$HPK/@code"/>
                  <xsl:attribute name="root"
                                 select="$genericMBHidHPK"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="value"
                                 select="$current-dispense-event/hl7:id/@extension"/>
                  <xsl:attribute name="root"
                                 select="concat($concatOidMBH, $current-dispense-event/hl7:id/@root)"/>
               </xsl:otherwise>
            </xsl:choose>
         </identificatie>
         <xsl:call-template name="mp9-toedieningsafspraak-from-mp612-MP93">
            <xsl:with-param name="current-dispense-event"
                            select="$current-dispense-event"/>
            <xsl:with-param name="transaction"
                            select="$transaction"/>
         </xsl:call-template>
         <!-- this is the override bit, the rest should be the same -->
         <xsl:call-template name="mp9-verstrekking-from-mp612">
            <xsl:with-param name="current-hl7-verstrekking"
                            select="$current-dispense-event"/>
            <xsl:with-param name="transaction"
                            select="$transaction"/>
         </xsl:call-template>
      </medicamenteuze_behandeling>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <!-- override of mp9-verstrekking-from-mp612 for MP9 3.0 -->
   <xsl:template name="mp9-verstrekking-from-mp612">
      <xsl:param name="current-hl7-verstrekking"
                 select="."/>
      <xsl:param name="transaction"
                 select="$transactionName"/>
      <xsl:for-each select="$current-hl7-verstrekking">
         <medicatieverstrekking>
            <!-- identificatie -->
            <xsl:for-each select="hl7:id[@extension]">
               <identificatie root="{@root}"
                              value="{@extension}"/>
            </xsl:for-each>
            <!-- 6.12 heeft geen echte verstrekkingsdatum -->
            <!-- we need a nullFlavor since this element is required -->
            <medicatieverstrekkings_datum_tijd nullFlavor="NI"/>
            <!-- 6.12 heeft de aanschrijfdatum -->
            <xsl:for-each select="hl7:effectiveTime[@value]">
               <aanschrijfdatum value="{nf:formatHL72VagueAdaDate(@value, nf:determine_date_precision(@value))}"/>
            </xsl:for-each>
            <!-- verstrekker -->
            <xsl:for-each select="hl7:responsibleParty/hl7:assignedCareProvider/hl7:representedOrganization">
               <verstrekker>
                  <xsl:call-template name="mp9-zorgaanbieder">
                     <xsl:with-param name="hl7-current-organization"
                                     select="."/>
                  </xsl:call-template>
               </verstrekker>
            </xsl:for-each>
            <!-- verstrekte_hoeveelheid -->
            <xsl:for-each select="hl7:quantity/hl7:translation[@codeSystem = $oidGStandaardBST902THES2]">
               <verstrekte_hoeveelheid>
                  <aantal value="{@value}"/>
                  <eenheid>
                     <xsl:call-template name="mp9-code-attribs">
                        <xsl:with-param name="current-hl7-code"
                                        select="."/>
                     </xsl:call-template>
                  </eenheid>
               </verstrekte_hoeveelheid>
            </xsl:for-each>
            <!-- verstrekt_geneesmiddel -->
            <xsl:for-each select=".//hl7:product/hl7:dispensedMedication/hl7:MedicationKind">
               <verstrekt_geneesmiddel>
                  <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.106_20130521000000-MP920">
                     <xsl:with-param name="product-hl7"
                                     select="."/>
                  </xsl:call-template>
               </verstrekt_geneesmiddel>
            </xsl:for-each>
            <!-- verbruiksduur -->
            <xsl:for-each select="hl7:expectedUseTime/hl7:width">
               <verbruiksduur value="{@value}"
                              unit="{nf:convertTime_UCUM2ADA_unit(./@unit)}"/>
            </xsl:for-each>
            <!-- afleverlocatie -->
            <xsl:for-each select="hl7:destination/hl7:serviceDeliveryLocation">
               <afleverlocatie value="{normalize-space(.)}"/>
            </xsl:for-each>
            <!-- distributievorm, aanvullende_informatie, toelichting, relatie_naar_verstrekkingsverzoek 
               not in mp 6.12 verstrekking, no output -->
         </medicatieverstrekking>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>