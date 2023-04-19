<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908254790134020200" xmlns:xhtml="http://www.w3.org/1999/xhtml">
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

    <xsl:param name="generateInstructionText" as="xs:boolean?" select="true()"/>

    <xsl:param name="usecase" as="xs:string?"/>

    <!-- ================================================================== -->

    <xsl:template name="ext-RenderedDosageInstruction" mode="ext-RenderedDosageInstruction" match="gebruiksinstructie" as="element(f:extension)?">
        <!-- Create the ext-RenderedDosageInstruction extension from ADA InstructionsForUse. -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- The ADA instance to extract the rendered dosage instruction from. 
            Override for default function in mp-InstructionsForUse so that we can generate instruction text based on structured data. -->
        </xsl:param>

        <xsl:for-each select="$in">
            <xsl:for-each select="omschrijving[@value != '']">
                <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-RenderedDosageInstruction" xmlns="http://hl7.org/fhir">
                    <valueString>
                        <xsl:attribute name="value">
                            <xsl:choose>
                                <xsl:when test="$generateInstructionText">
                                    <xsl:value-of select="nf:gebruiksintructie-string(..)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@value"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </valueString>
                </extension>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template name="generateLogicalId" match="*" mode="generateLogicalId">
        <!-- Helper template for creating logicalId for Touchstone. Adheres to requirements in MM-1752. Profilename-usecase-uniquestring. -->
        <xsl:param name="in" as="element()?" select=".">
            <!-- The ada element for which to create a logical id. Optional. Used to find profileName. Defaults to context. -->
        </xsl:param>
        <xsl:param name="uniqueString" as="xs:string?">
            <!-- The unique string with which to create a logical id. Optional. If not given a uuid will be generated. -->
        </xsl:param>
        <!-- NOTE: this does not work if you have two ada element names which may end up in different FHIR profiles, the function simply selects the first one found -->
        <xsl:param name="profile" as="xs:string?" select="nf:get-profilename-from-adaelement($in)">
            <!--  -->
        </xsl:param>

        <xsl:variable name="logicalIdStartString" as="xs:string*">
            <xsl:choose>
                <xsl:when test="$profile = ($profilenameHealthcareProvider, $profilenameHealthcareProviderOrganization)">
                    <xsl:value-of select="replace(replace(replace($profile, 'HealthcareProvider', 'HPrv'), 'Organization', 'Org'), 'Location', 'Loc')"/>
                </xsl:when>
                <xsl:when test="$profile = ($profileNameHealthProfessionalPractitioner, $profileNameHealthProfessionalPractitionerRole)">
                    <xsl:value-of select="replace(replace(replace($profile, 'HealthProfessional', 'HPrf'), 'Practitioner', 'Prac'), 'Role', 'Rol')"/>
                </xsl:when>
                <xsl:when test="self::farmaceutisch_product">
                    <xsl:value-of select="replace($profile, 'PharmaceuticalProduct', 'PhPrd')"/>
                </xsl:when>
                <xsl:when test="self::medicatieafspraak | self::wisselend_doseerschema | self::verstrekkingsverzoek | self::toedieningsafspraak | self::medicatieverstrekking | self::medicatiegebruik | self::medicatietoediening">
                    <xsl:value-of select="replace(replace(replace(replace(replace(replace($profile, 'Agreement', 'Agr'), 'Medication', 'Med'), 'Administration', 'Adm'), 'Dispense', 'Dsp'), 'Request', 'Req'), 'VariableDosingRegimen', 'VarDosReg')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$profile"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$usecase"/>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="string-length($uniqueString) le $maxLengthFHIRLogicalId - 2 and string-length($uniqueString) gt 0">
                <xsl:value-of select="replace(nf:assure-logicalid-length(nf:assure-logicalid-chars(concat(string-join($logicalIdStartString, '-'), '-', $uniqueString))), '\.', '-')"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- we do not have anything to create a stable logicalId, lets return a UUID -->
                <xsl:value-of select="nf:assure-logicalid-length(nf:assure-logicalid-chars(concat(string-join($logicalIdStartString, '-'), '-', uuid:get-uuid(.))))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:function name="uuid:generate-timestamp">
        <!--  Generates a timestamp of the amount of 100 nanosecond intervals from 15 October 1582, in UTC time.
        Override this function here to use a stable timestamp in order to create stable uuids -->
        <xsl:param name="node">
            <!--  -->
        </xsl:param>
        <!-- date calculation automatically goes correct when you add the timezone information, in this case that is UTC. -->
        <xsl:variable name="duration-from-1582" as="xs:dayTimeDuration">
            <!-- fixed date for stable uuid for test purposes -->
            <xsl:sequence select="xs:dateTime('2022-01-01T00:00:00.000Z') - xs:dateTime('1582-10-15T00:00:00.000Z')"/>
        </xsl:variable>
        <xsl:variable name="random-offset" as="xs:integer">
            <xsl:sequence select="uuid:next-nr($node) mod 10000"/>
        </xsl:variable>
        <!-- do the math to get the 100 nano second intervals -->
        <xsl:sequence select="(days-from-duration($duration-from-1582) * 24 * 60 * 60 + hours-from-duration($duration-from-1582) * 60 * 60 + minutes-from-duration($duration-from-1582) * 60 + seconds-from-duration($duration-from-1582)) * 1000 * 10000 + $random-offset"/>
    </xsl:function>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:function name="uuid:generate-clock-id" as="xs:string">
        <!-- Override this function here to use a stable timestamp in order to create stable uuids -->
        <xsl:sequence select="'0000'"/>
    </xsl:function>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="*" mode="doResourceInResultdoc">
        <!-- Creates xml document for a FHIR resource -->
        <xsl:param name="outputDir" select="'.'">
            <!-- The outputDir for the resource, defaults to 'current dir'. -->
        </xsl:param>
        <xsl:result-document href="{$outputDir}/{f:id/@value}.xml">
            <xsl:copy-of select="."/>
        </xsl:result-document>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="medicatieafspraak | wisselend_doseerschema | verstrekkingsverzoek | toedieningsafspraak | medicatieverstrekking | medicatiegebruik | medicatietoediening" mode="_generateId">
        <!-- Template to generate a unique id to identify this instance. Override the logicalId generation for our Touchstone resources with the goal to remove oids from filenames. -->
        <xsl:variable name="uniqueString" as="xs:string?">
            <xsl:choose>
                <xsl:when test="identificatie[@root][@value]">
                    <xsl:for-each select="(identificatie[@root][@value])[1]">
                        <!-- we remove '.' in root oid and '_' in extension to enlarge the chance of staying in 64 chars -->
                        <xsl:value-of select="replace(@value, '_', '')"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <!-- we do not have anything to create a stable logicalId, lets return a UUID -->
                    <xsl:value-of select="nf:get-uuid(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="generateLogicalId">
            <xsl:with-param name="uniqueString" select="$uniqueString"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
