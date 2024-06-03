<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/YATC-internal/ada-2-fhir/env/zibs2017/payload/zib-allergyintolerance-2.1.xsl"?>
<?yatc-distribution-info name="VZVZ-MedMij" timestamp="2024-01-29T11:45:25.52+01:00" version="0.1"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/YATC-internal/ada-2-fhir/env/zibs2017/payload/zib-allergyintolerance-2.1.xsl == -->
<!-- == Distribution: VZVZ-MedMij; 0.1; 2024-01-29T11:45:25.52+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="urn:fhir:stu3:functions"
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
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="referById"
              as="xs:boolean"
              select="false()"/>
   <!-- ================================================================== -->
   <xsl:template name="allergyintoleranceReference"
                 match="(allergie_intolerantie | allergy_intolerance)[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)]"
                 mode="doAllergyIntoleranceReference-2.1">
      <!-- Returns contents of Reference datatype element -->
      <xsl:variable name="theIdentifier"
                    select="(identificatie_nummer | zibroot/identificatienummer | identification_number | hcimroot/identification_number)[@value]"/>
      <xsl:variable name="theGroupKey"
                    select="nf:getGroupingKeyDefault(.)"/>
      <xsl:variable name="theGroupElement"
                    select="$allergyIntolerances[group-key = $theGroupKey]"
                    as="element()?"/>
      <xsl:choose>
         <xsl:when test="$theGroupElement">
            <xsl:variable name="fullUrl"
                          select="nf:getFullUrlOrId(($theGroupElement/f:entry)[1])"/>
            <reference value="{$fullUrl}"/>
         </xsl:when>
         <xsl:when test="$theIdentifier">
            <identifier>
               <xsl:call-template name="id-to-Identifier">
                  <xsl:with-param name="in"
                                  select="($theIdentifier[not(@root = $mask-ids-var)], $theIdentifier)[1]"/>
               </xsl:call-template>
            </identifier>
         </xsl:when>
      </xsl:choose>
      <xsl:if test="string-length($theGroupElement/reference-display) gt 0">
         <display value="{$theGroupElement/reference-display}"/>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="allergyIntoleranceEntry"
                 match="(allergie_intolerantie | allergy_intolerance)[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)]"
                 mode="doAllergyIntoleranceEntry-2.1"
                 as="element(f:entry)">
      <!-- Produces a FHIR entry element with an AllergyIntolerance resource for AllergyIntolerance -->
      <xsl:param name="uuid"
                 select="false()"
                 as="xs:boolean">
         <!-- If true generate uuid from scratch. Defaults to false(). Generating a uuid from scratch limits reproduction of the same output as the uuids will be different every time. -->
      </xsl:param>
      <xsl:param name="adaPatient"
                 select="(ancestor::*/patient[*//@value] | ancestor::*/bundle/subject/patient[*//@value])[1]"
                 as="element()">
         <!-- Optional, but should be there. Patient this resource is for. -->
      </xsl:param>
      <xsl:param name="dateT"
                 as="xs:date?">
         <!-- Optional. dateT may be given for relative dates, only applicable for test instances -->
      </xsl:param>
      <xsl:param name="entryFullUrl">
         <!-- Optional. Value for the entry.fullUrl -->
         <xsl:choose>
            <xsl:when test="$uuid or empty(zibroot/identificatienummer | hcimroot/identification_number)">
               <xsl:value-of select="nf:get-fhir-uuid(.)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="nf:getUriFromAdaId(zibroot/identificatienummer | hcimroot/identification_number, 'AllergyIntolerance', false())"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:param>
      <xsl:param name="fhirResourceId">
         <!-- Optional. Value for the entry.resource.AllergyIntolerance.id -->
         <xsl:choose>
            <xsl:when test="$referById">
               <xsl:choose>
                  <xsl:when test="not($uuid) and string-length(nf:removeSpecialCharacters((zibroot/identificatienummer | hcimroot/identification_number)/@value)) gt 0">
                     <xsl:value-of select="nf:removeSpecialCharacters(string-join((zibroot/identificatienummer | hcimroot/identification_number)/@value, ''))"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="nf:removeSpecialCharacters(replace($entryFullUrl, 'urn:[^i]*id:', ''))"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:when test="matches($entryFullUrl, '^https?:')">
               <xsl:value-of select="tokenize($entryFullUrl, '/')[last()]"/>
            </xsl:when>
         </xsl:choose>
      </xsl:param>
      <xsl:param name="searchMode"
                 select="'include'">
         <!-- Optional. Value for entry.search.mode. Default: include -->
      </xsl:param>
      <entry>
         <fullUrl value="{$entryFullUrl}"/>
         <resource>
            <xsl:call-template name="zib-AllergyIntolerance-2.1">
               <xsl:with-param name="in"
                               select="."/>
               <xsl:with-param name="logicalId"
                               select="$fhirResourceId"/>
               <xsl:with-param name="adaPatient"
                               select="$adaPatient"
                               as="element()"/>
               <xsl:with-param name="dateT"
                               select="$dateT"/>
            </xsl:call-template>
         </resource>
         <xsl:if test="string-length($searchMode) gt 0">
            <search>
               <mode value="{$searchMode}"/>
            </search>
         </xsl:if>
      </entry>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="zib-AllergyIntolerance-2.1"
                 match="allergie_intolerantie | allergy_intolerance"
                 as="element()"
                 mode="doZibAllergyIntolerance-2.1">
      <!-- Mapping of HCIM AllergyIntolerance concept in ADA to FHIR resource zib-AllergyIntolerance. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- Node to consider in the creation of the AllergyIntolerance resource for AllergyIntolerance. -->
      </xsl:param>
      <xsl:param name="logicalId"
                 as="xs:string?">
         <!-- Optional FHIR logical id for the record. -->
      </xsl:param>
      <xsl:param name="adaPatient"
                 select="(ancestor::*/patient[*//@value] | ancestor::*/bundle/subject/patient[*//@value])[1]"
                 as="element()">
         <!-- Required. ADA patient concept to build a reference to from this resource -->
      </xsl:param>
      <xsl:param name="dateT"
                 as="xs:date?">
         <!-- Optional. dateT may be given for relative dates, only applicable for test instances -->
      </xsl:param>
      <xsl:variable name="patientRef"
                    as="element()*">
         <xsl:for-each select="$adaPatient">
            <xsl:call-template name="patientReference"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:for-each select="$in">
         <!-- NL-CM:8.2.1    AllergieIntolerantie -->
         <xsl:variable name="resource">
            <xsl:variable name="profileValue">http://nictiz.nl/fhir/StructureDefinition/zib-AllergyIntolerance</xsl:variable>
            <AllergyIntolerance>
               <xsl:if test="string-length($logicalId) gt 0">
                  <xsl:choose>
                     <xsl:when test="$referById">
                        <id value="{nf:make-fhir-logicalid(tokenize($profileValue, './')[last()], $logicalId)}"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <id value="{$logicalId}"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:if>
               <meta>
                  <profile value="{$profileValue}"/>
               </meta>
               <!-- text narrative 
                        https://decor.nictiz.nl/art-decor/decor-datasets-\-cio-?id=2.16.840.1.113883.2.4.3.11.60.26.1.1&effectiveDate=2019-07-01T11%3A11%3A01&conceptId=2.16.840.1.113883.2.4.3.11.60.26.2.277&conceptEffectiveDate=2019-10-01T17%3A42%3A12&language=nl-NL
                    -->
               <xsl:for-each select="omschrijving[@value]">
                  <text>
                     <status value="additional"/>
                     <div xmlns="http://www.w3.org/1999/xhtml">
                        <xsl:value-of select="@value"/>
                     </div>
                  </text>
               </xsl:for-each>
               <!-- identifier -->
               <xsl:for-each select="zibroot/identificatienummer | hcimroot/identification_number">
                  <identifier>
                     <xsl:call-template name="id-to-Identifier">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </identifier>
               </xsl:for-each>
               <!-- CD    NL-CM:8.2.5        AllergieStatus            0..1    AllergieStatusCodelijst -->
               <!-- http://hl7.org/fhir/STU3/valueset-allergy-clinical-status.html -->
               <!-- Conceptmap: https://simplifier.net/NictizSTU3-Zib2017/AllergieStatusCodelijst-to-allergy-status -->
               <xsl:for-each select="(allergie_status | allergy_status)[@code = ('active', 'completed', 'obsolete')]">
                  <!-- the display is required in FHIR/MedMij, but is not necessarily present in ada
                        especially when this was converted from HL7v3-->
                  <xsl:variable name="clinicalStatusValue">
                     <xsl:choose>
                        <xsl:when test="@code = 'active'">active</xsl:when>
                        <xsl:when test="@code = 'completed'">resolved</xsl:when>
                        <xsl:otherwise>inactive</xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <clinicalStatus>
                     <xsl:attribute name="value"
                                    select="$clinicalStatusValue"/>
                     <xsl:call-template name="ext-code-specification-1.0">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </clinicalStatus>
               </xsl:for-each>
               <!-- Conceptmap: https://simplifier.net/NictizSTU3-Zib2017/AllergieStatusCodelijst-to-allergy-status -->
               <!-- https://bits.nictiz.nl/browse/MM-2235 -->
               <xsl:variable name="allergyStatus"
                             select="(allergie_status | allergy_status)/@code"/>
               <verificationStatus>
                  <xsl:attribute name="value">
                     <xsl:choose>
                        <!-- zib compliant -->
                        <xsl:when test="$allergyStatus = ('nullified')">
                           <xsl:text>entered-in-error</xsl:text>
                        </xsl:when>
                        <xsl:when test="$allergyStatus = ('obsolete')">
                           <xsl:text>refuted</xsl:text>
                        </xsl:when>
                        <xsl:when test="$allergyStatus = ('active', 'completed')">
                           <xsl:text>confirmed</xsl:text>
                        </xsl:when>
                        <!-- valid ActStatus in V3 but not zib-compliant -->
                        <xsl:when test="$allergyStatus = ('cancelled')">
                           <xsl:text>entered-in-error</xsl:text>
                        </xsl:when>
                        <xsl:when test="$allergyStatus = ('aborted')">
                           <xsl:text>refuted</xsl:text>
                        </xsl:when>
                        <xsl:when test="$allergyStatus = ('normal', 'held', 'suspended')">
                           <xsl:text>confirmed</xsl:text>
                        </xsl:when>
                        <xsl:when test="$allergyStatus = ('new')">
                           <xsl:text>unconfirmed</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:text>confirmed</xsl:text>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
               </verificationStatus>
               <!-- CD    NL-CM:8.2.4        AllergieCategorie        0..1 AllergieCategorieCodelijst-->
               <!-- The ZIB prescribes an (optional) value list for the allergy category, which is mapped onto
                         AllergyIntolerance.category. However, .category defines its own required coding, which can't be
                         always translated from the zib value set. In case we can't make the translation, we have no other
                         option than to exclude .category altogether, even if it means we also exclude the ZIB value - we
                         can't produce a valid FHIR instance otherwise. -->
               <xsl:for-each select="(allergie_categorie | allergy_category)[@code]">
                  <xsl:variable name="fhirCategory">
                     <xsl:choose>
                        <!-- SEE https://bits.nictiz.nl/browse/MM-498 for the mapping discussion -->
                        <!-- Propensity to adverse reactions to food    418471000    SNOMED CT    2.16.840.1.113883.6.96    Voeding-->
                        <xsl:when test="@code = '418471000' and @codeSystem = $oidSNOMEDCT">food</xsl:when>
                        <!--Propensity to adverse reactions to drug    419511003    SNOMED CT    2.16.840.1.113883.6.96    Medicijn-->
                        <xsl:when test="@code = '419511003' and @codeSystem = $oidSNOMEDCT">medication</xsl:when>
                        <!--Environmental allergy    426232007    SNOMED CT    2.16.840.1.113883.6.96    Omgeving-->
                        <xsl:when test="@code = '426232007' and @codeSystem = $oidSNOMEDCT">environment</xsl:when>
                        <!--Allergy to substance    419199007    SNOMED CT    2.16.840.1.113883.6.96    Stof of product-->
                        <xsl:when test="@code = '419199007' and @codeSystem = $oidSNOMEDCT">biologic</xsl:when>
                        <xsl:when test="@codeSystem = $oidHL7NullFlavor"/>
                        <xsl:otherwise>
                           <xsl:call-template name="util:logMessage">
                              <xsl:with-param name="level"
                                              select="$logWARN"/>
                              <xsl:with-param name="msg">Unsupported AllergyIntolerance category code "
<xsl:value-of select="@code"/>" from system "
<xsl:value-of select="@codeSystem"/>"</xsl:with-param>
                           </xsl:call-template>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <!-- Make sure displayNames represent SNOMED CT. Move original displayName to originalText if it is not 'up to snuff', unless originalText already has a value? Seems overdoing it -->
                  <xsl:variable name="in"
                                as="element()">
                     <xsl:copy>
                        <xsl:copy-of select="@*"/>
                        <xsl:choose>
                           <!-- Propensity to adverse reactions to food    418471000    SNOMED CT    2.16.840.1.113883.6.96    Voeding-->
                           <xsl:when test="@code = '418471000' and @codeSystem = $oidSNOMEDCT">
                              <xsl:attribute name="displayName">neiging tot ongewenste reactie op voedsel</xsl:attribute>
                              <!--<xsl:if test="not(@originalText) and not(@displayName = 'neiging tot ongewenste reactie op voedsel')">
                                            <xsl:attribute name="originalText" select="@displayName"/>
                                        </xsl:if>-->
                           </xsl:when>
                           <!--Propensity to adverse reactions to drug    419511003    SNOMED CT    2.16.840.1.113883.6.96    Medicijn-->
                           <xsl:when test="@code = '419511003' and @codeSystem = $oidSNOMEDCT">
                              <xsl:attribute name="displayName">neiging tot ongewenste reactie op medicatie en/of drug</xsl:attribute>
                              <!--<xsl:if test="not(@originalText) and not(@displayName = 'neiging tot ongewenste reactie op medicatie en/of drug')">
                                            <xsl:attribute name="originalText" select="@displayName"/>
                                        </xsl:if>-->
                           </xsl:when>
                           <!--Environmental allergy    426232007    SNOMED CT    2.16.840.1.113883.6.96    Omgeving-->
                           <xsl:when test="@code = '426232007' and @codeSystem = $oidSNOMEDCT">
                              <xsl:attribute name="displayName">omgevingsgerelateerde allergie</xsl:attribute>
                              <!--<xsl:if test="not(@originalText) and not(@displayName = 'omgevingsgerelateerde allergie')">
                                            <xsl:attribute name="originalText" select="@displayName"/>
                                        </xsl:if>-->
                           </xsl:when>
                           <!--Allergy to substance    419199007    SNOMED CT    2.16.840.1.113883.6.96    Stof of product-->
                           <xsl:when test="@code = '419199007' and @codeSystem = $oidSNOMEDCT">
                              <xsl:attribute name="displayName">allergie voor substantie</xsl:attribute>
                              <!--<xsl:if test="not(@originalText) and not(@displayName = 'allergie voor substantie')">
                                            <xsl:attribute name="originalText" select="@displayName"/>
                                        </xsl:if>-->
                           </xsl:when>
                        </xsl:choose>
                     </xsl:copy>
                  </xsl:variable>
                  <!-- valueSet binding in FHIR is required, so only one of the four options in the valueSet is permitted, otherwise do not output category -->
                  <category>
                     <xsl:choose>
                        <xsl:when test="string-length($fhirCategory) gt 0">
                           <xsl:attribute name="value"
                                          select="$fhirCategory"/>
                        </xsl:when>
                        <xsl:when test="@codeSystem = $oidHL7NullFlavor">
                           <xsl:call-template name="NullFlavor-to-DataAbsentReason">
                              <xsl:with-param name="in"
                                              select="."/>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                           <!-- should not reach this, but better safe than sorry because we are missing a @value without dataAbsentReason -->
                           <extension url="{$urlExtHL7DataAbsentReason}">
                              <valueCode value="unknown"/>
                           </extension>
                        </xsl:otherwise>
                     </xsl:choose>
                     <!-- And now for the actual thing: -->
                     <xsl:call-template name="ext-code-specification-1.0">
                        <xsl:with-param name="in"
                                        select="$in"/>
                     </xsl:call-template>
                  </category>
               </xsl:for-each>
               <!-- CD    NL-CM:8.2.7        MateVanKritiekZijn        0..1 MateVanKritiekZijnCodelijst -->
               <!--http://hl7.org/fhir/STU3/valueset-allergy-intolerance-criticality.html-->
               <xsl:for-each select="(mate_van_kritiek_zijn | criticality)[@code]">
                  <!-- Make sure displayNames represent SNOMED CT. Move original displayName to originalText if it is not 'up to snuff', unless originalText already has a value? Seems overdoing it -->
                  <xsl:variable name="in"
                                as="element()">
                     <xsl:copy>
                        <xsl:copy-of select="@*"/>
                        <xsl:choose>
                           <!--Mild    255604002    SNOMED CT    2.16.840.1.113883.6.96    Licht-->
                           <xsl:when test="@code = '255604002' and @codeSystem = $oidSNOMEDCT">
                              <xsl:attribute name="displayName">licht</xsl:attribute>
                              <!--<xsl:if test="not(@originalText) and not(@displayName = 'licht')">
                                            <xsl:attribute name="originalText" select="@displayName"/>
                                        </xsl:if>-->
                           </xsl:when>
                           <!--Moderate    6736007    SNOMED CT    2.16.840.1.113883.6.96    Matig-->
                           <xsl:when test="@code = '6736007' and @codeSystem = $oidSNOMEDCT">
                              <xsl:attribute name="displayName">matig</xsl:attribute>
                              <!--<xsl:if test="not(@originalText) and not(@displayName = 'matig')">
                                            <xsl:attribute name="originalText" select="@displayName"/>
                                        </xsl:if>-->
                           </xsl:when>
                           <!--Severe    24484000    SNOMED CT    2.16.840.1.113883.6.96    Ernstig-->
                           <xsl:when test="@code = '24484000' and @codeSystem = $oidSNOMEDCT">
                              <xsl:attribute name="displayName">ernstig</xsl:attribute>
                              <!--<xsl:if test="not(@originalText) and not(@displayName = 'ernstig')">
                                            <xsl:attribute name="originalText" select="@displayName"/>
                                        </xsl:if>-->
                           </xsl:when>
                           <!--Fatal    399166001    SNOMED CT    2.16.840.1.113883.6.96    Fataal-->
                           <xsl:when test="@code = '399166001' and @codeSystem = $oidSNOMEDCT">
                              <xsl:attribute name="displayName">fataal</xsl:attribute>
                              <!--<xsl:if test="not(@originalText) and not(@displayName = 'fataal')">
                                            <xsl:attribute name="originalText" select="@displayName"/>
                                        </xsl:if>-->
                           </xsl:when>
                        </xsl:choose>
                     </xsl:copy>
                  </xsl:variable>
                  <criticality>
                     <xsl:attribute name="value">
                        <xsl:choose>
                           <!--Mild    255604002    SNOMED CT    2.16.840.1.113883.6.96    Licht-->
                           <xsl:when test="@code = '255604002' and @codeSystem = $oidSNOMEDCT">low</xsl:when>
                           <!--Moderate    6736007    SNOMED CT    2.16.840.1.113883.6.96    Matig-->
                           <xsl:when test="@code = '6736007' and @codeSystem = $oidSNOMEDCT">high</xsl:when>
                           <!--Severe    24484000    SNOMED CT    2.16.840.1.113883.6.96    Ernstig-->
                           <xsl:when test="@code = '24484000' and @codeSystem = $oidSNOMEDCT">high</xsl:when>
                           <!--Fatal    399166001    SNOMED CT    2.16.840.1.113883.6.96    Fataal-->
                           <xsl:when test="@code = '399166001' and @codeSystem = $oidSNOMEDCT">high</xsl:when>
                           <xsl:otherwise>
                              <xsl:call-template name="util:logMessage">
                                 <xsl:with-param name="level"
                                                 select="$logWARN"/>
                                 <xsl:with-param name="msg">Unsupported AllergyIntolerance criticality code "
<xsl:value-of select="@code"/>" codeSystem "
<xsl:value-of select="@codeSystem"/>"</xsl:with-param>
                              </xsl:call-template>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:attribute>
                     <xsl:call-template name="ext-code-specification-1.0">
                        <xsl:with-param name="in"
                                        select="$in"/>
                     </xsl:call-template>
                  </criticality>
               </xsl:for-each>
               <!-- CD    NL-CM:8.2.2        VeroorzakendeStof        1..1 VeroorzakendeStofAllergeneStoffenCodelijst, VeroorzakendeStofHPKCodelijst, VeroorzakendeStofSNKCodelijst, VeroorzakendeStofSSKCodelijst, VeroorzakendeStofThesaurus122Codelijst-->
               <!-- code is required in the FHIR profile, so always output code, data-absent-reason if no actual value -->
               <code>
                  <xsl:choose>
                     <xsl:when test="(veroorzakende_stof | causative_agent)[@code]">
                        <xsl:call-template name="code-to-CodeableConcept">
                           <xsl:with-param name="in"
                                           select="veroorzakende_stof | causative_agent"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <extension url="http://hl7.org/fhir/StructureDefinition/data-absent-reason">
                           <valueCode value="unknown"/>
                        </extension>
                     </xsl:otherwise>
                  </xsl:choose>
               </code>
               <!-- >     NL-CM:0.0.12    Onderwerp Patient via nl.zorg.part.basiselementen -->
               <!-- Patient reference -->
               <patient>
                  <xsl:apply-templates select="$adaPatient"
                                       mode="doPatientReference-2.1"/>
               </patient>
               <!-- TS    NL-CM:8.2.6        BeginDatumTijd            0..1    -->
               <!-- onsetDateTime -->
               <xsl:for-each select="(begin_datum_tijd | start_date_time)[@value]">
                  <onsetDateTime>
                     <xsl:attribute name="value">
                        <xsl:call-template name="format2FHIRDate">
                           <xsl:with-param name="dateTime"
                                           select="xs:string(@value)"/>
                           <xsl:with-param name="dateT"
                                           select="$dateT"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </onsetDateTime>
               </xsl:for-each>
               <!-- TS    NL-CM:0.0.14    DatumTijd    0..1-->
               <!-- assertedDate -->
               <xsl:for-each select="(zibroot/datum_tijd | hcimroot/date_time)[@value]">
                  <xsl:call-template name="util:logMessage">
                     <xsl:with-param name="level"
                                     select="$logWARN"/>
                     <xsl:with-param name="msg">In the zib-AllergyIntolerance profile the DateTime concept from the BasicElements (NL-CM:0.0.14) is mapped to .onsetDateTime instead of .assertedDate (following https://bits.nictiz.nl/browse/MM-616), but this stylesheet wasn't updated accordingly. Since this stylesheet is actively used (for instance in MP 6.12) this discrepancy will not be corrected.</xsl:with-param>
                     <xsl:with-param name="terminate">false</xsl:with-param>
                  </xsl:call-template>
                  <assertedDate>
                     <xsl:attribute name="value">
                        <xsl:call-template name="format2FHIRDate">
                           <xsl:with-param name="dateTime"
                                           select="xs:string(@value)"/>
                           <xsl:with-param name="dateT"
                                           select="$dateT"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </assertedDate>
               </xsl:for-each>
               <!-- >     NL-CM:0.0.7        Auteur via nl.zorg.part.basiselementen -->
               <!-- recorder -->
               <xsl:variable name="zibrootAuteur"
                             select="zibroot/auteur/((patient_als_auteur | patient_as_author)/patient | zorgverlener_als_auteur/zorgverlener | health_professional_as_author/health_professional | betrokkene_als_auteur/contactpersoon | related_person_as_author/contact_person)"/>
               <xsl:variable name="adaAuteur"
                             as="element()*">
                  <xsl:choose>
                     <xsl:when test="$zibrootAuteur/*">
                        <xsl:sequence select="$zibrootAuteur"/>
                     </xsl:when>
                     <xsl:when test="$zibrootAuteur[not(@datatype) or @datatype = 'reference'][@value]">
                        <xsl:sequence select="(ancestor::*[parent::data]//(zorgverlener | health_professional | patient | contactpersoon | contact_person)[@id = $zibrootAuteur/@value])[1]"/>
                     </xsl:when>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="authorRef"
                             as="element()*">
                  <xsl:for-each select="$adaAuteur[self::zorgverlener | self::health_professional]">
                     <xsl:call-template name="practitionerRoleReference">
                        <xsl:with-param name="useExtension"
                                        select="true()"/>
                        <xsl:with-param name="addDisplay"
                                        select="false()"/>
                     </xsl:call-template>
                     <xsl:apply-templates select="."
                                          mode="doPractitionerReference-2.0"/>
                  </xsl:for-each>
                  <xsl:for-each select="$adaAuteur[self::patient]">
                     <xsl:sequence select="$patientRef"/>
                  </xsl:for-each>
                  <xsl:for-each select="$adaAuteur[self::contactpersoon | self::contact_person]">
                     <xsl:call-template name="relatedPersonReference"/>
                  </xsl:for-each>
               </xsl:variable>
               <xsl:if test="$authorRef">
                  <recorder>
                     <xsl:copy-of select="$authorRef[self::f:extension]"/>
                     <xsl:copy-of select="$authorRef[self::f:reference]"/>
                     <xsl:copy-of select="$authorRef[self::f:identifier]"/>
                     <xsl:copy-of select="$authorRef[self::f:display]"/>
                  </recorder>
               </xsl:if>
               <!-- >     NL-CM:0.0.2        Informatiebron via nl.zorg.part.basiselementen -->
               <xsl:variable name="zibrootInformant"
                             select="(zibroot/informatiebron | hcimroot/information_source)/((patient_als_bron | patient_as_information_source)/patient | zorgverlener/zorgverlener | health_professional/health_professional | betrokkene_als_bron/contactpersoon | related_person_as_information_source/contact_person)"/>
               <xsl:variable name="adaInformant"
                             as="element()*">
                  <xsl:choose>
                     <xsl:when test="$zibrootInformant/*">
                        <xsl:sequence select="$zibrootInformant"/>
                     </xsl:when>
                     <xsl:when test="$zibrootInformant[not(@datatype) or @datatype = 'reference'][@value]">
                        <xsl:sequence select="(ancestor::*[parent::data]//(zorgverlener | health_professional | patient | contactpersoon | contact_person)[@id = $zibrootInformant/@value])[1]"/>
                     </xsl:when>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="informantRef"
                             as="element()*">
                  <xsl:for-each select="$adaInformant[self::zorgverlener | self::health_professional]">
                     <xsl:call-template name="practitionerRoleReference">
                        <xsl:with-param name="useExtension"
                                        select="true()"/>
                        <xsl:with-param name="addDisplay"
                                        select="false()"/>
                     </xsl:call-template>
                     <xsl:apply-templates select="."
                                          mode="doPractitionerReference-2.0"/>
                  </xsl:for-each>
                  <xsl:for-each select="$adaInformant[self::patient]">
                     <xsl:sequence select="$patientRef"/>
                  </xsl:for-each>
                  <xsl:for-each select="$adaInformant[self::contactpersoon | self::contact_person]">
                     <xsl:call-template name="relatedPersonReference"/>
                  </xsl:for-each>
               </xsl:variable>
               <xsl:if test="$informantRef">
                  <asserter>
                     <xsl:copy-of select="$informantRef[self::f:extension]"/>
                     <xsl:copy-of select="$informantRef[self::f:reference]"/>
                     <xsl:copy-of select="$informantRef[self::f:identifier]"/>
                     <xsl:copy-of select="$informantRef[self::f:display]"/>
                  </asserter>
               </xsl:if>
               <!-- TS    NL-CM:8.2.8        LaatsteReactieDatumTijd    0..1 -->
               <xsl:for-each select="(laatste_reactie_datum_tijd | last_reaction_date_time)[@value]">
                  <lastOccurrence>
                     <xsl:attribute name="value">
                        <xsl:call-template name="format2FHIRDate">
                           <xsl:with-param name="dateTime"
                                           select="xs:string(@value)"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </lastOccurrence>
               </xsl:for-each>
               <!-- ST    NL-CM:8.2.9        Toelichting                0..1 -->
               <xsl:for-each select="(toelichting | comment)[@value]">
                  <note>
                     <text>
                        <xsl:call-template name="string-to-string">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </text>
                  </note>
               </xsl:for-each>
               <!-- >    NL-CM:8.2.10    Reactie                    0..* -->
               <xsl:for-each select="(reactie | reaction)[.//@code | .//@value]">
                  <reaction>
                     <!--CD    NL-CM:8.2.12            SpecifiekeStof    0..1 SpecifiekeStofAllergeneStoffenCodelijst, SpecifiekeStofHPKCodelijst, SpecifiekeStofSNKCodelijst, SpecifiekeStofSSKCodelijst, SpecifiekeStofThesaurus122Codelijst-->
                     <xsl:for-each select="(specifieke_stof | specific_substance)[@code]">
                        <substance>
                           <xsl:call-template name="code-to-CodeableConcept">
                              <xsl:with-param name="in"
                                              select="."/>
                           </xsl:call-template>
                        </substance>
                     </xsl:for-each>
                     <!--CD    NL-CM:8.2.11            Symptoom    1..* SymptoomCodelijst-->
                     <xsl:for-each select="(symptoom | symptom)[@code]">
                        <manifestation>
                           <xsl:call-template name="code-to-CodeableConcept">
                              <xsl:with-param name="in"
                                              select="."/>
                           </xsl:call-template>
                        </manifestation>
                     </xsl:for-each>
                     <!--TS    NL-CM:8.2.13            ReactieBeschrijving    0..1-->
                     <xsl:for-each select="(reactie_beschrijving | reaction_description)[@value]">
                        <description>
                           <xsl:call-template name="string-to-string">
                              <xsl:with-param name="in"
                                              select="."/>
                           </xsl:call-template>
                        </description>
                     </xsl:for-each>
                     <!--TS    NL-CM:8.2.17            ReactieTijdstip    0..1-->
                     <xsl:for-each select="(reactie_tijdstip | reaction_time)[@value]">
                        <onset>
                           <xsl:attribute name="value">
                              <xsl:call-template name="format2FHIRDate">
                                 <xsl:with-param name="dateTime"
                                                 select="xs:string(@value)"/>
                              </xsl:call-template>
                           </xsl:attribute>
                        </onset>
                     </xsl:for-each>
                     <!--CD    NL-CM:8.2.14            Ernst    0..1 ErnstCodelijst-->
                     <!-- http://hl7.org/fhir/STU3/valueset-reaction-event-severity.html -->
                     <xsl:for-each select="(ernst | severity)[@code]">
                        <severity>
                           <xsl:attribute name="value">
                              <xsl:choose>
                                 <!--Mild    255604002    SNOMED CT    2.16.840.1.113883.6.96    Licht-->
                                 <xsl:when test="@code = '255604002' and @codeSystem = $oidSNOMEDCT">mild</xsl:when>
                                 <!--Moderate    6736007    SNOMED CT    2.16.840.1.113883.6.96    Matig-->
                                 <xsl:when test="@code = '6736007' and @codeSystem = $oidSNOMEDCT">moderate</xsl:when>
                                 <!--Severe    24484000    SNOMED CT    2.16.840.1.113883.6.96    Ernstig-->
                                 <xsl:when test="@code = '24484000' and @codeSystem = $oidSNOMEDCT">severe</xsl:when>
                                 <xsl:otherwise>
                                    <xsl:call-template name="util:logMessage">
                                       <xsl:with-param name="level"
                                                       select="$logWARN"/>
                                       <xsl:with-param name="msg">Unsupported AllergyIntolerance reaction severity "
<xsl:value-of select="@code"/>" codeSystem "
<xsl:value-of select="@codeSystem"/>"</xsl:with-param>
                                    </xsl:call-template>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:attribute>
                           <xsl:call-template name="ext-code-specification-1.0">
                              <xsl:with-param name="in"
                                              select="."/>
                           </xsl:call-template>
                        </severity>
                     </xsl:for-each>
                     <!--CD    NL-CM:8.2.15            WijzeVanBlootstelling    0..1 WijzeVanBlootstellingCodelijst-->
                     <xsl:for-each select="(wijze_van_blootstelling | route_of_exposure)[@code]">
                        <exposureRoute>
                           <xsl:call-template name="code-to-CodeableConcept">
                              <xsl:with-param name="in"
                                              select="."/>
                           </xsl:call-template>
                        </exposureRoute>
                     </xsl:for-each>
                  </reaction>
               </xsl:for-each>
            </AllergyIntolerance>
         </xsl:variable>
         <!-- Add resource.text -->
         <xsl:apply-templates select="$resource"
                              mode="addNarrative"/>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>