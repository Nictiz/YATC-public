<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:yatcs="https://nictiz.nl/ns/YATC-shared" xmlns:yatcp="https://nictiz.nl/ns/YATC-public" xmlns:local="#local.jgb_q4z_2wb" version="3.0" exclude-inline-prefixes="#all">
    <!-- ================================================================== -->
    <!-- 
       This is the command wrapper for the pipeline in ada-2-fhir-r4.xpl.
       For more information see help/ada-2-fhir-r4-cw.help.txt
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

    <p:import href="../../../YATC-shared/xplmod/yatc-cw.mod.xpl"/>
    <p:import href="../../../YATC-shared/xplmod/yatc-parameters.mod.xpl"/>
    <p:import href="../xplmod/ada-2-fhir-r4.mod.xpl"/>
    <p:import href="ada-2-fhir-r4.xpl"/>

    <!-- ======================================================================= -->
    <!-- PORTS: -->

    <p:output port="result" primary="true" sequence="true" content-types="any"/>

    <!-- ======================================================================= -->
    <!-- OPTIONS: -->

    <p:option name="commandLine" as="xs:string" required="false" select="'-help'">
        <!-- The full command line (all arguments in a single string).
             This option is optional because in case of an empty command line, the option will not be set
             (due to the mysterious workings of Windows batch files). -->
    </p:option>

    <!-- ================================================================== -->

    <p:variable name="startDateTime" as="xs:dateTime" select="current-dateTime()"/>

    <!-- The possible command flags: -->
    <p:variable name="commandFlagsAll" as="xs:string+" select="($yatcs:commandFlagHelp, $yatcs:commandFlagList, $yatcs:commandFlagSetup, $yatcs:commandFlagAction, $yatcs:commandFlagActionList)"/>

    <!-- Unravel the command: -->
    <p:variable name="commandParts" as="xs:string*" select="tokenize($commandLine, '\s+')[.]"/>
    <p:variable name="commandFlags" as="xs:string*" select="$commandParts[starts-with(., '-')]"/>
    <p:variable name="commandFlagsNoArguments" as="xs:string*" select="$commandFlags ! replace(., '^(.+?)(:.+)?$', '$1')"/>
    <p:variable name="commandArguments" as="xs:string*" select="$commandParts[not(starts-with(., '-'))]"/>
    <p:variable name="invalidCommandFlagsPresent" as="xs:boolean" select="some $cf in $commandFlagsNoArguments satisfies not($cf = $commandFlagsAll)"/>

    <!-- Create a list of actions (separated by +). For instance -action:a+b means action a followed by action b. -->
    <p:variable name="actionsRaw" as="xs:string" select="$commandFlags[starts-with(., $yatcs:commandFlagAction)][1] => substring-after($yatcs:commandFlagAction || ':')"/>
    <p:variable name="actions" as="xs:string*" select="tokenize($actionsRaw, '\+')[.] => distinct-values()"/>

    <!-- Interpret the command: -->
    <p:choose>

        <!-- direct help request or invalid flags: -->
        <p:when test="$invalidCommandFlagsPresent or ($yatcs:commandFlagHelp = $commandFlags)">
            <yatcs:get-cw-help commandStaticBaseUri="{static-base-uri()}"/>
        </p:when>

        <!-- We have to handle a command: -->
        <p:otherwise>
            <p:output content-types="any" sequence="true"/>

            <p:variable name="application" as="xs:string" select="string($commandArguments[1])"/>
            <p:variable name="version" as="xs:string" select="string($commandArguments[2])"/>

            <!-- Get the parameters: -->
            <yatcs:get-combined-parameters-map>
                <p:with-option name="callerStaticBaseUri" select="static-base-uri()"/>
            </yatcs:get-combined-parameters-map>
            <p:variable name="parameters" as="map(xs:string, xs:string*)" select="."/>

            <!-- Get the ada-2-fhir-r4 data: -->
            <yatcp:get-ada-2-fhir-r4-data>
                <p:with-option name="parameters" select="$parameters"/>
                <p:with-option name="application" select="$application"/>
                <p:with-option name="version" select="$version"/>
            </yatcp:get-ada-2-fhir-r4-data>
            <p:variable name="ada2fhirr4Data" as="document-node()" select="."/>

            <p:choose>

                <!-- List the applications/versions: -->
                <p:when test="$yatcs:commandFlagList = $commandFlags">
                    <p:for-each>
                        <p:with-input select="$ada2fhirr4Data/*/yatcp:application">
                            <null/>
                        </p:with-input>
                        <p:identity>
                            <p:with-input>
                                <p:inline content-type="text/plain" xml:space="preserve">{/*/@name} {/*/@version}</p:inline>
                            </p:with-input>
                        </p:identity>
                    </p:for-each>
                    <p:text-join separator="&#10;"/>
                </p:when>

                <!-- List the available actions: -->
                <p:when test="$yatcs:commandFlagActionList = $commandFlags">
                    <p:for-each>
                        <p:with-input select="$ada2fhirr4Data/*/yatcp:application">
                            <null/>
                        </p:with-input>
                        <p:variable name="applicationPrompt" select="string(/*/@name) || '/' || string(/*/@version)"/>
                        <p:for-each>
                            <p:with-input select="/*/yatcp:action"/>
                            <p:variable name="description" as="xs:string" select="if (normalize-space(/*/@description) ne '') then (' (' || /*/@description || ')') else ''"/>
                            <p:variable name="defaultMarker" as="xs:string" select="if (xs:boolean((/*/@default, false())[1])) then '*' else ''"/>
                            <p:identity>
                                <p:with-input>
                                    <p:inline content-type="text/plain" xml:space="preserve">{$applicationPrompt} {$defaultMarker}{/*/@name}{$description}</p:inline>
                                </p:with-input>
                            </p:identity>
                        </p:for-each>
                    </p:for-each>
                    <p:text-join separator="&#10;"/>
                </p:when>

                <!-- Do something: -->
                <p:when test="count($commandArguments) eq 2">
                    <p:output content-types="any" sequence="true"/>

                    <yatcp:process-ada-2-fhir-r4 name="process-ada-2-fhir-r4">
                        <p:with-option name="parameters" select="$parameters"/>
                        <p:with-option name="ada2fhirr4Data" select="$ada2fhirr4Data"/>
                        <p:with-option name="application" select="$application"/>
                        <p:with-option name="version" select="$version"/>
                        <p:with-option name="setup" select="$yatcs:commandFlagSetup = $commandFlags"/>
                        <p:with-option name="actions" select="$actions"/>
                    </yatcp:process-ada-2-fhir-r4>

                    <!-- Report the duration and output nothing: -->
                    <yatcs:report-duration p:depends="process-ada-2-fhir-r4">
                        <p:with-option name="startDateTime" select="$startDateTime"/>
                    </yatcs:report-duration>

                </p:when>

                <!-- Unrecognized situation, repeat the help info: -->
                <p:otherwise>
                    <yatcs:get-cw-help commandStaticBaseUri="{static-base-uri()}"/>
                </p:otherwise>
            </p:choose>

        </p:otherwise>

    </p:choose>

</p:declare-step>
