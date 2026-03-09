<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-shared/xsl/util/uuid-stable.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.12; 2026-03-03T13:51:13.41+01:00 == -->
<xsl:stylesheet version="2.0"
                exclude-result-prefixes="#all"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="#local.2024111413163599491280100"
                xmlns:xhtml="http://www.w3.org/1999/xhtml">
   <!-- ================================================================== -->
   <!--
        This is to create stable uuids to avoid pseudochanges when generating lots of data. This helps Nictiz internal test processing and should never be used in a production(like) situation.
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
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="uuid:generate-timestamp">
      <!--  Generates a timestamp of the amount of 100 nanosecond intervals from 15 October 1582, in UTC time.
        Override this function here to use a stable timestamp in order to create stable uuids -->
      <xsl:param name="node"/>
      <!-- date calculation automatically goes correct when you add the timezone information, in this case that is UTC. -->
      <xsl:variable name="duration-from-1582"
                    as="xs:dayTimeDuration">
         <!-- fixed date for stable uuid for test purposes -->
         <xsl:sequence select="xs:dateTime('2022-01-01T00:00:00.000Z') - xs:dateTime('1582-10-15T00:00:00.000Z')"/>
      </xsl:variable>
      <xsl:variable name="random-offset"
                    as="xs:integer">
         <xsl:sequence select="uuid:next-nr($node) mod 1000000000000"/>
      </xsl:variable>
      <!-- do the math to get the 100 nano second intervals -->
      <xsl:sequence select="(days-from-duration($duration-from-1582) * 24 * 60 * 60 + hours-from-duration($duration-from-1582) * 60 * 60 + minutes-from-duration($duration-from-1582) * 60 + seconds-from-duration($duration-from-1582)) * 1000 * 10000 + $random-offset"/>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="uuid:generate-clock-id"
                 as="xs:string">
      <!-- Override this function here to use a stable timestamp in order to create stable uuids -->
      <xsl:sequence select="'0000'"/>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="uuid:next-nr"
                 as="xs:integer">
      <!-- Override this function to avoid the use of generate-id which generates a new id every execution. Instead use string-to-codepoints of a combination of profile and groupingkey -->
      <xsl:param name="node"/>
      <xsl:sequence select="xs:integer(nf:product-sum(string-to-codepoints(concat($node/@profile,nf:getGroupingKeyDefault($node)))[position() lt 500]))"/>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:function name="nf:product-sum"
                 as="xs:integer">
      <!-- Using a combination of addition and multiplication to generate a 'large' integer that is as unique as possible. For example: for a basic Medication resource, this leads to a 40+ character long integer. Others will usually be longer. -->
      <xsl:param name="in"/>
      <xsl:sequence select="if (count($in) = 1) then $in[1] else (if (count($in) mod 3 = 0) then $in[1] * nf:product-sum($in[position()&gt;1]) else $in[1] + nf:product-sum($in[position()&gt;1]))"/>
   </xsl:function>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <!-- copy of function in 2_fhir_fhir_include.xsl (R4 version) because the uuid-stable uses it and is also used outside of 2_fhir conversions -->
   <xsl:function name="nf:getGroupingKeyDefault"
                 as="xs:string?">
      <!-- If  holds a value, return the upper-cased combined string of @value/@root/@code/@codeSystem/@nullFlavor. Else return empty -->
      <xsl:param name="in"
                 as="element()?"/>
      <xsl:if test="$in">
         <xsl:value-of select="upper-case(string-join(($in//@value, $in//@root, $in//@unit, $in//@code[not(../@codeSystem = $oidHL7NullFlavor)], $in//@codeSystem[not(. = $oidHL7NullFlavor)], $in//*[@codeSystem = $oidHL7NullFlavor][@code = 'OTH']/@originalText)/normalize-space(), ''))"/>
      </xsl:if>
   </xsl:function>
</xsl:stylesheet>