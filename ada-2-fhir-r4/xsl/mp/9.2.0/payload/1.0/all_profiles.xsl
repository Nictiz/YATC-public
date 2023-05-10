<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="http://hl7.org/fhir" xmlns:nf="http://www.nictiz.nl/functions" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:uuid="http://www.uuid.org" xmlns:local="urn:fhir:stu3:functions" xmlns:nm="http://www.nictiz.nl/mappings">
    <!-- ================================================================== -->
    <!--
        This document imports common and mp specific functions and templates to convert mp ada instances to FHIR.
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

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:import href="../../../../zibs2020/payload/0.5-beta1/all_zibs.xsl"/>

    <xsl:import href="../../../../../../../YATC-shared/xsl/util/mp-functions.xsl"/>

    <xsl:import href="mp-AdministrationAgreement.xsl"/>
    <xsl:import href="mp-DispenseRequest.xsl"/>
    <xsl:import href="mp-InstructionsForUse.xsl"/>
    <xsl:import href="mp-MedicationAdministration2.xsl"/>
    <xsl:import href="mp-MedicationAgreement.xsl"/>
    <xsl:import href="mp-MedicationDispense.xsl"/>
    <xsl:import href="mp-MedicationUse2.xsl"/>
    <xsl:import href="mp-VariableDosingRegimen.xsl"/>

    <xsl:import href="ext-AsAgreedIndicator.xsl"/>
    <xsl:import href="ext-PharmaceuticalTreatmentIdentifier.xsl"/>
    <xsl:import href="ext-MedicationAgreementPeriodOfUseCondition.xsl"/>

</xsl:stylesheet>
