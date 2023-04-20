<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <!-- ======================================================================= -->
    <!-- 
       Schematron schema for additional validation of some aspects of the ada-2-fhir-r4-data file(s).
       
       It assumes that the document is valid against ../xsd/ada-2-fhir-r4-data.xsd.
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
    <!-- SETUP: -->

    <ns prefix="yatcp" uri="https://nictiz.nl/ns/YATC-public"/>

    <!-- ======================================================================= -->

    <!-- All application/version combinations must be unique: -->
    <include href="../../../YATC-shared/schmod/application-version.mod.sch"/>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <!-- Check the include/exclude elements in copy-patterns: -->
    <include href="../../../YATC-shared/schmod/copy-pattern.mod.sch"/>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    
    <!-- Check that @directory-d values are unique: -->
    <include href="../../../YATC-shared/schmod/directory-id.mod.sch"/>
    
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    
    <!-- Directory references in @directory attributes must exist: -->
    <include href="../../../YATC-shared/schmod/directory-id-reference.mod.sch"/>
    
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    
    <!-- Action names must be unique within an application: -->
    <pattern>
        <rule context="yatcp:action/@name">
            <let name="name" value="string(.)"/>
            <assert test="count(ancestor::*:application//descendant-or-self::yatcp:action/@name[. eq $name]) eq 1">Action name "<value-of select="$name"/>" not unique</assert>
        </rule>
    </pattern>
    
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    
    <!-- There can only be one (or none) default action for an application: -->
    <pattern>
        <rule context="yatcp:application">
            <assert test="count(yatcp:action[xs:boolean((@default, false())[1])]) le 1">Multiple default actions found</assert>
        </rule>
    </pattern>    
    
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    
    <!-- Action @depends-on targets must exist and not reference itself: -->
    <pattern>
        <rule context="yatcp:action[normalize-space(string(@depends-on)) ne '']">
            <let name="actionName" value="string(@name)"/>
            <let name="dependencies" value="tokenize(string(@depends-on), '\s+')[.]"/>
            <assert test="every $d in $dependencies satisfies ($d ne $actionName)">An action cannot depend on itself</assert>
            <assert test="every $d in $dependencies satisfies exists(../yatcp:action[@name eq $d])">One or more dependent actions not found</assert>
        </rule>
    </pattern>
    
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    
    <!-- A build that processes multiple input documents cannot have a specific output document specified: -->
    <pattern>
        <rule context="yatcp:build/yatcp:input-documents">
            <assert test="exists(../yatcp:discard-output) or exists(../yatcp:output-documents)">When using multiple input documents, you cannot specify a single output document (use either &lt;output-document directory="…"&gt; or &lt;yatcp:discard-output/&gt;)</assert>
        </rule>
    </pattern>
    
</schema>
