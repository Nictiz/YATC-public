<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="urn:hl7:utilities" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="#local.2023041908255624416880200" xmlns:nm="http://www.nictiz.nl/mappings" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- ================================================================== -->
    <!--
        This XSL was created to facilitate mapping from ADA MP9-transaction, to HL7 FHIR profiles.
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

    <xsl:import href="../../2_fhir_mp92_include.xsl"/>
    <xsl:import href="../../../../fhir/2_fhir_BundleEntryRequest.xsl"/>

    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- If the desired output is to be a Bundle, then a self link string of type url is required. 
         See: https://www.hl7.org/fhir/search.html#conformance -->
    <xsl:param name="bundleSelfLink" as="xs:string?"/>
    <!-- only give dateT a value if you want conversion of relative T dates to actual dates, otherwise a Touchstone relative T-date string will be generated -->
    <!--    <xsl:param name="dateT" as="xs:date?" select="current-date()"/>-->
    <!--        <xsl:param name="dateT" as="xs:date?" select="xs:date('2020-03-24')"/>-->
    <xsl:param name="dateT" as="xs:date?"/>
    <!-- pass an appropriate macAddress to ensure uniqueness of the UUID -->
    <!-- 02-00-00-00-00-00 may not be used in a production situation -->
    <xsl:param name="macAddress">02-00-00-00-00-00</xsl:param>
    <!-- parameter for debug level -->
    <xsl:param name="logLevel" select="$logWARN" as="xs:string"/>
    <!-- select="$oidBurgerservicenummer" zorgt voor maskeren BSN -->
    <xsl:param name="mask-ids" as="xs:string?" select="$oidBurgerservicenummer"/>
    <!-- parameter to determine whether to refer by resource/id -->
    <!-- should be false when there is no FHIR server available to retrieve the resources -->
    <xsl:param name="referById" as="xs:boolean" select="false()"/>
    <!-- The meta tag to be added. Optional. Typical use case is 'actionable' for prescriptions or proposals. Empty for informational purposes. -->
    <xsl:param name="metaTag" as="xs:string?">actionable</xsl:param>

    <!-- whether or nog to output schema / schematron links -->
    <xsl:param name="schematronXsdLinkInOutput" as="xs:boolean?" select="false()"/>

    <!-- ================================================================== -->

    <xsl:template match="/">
        <!-- Start conversion. Handle interaction specific stuff for "sturen_antwoord_voorstel_verstrekkingsverzoek". -->
        <xsl:call-template name="antwoordVoorstelMedicatieafspraak920">
            <xsl:with-param name="in" select="//sturen_antwoord_voorstel_medicatieafspraak/voorstel_gegevens"/>
        </xsl:call-template>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template name="antwoordVoorstelMedicatieafspraak920">
        <!-- Build a FHIR Resource -->
        <xsl:param name="in">
            <!-- ada voorstel_gegevens -->
        </xsl:param>

        <xsl:for-each select="$in">
            <xsl:if test="$schematronXsdLinkInOutput">
                <xsl:processing-instruction name="xml-model">href="http://hl7.org/fhir/R4/bundle.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
            </xsl:if>
            <Bundle xsl:exclude-result-prefixes="#all" xmlns="http://hl7.org/fhir">
                <xsl:if test="$schematronXsdLinkInOutput">
                    <xsl:attribute name="xsi:schemaLocation">http://hl7.org/fhir https://hl7.org/fhir/R4/bundle.xsd</xsl:attribute>
                </xsl:if>
                <id value="{nf:get-uuid(*[1])}"/>
                <meta>
                    <profile value="{nf:get-full-profilename-from-adaelement($in/..)}"/>
                </meta>
                <type value="transaction"/>
                <xsl:choose>
                    <xsl:when test="$bundleSelfLink[not(. = '')]">
                        <link>
                            <relation value="self"/>
                            <url value="{$bundleSelfLink}"/>
                        </link>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="util:logMessage">
                            <xsl:with-param name="level" select="$logWARN"/>
                            <xsl:with-param name="msg">Parameter bundleSelfLink is empty, but server SHALL return the parameters that were actually used to process the search.</xsl:with-param>
                            <xsl:with-param name="terminate" select="false()"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:apply-templates select="$bouwstenen-920" mode="addBundleEntrySearchOrRequest"/>

                <!-- common entries (patient, practitioners, organizations, practitionerroles, products, locations -->
                <xsl:apply-templates select="$commonEntries" mode="addBundleEntrySearchOrRequest"/>
            </Bundle>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
