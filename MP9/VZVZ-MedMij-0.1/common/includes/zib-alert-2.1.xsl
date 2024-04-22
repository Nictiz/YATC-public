<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="C:/Data/Erik/work/Nictiz/new/YATC-internal/ada-2-fhir/env/zibs2017/payload/zib-alert-2.1.xsl"?>
<?yatc-distribution-info name="VZVZ-MedMij" timestamp="2024-01-29T11:45:25.52+01:00" version="0.1"?>
<!-- == Provenance: C:/Data/Erik/work/Nictiz/new/YATC-internal/ada-2-fhir/env/zibs2017/payload/zib-alert-2.1.xsl == -->
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
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:param name="referById"
              as="xs:boolean"
              select="false()"/>
   <!-- ================================================================== -->
   <xsl:template name="alertReference"
                 match="alert[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)]"
                 mode="doAlertReference-2.1">
      <!-- Returns contents of Reference datatype element -->
      <xsl:variable name="theIdentifier"
                    select="identificatie_nummer[@value] | identification_number[@value]"/>
      <xsl:variable name="theGroupKey"
                    select="nf:getGroupingKeyDefault(.)"/>
      <xsl:variable name="theGroupElement"
                    select="$alerts[group-key = $theGroupKey]"
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
   <xsl:template name="alertEntry"
                 match="alert[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)]"
                 mode="doAlertEntry-2.1"
                 as="element(f:entry)">
      <!-- Produces a FHIR entry element with a Flag resource for Alert -->
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
      <xsl:param name="entryFullUrl"
                 select="nf:get-fhir-uuid(.)">
         <!-- Optional. Value for the entry.fullUrl -->
      </xsl:param>
      <xsl:param name="fhirResourceId">
         <!-- Optional. Value for the entry.resource.Flag.id -->
         <xsl:if test="$referById">
            <xsl:choose>
               <xsl:when test="not($uuid) and string-length(nf:removeSpecialCharacters((zibroot/identificatienummer | hcimroot/identification_number)/@value)) gt 0">
                  <xsl:value-of select="nf:removeSpecialCharacters(string-join((zibroot/identificatienummer | hcimroot/identification_number)/@value, ''))"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="nf:removeSpecialCharacters(replace($entryFullUrl, 'urn:[^i]*id:', ''))"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
      </xsl:param>
      <xsl:param name="searchMode"
                 select="'include'">
         <!-- Optional. Value for entry.search.mode. Default: include -->
      </xsl:param>
      <entry>
         <fullUrl value="{$entryFullUrl}"/>
         <resource>
            <xsl:call-template name="zib-Alert-2.1">
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
   <xsl:template name="zib-Alert-2.1"
                 match="alert[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)]"
                 as="element()"
                 mode="doZibAlert-2.1">
      <!-- Mapping of HCIM Alert concept in ADA to FHIR resource zib-Alert. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- Node to consider in the creation of the Flag resource for Alert. -->
      </xsl:param>
      <xsl:param name="logicalId"
                 as="xs:string?">
         <!-- Optional FHIR logical id for the patient record. -->
      </xsl:param>
      <xsl:param name="adaPatient"
                 select="(ancestor::*/patient[*//@value] | ancestor::*/bundle/subject/patient[*//@value])[1]"
                 as="element()">
         <!-- The ada patient that is subject of this Alert. -->
      </xsl:param>
      <xsl:param name="dateT"
                 as="xs:date?">
         <!-- Optional. dateT may be given for relative dates, only applicable for test instances -->
      </xsl:param>
      <xsl:for-each select="$in">
         <xsl:variable name="resource">
            <xsl:variable name="profileValue">http://nictiz.nl/fhir/StructureDefinition/zib-Alert</xsl:variable>
            <Flag>
               <xsl:if test="string-length($logicalId) gt 0">
                  <id value="{nf:make-fhir-logicalid(tokenize($profileValue, './')[last()], $logicalId)}"/>
               </xsl:if>
               <meta>
                  <profile value="{$profileValue}"/>
               </meta>
               <xsl:for-each select="conditie/probleem | condition/problem">
                  <xsl:choose>
                     <xsl:when test="*">
                        <extension url="http://hl7.org/fhir/StructureDefinition/flag-detail">
                           <valueReference>
                              <xsl:apply-templates select="."
                                                   mode="doProblemReference-3.0"/>
                           </valueReference>
                        </extension>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:for-each select="nf:ada-resolve-reference(.)">
                           <extension url="http://hl7.org/fhir/StructureDefinition/flag-detail">
                              <valueReference>
                                 <xsl:call-template name="_doReference">
                                    <xsl:with-param name="ResourceType">Condition</xsl:with-param>
                                 </xsl:call-template>
                              </valueReference>
                           </extension>
                        </xsl:for-each>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
               <xsl:for-each select="zibroot/identificatienummer | hcimroot/identification_number">
                  <identifier>
                     <xsl:call-template name="id-to-Identifier">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </identifier>
               </xsl:for-each>
               <!-- status does not exist in zib but is 1..1 in FHIR profile (not possible to add data-absent-reason due to required binding) -->
               <status value="active"/>
               <xsl:for-each select="alert_type[@code]">
                  <category>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </category>
               </xsl:for-each>
               <!-- code is 1..1 in FHIR profile, in zib either alert_naam or reference to problem should exist -->
               <code>
                  <xsl:variable name="nullFlavorsInValueset"
                                select="('OTH')"/>
                  <xsl:choose>
                     <xsl:when test="(alert_naam | alert_name)[@code]">
                        <xsl:call-template name="code-to-CodeableConcept">
                           <xsl:with-param name="in"
                                           select="alert_naam | alert_name"/>
                           <xsl:with-param name="treatNullFlavorAsCoding"
                                           select="(alert_naam | alert_name)/@code = $nullFlavorsInValueset and (alert_naam | alert_name)/@codeSystem = $oidHL7NullFlavor"/>
                        </xsl:call-template>
                     </xsl:when>
                     <xsl:otherwise>
                        <extension url="http://hl7.org/fhir/StructureDefinition/data-absent-reason">
                           <valueCode value="unknown"/>
                        </extension>
                     </xsl:otherwise>
                  </xsl:choose>
               </code>
               <!-- Patient reference -->
               <subject>
                  <xsl:apply-templates select="$adaPatient"
                                       mode="doPatientReference-2.1"/>
               </subject>
               <xsl:for-each select="(begin_datum_tijd | start_date_time)[@value]">
                  <period>
                     <start>
                        <xsl:attribute name="value">
                           <xsl:call-template name="format2FHIRDate">
                              <xsl:with-param name="dateTime"
                                              select="xs:string(@value)"/>
                              <xsl:with-param name="dateT"
                                              select="$dateT"/>
                           </xsl:call-template>
                        </xsl:attribute>
                     </start>
                  </period>
               </xsl:for-each>
            </Flag>
         </xsl:variable>
         <!-- Add resource.text -->
         <xsl:apply-templates select="$resource"
                              mode="addNarrative"/>
      </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>