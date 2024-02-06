<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/YATC-internal/ada-2-fhir/env/mp/2_fhir_mp91_include.xsl"?>
<?yatc-distribution-info name="VZVZ-MedMij" timestamp="2024-02-06T09:13:30.86+01:00" version="0.2"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/YATC-internal/ada-2-fhir/env/mp/2_fhir_mp91_include.xsl == -->
<!-- == Distribution: VZVZ-MedMij; 0.2; 2024-02-06T09:13:30.86+01:00 == -->
<xsl:stylesheet version="2.0"
                exclude-result-prefixes="#all"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="#local.2023103109525968639960100">
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
   <xsl:import href="package-1.3.10.xsl"/>
   <!-- ======================================================================= -->
   <xsl:param name="referById"
              as="xs:boolean"
              select="false()"/>
   <!-- pass an appropriate macAddress to ensure uniqueness of the UUID -->
   <!-- 02-00-00-00-00-00 may not be used in a production situation -->
   <xsl:param name="macAddress">02-00-00-00-00-00</xsl:param>
   <!-- ======================================================================= -->
   <xsl:variable name="gstd-coderingen">
      <code rootoid="{$oidGStandaardGPK}"
            xmlns="http://hl7.org/fhir"/>
      <code rootoid="{$oidGStandaardHPK}"
            xmlns="http://hl7.org/fhir"/>
      <code rootoid="{$oidGStandaardPRK}"
            xmlns="http://hl7.org/fhir"/>
      <code rootoid="{$oidGStandaardZInummer}"
            xmlns="http://hl7.org/fhir"/>
   </xsl:variable>
   <xsl:variable name="products"
                 as="element()*">
      <!-- Products -->
      <xsl:for-each-group select="//product"
                          group-by="nf:getProductGroupingKey(./product_code)">
         <xsl:for-each-group select="current-group()"
                             group-by="nf:getGroupingKeyDefault(.)">
            <!-- uuid als fullUrl en ook een fhir id genereren vanaf de tweede groep -->
            <xsl:variable name="uuid"
                          as="xs:boolean"
                          select="position() &gt; 1"/>
            <xsl:variable name="most-specific-product-code"
                          select="nf:get-specific-productcode(product_code)[@code][not(@codeSystem = $oidHL7NullFlavor)]"
                          as="element(product_code)?"/>
            <xsl:variable name="productCodeAsId"
                          as="element()?">
               <product_code value="{$most-specific-product-code/@code}"
                             root="{$most-specific-product-code/@codeSystem}"
                             xmlns="http://hl7.org/fhir"/>
            </xsl:variable>
            <xsl:variable name="entryFullUrl">
               <xsl:choose>
                  <xsl:when test="not($uuid) and $most-specific-product-code">
                     <xsl:value-of select="nf:getUriFromAdaId($productCodeAsId, 'Medication', false())"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="nf:get-fhir-uuid(.)"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="fhirResourceId">
               <xsl:choose>
                  <xsl:when test="$uuid">
                     <xsl:value-of select="nf:removeSpecialCharacters(replace($entryFullUrl, 'urn:[^i]*id:', ''))"/>
                  </xsl:when>
                  <xsl:when test="$referById and $most-specific-product-code">
                     <xsl:value-of select="nf:removeSpecialCharacters(concat($most-specific-product-code/@codeSystem, '-', $most-specific-product-code/@code))"/>
                  </xsl:when>
                  <xsl:when test="$referById and ./product_specificatie/product_naam/@value">
                     <xsl:value-of select="upper-case(nf:removeSpecialCharacters(./product_specificatie/product_naam/@value))"/>
                  </xsl:when>
                  <xsl:when test="$referById">
                     <!-- should not happen, but let's fall back on the grouping-key() -->
                     <xsl:value-of select="nf:removeSpecialCharacters(current-grouping-key())"/>
                  </xsl:when>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="searchMode">include</xsl:variable>
            <uniek-product>
               <group-key>
                  <xsl:value-of select="current-grouping-key()"/>
               </group-key>
               <reference-display>
                  <xsl:choose>
                     <xsl:when test="$most-specific-product-code[@displayName]">
                        <xsl:value-of select="($most-specific-product-code/@displayName)[1]"/>
                     </xsl:when>
                     <xsl:when test="product_specificatie/product_naam/@value">
                        <xsl:value-of select="product_specificatie/product_naam/@value"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <!-- should not happen, but let's fall back on the grouping-key() -->
                        <xsl:value-of select="nf:removeSpecialCharacters(current-grouping-key())"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </reference-display>
               <xsl:variable name="searchMode"
                             as="xs:string">include</xsl:variable>
               <entry xmlns="http://hl7.org/fhir">
                  <fullUrl value="{$entryFullUrl}"/>
                  <resource>
                     <xsl:call-template name="zib-Product">
                        <xsl:with-param name="in"
                                        select="."/>
                        <xsl:with-param name="medication-id"
                                        select="$fhirResourceId"/>
                     </xsl:call-template>
                  </resource>
                  <xsl:if test="string-length($searchMode) gt 0">
                     <search>
                        <mode value="{$searchMode}"/>
                     </search>
                  </xsl:if>
               </entry>
            </uniek-product>
         </xsl:for-each-group>
      </xsl:for-each-group>
   </xsl:variable>
   <xsl:variable name="locations"
                 as="element()*">
      <!-- Locaties -->
      <xsl:for-each-group select="//afleverlocatie"
                          group-by="nf:getGroupingKeyDefault(.)">
         <unieke-locatie>
            <group-key>
               <xsl:value-of select="current-grouping-key()"/>
            </group-key>
            <xsl:for-each select="current-group()[1]">
               <xsl:variable name="searchMode"
                             as="xs:string">include</xsl:variable>
               <entry xmlns="http://hl7.org/fhir">
                  <fullUrl value="{nf:get-fhir-uuid(.)}"/>
                  <resource>
                     <xsl:choose>
                        <xsl:when test="$referById">
                           <xsl:call-template name="zib-Dispense-Location-2.0">
                              <xsl:with-param name="ada-locatie"
                                              select="."/>
                              <xsl:with-param name="location-id"
                                              select="nf:removeSpecialCharacters(current-grouping-key())"/>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:call-template name="zib-Dispense-Location-2.0">
                              <xsl:with-param name="ada-locatie"
                                              select="."/>
                           </xsl:call-template>
                        </xsl:otherwise>
                     </xsl:choose>
                  </resource>
                  <xsl:if test="string-length($searchMode) gt 0">
                     <search>
                        <mode value="{$searchMode}"/>
                     </search>
                  </xsl:if>
               </entry>
            </xsl:for-each>
         </unieke-locatie>
      </xsl:for-each-group>
   </xsl:variable>
   <xsl:variable name="bouwstenen-910"
                 as="element(f:entry)*">
      <xsl:variable name="searchMode"
                    as="xs:string">match</xsl:variable>
      <!-- medicatieafspraken -->
      <xsl:for-each select="//medicatieafspraak">
         <!-- entry for MedicationRequest -->
         <xsl:call-template name="MedicationAgreementEntry-3.0">
            <xsl:with-param name="searchMode"
                            select="$searchMode"/>
         </xsl:call-template>
      </xsl:for-each>
      <!-- verstrekkingsverzoeken -->
      <xsl:for-each select="//verstrekkingsverzoek">
         <entry xmlns="http://hl7.org/fhir">
            <fullUrl value="{nf:getUriFromAdaId(./identificatie)}"/>
            <resource>
               <xsl:call-template name="zib-DispenseRequest-2.2">
                  <xsl:with-param name="verstrekkingsverzoek"
                                  select="."/>
               </xsl:call-template>
            </resource>
            <xsl:if test="string-length($searchMode) gt 0">
               <search>
                  <mode value="{$searchMode}"/>
               </search>
            </xsl:if>
         </entry>
      </xsl:for-each>
      <!-- toedieningsafspraken -->
      <xsl:for-each select="//toedieningsafspraak">
         <entry xmlns="http://hl7.org/fhir">
            <fullUrl value="{nf:getUriFromAdaId(./identificatie)}"/>
            <resource>
               <xsl:call-template name="zib-AdministrationAgreement-3.0">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="resource-id"
                                  select="                                 if ($referById) then                                     nf:removeSpecialCharacters(./identificatie/@value)                                 else                                     ()"/>
               </xsl:call-template>
            </resource>
            <xsl:if test="string-length($searchMode) gt 0">
               <search>
                  <mode value="{$searchMode}"/>
               </search>
            </xsl:if>
         </entry>
      </xsl:for-each>
      <!-- verstrekkingen -->
      <xsl:for-each select="//verstrekking">
         <entry xmlns="http://hl7.org/fhir">
            <fullUrl value="{nf:getUriFromAdaId(./identificatie)}"/>
            <resource>
               <xsl:call-template name="zib-Dispense-2.0">
                  <xsl:with-param name="verstrekking"
                                  select="."/>
                  <xsl:with-param name="medicationdispense-id"
                                  select="                                 if ($referById) then                                     nf:removeSpecialCharacters(./identificatie/@value)                                 else                                     ()"/>
               </xsl:call-template>
            </resource>
            <xsl:if test="string-length($searchMode) gt 0">
               <search>
                  <mode value="{$searchMode}"/>
               </search>
            </xsl:if>
         </entry>
      </xsl:for-each>
      <!-- medicatie_gebruik -->
      <xsl:for-each select="//medicatie_gebruik">
         <!-- entry for MedicationRequest -->
         <xsl:call-template name="MedicationUseEntry-3.0">
            <xsl:with-param name="searchMode"
                            select="$searchMode"/>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:variable>
   <xsl:variable name="bouwstenen-verstrekkingenvertaling"
                 as="element(f:entry)*">
      <xsl:variable name="searchMode"
                    as="xs:string">match</xsl:variable>
      <!-- toedieningsafspraken -->
      <xsl:for-each select="//toedieningsafspraak">
         <entry xmlns="http://hl7.org/fhir">
            <fullUrl value="{nf:get-fhir-uuid(.)}"/>
            <resource>
               <xsl:call-template name="mp612dispensetofhirconversionadministrationagreement-1.0.0">
                  <xsl:with-param name="toedieningsafspraak"
                                  select="."/>
                  <!-- there may be only one toedieningsafspraak per MBH, so if there is no identification we fall back on MBH id
                        with an appended string, since it may not be the same as the verstrekking id-->
                  <xsl:with-param name="medicationdispense-id"
                                  select="                                 if ($referById) then                                     (if (string-length(nf:removeSpecialCharacters(identificatie/@value)) gt 0) then                                         nf:removeSpecialCharacters(identificatie/@value)                                     else                                         (if (string-length(nf:removeSpecialCharacters(../identificatie/@value)) gt 0) then                                             nf:removeSpecialCharacters(../identificatie/@value)                                         else                                             uuid:get-uuid(.)))                                 else                                     ()">
                  </xsl:with-param>
               </xsl:call-template>
            </resource>
            <xsl:if test="string-length($searchMode) gt 0">
               <search>
                  <mode value="{$searchMode}"/>
               </search>
            </xsl:if>
         </entry>
      </xsl:for-each>
      <!-- verstrekkingen -->
      <xsl:for-each select="//verstrekking">
         <entry xmlns="http://hl7.org/fhir">
            <fullUrl value="{nf:getUriFromAdaId(./identificatie)}"/>
            <resource>
               <xsl:call-template name="mp612dispensetofhirconversiondispense-1.0.0">
                  <xsl:with-param name="verstrekking"
                                  select="."/>
                  <xsl:with-param name="medicationdispense-id"
                                  select="                                 if ($referById) then                                     nf:removeSpecialCharacters(./identificatie/@value)                                 else                                     ()"/>
               </xsl:call-template>
            </resource>
            <xsl:if test="string-length($searchMode) gt 0">
               <search>
                  <mode value="{$searchMode}"/>
               </search>
            </xsl:if>
         </entry>
      </xsl:for-each>
   </xsl:variable>
   <!--    <xsl:template name="mbh-id-2-reference">-->
   <!-- ================================================================== -->
   <xsl:template name="ext-zib-medication-medication-treatment-2.0">
      <xsl:param name="in"
                 as="element()?"/>
      <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-Medication-MedicationTreatment"
                 xmlns="http://hl7.org/fhir">
         <valueIdentifier>
            <xsl:call-template name="id-to-Identifier">
               <xsl:with-param name="in"
                               select="."/>
            </xsl:call-template>
         </valueIdentifier>
      </extension>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="organization-612-1.0">
      <!-- Template for FHIR profile nl-core-organization-2.0 -->
      <xsl:param name="ada-zorgaanbieder"
                 as="element()?">
         <!-- ada element zorgaanbieder -->
      </xsl:param>
      <xsl:param name="logicalId"
                 as="xs:string?">
         <!-- optional technical FHIR logicalId to be used as resource.id -->
      </xsl:param>
      <xsl:for-each select="$ada-zorgaanbieder">
         <Organization xmlns="http://hl7.org/fhir">
            <xsl:for-each select="$logicalId">
               <id value="{.}"/>
            </xsl:for-each>
            <meta>
               <profile value="http://nictiz.nl/fhir/StructureDefinition/mp612-DispenseToFHIRConversion-Organization"/>
            </meta>
            <xsl:call-template name="organization-payload"/>
         </Organization>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="organization-payload">
      <!-- Helper template for organization payload independent of version (6.12 or nl-core). -->
      <!-- There was a name change to zorgaanbieder_identificatienummer in the zib which was adopted by MP 9.0.7, 
                     zorgaanbieder_identificatie_nummer is still here for backwards compatibility with 9.0.6 and before -->
      <xsl:for-each select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)[@value]">
         <identifier xmlns="http://hl7.org/fhir">
            <xsl:call-template name="id-to-Identifier">
               <xsl:with-param name="in"
                               select="."/>
            </xsl:call-template>
         </identifier>
      </xsl:for-each>
      <!-- todo organisatietype / afdelingspecialisme, is not part of an MP transaction up until now -->
      <xsl:for-each select="./organisatie_naam[.//(@value | @code)]">
         <name value="{./@value}"
               xmlns="http://hl7.org/fhir"/>
      </xsl:for-each>
      <!-- contactgegevens -->
      <xsl:apply-templates select="(telefoon_email/contactgegevens | contactgegevens)[.//(@value | @code | @nullFlavor)]"
                           mode="doContactPoint"/>
      <!-- There was a dataset change to remove the obsolete group 'adres' which was adopted by MP 9.0.7, 
                     adres/adresgegevens is still here for backwards compatibility with 9.0.6 and before -->
      <xsl:apply-templates select="(adres/adresgegevens | adresgegevens)"
                           mode="doAddress"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="patient-payload">
      <!-- Helper template for patient payload independent of version (6.12 or nl-core). -->
      <!-- patient_identificatienummer  -->
      <xsl:for-each select="(patient_identificatienummer | identificatienummer)[.//(@value | @nullFlavor)]">
         <identifier xmlns="http://hl7.org/fhir">
            <xsl:call-template name="id-to-Identifier">
               <xsl:with-param name="in"
                               select="."/>
            </xsl:call-template>
         </identifier>
      </xsl:for-each>
      <!-- naamgegevens -->
      <xsl:for-each select="naamgegevens[.//(@value | @code | @nullFlavor)]">
         <xsl:call-template name="nl-core-humanname-2.0">
            <xsl:with-param name="in"
                            select="."/>
            <xsl:with-param name="unstructuredName"
                            select="ongestructureerde_naam"/>
         </xsl:call-template>
      </xsl:for-each>
      <!-- contactgegevens -->
      <xsl:apply-templates select="contactgegevens[.//(@value | @code | @nullFlavor)]"
                           mode="doContactPoint"/>
      <!-- geslacht -->
      <xsl:for-each select="geslacht[.//(@value | @code)]">
         <xsl:call-template name="patient-gender">
            <xsl:with-param name="ada-geslacht"
                            select="."/>
         </xsl:call-template>
      </xsl:for-each>
      <!-- geboortedatum -->
      <xsl:for-each select="geboortedatum[@value]">
         <birthDate value="{@value}"
                    xmlns="http://hl7.org/fhir"/>
      </xsl:for-each>
      <!-- adresgegevens -->
      <xsl:apply-templates select="adresgegevens[.//(@value | @code | @nullFlavor)]"
                           mode="doAddress"/>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="afleverlocatieReference"
                 match="afleverlocatie"
                 mode="doLocationReference">
      <!-- Helper template to create a FHIR reference to a Location resource for afleverlocatie -->
      <reference value="{nf:getFullUrlOrId('LOCATION', nf:getGroupingKeyDefault(.), false())}"
                 xmlns="http://hl7.org/fhir"/>
      <xsl:if test="./@value">
         <display value="{./@value}"
                  xmlns="http://hl7.org/fhir"/>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="patient-gender">
      <!-- Helper template to map ada geslacht to FHIR gender -->
      <xsl:param name="ada-geslacht"
                 as="element()*">
         <!-- ada element which contains geslacht, should be of datatype code -->
      </xsl:param>
      <xsl:for-each select="$ada-geslacht">
         <gender xmlns="http://hl7.org/fhir">
            <xsl:attribute name="value">
               <xsl:choose>
                  <xsl:when test="./@code = 'M'">male</xsl:when>
                  <xsl:when test="./@code = 'F'">female</xsl:when>
                  <xsl:when test="./@code = 'UN'">other</xsl:when>
                  <xsl:when test="./@code = 'UNK'">unknown</xsl:when>
                  <xsl:otherwise>unknown</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
         </gender>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="missing-type-reference-practitionerrole"
                 match="zorgverlener"
                 mode="doMissingTypeReferencePractitionerRole">
      <!-- Helper template to create missing type extension with FHIR PractitionerRole reference, context should be ada zorgverlener element -->
      <!--<xsl:variable name="display" as="xs:string?" select="normalize-space(concat(string-join((.//naamgegevens[1]//*[not(name() = 'naamgebruik')]/@value), ' '), ' || ', string-join(.//organisatie_naam/@value | .//specialisme/@displayName, ' || ')))"/>-->
      <extension url="{$urlExtNLMissingTypeReference}"
                 xmlns="http://hl7.org/fhir">
         <valueReference>
            <xsl:apply-templates select="."
                                 mode="doPractitionerRoleReference-2.0"/>
         </valueReference>
      </extension>
      <!--<display value="{$display}"/>-->
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="reference-practitionerrole"
                 match="zorgverlener"
                 mode="doPractitionerRoleReference-907">
      <!-- Helper template to create extension with FHIR PractitionerRole reference, context should be ada zorgverlener element -->
      <extension url="{$urlExtNLPractitionerRoleReference}"
                 xmlns="http://hl7.org/fhir">
         <valueReference>
            <xsl:apply-templates select="."
                                 mode="doPractitionerRoleReference-2.0"/>
         </valueReference>
      </extension>
      <!-- additional display element -->
      <xsl:variable name="theGroupKey"
                    select="nf:getGroupingKeyDefault(.)"/>
      <xsl:variable name="theGroupElement"
                    select="$practitionerRoles[group-key = $theGroupKey]"
                    as="element()?"/>
      <xsl:if test="string-length($theGroupElement/reference-display) gt 0">
         <display value="{$theGroupElement/reference-display}"
                  xmlns="http://hl7.org/fhir"/>
      </xsl:if>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="verstrekker-performer-actor"
                 match="verstrekker"
                 mode="doPerformerActor">
      <!-- Helper template to create FHIR performer.actor, context should be ada verstrekker element -->
      <!-- verstrekker -->
      <performer xmlns="http://hl7.org/fhir">
         <!-- in dataset toedieningsafspraak 9.0.6 staat zorgaanbieder (onnodig) een keer extra genest -->
         <xsl:for-each select=".//zorgaanbieder[not(zorgaanbieder)]">
            <actor>
               <xsl:apply-templates select="."
                                    mode="doOrganizationReference-2.0"/>
            </actor>
         </xsl:for-each>
      </performer>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="zorgverlener-requester"
                 match="zorgverlener"
                 mode="doRequesterAgent">
      <!-- Helper template to create FHIR requestor.agent, input or context should be ada zorgverlener element -->
      <xsl:param name="zorgverlener"
                 select=".">
         <!-- ada element zorgverlener, is derived from context when not set -->
      </xsl:param>
      <requester xmlns="http://hl7.org/fhir">
         <xsl:for-each select="$zorgverlener">
            <agent>
               <xsl:apply-templates select="."
                                    mode="doPractitionerReference-2.0"/>
            </agent>
            <xsl:for-each select=".//zorgaanbieder[not(zorgaanbieder)][.//@value]">
               <onBehalfOf>
                  <xsl:apply-templates select="."
                                       mode="doOrganizationReference-2.0"/>
               </onBehalfOf>
            </xsl:for-each>
         </xsl:for-each>
      </requester>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="zorgverlener-requester-ext"
                 match="voorschrijver | auteur"
                 mode="doRequesterExtension">
      <!-- Helper template to create FHIR requester.extension (with PractitionerRoleReference) and .agent, context should be ada voorschrijver or auteur element -->
      <xsl:for-each select="./zorgverlener[.//(@value | @code)]">
         <requester xmlns="http://hl7.org/fhir">
            <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-MedicationAgreement-RequesterRole">
               <valueReference>
                  <xsl:apply-templates select="."
                                       mode="doPractitionerRoleReference-2.0"/>
               </valueReference>
            </extension>
            <!-- agent is verplicht in FHIR, dit is eigenlijk dubbelop omdat de practitionerRole hier ook al naar verwijst -->
            <agent>
               <xsl:apply-templates select="."
                                    mode="doPractitionerReference-2.0"/>
            </agent>
         </requester>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="zorgverlener-requester-ext-907"
                 match="voorschrijver | auteur"
                 mode="doRequesterExtension-907">
      <!-- Helper template to create FHIR requester.agent (with missing type extension), context should be ada voorschrijver element -->
      <xsl:for-each select="./zorgverlener[.//(@value | @code)]">
         <requester xmlns="http://hl7.org/fhir">
            <agent>
               <xsl:apply-templates select="."
                                    mode="doPractitionerRoleReference-907"/>
            </agent>
         </requester>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="fhir-contact-point"
                 match="contactgegevens"
                 mode="doContactPoint">
      <!-- Template for FHIR datatype ContactPoint, context should be ada contactgegevens element -->
      <xsl:for-each select="telefoonnummers[.//(@value | @code)]">
         <telecom xmlns="http://hl7.org/fhir">
            <system value="phone"/>
            <value value="{telefoonnummer/@value}"/>
            <!-- todo telecomtype, is not part of an MP transaction up until now -->
            <use>
               <xsl:attribute name="value">
                  <xsl:choose>
                     <xsl:when test="nummer_soort/@code = 'WP'">work</xsl:when>
                     <xsl:when test="nummer_soort/@code = 'HP'">home</xsl:when>
                     <xsl:when test="nummer_soort/@code = 'TMP'">temp</xsl:when>
                     <xsl:otherwise>unsupported nummer_soort/@code: '
<xsl:value-of select="nummer_soort/@code"/>'.</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
            </use>
         </telecom>
      </xsl:for-each>
      <xsl:for-each select="email_adressen[.//(@value | @code)]">
         <telecom xmlns="http://hl7.org/fhir">
            <system value="email"/>
            <value value="{email_adres/@value}"/>
            <!-- todo telecomtype, is not part of an MP transaction up until now -->
            <use>
               <xsl:attribute name="value">
                  <xsl:choose>
                     <xsl:when test="email_soort/@code = 'WP'">work</xsl:when>
                     <xsl:when test="email_soort/@code = 'HP'">home</xsl:when>
                     <xsl:otherwise>unsupported nummer_soort/@code: '
<xsl:value-of select="nummer_soort/@code"/>'.</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
            </use>
         </telecom>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="VV-in-MedicationRequest-2.2">
      <!-- Creates MedicationRequest resource based on input params -->
      <xsl:param name="verstrekkingsverzoek"
                 as="element()?">
         <!-- ada element for dispense request -->
      </xsl:param>
      <xsl:param name="medicationrequest-id"
                 as="xs:string?">
         <!-- the (optional) technical id for the resource -->
      </xsl:param>
      <xsl:for-each select="$verstrekkingsverzoek">
         <xsl:variable name="resource">
            <xsl:variable name="profileValue">http://nictiz.nl/fhir/StructureDefinition/zib-DispenseRequest</xsl:variable>
            <MedicationRequest xmlns="http://hl7.org/fhir">
               <xsl:if test="string-length($medicationrequest-id) gt 0">
                  <id value="{nf:make-fhir-logicalid(tokenize($profileValue, './')[last()], $medicationrequest-id)}"/>
               </xsl:if>
               <meta>
                  <profile value="{$profileValue}"/>
               </meta>
               <!-- aanvullende_wensen in extensie -->
               <xsl:for-each select="aanvullende_wensen[@code]">
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-Medication-AdditionalInformation">
                     <valueCodeableConcept>
                        <xsl:call-template name="code-to-CodeableConcept">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </valueCodeableConcept>
                  </extension>
               </xsl:for-each>
               <!-- relatie naar medicatieafspraak -->
               <xsl:for-each select="relatie_naar_medicatieafspraak/identificatie[not(@root = $oidHL7NullFlavor)][@value]">
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-DispenseRequest-RelatedMedicationAgreement">
                     <valueReference>
                        <identifier>
                           <xsl:call-template name="id-to-Identifier">
                              <xsl:with-param name="in"
                                              select="."/>
                           </xsl:call-template>
                        </identifier>
                        <display>
                           <xsl:attribute name="value">Relatie naar medicatieafspraak, id = 
<xsl:value-of select="./string-join((@value, @root), ' || ')"/>
                           </xsl:attribute>
                        </display>
                     </valueReference>
                  </extension>
               </xsl:for-each>
               <!-- relatie naar medicamenteuze behandeling -->
               <xsl:for-each select="./../identificatie[@value]">
                  <xsl:call-template name="ext-zib-medication-medication-treatment-2.0">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- Verstrekkingsverzoek id -->
               <xsl:for-each select="./identificatie[@value]">
                  <identifier>
                     <xsl:call-template name="id-to-Identifier">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </identifier>
               </xsl:for-each>
               <intent value="order"/>
               <!-- type bouwsteen, hier een medicatieverstrekking -->
               <category>
                  <coding>
                     <system value="http://snomed.info/sct"/>
                     <code value="52711000146108"/>
                     <display value="Request to dispense medication to patient (situation)"/>
                  </coding>
                  <text value="Verstrekkingsverzoek"/>
               </category>
               <!-- geneesmiddel -->
               <xsl:apply-templates select="./te_verstrekken_geneesmiddel/product[.//(@value | @code)]"
                                    mode="doMedicationReference"/>
               <!-- patiënt -->
               <subject>
                  <xsl:apply-templates select="./../../patient"
                                       mode="doPatientReference-2.1"/>
               </subject>
               <!-- verstrekkingsverzoek datum -->
               <xsl:for-each select="./datum[@value]">
                  <authoredOn>
                     <xsl:attribute name="value">
                        <xsl:call-template name="format2FHIRDate">
                           <xsl:with-param name="dateTime"
                                           select="@value"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </authoredOn>
               </xsl:for-each>
               <!-- auteur -->
               <!-- todo -->
               <!--                <xsl:apply-templates select="./[.//(@value | @code)]" mode="doRequesterExtension-907"/>-->
               <xsl:for-each select="auteur/zorgverlener[.//(@value | @code)]">
                  <requester>
                     <agent>
                        <xsl:call-template name="practitionerRoleReference">
                           <xsl:with-param name="useExtension"
                                           select="true()"/>
                           <xsl:with-param name="addDisplay"
                                           select="false()"/>
                        </xsl:call-template>
                        <xsl:call-template name="practitionerReference"/>
                     </agent>
                  </requester>
               </xsl:for-each>
               <!-- toelichting -->
               <xsl:for-each select="./toelichting[@value]">
                  <note>
                     <text value="{./@value}"/>
                  </note>
               </xsl:for-each>
               <!-- verstrekkingsverzoek zelf in FHIR -->
               <dispenseRequest>
                  <!-- afleverlocatie -->
                  <xsl:for-each select="./afleverlocatie[@value]">
                     <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-Dispense-Location">
                        <valueReference>
                           <xsl:apply-templates select="."
                                                mode="doLocationReference"/>
                        </valueReference>
                     </extension>
                  </xsl:for-each>
                  <!-- verbruiksperiode start/eind -->
                  <xsl:for-each select="./verbruiksperiode[(ingangsdatum | einddatum)/@value]">
                     <validityPeriod>
                        <xsl:for-each select="./ingangsdatum[@value]">
                           <start>
                              <xsl:attribute name="value">
                                 <xsl:call-template name="format2FHIRDate">
                                    <xsl:with-param name="dateTime"
                                                    select="@value"/>
                                 </xsl:call-template>
                              </xsl:attribute>
                           </start>
                        </xsl:for-each>
                        <xsl:for-each select="./einddatum[@value]">
                           <end>
                              <xsl:attribute name="value">
                                 <xsl:call-template name="format2FHIRDate">
                                    <xsl:with-param name="dateTime"
                                                    select="@value"/>
                                 </xsl:call-template>
                              </xsl:attribute>
                           </end>
                        </xsl:for-each>
                     </validityPeriod>
                  </xsl:for-each>
                  <!-- aantal_herhalingen -->
                  <xsl:for-each select="./aantal_herhalingen[@value]">
                     <numberOfRepeatsAllowed value="{./@value}"/>
                  </xsl:for-each>
                  <!-- te_verstrekken_hoeveelheid -->
                  <xsl:for-each select="./te_verstrekken_hoeveelheid[.//@value]">
                     <quantity>
                        <xsl:call-template name="hoeveelheid-complex-to-Quantity">
                           <xsl:with-param name="waarde"
                                           select="./aantal"/>
                           <xsl:with-param name="eenheid"
                                           select="./eenheid"/>
                        </xsl:call-template>
                     </quantity>
                  </xsl:for-each>
                  <!-- verbruiksperiode -->
                  <xsl:for-each select="./verbruiksperiode/duur[@value]">
                     <expectedSupplyDuration>
                        <xsl:call-template name="hoeveelheid-to-Duration">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </expectedSupplyDuration>
                  </xsl:for-each>
                  <!-- beoogd verstrekker -->
                  <xsl:for-each select="./beoogd_verstrekker[.//(@value | @code)]">
                     <performer>
                        <xsl:apply-templates select="./zorgaanbieder"
                                             mode="doOrganizationReference-2.0"/>
                     </performer>
                  </xsl:for-each>
               </dispenseRequest>
            </MedicationRequest>
         </xsl:variable>
         <!-- Add resource.text -->
         <xsl:apply-templates select="$resource"
                              mode="addNarrative"/>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="zib-AdministrationAgreement-3.0">
      <!-- Template based on FHIR Profile http://nictiz.nl/fhir/StructureDefinition/zib-AdministrationAgreement  -->
      <xsl:param name="in"
                 as="element()?"
                 select=".">
         <!-- Optional, defaults to context element. Input ada element which had toedieningsafspraak. -->
      </xsl:param>
      <xsl:param name="resource-id"
                 as="xs:string?">
         <!-- Optional, the resource logical id -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:variable name="resource">
            <MedicationDispense xmlns="http://hl7.org/fhir">
               <xsl:for-each select="$resource-id">
                  <id value="{.}"/>
               </xsl:for-each>
               <meta>
                  <profile value="http://nictiz.nl/fhir/StructureDefinition/zib-AdministrationAgreement"/>
               </meta>
               <!-- afspraakdatum -->
               <xsl:apply-templates select="afspraakdatum[@value]"
                                    mode="TA-afspraakdatum"/>
               <!-- reden afspraak -->
               <xsl:for-each select="./reden_afspraak[@value]">
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-AdministrationAgreement-AgreementReason">
                     <valueString value="{./@value}"/>
                  </extension>
               </xsl:for-each>
               <!-- gebruiksperiode_start /eind -->
               <xsl:for-each select=".[(gebruiksperiode_start | gebruiksperiode_eind)//(@value)]">
                  <xsl:call-template name="ext-zib-Medication-PeriodOfUse-2.0">
                     <xsl:with-param name="start"
                                     select="./gebruiksperiode_start"/>
                     <xsl:with-param name="end"
                                     select="./gebruiksperiode_eind"/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- gebruiksperiode - duur -->
               <xsl:for-each select="./gebruiksperiode[.//@value]">
                  <xsl:call-template name="ext-zib-Medication-Use-Duration"/>
               </xsl:for-each>
               <!-- aanvullende_informatie -->
               <xsl:for-each select="./aanvullende_informatie[.//(@value | @code)]">
                  <xsl:call-template name="ext-zib-Medication-AdditionalInformation-2.0"/>
               </xsl:for-each>
               <!-- relatie naar medicamenteuze behandeling -->
               <xsl:for-each select="./../identificatie[.//(@value)]">
                  <xsl:call-template name="ext-zib-medication-medication-treatment-2.0">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- kopie indicator -->
               <!-- zit niet in alle transacties, eigenlijk alleen in medicatieoverzicht -->
               <xsl:for-each select="./kopie_indicator[.//(@value | @code)]">
                  <xsl:call-template name="ext-zib-Medication-CopyIndicator-2.0"/>
               </xsl:for-each>
               <!-- instructionsForUseDescription, only from version 2.2.3 onwards -->
               <xsl:call-template name="ext-zib-Medication-InstructionsForUseDescription-1.0">
                  <xsl:with-param name="in"
                                  select="gebruiksinstructie/omschrijving[@value | @nullFlavor]"/>
               </xsl:call-template>
               <!-- herhaalperiode cyclisch schema -->
               <xsl:for-each select="./gebruiksinstructie/herhaalperiode_cyclisch_schema[.//(@value | @code)]">
                  <xsl:call-template name="ext-zib-Medication-RepeatPeriodCyclicalSchedule-2.0"/>
               </xsl:for-each>
               <!-- stoptype -->
               <xsl:for-each select="stoptype[.//(@value | @code)]">
                  <xsl:call-template name="ext-zib-Medication-StopType-2.0"/>
               </xsl:for-each>
               <!-- TA id -->
               <xsl:for-each select="./identificatie[.//(@value | @code)]">
                  <identifier>
                     <xsl:call-template name="id-to-Identifier">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </identifier>
               </xsl:for-each>
               <!-- geannuleerd_indicator, in status -->
               <xsl:for-each select="./geannuleerd_indicator[@value = 'true']">
                  <status value="entered-in-error"/>
               </xsl:for-each>
               <!-- type bouwsteen, hier een toedieningsafspraak -->
               <category>
                  <coding>
                     <system value="http://snomed.info/sct"/>
                     <code value="422037009"/>
                     <display value="Provider medication administration instructions (procedure)"/>
                  </coding>
                  <text value="Toedieningsafspraak"/>
               </category>
               <!-- geneesmiddel -->
               <xsl:apply-templates select="./geneesmiddel_bij_toedieningsafspraak/product[.//(@value | @code)]"
                                    mode="doMedicationReference"/>
               <!-- patiënt -->
               <subject>
                  <xsl:apply-templates select="./../../patient"
                                       mode="doPatientReference-2.1"/>
               </subject>
               <!-- verstrekker -->
               <xsl:apply-templates select="./verstrekker[.//(@value | @code)]"
                                    mode="doPerformerActor"/>
               <!-- relatie naar medicatieafspraak -->
               <xsl:for-each select="relatie_naar_medicatieafspraak/identificatie[not(@root = $oidHL7NullFlavor)][.//@value]">
                  <authorizingPrescription>
                     <identifier>
                        <xsl:call-template name="id-to-Identifier">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </identifier>
                     <display>
                        <xsl:attribute name="value">relatie naar medicatieafspraak: 
<xsl:value-of select="./string-join((@value, @root), ' || ')"/>
                        </xsl:attribute>
                     </display>
                  </authorizingPrescription>
               </xsl:for-each>
               <!-- toelichting -->
               <xsl:for-each select="./toelichting[@value]">
                  <note>
                     <text value="{./@value}"/>
                  </note>
               </xsl:for-each>
               <!-- gebruiksinstructie -->
               <xsl:call-template name="handle-gebruiksinstructie-3.0">
                  <xsl:with-param name="in"
                                  select="gebruiksinstructie"/>
                  <xsl:with-param name="outputText"
                                  select="false()"/>
               </xsl:call-template>
            </MedicationDispense>
         </xsl:variable>
         <!-- Add resource.text -->
         <xsl:apply-templates select="$resource"
                              mode="addNarrative"/>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="mp612dispensetofhirconversionadministrationagreement-1.0.0">
      <!--  Template based on FHIR Profile https://simplifier.net/nictizstu3-zib2017/mp612dispensetofhirconversionadministrationagreement  -->
      <xsl:param name="toedieningsafspraak"
                 as="element()?">
         <!-- ada xml element toedieningsafspraak -->
      </xsl:param>
      <xsl:param name="medicationdispense-id"
                 as="xs:string?">
         <!-- optional technical id for the FHIR MedicationDispense resource -->
      </xsl:param>
      <xsl:for-each select="$toedieningsafspraak">
         <xsl:variable name="resource">
            <xsl:variable name="profileValue">http://nictiz.nl/fhir/StructureDefinition/mp612-DispenseToFHIRConversion-AdministrationAgreement</xsl:variable>
            <MedicationDispense xmlns="http://hl7.org/fhir">
               <xsl:if test="string-length($medicationdispense-id) gt 0">
                  <id value="{nf:make-fhir-logicalid(tokenize($profileValue, './')[last()], $medicationdispense-id)}"/>
               </xsl:if>
               <meta>
                  <profile value="{$profileValue}"/>
               </meta>
               <!-- afspraakdatum -->
               <xsl:apply-templates select="(afspraakdatum | afspraak_datum_tijd)[@value]"
                                    mode="TA-afspraakdatum"/>
               <!-- gebruiksperiode_start /eind -->
               <xsl:for-each select=".[(gebruiksperiode_start | gebruiksperiode_eind)//(@value)]">
                  <xsl:call-template name="ext-zib-Medication-PeriodOfUse-2.0">
                     <xsl:with-param name="start"
                                     select="gebruiksperiode_start"/>
                     <xsl:with-param name="end"
                                     select="gebruiksperiode_eind"/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- gebruiksperiode - duur -->
               <xsl:for-each select="gebruiksperiode[.//@value]">
                  <xsl:call-template name="ext-zib-Medication-Use-Duration"/>
               </xsl:for-each>
               <!-- relatie naar medicamenteuze behandeling -->
               <xsl:for-each select="../identificatie[.//(@value)]">
                  <xsl:call-template name="ext-zib-medication-medication-treatment-2.0">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- herhaalperiode cyclisch schema -->
               <xsl:for-each select="./gebruiksinstructie/herhaalperiode_cyclisch_schema[.//(@value | @code)]">
                  <xsl:call-template name="ext-zib-Medication-RepeatPeriodCyclicalSchedule-2.0"/>
               </xsl:for-each>
               <!-- type bouwsteen, hier een toedieningsafspraak -->
               <category>
                  <coding>
                     <system value="http://snomed.info/sct"/>
                     <code value="422037009"/>
                     <display value="Provider medication administration instructions (procedure)"/>
                  </coding>
                  <text value="Toedieningsafspraak"/>
               </category>
               <!-- geneesmiddel -->
               <xsl:apply-templates select="geneesmiddel_bij_toedieningsafspraak/product[.//(@value | @code)]"
                                    mode="doMedicationReference"/>
               <!-- patiënt -->
               <subject>
                  <xsl:apply-templates select="./../../patient"
                                       mode="doPatientReference-2.1"/>
               </subject>
               <!-- verstrekker -->
               <xsl:apply-templates select="verstrekker[.//(@value | @code)]"
                                    mode="doPerformerActor"/>
               <!-- gebruiksinstructie -->
               <xsl:apply-templates select="gebruiksinstructie"
                                    mode="handleGebruiksinstructie"/>
            </MedicationDispense>
         </xsl:variable>
         <!-- Add resource.text -->
         <xsl:apply-templates select="$resource"
                              mode="addNarrative"/>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="TA-afspraakdatum"
                 match="afspraakdatum | afspraak_datum_tijd"
                 mode="TA-afspraakdatum">
      <!-- Creates the FHIR element for TA afspraakdatum, context should be ada afspraakdatum -->
      <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-AdministrationAgreement-AuthoredOn"
                 xmlns="http://hl7.org/fhir">
         <valueDateTime>
            <xsl:attribute name="value">
               <xsl:call-template name="format2FHIRDate">
                  <xsl:with-param name="dateTime"
                                  select="@value"/>
               </xsl:call-template>
            </xsl:attribute>
         </valueDateTime>
      </extension>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="zib-Dispense-2.0">
      <!-- Creates a FHIR MedicationDispense resource based on ada verstrekking -->
      <xsl:param name="verstrekking"
                 as="element()?">
         <!-- ada verstrekking -->
      </xsl:param>
      <xsl:param name="medicationdispense-id"
                 as="xs:string?">
         <!-- optional technical FHIR resource id -->
      </xsl:param>
      <xsl:for-each select="$verstrekking">
         <xsl:variable name="resource">
            <xsl:variable name="profileValue">http://nictiz.nl/fhir/StructureDefinition/zib-Dispense</xsl:variable>
            <MedicationDispense xmlns="http://hl7.org/fhir">
               <xsl:if test="string-length($medicationdispense-id) gt 0">
                  <id value="{nf:make-fhir-logicalid(tokenize($profileValue, './')[last()], $medicationdispense-id)}"/>
               </xsl:if>
               <meta>
                  <profile value="{$profileValue}"/>
               </meta>
               <!-- distributievorm -->
               <xsl:for-each select="distributievorm[@code]">
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-Dispense-DistributionForm">
                     <valueCodeableConcept>
                        <xsl:call-template name="code-to-CodeableConcept">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </valueCodeableConcept>
                  </extension>
               </xsl:for-each>
               <!-- aanschrijfdatum -->
               <xsl:for-each select="aanschrijfdatum[@value]">
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-Dispense-RequestDate">
                     <valueDateTime>
                        <xsl:attribute name="value">
                           <xsl:call-template name="format2FHIRDate">
                              <xsl:with-param name="dateTime"
                                              select="xs:string(@value)"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </valueDateTime>
                  </extension>
               </xsl:for-each>
               <!-- aanvullende_informatie -->
               <xsl:for-each select="aanvullende_informatie[@code]">
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-Medication-AdditionalInformation">
                     <valueCodeableConcept>
                        <xsl:call-template name="code-to-CodeableConcept">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </valueCodeableConcept>
                  </extension>
               </xsl:for-each>
               <!-- relatie naar medicamenteuze behandeling -->
               <xsl:for-each select="../identificatie[@value]">
                  <xsl:call-template name="ext-zib-medication-medication-treatment-2.0">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- MVE id -->
               <xsl:for-each select="identificatie[@value]">
                  <identifier>
                     <xsl:call-template name="id-to-Identifier">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </identifier>
               </xsl:for-each>
               <!-- type bouwsteen, hier een medicatieverstrekking -->
               <category>
                  <coding>
                     <system value="http://snomed.info/sct"/>
                     <code value="373784005"/>
                     <display value="Dispensing medication (procedure)"/>
                  </coding>
                  <text value="Medicatieverstrekking"/>
               </category>
               <!-- geneesmiddel -->
               <xsl:apply-templates select="verstrekt_geneesmiddel/product[.//(@value | @code)]"
                                    mode="doMedicationReference"/>
               <!-- patiënt -->
               <subject>
                  <xsl:apply-templates select="../../patient"
                                       mode="doPatientReference-2.1"/>
               </subject>
               <!-- verstrekker -->
               <xsl:apply-templates select="verstrekker[.//(@value | @code)]"
                                    mode="doPerformerActor"/>
               <!-- relatie naar verstrekkingsverzoek -->
               <xsl:for-each select="relatie_naar_verstrekkingsverzoek/identificatie[@value]">
                  <authorizingPrescription>
                     <identifier>
                        <xsl:call-template name="id-to-Identifier">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </identifier>
                     <display value="Verstrekkingsverzoek met identificatie {./@value} in identificerend systeem {./@root}."/>
                  </authorizingPrescription>
               </xsl:for-each>
               <xsl:for-each select="verstrekte_hoeveelheid[.//*[@value]]">
                  <quantity>
                     <xsl:call-template name="hoeveelheid-complex-to-Quantity">
                        <xsl:with-param name="eenheid"
                                        select="eenheid"/>
                        <xsl:with-param name="waarde"
                                        select="aantal"/>
                     </xsl:call-template>
                  </quantity>
               </xsl:for-each>
               <!-- verbruiksduur -->
               <xsl:for-each select="verbruiksduur[@value]">
                  <daysSupply>
                     <xsl:call-template name="hoeveelheid-to-Duration">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </daysSupply>
               </xsl:for-each>
               <!-- datum -->
               <xsl:for-each select="datum[@value]">
                  <whenHandedOver>
                     <xsl:attribute name="value">
                        <xsl:call-template name="format2FHIRDate">
                           <xsl:with-param name="dateTime"
                                           select="xs:string(@value)"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </whenHandedOver>
               </xsl:for-each>
               <!-- afleverlocatie -->
               <xsl:for-each select="afleverlocatie[@value]">
                  <destination>
                     <xsl:apply-templates select="."
                                          mode="doLocationReference"/>
                  </destination>
               </xsl:for-each>
               <!-- toelichting  -->
               <xsl:for-each select="toelichting[@value]">
                  <note>
                     <text value="{@value}"/>
                  </note>
               </xsl:for-each>
            </MedicationDispense>
         </xsl:variable>
         <!-- Add resource.text -->
         <xsl:apply-templates select="$resource"
                              mode="addNarrative"/>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="mp612dispensetofhirconversiondispense-1.0.0">
      <!-- Creates a FHIR MedicationDispense resource based on ada verstrekking in the verstrekkingenvertaling transaction -->
      <xsl:param name="verstrekking"
                 as="element()?">
         <!-- ada verstrekking -->
      </xsl:param>
      <xsl:param name="medicationdispense-id"
                 as="xs:string?">
         <!-- optional technical FHIR resource id -->
      </xsl:param>
      <xsl:for-each select="$verstrekking">
         <xsl:variable name="resource">
            <xsl:variable name="profileValue">http://nictiz.nl/fhir/StructureDefinition/mp612-DispenseToFHIRConversion-Dispense</xsl:variable>
            <MedicationDispense xmlns="http://hl7.org/fhir">
               <xsl:if test="string-length($medicationdispense-id) gt 0">
                  <id value="{nf:make-fhir-logicalid(tokenize($profileValue, './')[last()], $medicationdispense-id)}"/>
               </xsl:if>
               <meta>
                  <profile value="{$profileValue}"/>
               </meta>
               <!-- aanschrijfdatum -->
               <xsl:for-each select="aanschrijfdatum[@value]">
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-Dispense-RequestDate">
                     <valueDateTime>
                        <xsl:attribute name="value">
                           <xsl:call-template name="format2FHIRDate">
                              <xsl:with-param name="dateTime"
                                              select="@value"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </valueDateTime>
                  </extension>
               </xsl:for-each>
               <!-- relatie naar medicamenteuze behandeling -->
               <xsl:for-each select="../identificatie[@value]">
                  <xsl:call-template name="ext-zib-medication-medication-treatment-2.0">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- MVE id -->
               <xsl:for-each select="identificatie[@value]">
                  <identifier>
                     <xsl:call-template name="id-to-Identifier">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </identifier>
               </xsl:for-each>
               <!-- type bouwsteen, hier een medicatieverstrekking -->
               <category>
                  <coding>
                     <system value="http://snomed.info/sct"/>
                     <code value="373784005"/>
                     <display value="Dispensing medication (procedure)"/>
                  </coding>
                  <text value="Medicatieverstrekking"/>
               </category>
               <!-- geneesmiddel -->
               <xsl:apply-templates select="verstrekt_geneesmiddel/product[.//(@value | @code)]"
                                    mode="doMedicationReference"/>
               <!-- patiënt -->
               <subject>
                  <xsl:apply-templates select="../../patient"
                                       mode="doPatientReference-2.1"/>
               </subject>
               <!-- verstrekker -->
               <xsl:apply-templates select="verstrekker[.//(@value | @code)]"
                                    mode="doPerformerActor"/>
               <!-- relatie naar verstrekkingsverzoek -->
               <xsl:for-each select="relatie_naar_verstrekkingsverzoek/identificatie[@value]">
                  <authorizingPrescription>
                     <identifier>
                        <xsl:call-template name="id-to-Identifier">
                           <xsl:with-param name="in"
                                           select="."/>
                        </xsl:call-template>
                     </identifier>
                     <!-- TODO alle inhoud van dit voorschrift meegven in de display -->
                     <display value="Verstrekkingsverzoek met identificatie {./@value} in identificerend systeem {./@root}."/>
                  </authorizingPrescription>
               </xsl:for-each>
               <xsl:for-each select="verstrekte_hoeveelheid[.//*[@value]]">
                  <quantity>
                     <xsl:call-template name="hoeveelheid-complex-to-Quantity">
                        <xsl:with-param name="eenheid"
                                        select="eenheid"/>
                        <xsl:with-param name="waarde"
                                        select="aantal"/>
                     </xsl:call-template>
                  </quantity>
               </xsl:for-each>
               <!-- verbruiksduur -->
               <xsl:for-each select="verbruiksduur[@value]">
                  <daysSupply>
                     <xsl:call-template name="hoeveelheid-to-Duration">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </daysSupply>
               </xsl:for-each>
               <!-- datum -->
               <xsl:for-each select="datum[@value]">
                  <whenHandedOver value="{nf:add-Amsterdam-timezone-to-dateTimeString(./@value)}"/>
               </xsl:for-each>
               <xsl:for-each select="datum[@nullFlavor]">
                  <whenHandedOver>
                     <extension url="http://hl7.org/fhir/StructureDefinition/iso21090-nullFlavor">
                        <valueCode value="{./@nullFlavor}"/>
                     </extension>
                  </whenHandedOver>
               </xsl:for-each>
               <!-- afleverlocatie -->
               <xsl:for-each select="afleverlocatie[@value]">
                  <destination>
                     <xsl:apply-templates select="."
                                          mode="doLocationReference"/>
                  </destination>
               </xsl:for-each>
            </MedicationDispense>
         </xsl:variable>
         <!-- Add resource.text -->
         <xsl:apply-templates select="$resource"
                              mode="addNarrative"/>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="zib-Dispense-Location-2.0">
      <xsl:param name="ada-locatie"
                 as="element()?"
                 select="."/>
      <xsl:param name="location-id"
                 as="xs:string?"/>
      <xsl:for-each select="$ada-locatie">
         <xsl:variable name="profileValue">http://fhir.nl/fhir/StructureDefinition/nl-core-location</xsl:variable>
         <Location xmlns="http://hl7.org/fhir">
            <xsl:if test="string-length($location-id) gt 0">
               <id value="{nf:make-fhir-logicalid(tokenize($profileValue, './')[last()], $location-id)}"/>
            </xsl:if>
            <meta>
               <profile value="{$profileValue}"/>
            </meta>
            <name value="{./@value}"/>
         </Location>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="zib-DispenseRequest-2.2">
      <!-- Template based on FHIR Profile https://simplifier.net/nictizstu3-zib2017/zib-dispenserequest -->
      <xsl:param name="verstrekkingsverzoek"
                 as="element()?">
         <!-- ada element for dispenserequest -->
      </xsl:param>
      <xsl:param name="searchMode"
                 as="xs:string"
                 select="'include'"/>
      <xsl:for-each select="$verstrekkingsverzoek">
         <xsl:call-template name="VV-in-MedicationRequest-2.2">
            <xsl:with-param name="verstrekkingsverzoek"
                            select="."/>
            <xsl:with-param name="medicationrequest-id"
                            select="                         if ($referById) then                             nf:removeSpecialCharacters(identificatie/@value)                         else                             ()"/>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="zib-Product"
                 match="product"
                 mode="doMedication">
      <xsl:param name="in"
                 select=".">
         <!-- Node to process. Defaults to context node -->
      </xsl:param>
      <xsl:param name="profile-uri"
                 as="xs:string">
         <!-- Resource.meta.profile. Defaults to http://nictiz.nl/fhir/StructureDefinition/zib-Product unless a parent beschikbaarstellen_verstrekkingenvertaling is encountered -->
         <xsl:choose>
            <xsl:when test="ancestor::beschikbaarstellen_verstrekkingenvertaling">http://nictiz.nl/fhir/StructureDefinition/mp612-DispenseToFHIRConversion-Product</xsl:when>
            <xsl:otherwise>http://nictiz.nl/fhir/StructureDefinition/zib-Product</xsl:otherwise>
         </xsl:choose>
      </xsl:param>
      <xsl:param name="medication-id"
                 as="xs:string?">
         <!-- Resource.id. Resource.id is created when this parameter is populated. Default is empty -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:variable name="resource">
            <Medication xmlns="http://hl7.org/fhir">
               <xsl:if test="string-length($medication-id) gt 0">
                  <xsl:choose>
                     <xsl:when test="$referById">
                        <id value="{nf:make-fhir-logicalid(tokenize($profile-uri, './')[last()], $medication-id)}"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <id value="{nf:removeSpecialCharacters($medication-id)}"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:if>
               <meta>
                  <profile value="{$profile-uri}"/>
               </meta>
               <xsl:for-each select="product_specificatie/omschrijving[@value]">
                  <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-Product-Description">
                     <valueString value="{replace(string-join(./@value, ''),'(^\s+)|(\s+$)','')}"/>
                  </extension>
               </xsl:for-each>
               <xsl:variable name="most-specific-product-code"
                             select="nf:get-specific-productcode(product_code)"
                             as="element(product_code)?"/>
               <xsl:choose>
                  <xsl:when test="product_code[not(@codeSystem = $oidHL7NullFlavor)]">
                     <code>
                        <xsl:for-each select="product_code[not(@codeSystem = $oidHL7NullFlavor)]">
                           <xsl:choose>
                              <xsl:when test="@codeSystem = $most-specific-product-code/@codeSystem">
                                 <xsl:call-template name="code-to-CodeableConcept">
                                    <xsl:with-param name="in"
                                                    select="."/>
                                    <xsl:with-param name="userSelected">true</xsl:with-param>
                                 </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:call-template name="code-to-CodeableConcept">
                                    <xsl:with-param name="in"
                                                    select="."/>
                                 </xsl:call-template>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:for-each>
                        <xsl:for-each select="$most-specific-product-code[@displayName]">
                           <text value="{@displayName}"/>
                        </xsl:for-each>
                     </code>
                  </xsl:when>
                  <xsl:when test="product_code[@codeSystem = $oidHL7NullFlavor]">
                     <code>
                        <xsl:call-template name="code-to-CodeableConcept">
                           <xsl:with-param name="in"
                                           select="product_code"/>
                        </xsl:call-template>
                        <xsl:if test="not(product_code[@originalText]) and product_specificatie/product_naam/@value">
                           <text value="{product_specificatie/product_naam/@value}"/>
                        </xsl:if>
                     </code>
                  </xsl:when>
                  <xsl:when test="product_specificatie/product_naam[@value]">
                     <code>
                        <text value="{product_specificatie/product_naam/@value}"/>
                     </code>
                  </xsl:when>
               </xsl:choose>
               <xsl:for-each select="product_specificatie/farmaceutische_vorm[@code]">
                  <form>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </form>
               </xsl:for-each>
               <xsl:for-each select="./product_specificatie/ingredient[.//(@value | @code)]">
                  <ingredient>
                     <xsl:for-each select="./ingredient_code[@code]">
                        <itemCodeableConcept>
                           <xsl:call-template name="code-to-CodeableConcept">
                              <xsl:with-param name="in"
                                              select="."/>
                           </xsl:call-template>
                        </itemCodeableConcept>
                     </xsl:for-each>
                     <xsl:for-each select="./sterkte">
                        <amount>
                           <xsl:call-template name="hoeveelheid-complex-to-Ratio">
                              <xsl:with-param name="numerator"
                                              select="./hoeveelheid_ingredient"/>
                              <xsl:with-param name="denominator"
                                              select="./hoeveelheid_product"/>
                           </xsl:call-template>
                        </amount>
                     </xsl:for-each>
                  </ingredient>
               </xsl:for-each>
            </Medication>
         </xsl:variable>
         <!-- Add resource.text -->
         <xsl:apply-templates select="$resource"
                              mode="addNarrative"/>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:getFullUrlOrId"
                 as="xs:string?">
      <xsl:param name="resourceType"
                 as="xs:string?">
         <!-- The type of resource to find, using the variable with common entries -->
      </xsl:param>
      <xsl:param name="group-key"
                 as="xs:string?">
         <!-- The group key to find the correct instance in the variables with common entries -->
      </xsl:param>
      <xsl:param name="bln-id"
                 as="xs:boolean">
         <!-- In case of $referById determine whether you get the id of or reference to the resource. If false() you get the reference (Patient/XXX_Amaya), if true() you get the id (XXX_Amaya). -->
      </xsl:param>
      <xsl:variable name="RESOURCETYPE"
                    select="normalize-space(upper-case($resourceType))"/>
      <xsl:variable name="var">
         <xsl:choose>
            <xsl:when test="$RESOURCETYPE = 'PATIENT'">
               <xsl:copy-of select="$patients"/>
            </xsl:when>
            <xsl:when test="$RESOURCETYPE = 'ORGANIZATION'">
               <xsl:copy-of select="$organizations"/>
            </xsl:when>
            <xsl:when test="$RESOURCETYPE = 'PRACTITIONER'">
               <xsl:copy-of select="$practitioners"/>
            </xsl:when>
            <xsl:when test="$RESOURCETYPE = 'PRACTITIONERROLE'">
               <xsl:copy-of select="$practitionerRoles"/>
            </xsl:when>
            <xsl:when test="$RESOURCETYPE = 'PRODUCT'">
               <xsl:copy-of select="$products"/>
            </xsl:when>
            <xsl:when test="$RESOURCETYPE = 'LOCATION'">
               <xsl:copy-of select="$locations"/>
            </xsl:when>
            <xsl:when test="$RESOURCETYPE = ('GEWICHT', 'LENGTE', 'BODYOBSERVATION', 'BODY-OBSERVATION')">
               <xsl:copy-of select="$body-observations"/>
            </xsl:when>
            <xsl:when test="$RESOURCETYPE = 'REDENVOORSCHRIJVEN'">
               <xsl:copy-of select="$problems"/>
            </xsl:when>
            <xsl:when test="$RESOURCETYPE = 'RELATEDPERSON'">
               <xsl:copy-of select="$relatedPersons"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$referById = true()">
            <xsl:variable name="resource"
                          select="$var/*[.//group-key/text() = $group-key]//*[f:id]"/>
            <xsl:choose>
               <xsl:when test="$bln-id">
                  <xsl:value-of select="$resource/f:id/@value"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="concat($resource/local-name(), '/', $resource/f:id/@value)"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$var/*[.//group-key/text() = $group-key]//f:entry/f:fullUrl/@value"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:getProductGroupingKey"
                 as="xs:string">
      <!-- Creates a grouping key for product, taking account of products which don't have a product-code -->
      <xsl:param name="ada-product-code"
                 as="element()*"/>
      <xsl:variable name="specific-productcode"
                    select="nf:get-specific-productcode($ada-product-code[not(@codeSystem = $oidHL7NullFlavor)])"/>
      <xsl:choose>
         <xsl:when test="$specific-productcode">
            <xsl:value-of select="$specific-productcode/concat(@code, @codeSystem)"/>
         </xsl:when>
         <xsl:otherwise>MAGISTRAAL</xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:get-specific-productcode"
                 as="element()?">
      <!-- Takes a collection of product_codes as input and returns the most specific one according to G-std, otherwise just the first one -->
      <xsl:param name="ada-product-code"
                 as="element()*">
         <!-- Collection of ada product codes to select the most specific one from -->
      </xsl:param>
      <xsl:choose>
         <xsl:when test="$ada-product-code[@codeSystem = $oidGStandaardZInummer]">
            <xsl:copy-of select="$ada-product-code[@codeSystem = $oidGStandaardZInummer]"/>
         </xsl:when>
         <xsl:when test="$ada-product-code[@codeSystem = $oidGStandaardHPK]">
            <xsl:copy-of select="$ada-product-code[@codeSystem = $oidGStandaardHPK]"/>
         </xsl:when>
         <xsl:when test="$ada-product-code[@codeSystem = $oidGStandaardPRK]">
            <xsl:copy-of select="$ada-product-code[@codeSystem = $oidGStandaardPRK]"/>
         </xsl:when>
         <xsl:when test="$ada-product-code[@codeSystem = $oidGStandaardGPK]">
            <xsl:copy-of select="$ada-product-code[@codeSystem = $oidGStandaardGPK]"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$ada-product-code[1]"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="medicatieoverzicht-9.0.7">
      <!-- Makes the List entry for MP 9.0.7 and 9.1 -->
      <xsl:param name="documentgegevens"
                 select="."
                 as="element()?">
         <!-- Document data for medication overview. Defaults to context. -->
      </xsl:param>
      <xsl:param name="entries"
                 as="element(f:entry)*">
         <!-- FHIR entries for the List -->
      </xsl:param>
      <xsl:param name="searchMode"
                 as="xs:string"
                 select="'match'">
         <!-- The search mode, defaults to 'match' -->
      </xsl:param>
      <xsl:for-each select="$documentgegevens">
         <entry xmlns="http://hl7.org/fhir">
            <fullUrl value="{nf:get-fhir-uuid(.)}"/>
            <resource>
               <List>
                  <xsl:if test="$referById">
                     <id value="{generate-id(.)}"/>
                  </xsl:if>
                  <meta>
                     <profile value="http://nictiz.nl/fhir/StructureDefinition/MedicationOverview"/>
                  </meta>
                  <xsl:if test="verificatie_patient[.//(@value | @code)] | verificatie_zorgverlener[.//(@value | @code)]">
                     <extension url="http://nictiz.nl/fhir/StructureDefinition/MedicationOverview-Verification">
                        <xsl:for-each select="./verificatie_patient/geverifieerd_met_patientq/@value">
                           <extension url="VerificationPatient">
                              <valueBoolean value="{.}"/>
                           </extension>
                        </xsl:for-each>
                        <xsl:for-each select="./verificatie_patient/verificatie_datum/@value">
                           <extension url="VerificationPatientDate">
                              <valueDateTime>
                                 <xsl:attribute name="value">
                                    <xsl:call-template name="format2FHIRDate">
                                       <xsl:with-param name="dateTime"
                                                       select="xs:string(.)"/>
                                    </xsl:call-template>
                                 </xsl:attribute>
                              </valueDateTime>
                           </extension>
                        </xsl:for-each>
                        <xsl:for-each select="./verificatie_zorgverlener/geverifieerd_met_zorgverlenerq/@value">
                           <extension url="VerificationHealthProfessional">
                              <valueBoolean value="{.}"/>
                           </extension>
                        </xsl:for-each>
                        <xsl:for-each select="./verificatie_zorgverlener/verificatie_datum/@value">
                           <extension url="VerificationHealthProfessionalDate">
                              <valueDateTime>
                                 <xsl:attribute name="value">
                                    <xsl:call-template name="format2FHIRDate">
                                       <xsl:with-param name="dateTime"
                                                       select="xs:string(.)"/>
                                    </xsl:call-template>
                                 </xsl:attribute>
                              </valueDateTime>
                           </extension>
                        </xsl:for-each>
                     </extension>
                  </xsl:if>
                  <status value="current"/>
                  <mode value="snapshot"/>
                  <code>
                     <coding>
                        <system value="http://snomed.info/sct"/>
                        <code value="11181000146103"/>
                        <display value="Actual medication overview (record artifact)"/>
                     </coding>
                     <text value="Medicatieoverzicht"/>
                  </code>
                  <subject>
                     <xsl:apply-templates select="./ancestor::*[ancestor::data]/patient"
                                          mode="doPatientReference-2.1"/>
                  </subject>
                  <xsl:for-each select="document_datum/@value">
                     <date>
                        <xsl:attribute name="value">
                           <xsl:call-template name="format2FHIRDate">
                              <xsl:with-param name="dateTime"
                                              select="."/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </date>
                  </xsl:for-each>
                  <xsl:for-each select="./auteur">
                     <xsl:for-each select="./auteur_is_zorgaanbieder/zorgaanbieder[.//(@value | @code)]">
                        <source>
                           <extension url="http://nictiz.nl/fhir/StructureDefinition/MedicationOverview-SourceOrganization">
                              <valueReference>
                                 <xsl:apply-templates select="."
                                                      mode="doOrganizationReference-2.0"/>
                              </valueReference>
                           </extension>
                           <xsl:variable name="display-for-reference">
                              <xsl:choose>
                                 <xsl:when test="organisatie_naam[@value]">
                                    <xsl:value-of select="organisatie_naam/@value"/>
                                 </xsl:when>
                                 <xsl:when test="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)[@value]">Organisatie met id '
<xsl:value-of select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)/@value"/>' in identificerend systeem '
<xsl:value-of select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)/@root"/>'.</xsl:when>
                                 <xsl:otherwise>Organisatie informatie: 
<xsl:value-of select="string-join(.//(@value | @code | @root | @codeSystem), ' - ')"/>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:variable>
                           <display value="{$display-for-reference}"/>
                        </source>
                     </xsl:for-each>
                     <xsl:for-each select="auteur_is_patient[@value = 'true']">
                        <source>
                           <xsl:apply-templates select="./ancestor::*[ancestor::data]/patient"
                                                mode="doPatientReference-2.1"/>
                        </source>
                     </xsl:for-each>
                  </xsl:for-each>
                  <!-- the entries with references to medicatieafspraak/toedieningsafspraak/medicatiegebruik -->
                  <!-- MA's en TA's -->
                  <xsl:apply-templates select="$entries[f:resource/*/f:category/f:coding[f:system/@value = 'http://snomed.info/sct'][f:code/@value = ('16076005', '422037009')]]"
                                       mode="doMOListReference"/>
                  <!-- MGB's -->
                  <xsl:apply-templates select="$entries[f:resource/*/f:category/f:coding[f:system/@value = 'urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3'][f:code/@value = '6']]"
                                       mode="doMOListReference"/>
               </List>
            </resource>
            <xsl:if test="string-length($searchMode) gt 0">
               <search>
                  <mode value="{$searchMode}"/>
               </search>
            </xsl:if>
         </entry>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="medicatieoverzicht-list-reference"
                 match="f:entry"
                 mode="doMOListReference">
      <!-- Make an entry with a reference to another entry as is used in the List resource in Bundle for Medicatieoverzicht (medication overview) -->
      <entry xmlns="http://hl7.org/fhir">
         <item>
            <reference>
               <xsl:attribute name="value">
                  <xsl:choose>
                     <xsl:when test="$referById">
                        <xsl:value-of select="concat(f:resource/*[f:id]/local-name(), '/', f:resource/*/f:id/@value)"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="f:fullUrl/@value"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
            </reference>
            <display value="{f:resource/*/f:category/f:text/@value} identifier: value='{f:resource/*/f:identifier[1]/f:value/@value}', system='{./f:resource/*/f:identifier[1]/f:system/@value}'"/>
         </item>
      </entry>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="medicationReference"
                 match="product"
                 mode="doMedicationReference">
      <!-- determine most specific product_code -->
      <xsl:variable name="productCode"
                    select="product_code"/>
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
      <medicationReference xmlns="http://hl7.org/fhir">
         <xsl:variable name="fullUrl"
                       select="nf:getFullUrlOrId('PRODUCT', nf:getGroupingKeyDefault(.), false())"/>
         <reference value="{$fullUrl}"/>
         <display>
            <xsl:variable name="displayValue"
                          as="element()">
               <reference>
                  <xsl:attribute name="value">
                     <xsl:choose>
                        <xsl:when test="product_code[@codeSystem = $mainGstdLevel]/@displayName">
                           <xsl:value-of select="product_code[@codeSystem = $mainGstdLevel]/@displayName"/>
                        </xsl:when>
                        <xsl:when test="product_code[@codeSystem = $oidHL7NullFlavor][@code = 'OTH'][../product_specificatie/product_naam[@value]]">
                           <xsl:value-of select="product_specificatie/product_naam/@value"/>
                        </xsl:when>
                        <!-- assume the first product_code displayName if not match above -->
                        <xsl:when test="product_code/@displayName">
                           <xsl:value-of select="product_code[@displayName][1]/@displayName"/>
                        </xsl:when>
                        <xsl:when test="product_specificatie/product_naam/@value">
                           <xsl:value-of select="product_specificatie/product_naam/@value"/>
                        </xsl:when>
                        <xsl:otherwise>ERROR: DISPLAYNAME NOT FOUND IN INPUT</xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
               </reference>
            </xsl:variable>
            <xsl:attribute name="value">
               <!-- remove leading / trailing spaces to adhere to FHIR requirements for strings, MM-1781 -->
               <xsl:call-template name="string-to-string">
                  <xsl:with-param name="in"
                                  select="$displayValue"/>
               </xsl:call-template>
            </xsl:attribute>
         </display>
      </medicationReference>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template name="organization-entry-612"
                 match="zorgaanbieder[not(zorgaanbieder)]"
                 mode="doOrganization612">
      <!-- Creates an organization resource as a FHIR entry -->
      <xsl:param name="uuid"
                 as="xs:boolean">
         <!-- boolean to determine whether to generate a uuid for the fullURL -->
      </xsl:param>
      <xsl:param name="searchMode"
                 as="xs:string"
                 select="'include'"/>
      <xsl:variable name="ada-id">
         <xsl:choose>
            <xsl:when test="$uuid or not((zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer)/@value)">
               <xsl:value-of select="nf:get-fhir-uuid(.)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="nf:getUriFromAdaId(nf:ada-za-id(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer))"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <entry xmlns="http://hl7.org/fhir">
         <fullUrl value="{$ada-id}"/>
         <resource>
            <xsl:choose>
               <xsl:when test="$referById">
                  <xsl:variable name="fhirResourceId">
                     <xsl:choose>
                        <xsl:when test="$uuid">
                           <xsl:value-of select="nf:removeSpecialCharacters($ada-id)"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="(upper-case(nf:removeSpecialCharacters(string-join(./*/@value, ''))))"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:call-template name="organization-612-1.0">
                     <xsl:with-param name="ada-zorgaanbieder"
                                     select="."/>
                     <xsl:with-param name="logicalId"
                                     select="$fhirResourceId"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="organization-612-1.0">
                     <xsl:with-param name="ada-zorgaanbieder"
                                     select="."/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </resource>
         <xsl:if test="string-length($searchMode) gt 0">
            <search>
               <mode value="{$searchMode}"/>
            </search>
         </xsl:if>
      </entry>
   </xsl:template>
</xsl:stylesheet>