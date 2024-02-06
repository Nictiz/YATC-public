<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/YATC-internal/ada-2-fhir/env/zibs2017/payload/nl-core-practitioner-2.0.xsl"?>
<?yatc-distribution-info name="VZVZ-MedMij" timestamp="2024-02-06T09:13:30.86+01:00" version="0.2"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/YATC-internal/ada-2-fhir/env/zibs2017/payload/nl-core-practitioner-2.0.xsl == -->
<!-- == Distribution: VZVZ-MedMij; 0.2; 2024-02-06T09:13:30.86+01:00 == -->
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
   <!-- import because we want to be able to override the param for macAddress for UUID generation -->
   <!--    <xsl:import href="all-zibs.xsl"/>-->
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:param name="referById"
              as="xs:boolean"
              select="false()"/>
   <xsl:variable name="practitioners"
                 as="element()*">
      <xsl:variable name="healthProfessional"
                    select="//(zorgverlener[not(zorgverlener)] | health_professional[not(health_professional)])"/>
      <!-- Zorgverleners in Practitioners -->
      <!-- AWE: the commented out version makes two different groups when @value and @root are in different order in the ada xml -->
      <!-- This causes two or more entries with an identical grouping-key, causing problems with identical practitioners with same fullUrl in a Bundle... -->
      <!-- <xsl:for-each-group select="//(zorgverlener[not(zorgverlener)][not(@datatype = 'reference')] | health_professional[not(health_professional)])[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)]" group-by="
                string-join(for $att in nf:ada-zvl-id(zorgverlener_identificatienummer | zorgverlener_identificatie_nummer | health_professional_identification_number)/(@root, @value)
                return
                    $att, '')">-->
      <xsl:for-each-group select="$healthProfessional[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)]"
                          group-by="             concat(nf:ada-zvl-id(zorgverlener_identificatienummer | zorgverlener_identificatie_nummer | health_professional_identification_number)/@root,             nf:ada-zvl-id(zorgverlener_identificatienummer | zorgverlener_identificatie_nummer | health_professional_identification_number)/normalize-space(@value))">
         <xsl:for-each-group select="current-group()"
                             group-by="nf:getGroupingKeyPractitioner(.)">
            <!-- uuid als fullUrl en ook een fhir id genereren vanaf de tweede groep -->
            <xsl:variable name="uuid"
                          as="xs:boolean"
                          select="position() &gt; 1"/>
            <unieke-zorgverlener xmlns="">
               <group-key>
                  <xsl:value-of select="current-grouping-key()"/>
               </group-key>
               <reference-display>
                  <xsl:value-of select="nf:get-practitioner-display(current-group()[1])"/>
               </reference-display>
               <xsl:call-template name="practitionerEntry">
                  <xsl:with-param name="uuid"
                                  select="$uuid"/>
               </xsl:call-template>
            </unieke-zorgverlener>
         </xsl:for-each-group>
      </xsl:for-each-group>
   </xsl:variable>
   <!-- ================================================================== -->
   <xsl:template name="practitionerReference"
                 match="zorgverlener[not(zorgverlener)] | health_professional[not(health_professional)]"
                 mode="doPractitionerReference-2.0"
                 as="element()*">
      <!-- Returns contents of Reference datatype element -->
      <xsl:variable name="theIdentifier"
                    select="zorgverlener_identificatienummer[@value] | zorgverlener_identificatie_nummer[@value] | health_professional_identification_number[@value]"/>
      <xsl:variable name="theGroupKey"
                    select="nf:getGroupingKeyPractitioner(.)"/>
      <xsl:variable name="theGroupElement"
                    select="$practitioners[group-key = $theGroupKey]"
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
   <xsl:template name="practitionerEntry"
                 match="zorgverlener[not(zorgverlener)][*] | health_professional[not(health_professional)][*]"
                 mode="doPractitionerEntry-2.0">
      <!-- Produces a FHIR entry element with a Practitioner resource for HealthProfessional -->
      <xsl:param name="uuid"
                 select="false()"
                 as="xs:boolean">
         <!-- If false and (zorgverlener_identificatie_nummer | health_professional_identification_number) generate from that. Otherwise generate uuid from scratch. Generating a uuid from scratch limits reproduction of the same output as the uuids will be different every time. -->
      </xsl:param>
      <xsl:param name="entryFullUrl">
         <!-- Optional. Value for the entry.fullUrl -->
         <xsl:choose>
            <xsl:when test="$uuid or empty(zorgverlener_identificatienummer | zorgverlener_identificatie_nummer | health_professional_identification_number)">
               <!-- let's use the practitioner node without specialty and organization to determine uuid, 
                        this way the practitionerrole uuid generation can use the whole zorgverlener element for its uuid and not conflict with the one for practitioner -->
               <xsl:variable name="healthProNoOrganization"
                             as="element()?">
                  <xsl:apply-templates select="."
                                       mode="copy4PractitionerKey"/>
               </xsl:variable>
               <xsl:value-of select="nf:get-fhir-uuid($healthProNoOrganization)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="nf:getUriFromAdaId(nf:ada-zvl-id(zorgverlener_identificatienummer | zorgverlener_identificatie_nummer | health_professional_identification_number), 'Practitioner', false())"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:param>
      <xsl:param name="fhirResourceId">
         <!-- Optional. Value for the entry.resource.Practitioner.id -->
         <xsl:choose>
            <xsl:when test="$referById">
               <xsl:variable name="zvlIdentification"
                             as="element()*"
                             select="(zorgverlener_identificatienummer | zorgverlener_identificatie_nummer | health_professional_identification_number)[@value | @root]"/>
               <xsl:choose>
                  <xsl:when test="$uuid">
                     <xsl:value-of select="nf:removeSpecialCharacters(replace($entryFullUrl, 'urn:[^i]*id:', ''))"/>
                  </xsl:when>
                  <xsl:when test="$zvlIdentification">
                     <!--                        <xsl:value-of select="(upper-case(nf:removeSpecialCharacters(string-join((zorgverlener_identificatienummer | zorgverlener_identificatie_nummer | health_professional_identification_number)[1]/(@root | @value), ''))))"/>-->
                     <!-- string-join follows order of @value / @root in XML, but we want a predictable order -->
                     <xsl:value-of select="(upper-case(nf:removeSpecialCharacters(concat($zvlIdentification[1]/@root, '-', $zvlIdentification[1]/@value))))"/>
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
            <xsl:call-template name="nl-core-practitioner-2.0">
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
   <xsl:template name="nl-core-practitioner-2.0"
                 match="zorgverlener[not(zorgverlener)] | health_professional[not(health_professional)]"
                 mode="doPractitionerResource-2.0">
      <!-- Mapping of HCIM HealthProfessional concept in ADA to FHIR resource nl-core-practitioner. -->
      <xsl:param name="in"
                 as="element()?">
         <!-- Node to consider in the creation of the Practitioner resource for HealthProfessional. -->
      </xsl:param>
      <xsl:param name="logicalId"
                 as="xs:string?">
         <!-- Optional FHIR logical id for the record. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:variable name="resource">
            <xsl:variable name="profileValue">http://fhir.nl/fhir/StructureDefinition/nl-core-practitioner</xsl:variable>
            <Practitioner>
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
               <xsl:for-each select="(zorgverlener_identificatienummer | zorgverlener_identificatie_nummer | health_professional_identification_number)[@value]">
                  <identifier>
                     <xsl:call-template name="id-to-Identifier">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </identifier>
               </xsl:for-each>
               <xsl:for-each select="zibroot/identificatienummer | hcimroot/identification_number">
                  <identifier>
                     <xsl:call-template name="id-to-Identifier">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </identifier>
               </xsl:for-each>
               <!-- in some data sets the name_information is unfortunately unnecessarily nested in an extra group, hence the extra predicate -->
               <xsl:for-each select=".//(naamgegevens[not(naamgegevens)] | name_information[not(name_information)])[not(ancestor::patient)]">
                  <xsl:call-template name="nl-core-humanname-2.0">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- in some data sets the contact_information is unfortunately unnecessarily nested in an extra group, hence the extra predicate -->
               <!-- MM-2693 Filter private contact details -->
               <xsl:for-each select=".//(contactgegevens[not(contactgegevens)] | contact_information[not(contact_information)])[not(ancestor::patient)]">
                  <xsl:call-template name="nl-core-contactpoint-1.0">
                     <xsl:with-param name="in"
                                     select="."/>
                     <xsl:with-param name="filterprivate"
                                     select="true()"
                                     as="xs:boolean"/>
                  </xsl:call-template>
               </xsl:for-each>
               <!-- in some data sets the address_information is unfortunately unnecessarily nested in an extra group, hence the extra predicate -->
               <!-- MM-2693 Filter private addresses -->
               <xsl:for-each select=".//(adresgegevens[not(adresgegevens)][not(adres_soort/tokenize(@code, '\s') ='HP')] | address_information[not(address_information)][not(address_type/tokenize(@code, '\s') ='HP')])[not(ancestor::patient)]">
                  <xsl:call-template name="nl-core-address-2.0">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </xsl:for-each>
            </Practitioner>
         </xsl:variable>
         <!-- Add resource.text -->
         <xsl:apply-templates select="$resource"
                              mode="addNarrative"/>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="@* | node()"
                 mode="copy4PractitionerKey">
      <!-- Default copy Template -->
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"
                              mode="copy4PractitionerKey"/>
      </xsl:copy>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="zorgaanbieder | healthcare_provider | specialisme | specialty | zorgverlener_rol | health_professional_role"
                 mode="copy4PractitionerKey">
      <!-- Do not copy the organization, specialty and role as they are not in FHIR Practitioner resource, so should not be part of duplicate detection -->
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:getGroupingKeyPractitioner"
                 as="xs:string?">
      <!-- If  holds a value, return the upper-cased combined string of @value/@root/@code/@codeSystem/@nullFlavor on the health_professional_identification_number/name_information/address_information/contact_information. Else return empty.
            There is a specific function for determining uniqueness of healthProfessional, because it also may hold information about the organization, which should not be taken into account for determining uniqueness (that information is in FHIR resource practitionerRole) -->
      <xsl:param name="healthProfessional"
                 as="element()?"/>
      <xsl:if test="$healthProfessional">
         <!-- MM-1437 allow for more than one healthProfessional identification / name / address / contact details -->
         <!-- let's just select the professional and leave out the healthcareProvider, role and specialism, we don't want those to determine uniqueness -->
         <xsl:variable name="healthPro4Key"
                       as="element()?">
            <xsl:apply-templates select="$healthProfessional"
                                 mode="copy4PractitionerKey"/>
         </xsl:variable>
         <xsl:value-of select="nf:getGroupingKeyDefault($healthPro4Key)"/>
      </xsl:if>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:get-stable-fhir-logical-id"
                 as="xs:string?">
      <!-- If  holds a value, return the upper-cased combined string of @value/@root/@code/@codeSystem/@nullFlavor on the health_professional_identification_number/last_name_information. Else return empty -->
      <xsl:param name="healthProfessional"
                 as="element()?"/>
      <xsl:if test="$healthProfessional">
         <xsl:variable name="personIdentifier"
                       select="nf:getValueAttrDefault($healthProfessional/zorgverlener_identificatienummer | $healthProfessional/zorgverlener_identificatie_nummer | $healthProfessional/health_professional_identification_number)"/>
         <xsl:variable name="personName"
                       select="nf:getValueAttrDefault($healthProfessional/zorgverlener_naam | $healthProfessional/naamgegevens/geslachtsnaam/achternaam | $healthProfessional/name_information/last_name/last_name)"/>
         <xsl:value-of select="concat($personIdentifier, $personName)"/>
      </xsl:if>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:getValueAttrPractitioner"
                 as="xs:string?">
      <!-- If  holds a value, return the upper-cased combined string of @value/@root/@code/@codeSystem/@nullFlavor on the health_professional_identification_number/name_information/address_information/contact_information. Else return empty -->
      <xsl:param name="healthProfessional"
                 as="element()?"/>
      <xsl:if test="$healthProfessional">
         <xsl:variable name="personIdentifier"
                       select="nf:getValueAttrDefault($healthProfessional/zorgverlener_identificatienummer | $healthProfessional/zorgverlener_identificatie_nummer | $healthProfessional/health_professional_identification_number)"/>
         <xsl:variable name="personName"
                       select="nf:getValueAttrDefault($healthProfessional/zorgverlener_naam | $healthProfessional/naamgegevens | $healthProfessional/name_information)"/>
         <xsl:variable name="personAddress"
                       select="nf:getValueAttrDefault($healthProfessional/adres | $healthProfessional/adresgegevens | $healthProfessional/address_information)"/>
         <xsl:variable name="contactInformation"
                       select="nf:getValueAttrDefault($healthProfessional/telefoon_email | $healthProfessional/contactgegevens | $healthProfessional/contact_information)"/>
         <xsl:value-of select="concat($personIdentifier, $personName, $personAddress, $contactInformation)"/>
      </xsl:if>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:get-practitioner-display"
                 as="xs:string?">
      <!-- If  holds a value, return a human readable string of health_professional_identification_number/name_information/organization_name/specialty/health_professional_role. Else return empty -->
      <xsl:param name="healthProfessional"
                 as="element()?"/>
      <xsl:for-each select="$healthProfessional">
         <xsl:variable name="personIdentifier"
                       select="nf:ada-zvl-id(.//zorgverlener_identificatienummer[1] | .//zorgverlener_identificatie_nummer[1] | .//health_professional_identification_number[1])/@value"/>
         <xsl:variable name="personName"
                       select=".//naamgegevens[not(naamgegevens)][not(ancestor::patient)][1]//*[not(name() = 'naamgebruik')]/@value | .//name_information[not(name_information)][not(ancestor::patient)][1]//*[not(name() = 'name_usage')]/@value"/>
         <xsl:variable name="organizationName"
                       select=".//organisatie_naam[1]/@value | .//organization_name[1]/@value"/>
         <xsl:variable name="specialty"
                       select=".//(specialisme | specialty)[not(@codeSystem = $oidHL7NullFlavor)][1]/@displayName"/>
         <xsl:variable name="role"
                       select=".//zorgverleners_rol/(@displayName, @code)[1] | .//health_professional_role/(@displayName, @code)[1]"/>
         <xsl:choose>
            <xsl:when test="$personName">
               <xsl:value-of select="normalize-space(string-join($personName, ' '))"/>
            </xsl:when>
            <xsl:when test="$role">
               <xsl:value-of select="normalize-space($role)"/>
            </xsl:when>
            <xsl:when test="$personIdentifier">
               <xsl:value-of select="normalize-space($personIdentifier)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
   </xsl:function>
</xsl:stylesheet>