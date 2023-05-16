<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:yatcp="https://nictiz.nl/ns/YATC-public" xmlns:xvrl="http://www.xproc.org/ns/xvrl" xmlns:local="#local.uqk_swy_2wb" version="3.0" exclude-inline-prefixes="#all" type="yatcp:process-ada-2-fhir-r4" name="process-ada-2-fhir-r4">
    <!-- ================================================================== -->
    <!-- 
       This pipeline will perform the ada-2-fhir-r4 processing. 
       
       Remark: It acts as an identity step not because we need it but to make sure all processing takes place 
       in the right order. 
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

    <p:import href="../xplmod/component-parameter-names.mod.xpl"/>
    <p:import href="../xplmod/ada-2-fhir-r4.mod.xpl"/>
    <p:import href="../../../YATC-shared/xplmod/yatc-general.mod.xpl"/>
    <p:import href="../../../YATC-shared/xplmod/yatc-parameters.mod.xpl"/>
    <p:import href="../../../YATC-shared/xplmod/yatc-application-data.mod.xpl"/>

    <!-- ======================================================================= -->
    <!-- PORTS: -->

    <p:input port="source" primary="true" sequence="true" content-types="any">
        <p:empty/>
    </p:input>
    <p:output port="result" primary="true" sequence="true" content-types="any" pipe="source@process-ada-2-fhir-r4"/>

    <!-- ======================================================================= -->
    <!-- STATIC OPTIONS: -->

    <p:option static="true" name="ada-2-fhir-r4-debug" as="xs:boolean" select="false()">
        <!-- Set this to true to get some additional output/behavior for debugging purposes -->
    </p:option>

    <!-- Definition of the validation types (must be the same as the elements that trigger this action step): -->
    <p:option static="true" name="validationTypeSchema" as="xs:string" select="'validate-with-schema'"/>
    <p:option static="true" name="validationTypeSchematron" as="xs:string" select="'validate-with-schematron'"/>

    <!-- ======================================================================= -->
    <!-- OPTIONS: -->

    <p:option name="ada2fhirr4Data" as="document-node()?" required="false" select="()">
        <!-- There are situations that we already might have retrieved the relevant (and pruned!) ada-2-fhir-r4 data. 
             If so, pass this as a document using this option.
        -->
    </p:option>

    <p:option name="parameters" as="map(xs:string, xs:string*)?" required="false" select="()">
        <!-- Optional set of already retrieved YATC parameters in effect. -->
    </p:option>

    <p:option name="application" as="xs:string?" required="false" select="()">
        <!-- The application to retrieve the data for (for instance lab). 
             If you want all applications, leave this option empty or use $yatcs:allIndicator  
        -->
    </p:option>

    <p:option name="version" as="xs:string?" required="false" select="()">
        <!-- The version (for the application) to retrieve the data for (for instance 3.0.0). 
             If you want all versions, leave this option empty or use $yatcs:allIndicator  -->
    </p:option>

    <p:option name="setup" as="xs:boolean" required="false" select="true()">
        <!-- If true, the application's setup will be done (the <setup> elements processed). -->
    </p:option>

    <p:option name="actions" as="xs:string*" required="false" select="()">
        <!-- The list of actions to perform -->
    </p:option>


    <!-- ======================================================================= -->

    <p:declare-step type="local:ada-2-fhir-r4-for-application" name="ada-2-fhir-r4-for-application">
        <!-- Performs the ada-2-fhir-r4 processing for a single application/version combination, for instance lab/3.0.0.
             Input is the <yatcp:application> element from the ada-2-fhir-r4 data file for an application/version.
        -->
        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <p:input port="source" primary="true" sequence="false" content-types="xml">
            <!-- The <yatcp:application> element with the information about the data to retrieve. -->
        </p:input>

        <p:option name="parameters" as="map(xs:string, xs:string*)" required="true"/>
        <p:option name="setup" as="xs:boolean" required="true"/>
        <p:option name="actions" as="xs:string*" required="true"/>

        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <!-- Initialization/preparations: -->
        <p:variable name="application" as="xs:string" select="xs:string(/*/@name)"/>
        <p:variable name="version" as="xs:string" select="xs:string(/*/@version)"/>
        <p:variable name="storageBaseDirectory" as="xs:string" select="xs:string(/*/@_target-dir)"/>

        <p:identity message=""/>
        <p:identity message="* ada-2-fhir-r4 processing for {$application}/{$version}"/>
        <p:identity message="  * Application storage directory: &quot;{$storageBaseDirectory}&quot;"/>

        <yatcs:process-application-messages/>

        <!-- Perform the setup if requested: -->
        <p:if test="$setup" name="do-setups">
            <p:for-each name="setups">
                <p:with-input select="/*/yatcp:setup"/>
                <yatcs:process-setup-element reportCount="true" loadResults="false"/>
            </p:for-each>
        </p:if>

        <!-- Process the actions: -->
        <p:identity depends="do-setups">
            <p:with-input pipe="source@ada-2-fhir-r4-for-application"/>
        </p:identity>
        <p:variable name="defaultActionName" as="xs:string?" select="(/*/yatcp:action[xs:boolean((@default, false())[1])][1])/@name"/>
        <p:choose>
            <p:when test="empty($actions) and exists($defaultActionName)">
                <local:process-action-by-name>
                    <p:with-option name="actionName" select="$defaultActionName"/>
                    <p:with-option name="parameters" select="$parameters"/>
                </local:process-action-by-name>
            </p:when>
            <p:when test="exists($actions)">
                <p:for-each>
                    <p:with-input select="$actions">
                        <null/>
                    </p:with-input>
                    <p:variable name="actionName" as="xs:string" select="."/>
                    <local:process-action-by-name>
                        <p:with-input pipe="source@ada-2-fhir-r4-for-application"/>
                        <p:with-option name="actionName" select="$actionName"/>
                        <p:with-option name="parameters" select="$parameters"/>
                    </local:process-action-by-name>
                </p:for-each>
            </p:when>
            <p:otherwise>
                <p:identity message="  * No action(s) specified"/>
            </p:otherwise>
        </p:choose>

    </p:declare-step>

    <!-- ======================================================================= -->

    <p:declare-step type="local:process-action-by-name" name="process-action-by-name">
        <!-- Performs all the processing for a single action. The action must be passed in by name.
             If this action has any dependent actions (@depends-on), these will be executed first.
             A check is made for circular action references.
             The step itself acts as an identity step.
        -->
        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <p:input port="source" primary="true" sequence="false" content-types="xml">
            <!-- The <yatcp:application> element that holds the action to process. -->
        </p:input>
        <p:output port="result" sequence="false" content-types="xml" pipe="source@process-action-by-name"/>

        <p:option name="actionName" as="xs:string" required="true"/>
        <p:option name="parameters" as="map(xs:string, xs:string*)" required="true"/>
        <p:option name="dependencyParentActionName" as="xs:string?" required="false" select="()">
            <!-- If this action is executed as a dependency of another action (part of its @depends-on attribute),
                 pass the name of the parent action in this option. Used for reporting only. -->
        </p:option>
        <p:option name="previousDependencyActions" as="xs:string*" required="false" select="()">
            <!-- List of actions already executed. -->
        </p:option>

        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <!-- Check if this action exists at all: -->
        <p:if test="empty(/*/yatcp:action[@name eq $actionName])">
            <p:error code="yatcs:error">
                <p:with-input>
                    <p:inline content-type="text/plain" xml:space="preserve">Undefined action: "{$actionName}"</p:inline>
                </p:with-input>
            </p:error>
        </p:if>

        <!-- Check for circular actions (whether this action was already executed): -->
        <p:if test="$actionName = $previousDependencyActions">
            <p:error code="yatcs:error">
                <p:with-input>
                    <p:inline content-type="text/plain" xml:space="preserve">Circular action dependency: "{$actionName}" was already executed</p:inline>
                </p:with-input>
            </p:error>
        </p:if>

        <!-- Extract and gather some basic application-level things for this action/builds: -->
        <p:variable name="application" as="xs:string" select="xs:string(/*/@name)"/>
        <p:variable name="version" as="xs:string" select="xs:string(/*/@version)"/>
        <p:variable name="storageBaseDirectory" as="xs:string" select="xs:string(/*/@_target-dir)"/>
        <p:variable name="sourceProjectName" as="xs:string" select="xs:string((/*/@source-project-name, $application)[1])"/>

        <!-- Process the requested action: -->
        <p:for-each name="process-action">
            <p:with-input select="/*/yatcp:action[@name eq $actionName][1]"/>

            <!-- First, take care of the dependencies (if any): -->
            <p:variable name="dependencies" as="xs:string*" select="tokenize(string(/*/@depends-on), '\s+')[.]"/>
            <p:for-each>
                <p:with-input select="$dependencies">
                    <null/>
                </p:with-input>
                <p:variable name="mainActionName" as="xs:string" select="$actionName">
                    <!-- Remark: This copying of the action name shouldn't be necessary, but it works around a hard to trace bug... :( -->
                </p:variable>
                <p:variable name="dependentActionName" as="xs:string" select="."/>
                <local:process-action-by-name>
                    <p:with-input pipe="source@process-action-by-name"/>
                    <p:with-option name="actionName" select="$dependentActionName"/>
                    <p:with-option name="dependencyParentActionName" select="$mainActionName"/>
                    <p:with-option name="previousDependencyActions" select="($previousDependencyActions, $mainActionName)"/>
                    <p:with-option name="parameters" select="$parameters"/>
                </local:process-action-by-name>
            </p:for-each>

            <!-- Now go for this specific action: -->
            <p:identity>
                <p:with-input pipe="current@process-action"/>
            </p:identity>
            <p:identity message="  * Action {string-join((/*/@name, /*/@description), ' - ')}{if (exists($dependencyParentActionName)) then (' (dependency of ' || $dependencyParentActionName || ')') else ()} for {$application}/{$version}"/>

            <!-- Output any action specific messages up-front: -->
            <yatcs:process-application-messages>
                <p:with-option name="messagePrefix" select="'    * '"/>
            </yatcs:process-application-messages>

            <!-- Do the builds/steps in the action: -->
            <p:for-each>
                <p:with-input select="/*/yatcp:*"/>
                <p:choose>

                    <!-- Build (XSLT transformation) step: -->
                    <p:when test="exists(/*/self::yatcp:build)">
                        <local:process-action-build>
                            <p:with-option name="parameters" select="$parameters"/>
                            <p:with-option name="application" select="$application"/>
                            <p:with-option name="version" select="$version"/>
                            <p:with-option name="storageBaseDirectory" select="$storageBaseDirectory"/>
                            <p:with-option name="sourceProjectName" select="$sourceProjectName"/>
                        </local:process-action-build>
                    </p:when>

                    <p:when test="exists(/*/self::yatcp:validate-with-schema) or exists(/*/self::yatcp:validate-with-schematron)">
                        <local:process-action-validate>
                            <p:with-option name="parameters" select="$parameters"/>
                        </local:process-action-validate>
                    </p:when>

                    <p:when test="exists(/*/self::yatcp:copy)">
                        <local:process-action-copy>
                            <p:with-option name="parameters" select="$parameters"/>
                        </local:process-action-copy>
                    </p:when>

                    <!-- Unrecognized: -->
                    <p:otherwise>
                        <p:error code="yatcs:error">
                            <p:with-input>
                                <p:inline content-type="text/plain" xml:space="preserve">Unrecognized ada-2-fhir-r4 action build/step element: {local-name(/*)}</p:inline>
                            </p:with-input>
                        </p:error>
                    </p:otherwise>

                </p:choose>
            </p:for-each>

        </p:for-each>

    </p:declare-step>

    <!-- ======================================================================= -->

    <p:declare-step type="local:process-action-build" name="process-action-build">
        <!-- Processes a build step (<build> element) for an action.  
             The step itself acts as an identity step.
        -->
        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <p:input port="source" primary="true" sequence="false" content-types="xml">
            <!-- The <yatcp:build> element to process. -->
        </p:input>
        <p:output port="result" sequence="false" content-types="xml" pipe="source@process-action-build"/>

        <p:option name="parameters" as="map(xs:string, xs:string*)" required="true"/>
        <p:option name="application" as="xs:string" required="true"/>
        <p:option name="version" as="xs:string" required="true"/>
        <p:option name="storageBaseDirectory" as="xs:string" required="true"/>
        <p:option name="sourceProjectName" as="xs:string" required="true"/>

        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <p:variable name="buildName" as="xs:string" select="string((/*/@name, (local-name(/*) || ' ' || p:iteration-position() || '/' || p:iteration-size()))[1])"/>
        <p:variable name="hrefBuildStylesheet" as="xs:string" select="string(/*/yatcp:stylesheet/@href)"/>

        <!-- Identify the stylesheet to be used and check its availability:: -->
        <p:identity message="    * Build &quot;{$buildName}&quot;"/>
        <p:identity message="      * Stylesheet: &quot;{$hrefBuildStylesheet}&quot;"/>
        <p:if test="not(doc-available($hrefBuildStylesheet))">
            <p:error code="yatcs:error">
                <p:with-input>
                    <p:inline content-type="text/plain" xml:space="preserve">Build stylesheet not found or not well-formed: &quot;{$hrefBuildStylesheet}&quot;</p:inline>
                </p:with-input>
            </p:error>
        </p:if>

        <!-- Find out up-front what we have to do with the direct output of the stylesheet: -->
        <p:variable name="discardOutput" as="xs:boolean" select="exists(/*/yatcp:discard-output)"/>
        <p:variable name="multipleOutputs" select="not($discardOutput) and exists(/*/yatcp:output-documents)"/>
        <p:variable name="outputSpecification" as="xs:string?" select="
                if ($discardOutput) then () 
                else if ($multipleOutputs) then string(/*/yatcp:output-documents/@directory)
                else string-join((/*/yatcp:output-document/@directory, /*/yatcp:output-document/@name), '/')
             "/>

        <!-- Create the basic map with the stylesheet parameters. All these parameters are string values. -->
        <p:xslt>
            <p:with-input pipe="source@process-action-build"/>
            <p:with-input port="stylesheet" href="xsl-ada-2-fhir-r4/get-ada-2-fhir-r4-build-stylesheet-parameters.xsl"/>
            <p:with-option name="parameters" select="map{
                    'application': $application, 
                    'version': $version, 
                    'sourceProjectName': $sourceProjectName,
                    'buildName': $buildName,
                    'baseDirectory': $storageBaseDirectory
                }"/>
        </p:xslt>
        <p:variable name="buildStylesheetParameters" as="map(*)" select="."/>

        <!-- Now based on the type of input we have, run the stylesheet: -->
        <p:identity>
            <p:with-input pipe="source@process-action-build"/>
        </p:identity>
        <p:choose name="apply-build-stylesheet">

            <!-- No input document: -->
            <p:when test="exists(/*/yatcp:no-input)">
                <p:output port="result" primary="true" sequence="true"/>
                <p:output port="secondary" primary="false" sequence="true" pipe="secondary@apply-build-stylesheet-no-input"/>
                <p:xslt name="apply-build-stylesheet-no-input" message="      * No input document">
                    <p:with-input>
                        <dummy/>
                    </p:with-input>
                    <p:with-input port="stylesheet" href="{$hrefBuildStylesheet}"/>
                    <p:with-option name="parameters" select="$buildStylesheetParameters"/>
                </p:xslt>
                <!-- Set the correct base-uri for the direct output document (if not discarded): -->
                <p:if test="not($discardOutput)">
                    <p:choose>
                        <p:when test="$multipleOutputs">
                            <p:set-properties properties="map{'base-uri': string-join(($outputSpecification, 'no-input.xml'), '/')}"/>
                        </p:when>
                        <p:otherwise>
                            <p:set-properties properties="map{'base-uri': $outputSpecification}"/>
                        </p:otherwise>
                    </p:choose>
                </p:if>
            </p:when>

            <!-- A specific input document: -->
            <p:when test="exists(/*/yatcp:input-document)">
                <p:output port="result" primary="true" sequence="true"/>
                <p:output port="secondary" primary="false" sequence="true" pipe="secondary@apply-build-stylesheet-input-document"/>
                <p:variable name="inputFilename" select="string(/*/yatcp:input-document[1]/@name)"/>
                <p:variable name="inputUri" as="xs:string" select="string-join((/*/yatcp:input-document[1]/@directory, $inputFilename), '/')"/>
                <p:if test="not(doc-available($inputUri))">
                    <p:error code="yatcs:error">
                        <p:with-input>
                            <p:inline content-type="text/plain" xml:space="preserve">Input document for build not found or not well-formed: &quot;{$inputFilename}&quot;</p:inline>
                        </p:with-input>
                    </p:error>
                </p:if>
                <p:xslt name="apply-build-stylesheet-input-document" message="      * Input document &quot;{$inputFilename}&quot;">
                    <p:with-input href="{$inputUri}"/>
                    <p:with-input port="stylesheet" href="{$hrefBuildStylesheet}"/>
                    <p:with-option name="parameters" select="$buildStylesheetParameters"/>
                </p:xslt>
                <!-- Set the correct base-uri for the direct output document (if not discarded): -->
                <p:if test="not($discardOutput)">
                    <p:choose>
                        <p:when test="$multipleOutputs">
                            <p:set-properties properties="map{'base-uri': string-join(($outputSpecification, $inputFilename), '/')}"/>
                        </p:when>
                        <p:otherwise>
                            <p:set-properties properties="map{'base-uri': $outputSpecification}"/>
                        </p:otherwise>
                    </p:choose>
                </p:if>
            </p:when>

            <!-- Multiple input documents -->
            <p:when test="exists(/*/yatcp:input-documents)">
                <p:output port="result" primary="true" sequence="true" pipe="result@apply-build-stylesheet-input-documents"/>
                <p:output port="secondary" primary="false" sequence="true" pipe="secondary@apply-build-stylesheet-input-documents"/>
                <p:variable name="inputDocumentsElement" as="element(yatcp:input-documents)" select="/*/yatcp:input-documents[1]"/>
                <p:variable name="inputDirectory" as="xs:string" select="string($inputDocumentsElement/@directory)"/>
                <p:variable name="acceptEmpty" as="xs:boolean" select="xs:boolean(($inputDocumentsElement/@accept-empty, false())[1])"/>
                <!-- Load the documents: -->
                <yatcs:load-documents-from-disk-from-patterns p:message="      * Input directory: &quot;{$inputDirectory}&quot;">
                    <p:with-option name="copyPatternsElement" select="$inputDocumentsElement"/>
                    <p:with-option name="hrefSource" select="$inputDirectory"/>
                </yatcs:load-documents-from-disk-from-patterns>
                <!-- Check for an empty set: -->
                <p:variable name="inputDocumentsCount" as="xs:integer" select="count(collection())" collection="true"/>
                <p:if test="not($acceptEmpty) and ($inputDocumentsCount le 0)">
                    <p:error code="yatcs:error">
                        <p:with-input>
                            <p:inline content-type="text/plain" xml:space="preserve">No documents selected for build "{$buildName}"</p:inline>
                        </p:with-input>
                    </p:error>
                </p:if>
                <!-- Do the transforms: -->
                <p:for-each name="apply-build-stylesheet-input-documents">
                    <p:output port="result" primary="true" sequence="true"/>
                    <p:output port="secondary" primary="false" sequence="true" pipe="secondary@apply-build-stylesheet"/>
                    <p:variable name="inputFilename" as="xs:string" select="replace(base-uri(/), '.*[/\\]([^/\\]+)$', '$1')"/>
                    <p:xslt name="apply-build-stylesheet" message="      * ({p:iteration-position()}/{p:iteration-size()}) {$inputFilename}">
                        <p:with-input port="stylesheet" href="{$hrefBuildStylesheet}"/>
                        <p:with-option name="parameters" select="$buildStylesheetParameters"/>
                    </p:xslt>
                    <!-- Set the correct base-uri for the direct output document (if not discarded): -->
                    <p:if test="not($discardOutput)">
                        <p:set-properties properties="map{'base-uri': string-join(($outputSpecification, $inputFilename), '/')}"/>
                    </p:if>
                </p:for-each>

            </p:when>

            <!-- Unrecognized: -->
            <p:otherwise>
                <p:output port="result" primary="true" sequence="true"/>
                <p:output port="secondary" primary="false" sequence="true">
                    <p:empty/>
                </p:output>
                <p:error code="yatcs:error">
                    <p:with-input>
                        <p:inline content-type="text/plain" xml:space="preserve">Invalid or missing input specification for build &quot;{$buildName}&quot;</p:inline>
                    </p:with-input>
                </p:error>
            </p:otherwise>

        </p:choose>

        <!-- The primary output of the p:choose above are the direct document(s) produced by the stylesheet. 
                 See if we have to store this. -->
        <p:if test="not($discardOutput)">
            <p:for-each>
                <!-- Due to the way the stylesheets are made, it might happen that such a file is empty. Detect this,
                         and only perform a store when there's something to store:-->
                <p:if test="exists(/*)">
                    <p:identity message="      * Storing direct build result: &quot;{base-uri(/)}&quot;" use-when="$ada-2-fhir-r4-debug"/>
                    <p:store href="{base-uri(/)}" serialization="$yatcs:standardXmlSerialization"/>
                </p:if>
            </p:for-each>
        </p:if>

        <!-- Check for secondary outputs (from <xsl:result-document> instructions): -->
        <!-- Take care to set the correct serialization *in* the stylesheet! -->
        <p:for-each>
            <p:with-input pipe="secondary@apply-build-stylesheet"/>
            <p:identity message="      * Storing secondary build result: &quot;{base-uri(/)}&quot;" use-when="$ada-2-fhir-r4-debug"/>
            <p:store href="{base-uri(/)}"/>
        </p:for-each>

    </p:declare-step>

    <!-- ======================================================================= -->

    <p:declare-step type="local:process-action-validate" name="process-action-validate">
        <!-- Processes a validation step (<validate-with-schema> or <validate-with-schematron> element) for an action.  
             The step itself acts as an identity step.
        -->
        
        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <p:input port="source" primary="true" sequence="false" content-types="xml">
            <!-- The <yatcp:validate-with-*> element to process. -->
        </p:input>
        <p:output port="result" sequence="false" content-types="xml" pipe="source@process-action-validate"/>

        <p:option name="parameters" as="map(xs:string, xs:string*)" required="true"/>

        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <p:variable name="validationType" as="xs:string" select="local-name(/*)"/>
        <p:variable name="buildName" as="xs:string" select="string((/*/@name, ($validationType || ' ' || p:iteration-position() || '/' || p:iteration-size()))[1])"/>
        <p:variable name="hrefSchema" as="xs:string" select="string(/*/yatcp:schema/@href)"/>

        <!-- Identify the schema to be used and check its availability:: -->
        <p:identity message="    * {$validationType} &quot;{$buildName}&quot;"/>
        <p:identity message="      * Schema: &quot;{$hrefSchema}&quot;"/>
        <p:if test="not(doc-available($hrefSchema))">
            <p:error code="yatcs:error">
                <p:with-input>
                    <p:inline content-type="text/plain" xml:space="preserve">Schema not found or not well-formed: &quot;{$hrefSchema}&quot;</p:inline>
                </p:with-input>
            </p:error>
        </p:if>

        <!-- Find out whether we have to write a report: -->
        <p:variable name="outputReportElement" as="element(yatcp:output-report)?" select="/*/yatcp:output-report[1]"/>
        <p:variable name="doOutputReport" as="xs:boolean" select="exists($outputReportElement)"/>
        <p:variable name="reportUri" as="xs:string" select="string-join(($outputReportElement/@directory, $outputReportElement/@name), '/')"/>
        <p:variable name="reportPruneValid" as="xs:boolean" select="xs:boolean(($outputReportElement/@prune-valid, true())[1])"/>

        <!-- Create the sequence of documents to validate: -->
        <p:choose>
            <p:when test="exists(/*/yatcp:input-document)">
                <p:variable name="inputUri" as="xs:string" select="string-join((/*/yatcp:input-document[1]/@directory, /*/yatcp:input-document[1]/@name), '/')"/>
                <p:if test="not(doc-available($inputUri))">
                    <p:error code="yatcs:error">
                        <p:with-input>
                            <p:inline content-type="text/plain" xml:space="preserve">Input document for build not found or not well-formed: &quot;{$inputUri}&quot;</p:inline>
                        </p:with-input>
                    </p:error>
                </p:if>
                <p:load href="{$inputUri}" content-type="xml"/>
            </p:when>
            <p:when test="exists(/*/yatcp:input-documents)">
                <p:variable name="inputDocumentsElement" as="element(yatcp:input-documents)" select="/*/yatcp:input-documents[1]"/>
                <p:variable name="inputDirectory" as="xs:string" select="string($inputDocumentsElement/@directory)"/>
                <p:variable name="acceptEmpty" as="xs:boolean" select="xs:boolean(($inputDocumentsElement/@accept-empty, false())[1])"/>
                <!-- Load the documents: -->
                <yatcs:load-documents-from-disk-from-patterns p:message="      * Input directory: &quot;{$inputDirectory}&quot;">
                    <p:with-option name="copyPatternsElement" select="$inputDocumentsElement"/>
                    <p:with-option name="hrefSource" select="$inputDirectory"/>
                </yatcs:load-documents-from-disk-from-patterns>
                <!-- Check for an empty set: -->
                <p:variable name="inputDocumentsCount" as="xs:integer" select="count(collection())" collection="true"/>
                <p:if test="not($acceptEmpty) and ($inputDocumentsCount le 0)">
                    <p:error code="yatcs:error">
                        <p:with-input>
                            <p:inline content-type="text/plain" xml:space="preserve">No documents selected for build "{$buildName}"</p:inline>
                        </p:with-input>
                    </p:error>
                </p:if>
            </p:when>
            <p:otherwise>
                <p:error code="yatcs:error">
                    <p:with-input>
                        <p:inline content-type="text/plain" xml:space="preserve">Invalid or missing input specification for build &quot;{$buildName}&quot;</p:inline>
                    </p:with-input>
                </p:error>
            </p:otherwise>
        </p:choose>

        <!-- Do the validation and report about it:: -->
        <p:for-each name="validation-loop">
            <p:output pipe="@do-validations"/>

            <p:variable name="filename" select="replace(base-uri(/), '.*[/\\]([^/\\]+)$', '$1')"/>
            <p:choose name="do-validations" message="      * ({p:iteration-position()}/{p:iteration-size()}) {$filename}">
                <p:when test="$validationType eq $validationTypeSchema">
                    <p:output pipe="report@do-schema-validation"/>
                    <p:validate-with-xml-schema assert-valid="false" report-format="xvrl" name="do-schema-validation">
                        <p:with-input port="schema" href="{$hrefSchema}"/>
                    </p:validate-with-xml-schema>
                </p:when>
                <p:when test="$validationType eq $validationTypeSchematron">
                    <p:output pipe="report@do-schematron-validation"/>
                    <p:validate-with-schematron assert-valid="false" report-format="xvrl" name="do-schematron-validation">
                        <p:with-input port="schema" href="{$hrefSchema}"/>
                    </p:validate-with-schematron>
                </p:when>
                <p:otherwise>
                    <p:error code="yatcs:error">
                        <p:with-input>
                            <p:inline content-type="text/plain" xml:space="preserve">Invalid validation type: &quot;{$validationType}&quot;</p:inline>
                        </p:with-input>
                    </p:error>
                </p:otherwise>
            </p:choose>

            <!-- Inspect the XVRL report and see if we have to report anything: -->
            <p:if test="exists(/*/xvrl:detection)">
                <p:for-each>
                    <p:with-input select="/*/xvrl:detection"/>
                    <p:identity message="        * {/*/@severity}: {/*/xvrl:message}"/>
                </p:for-each>
            </p:if>
        </p:for-each>

        <!-- Store results, if requested: -->
        <p:if test="$doOutputReport">
            <p:wrap-sequence wrapper="validation-results"/>
            <p:add-attribute attribute-name="timestamp" attribute-value="{current-dateTime()}"/>
            <p:if test="$reportPruneValid">
                <p:delete match="xvrl:report[empty(xvrl:detection)]"/>
            </p:if>
            <p:identity message="      * XVRL report written to &quot;{$reportUri}&quot;"/>
            <p:store href="{$reportUri}" serialization="$yatcs:standardXmlSerialization"/>
        </p:if>

    </p:declare-step>

    <!-- ======================================================================= -->

    <p:declare-step type="local:process-action-copy" name="process-action-copy">
        <!-- Processes a copy step (<copy> element) for an action.  
             The step itself acts as an identity step.
        -->
        
        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <p:input port="source" primary="true" sequence="false" content-types="xml">
            <!-- The <yatcp:copy> element to process. -->
        </p:input>
        <p:output port="result" sequence="false" content-types="xml" pipe="source@process-action-copy"/>

        <p:option name="parameters" as="map(xs:string, xs:string*)" required="true"/>

        <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

        <p:variable name="buildName" as="xs:string" select="string((/*/@name, (local-name(/*) || ' ' || p:iteration-position() || '/' || p:iteration-size()))[1])"/>
        <p:variable name="sourceElement" as="element(yatcp:source)" select="/*/yatcp:source"/>
        <p:variable name="hrefSource" as="xs:string" select="string($sourceElement/@directory)"/>
        <p:variable name="hrefTarget" as="xs:string" select="string(/*/yatcp:target/@directory)"/>
        <p:variable name="recurse" as="xs:boolean" select="xs:boolean((/*/@recurse, false())[1])"/>

        <!-- Identify the schema to be used and check its availability:: -->
        <p:identity message="    * Copy &quot;{$buildName}&quot;"/>
        <p:identity message="      * Source: &quot;{$hrefSource}&quot;"/>
        <p:identity message="      * Target: &quot;{$hrefTarget}&quot;"/>

        <yatcs:copy-dir-from-patterns>
            <p:with-option name="copyPatternsElement" select="$sourceElement"/>
            <p:with-option name="hrefSource" select="$hrefSource"/>
            <p:with-option name="hrefTarget" select="$hrefTarget"/>
            <p:with-option name="recurse" select="$recurse"/>
            <p:with-option name="reportCount" select="true()"/>
            <p:with-option name="clearTarget" select="false()"/>
        </yatcs:copy-dir-from-patterns>

        <yatcs:report-count>
            <p:with-option name="prompt" select="'      * Files copied: '"/>
        </yatcs:report-count>

    </p:declare-step>

    <!-- ======================================================================= -->
    <!-- MAIN: -->

    <!-- Get the parameters: -->
    <yatcs:get-combined-parameters-map>
        <p:with-option name="parameters" select="$parameters"/>
        <p:with-option name="callerStaticBaseUri" select="static-base-uri()"/>
    </yatcs:get-combined-parameters-map>
    <p:variable name="parameters" as="map(xs:string, xs:string*)" select="."/>

    <!-- Get the application ADA retrieval data: -->
    <yatcp:get-ada-2-fhir-r4-data>
        <p:with-option name="parameters" select="$parameters"/>
        <p:with-option name="ada2fhirr4Data" select="$ada2fhirr4Data"/>
        <p:with-option name="application" select="$application"/>
        <p:with-option name="version" select="$version"/>
    </yatcp:get-ada-2-fhir-r4-data>

    <!-- Report if we're in debug mode: -->
    <p:identity message="*** DEBUG ON FOR ada-2-fhir-r4" use-when="$ada-2-fhir-r4-debug"/>

    <!-- Check if we found anything: -->
    <p:if test="empty(/*/yatcp:application)">
        <p:error code="yatcs:error">
            <p:with-input>
                <p:inline content-type="text/plain" xml:space="preserve">No data found for application/version &quot;{$application}&quot;/&quot;{$version}&quot;</p:inline>
            </p:with-input>
        </p:error>
    </p:if>

    <!-- Now loop over all the applications that are in the pruned ADA Retrieval data: -->
    <p:for-each>
        <p:with-input select="/*/yatcp:application"/>

        <!-- Perform the processing for each application (when debugging we don't add the try/catch): -->
        <p:try use-when="not($ada-2-fhir-r4-debug)">
            <local:ada-2-fhir-r4-for-application>
                <p:with-option name="parameters" select="$parameters"/>
                <p:with-option name="setup" select="$setup"/>
                <p:with-option name="actions" select="$actions"/>
            </local:ada-2-fhir-r4-for-application>
            <p:catch name="get-production-error-catch">
                <!-- Some error occurred during processing. Report this, but try to keep calm and carry on: -->
                <p:variable name="message" select="string(/*)" pipe="error@get-production-error-catch"/>
                <p:identity message="  * ERROR: {$message}">
                    <p:with-input>
                        <p:empty/>
                    </p:with-input>
                </p:identity>
                <p:sink/>
            </p:catch>
        </p:try>
        <local:ada-2-fhir-r4-for-application p:use-when="$ada-2-fhir-r4-debug">
            <p:with-option name="parameters" select="$parameters"/>
            <p:with-option name="setup" select="$setup"/>
            <p:with-option name="actions" select="$actions"/>
        </local:ada-2-fhir-r4-for-application>

    </p:for-each>

</p:declare-step>
