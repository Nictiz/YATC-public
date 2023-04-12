<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:yatcp="https://nictiz.nl/ns/YATC-public" xmlns:local="#local.mp5_xfy_2wb" version="3.0" exclude-inline-prefixes="#all">
    <!-- ================================================================== -->
    <!-- 
       XProc module with generic code for use in the ada-2-fhir-r4 component of YATC-public.
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

    <p:declare-step type="yatcp:get-ada-2-fhir-r4-data">
        <!-- 
            This step retrieves the ada-2-fhir-r4 data and returns this on its result port as an XML document.
            - Processes XIncludes (if any) and validates the result
            - Finalizes (enhances) the output with all kinds of fully expanded directory/filenames, defaults filled in, etc.
            
            The result can optionally be pruned on application and version information. 
            
            There are situations in the calling code where this document might be already loaded. If so, pass this 
            already loaded document in the $ada2fhirr4Data parameter. If provided, this document will be passed 
            unchanged (and unchecked!).
        -->
        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <p:import href="../../../YATC-shared/xplmod/yatc-application-data.mod.xpl"/>
        <p:import href="component-parameter-names.mod.xpl"/>

        <p:output port="result" primary="true" sequence="false">
            <!-- The ADA retrieval data.  -->
        </p:output>

        <p:option name="parameters" as="map(xs:string, xs:string*)" required="true">
            <!-- The YATC parameters in effect. -->
        </p:option>

        <p:option name="ada2fhirr4Data" as="document-node()?" required="false" select="()">
            <!-- There are situations that we already might have retrieved this data. If so, pass 
                 this as a document using this option. Its contents will be returned unchanged. This means: unpruned
                 and unvalidated! It's up to the caller to make sure the information is correct!
            -->
        </p:option>

        <p:option name="application" as="xs:string?" required="false" select="()">
            <!-- Prune the document for all applications with a name that does not match $application.
                 If this option is empty or $yatcs:allIndicator, no pruning on application name will take place.
            -->
        </p:option>

        <p:option name="version" as="xs:string?" required="false" select="()">
            <!-- Prune the document for all applications with a version that does not match $version.
                 If this option is empty or $yatcp:allIndicator, no pruning on version will take place.
            -->
        </p:option>

        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <yatcs:get-application-data>
            <p:with-option name="parameters" select="$parameters"/>
            <p:with-option name="retrievedData" select="$ada2fhirr4Data"/>
            <p:with-option name="parnameDataDocument" select="$yatcp:parnameAda2fhirr4DataDocument"/>
            <p:with-option name="hrefSchema" select="resolve-uri('../xsd/ada-2-fhir-r4-data.xsd', static-base-uri())"/>
            <p:with-option name="hrefSchematron" select="resolve-uri('../sch/ada-2-fhir-r4-data.sch', static-base-uri())"/>
            <p:with-option name="hrefFinalizationStylesheet" select="resolve-uri('xsl-ada-2-fhir-r4.mod/finalize-ada-2-fhir-r4-data.xsl', static-base-uri())"/>
            <p:with-option name="application" select="$application"/>
            <p:with-option name="version" select="$version"/>
        </yatcs:get-application-data>

    </p:declare-step>

</p:library>
