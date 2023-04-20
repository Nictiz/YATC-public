<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:yatcp="https://nictiz.nl/ns/YATC-public" xmlns:local="#local.kbc_1my_2wb" version="3.0" exclude-inline-prefixes="#all">
    <!-- ================================================================== -->
    <!-- 
       Test driver for the <yatcp:get-ada-2-fhir-r4-data> step in ../ada-2-fhir-r4.mod.xpl
    -->
    <!-- ======================================================================= -->
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
    <!-- ======================================================================= -->
    <!-- IMPORTS: -->

    <p:import href="../../../../YATC-shared/xplmod/yatc-general.mod.xpl"/>
    <p:import href="../../../../YATC-shared/xplmod/yatc-parameters.mod.xpl"/>
    <p:import href="../ada-2-fhir-r4.mod.xpl"/>

    <!-- ======================================================================= -->
    <!-- PORTS: -->

    <p:output port="result" primary="true" sequence="false" content-types="xml" serialization="$yatcs:standardXmlSerialization">
        <!-- The retrieved document. -->
    </p:output>

    <!-- ======================================================================= -->

    <!-- Get the parameters on board: -->
    <yatcs:get-combined-parameters-map>
        <p:with-option name="callerStaticBaseUri" select="static-base-uri()"/>
    </yatcs:get-combined-parameters-map>
    <p:variable name="parameters" as="map(xs:string, xs:string*)" select="."/>

    <!-- Retrieve the document: -->
    <yatcp:get-ada-2-fhir-r4-data>
        <p:with-option name="parameters" select="$parameters"/>
        <p:with-option name="application" select="'lab'"/>
        <!--<p:with-option name="ada2WikiData" as="document-node()" select=".">
            <DOCUMENT/>
        </p:with-option>-->
    </yatcp:get-ada-2-fhir-r4-data>

</p:declare-step>
