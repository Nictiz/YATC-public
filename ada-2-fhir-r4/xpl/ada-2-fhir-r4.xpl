<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:yatcp="https://nictiz.nl/ns/YATC-public"  xmlns:local="#local.uqk_swy_2wb" version="3.0" exclude-inline-prefixes="#all" type="yatcp:process-ada-2-fhir-r4" name="process-ada-2-fhir-r4">
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
    <p:import href="../../../YATC-shared/xplmod/yatc-component-steps.mod.xpl"></p:import>

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
            
            <yatcs:process-standard-steps>
                <p:with-option name="application" select="$application"/>
                <p:with-option name="version" select="$version"/>
                <p:with-option name="storageBaseDirectory" select="$storageBaseDirectory"/>
                <p:with-option name="sourceProjectName" select="$sourceProjectName"/>
                <p:with-option name="messagePrefix" select="'    * '"/>
            </yatcs:process-standard-steps>

        </p:for-each>

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
