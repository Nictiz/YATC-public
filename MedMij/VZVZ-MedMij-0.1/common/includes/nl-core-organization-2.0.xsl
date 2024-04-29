<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/YATC-internal/ada-2-fhir/env/zibs2017/payload/nl-core-organization-2.0.xsl"?>
<?yatc-distribution-info name="VZVZ-MedMij" timestamp="2024-01-29T11:45:25.52+01:00" version="0.1"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/YATC-internal/ada-2-fhir/env/zibs2017/payload/nl-core-organization-2.0.xsl == -->
<!-- == Distribution: VZVZ-MedMij; 0.1; 2024-01-29T11:45:25.52+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
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
   <!--    <xsl:import href="_zib2017.xsl"/>-->
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="referById"
              as="xs:boolean"
              select="false()"/>
   <!-- JD: Kind of hacky to add zib-Payer Insurance Company to zorgaanbieders, but as it is all nl-core-organization I do not see another option. -->
   <xsl:variable name="organizations"
                 as="element()*">
      <xsl:variable name="healthProvider"
                    select="//zorgaanbieder[not(zorgaanbieder)] | //healthcare_provider[not(healthcare_provider)] | //payer/insurance_company"/>
      <!-- Zorgaanbieders -->
      <!-- AWE: the commented out version makes two different groups when @value and @root are in different order in the ada xml -->
      <!-- This causes two entries with an identical grouping-key, causing problems when attempting to retrieve references... -->
      <!-- <xsl:for-each-group select="$healthProvider[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)]" group-by="
            string-join(for $att in nf:ada-za-id(zorgaanbieder_identificatienummer | zorgaanbieder_identificatie_nummer | healthcare_provider_identification_number)/(@root, @value)
            return
            $att, '')">-->
      <xsl:for-each-group select="$healthProvider[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)]"
                          group-by="             concat(nf:ada-za-id(zorgaanbieder_identificatienummer | zorgaanbieder_identificatie_nummer | healthcare_provider_identification_number)/@root,             nf:ada-za-id(zorgaanbieder_identificatienummer | zorgaanbieder_identificatie_nummer | healthcare_provider_identification_number)/normalize-space(@value))">
         <xsl:for-each-group select="current-group()"
                             group-by="nf:getGroupingKeyDefault(.)">
            <!-- uuid als fullUrl en ook een fhir id genereren vanaf de tweede groep -->
            <xsl:variable name="uuid"
                          as="xs:boolean"
                          select="position() &gt; 1"/>
            <unieke-zorgaanbieder xmlns="">
               <group-key>
                  <xsl:value-of select="current-grouping-key()"/>
               </group-key>
               <reference-display>
                  <xsl:variable name="organizationName"
                                select="(organisatie_naam | organization_name)/@value[not(. = '')]"/>
                  <xsl:variable name="organizationLocation"
                                select="(organisatie_locatie | organization_location)/@value[not(. = '')]"/>
                  <xsl:variable name="organizationIdentifier"
                                select="(zorgaanbieder_identificatie_nummer | zorgaanbieder_identificatienummer | healthcare_provider_identification_number)[@value[not(. = '')]]"/>
                  <xsl:choose>
                     <xsl:when test="$organizationName or $organizationLocation">
                        <xsl:value-of select="current-group()[1]/normalize-space(string-join($organizationName[1] | $organizationLocation[1], ' - '))"/>
                     </xsl:when>
                     <xsl:when test="$organizationIdentifier">Organisatie met id '
<xsl:value-of select="$organizationIdentifier/@value"/>' in identificerend systeem '
<xsl:value-of select="$organizationIdentifier/@root"/>'.</xsl:when>
                     <xsl:otherwise>Organisatie informatie: 
<xsl:value-of select="string-join(.//(@value | @code | @root | @codeSystem), ' - ')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </reference-display>
               <xsl:call-template name="organizationEntry">
                  <xsl:with-param name="uuid"
                                  select="$uuid"/>
               </xsl:call-template>
            </unieke-zorgaanbieder>
         </xsl:for-each-group>
      </xsl:for-each-group>
   </xsl:variable>
   <!-- ================================================================== -->
   <xsl:template name="organizationReference"
                 match="//(zorgaanbieder[not(zorgaanbieder)] | healthcare_provider[not(healthcare_provider)] | payer/insurance_company)"
                 mode="doOrganizationReference-2.0">
      <!-- Creates organization reference -->
      <xsl:variable name="theIdentifier"
                    select="(zorgaanbieder_identificatienummer | zorgaanbieder_identificatie_nummer | healthcare_provider_identification_number | identification_number)[@value]"/>
      <xsl:variable name="theGroupKey"
                    select="nf:getGroupingKeyDefault(.)"/>
      <xsl:variable name="theGroupElement"
                    select="$organizations[group-key = $theGroupKey]"
                    as="element()*"/>
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
   <xsl:template name="organizationEntry"
                 match="//(zorgaanbieder[not(zorgaanbieder)] | healthcare_provider[not(healthcare_provider)] | payer/insurance_company)"
                 mode="doOrganizationEntry-2.0">
      <!-- Produces a FHIR entry element with an Organization resource -->
      <xsl:param name="uuid"
                 select="false()"
                 as="xs:boolean">
         <!-- 
            If false and (zorgaanbieder_identificatie_nummer | healthcare_provider_identification_number) generate from that. 
            Otherwise generate uuid from scratch. 
            Generating a UUID from scratch limits reproduction of the same output as the UUIDs will be different every time.
         -->
      </xsl:param>
      <xsl:param name="entryFullUrl">
         <!-- Optional. Value for the entry.fullUrl -->
         <xsl:choose>
            <xsl:when test="$uuid or empty(zorgaanbieder_identificatienummer | zorgaanbieder_identificatie_nummer | healthcare_provider_identification_number | identification_number)">
               <xsl:value-of select="nf:get-fhir-uuid(.)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="nf:getUriFromAdaId(nf:ada-za-id(zorgaanbieder_identificatienummer | zorgaanbieder_identificatie_nummer | healthcare_provider_identification_number | identification_number), 'Organization', false())"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:param>
      <xsl:param name="fhirResourceId">
         <!-- Optional. Value for the entry.resource.Organization.id -->
         <xsl:choose>
            <xsl:when test="$referById">
               <xsl:variable name="zaIdentification"
                             as="element()*"
                             select="(zorgaanbieder_identificatienummer | zorgaanbieder_identificatie_nummer | healthcare_provider_identification_number | identification_number)[@value | @root]"/>
               <xsl:choose>
                  <xsl:when test="$uuid">
                     <xsl:value-of select="nf:removeSpecialCharacters(replace($entryFullUrl, 'urn:[^i]*id:', ''))"/>
                  </xsl:when>
                  <xsl:when test="$zaIdentification">
                     <!--                        <xsl:value-of select="(upper-case(nf:removeSpecialCharacters(string-join($zaIdentification[1]/(@root | @value), ''))))"/>-->
                     <!-- string-join follows order of @value / @root in XML, but we want a predictable order -->
                     <xsl:value-of select="(upper-case(nf:removeSpecialCharacters(concat($zaIdentification[1]/@root, '-', $zaIdentification[1]/@value))))"/>
                  </xsl:when>
                  <!-- AWE, in some rare cases this does not give a unique resource id -->
                  <!--<xsl:otherwise>
                        <xsl:value-of select="(upper-case(nf:removeSpecialCharacters(string-join(./*/@value, ''))))"/>
                        </xsl:otherwise>-->
                  <!-- so fall back on entryFullUrl instead -->
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
            <xsl:call-template name="nl-core-organization-2.0">
               <xsl:with-param name="in"
                               select="."/>
               <xsl:with-param name="logicalId"
                               select="$fhirResourceId"/>
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
   <xsl:template name="nl-core-organization-2.0"
                 match="//(zorgaanbieder[not(zorgaanbieder)] | healthcare_provider[not(healthcare_provider)] | payer/insurance_company)"
                 mode="doOrganizationResource-2.0">
      <xsl:param name="in"
                 as="element()?">
         <!-- Node to consider in the creation of an Organization resource -->
      </xsl:param>
      <xsl:param name="logicalId"
                 as="xs:string?">
         <!-- Organization.id value -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:variable name="resource">
            <xsl:variable name="profileValue">
               <xsl:choose>
                  <xsl:when test="ancestor::beschikbaarstellen_verstrekkingenvertaling">http://nictiz.nl/fhir/StructureDefinition/mp612-DispenseToFHIRConversion-Organization</xsl:when>
                  <xsl:otherwise>http://fhir.nl/fhir/StructureDefinition/nl-core-organization</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <Organization>
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
               <xsl:for-each select="(zorgaanbieder_identificatienummer | zorgaanbieder_identificatie_nummer | healthcare_provider_identification_number | identification_number | zibroot/identificatienummer | hcimroot/identification_number)[@value]">
                  <identifier>
                     <xsl:call-template name="id-to-Identifier">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </identifier>
               </xsl:for-each>
               <!-- type -->
               <xsl:for-each select="organization_type | organisatie_type | department_specialty | afdeling_specialisme">
                  <xsl:variable name="display"
                                select="@displayName[not(. = '')]"/>
                  <type>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="."/>
                        <xsl:with-param name="codeMap"
                                        as="element()*">
                           <xsl:for-each select="$orgRoleCodeMap">
                              <map>
                                 <xsl:attribute name="inCode"
                                                select="@hl7Code"/>
                                 <xsl:attribute name="inCodeSystem"
                                                select="@hl7CodeSystem"/>
                                 <xsl:attribute name="code"
                                                select="@hl7Code"/>
                                 <xsl:attribute name="codeSystem"
                                                select="@hl7CodeSystem"/>
                                 <!-- reuse original displayName -->
                                 <xsl:attribute name="displayName"
                                                select="($display, @displayName)[1]"/>
                              </map>
                           </xsl:for-each>
                        </xsl:with-param>
                     </xsl:call-template>
                  </type>
               </xsl:for-each>
               <!-- name -->
               <xsl:variable name="organizationName"
                             select="(organisatie_naam | organization_name)/@value"/>
               <xsl:variable name="organizationLocation"
                             select="(organisatie_locatie | organization_location)/@value"/>
               <xsl:if test="$organizationName | $organizationLocation">
                  <!-- Cardinality of ADA allows organizationLocation to be present without organizationName. This allows Organization.name to be the value of organizationLocation. This conforms to mapping of HCIM HealthcareProvider -->
                  <name value="{string-join(($organizationName, $organizationLocation)[not(. = '')],' - ')}"/>
               </xsl:if>
               <!-- J.D. - Noticed in zib2017 ADA project that in vanilla ADA contact and address are in a container with the same name. Filtering here ... -->
               <xsl:variable name="contact"
                             as="element()*">
                  <xsl:choose>
                     <xsl:when test="(contactgegevens | contact_information)/(contactgegevens | contact_information)">
                        <xsl:sequence select="(contactgegevens | contact_information)/(contactgegevens | contact_information)"/>
                     </xsl:when>
                     <!-- Add zib-Payer contact -->
                     <xsl:when test="self::insurance_company">
                        <xsl:sequence select="parent::payer/contact_information/contact_information"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:sequence select="contactgegevens | contact_information"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="address"
                             as="element()*">
                  <xsl:choose>
                     <xsl:when test="(adresgegevens | address_information)/(adresgegevens | address_information)">
                        <xsl:sequence select="(adresgegevens | address_information)/(adresgegevens | address_information)"/>
                     </xsl:when>
                     <!-- Add zib-Payer address -->
                     <xsl:when test="self::insurance_company">
                        <xsl:sequence select="parent::payer/address_information/address_information"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:sequence select="adresgegevens | address_information"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <!-- contactgegevens -->
               <!-- MM-2693 Filter private contact details -->
               <xsl:call-template name="nl-core-contactpoint-1.0">
                  <xsl:with-param name="in"
                                  select="$contact"/>
                  <xsl:with-param name="filterprivate"
                                  select="true()"
                                  as="xs:boolean"/>
               </xsl:call-template>
               <!-- address -->
               <!-- MM-2693 Filter private addresses -->
               <xsl:call-template name="nl-core-address-2.0">
                  <xsl:with-param name="in"
                                  select="$address[not((adres_soort | address_information)/tokenize(@code, '\s') ='HP')]"
                                  as="element()*"/>
               </xsl:call-template>
            </Organization>
         </xsl:variable>
         <!-- Add resource.text -->
         <xsl:apply-templates select="$resource"
                              mode="addNarrative"/>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>