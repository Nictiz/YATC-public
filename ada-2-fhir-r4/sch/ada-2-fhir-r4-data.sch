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
    
</schema>
