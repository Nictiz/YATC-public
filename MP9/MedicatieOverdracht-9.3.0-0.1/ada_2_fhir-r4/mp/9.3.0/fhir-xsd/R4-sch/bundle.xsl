<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: HL7-mappings/ada_2_fhir-r4/mp/9.3.0/fhir-xsd/R4-sch/bundle.xsl == -->
<!-- == Distribution: VZVZ-MedicatieOverdracht-9.3.0; 0.1; 2024-03-12T15:03:10.81+01:00 == -->
<axsl:stylesheet version="2.0"
                 xmlns:axsl="http://www.w3.org/1999/XSL/Transform"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                 xmlns:f="http://hl7.org/fhir"
                 xmlns:h="http://www.w3.org/1999/xhtml"
                 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                 xmlns:saxon="http://saxon.sf.net/"
                 xmlns:xs="http://www.w3.org/2001/XMLSchema"
                 xmlns:schold="http://www.ascc.net/xml/schematron"
                 xmlns:xhtml="http://www.w3.org/1999/xhtml">
   <!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <axsl:param name="archiveDirParameter"/>
   <axsl:param name="archiveNameParameter"/>
   <axsl:param name="fileNameParameter"/>
   <axsl:param name="fileDirParameter"/>
   <axsl:variable name="document-uri">
      <axsl:value-of select="document-uri(/)"/>
   </axsl:variable>
   <!--PHASES-->
   <!--PROLOG-->
   <axsl:output method="xml"
                omit-xml-declaration="no"
                standalone="yes"
                indent="yes"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
   <!--XSD TYPES FOR XSLT2-->
   <!--KEYS AND FUNCTIONS-->
   <!--DEFAULT RULES-->
   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <axsl:template match="*"
                  mode="schematron-select-full-path">
      <axsl:apply-templates select="."
                            mode="schematron-get-full-path"/>
   </axsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <axsl:template match="*"
                  mode="schematron-get-full-path">
      <axsl:apply-templates select="parent::*"
                            mode="schematron-get-full-path"/>
      <axsl:text>/</axsl:text>
      <axsl:choose>
         <axsl:when test="namespace-uri()=''">
            <axsl:value-of select="name()"/>
         </axsl:when>
         <axsl:otherwise>
            <axsl:text>*:</axsl:text>
            <axsl:value-of select="local-name()"/>
            <axsl:text>[namespace-uri()='</axsl:text>
            <axsl:value-of select="namespace-uri()"/>
            <axsl:text>']</axsl:text>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:variable name="preceding"
                     select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <axsl:text>[</axsl:text>
      <axsl:value-of select="1+ $preceding"/>
      <axsl:text>]</axsl:text>
   </axsl:template>
   <axsl:template match="@*"
                  mode="schematron-get-full-path">
      <axsl:apply-templates select="parent::*"
                            mode="schematron-get-full-path"/>
      <axsl:text>/</axsl:text>
      <axsl:choose>
         <axsl:when test="namespace-uri()=''">@
<axsl:value-of select="name()"/>
         </axsl:when>
         <axsl:otherwise>
            <axsl:text>@*[local-name()='</axsl:text>
            <axsl:value-of select="local-name()"/>
            <axsl:text>' and namespace-uri()='</axsl:text>
            <axsl:value-of select="namespace-uri()"/>
            <axsl:text>']</axsl:text>
         </axsl:otherwise>
      </axsl:choose>
   </axsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <axsl:template match="node() | @*"
                  mode="schematron-get-full-path-2">
      <axsl:for-each select="ancestor-or-self::*">
         <axsl:text>/</axsl:text>
         <axsl:value-of select="name(.)"/>
         <axsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <axsl:text>[</axsl:text>
            <axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <axsl:text>]</axsl:text>
         </axsl:if>
      </axsl:for-each>
      <axsl:if test="not(self::*)">
         <axsl:text/>/@
<axsl:value-of select="name(.)"/>
      </axsl:if>
   </axsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <axsl:template match="node() | @*"
                  mode="schematron-get-full-path-3">
      <axsl:for-each select="ancestor-or-self::*">
         <axsl:text>/</axsl:text>
         <axsl:value-of select="name(.)"/>
         <axsl:if test="parent::*">
            <axsl:text>[</axsl:text>
            <axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <axsl:text>]</axsl:text>
         </axsl:if>
      </axsl:for-each>
      <axsl:if test="not(self::*)">
         <axsl:text/>/@
<axsl:value-of select="name(.)"/>
      </axsl:if>
   </axsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <axsl:template match="/"
                  mode="generate-id-from-path"/>
   <axsl:template match="text()"
                  mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*"
                            mode="generate-id-from-path"/>
      <axsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </axsl:template>
   <axsl:template match="comment()"
                  mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*"
                            mode="generate-id-from-path"/>
      <axsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </axsl:template>
   <axsl:template match="processing-instruction()"
                  mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*"
                            mode="generate-id-from-path"/>
      <axsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </axsl:template>
   <axsl:template match="@*"
                  mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*"
                            mode="generate-id-from-path"/>
      <axsl:value-of select="concat('.@', name())"/>
   </axsl:template>
   <axsl:template match="*"
                  mode="generate-id-from-path"
                  priority="-0.5">
      <axsl:apply-templates select="parent::*"
                            mode="generate-id-from-path"/>
      <axsl:text>.</axsl:text>
      <axsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </axsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <axsl:template match="/"
                  mode="generate-id-2">U</axsl:template>
   <axsl:template match="*"
                  mode="generate-id-2"
                  priority="2">
      <axsl:text>U</axsl:text>
      <axsl:number level="multiple"
                   count="*"/>
   </axsl:template>
   <axsl:template match="node()"
                  mode="generate-id-2">
      <axsl:text>U.</axsl:text>
      <axsl:number level="multiple"
                   count="*"/>
      <axsl:text>n</axsl:text>
      <axsl:number count="node()"/>
   </axsl:template>
   <axsl:template match="@*"
                  mode="generate-id-2">
      <axsl:text>U.</axsl:text>
      <axsl:number level="multiple"
                   count="*"/>
      <axsl:text>_</axsl:text>
      <axsl:value-of select="string-length(local-name(.))"/>
      <axsl:text>_</axsl:text>
      <axsl:value-of select="translate(name(),':','.')"/>
   </axsl:template>
   <!--Strip characters-->
   <axsl:template match="text()"
                  priority="-1"/>
   <!--SCHEMA SETUP-->
   <axsl:template match="/">
      <svrl:schematron-output title=""
                              schemaVersion=""
                              xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
         <axsl:comment>
            <axsl:value-of select="$archiveDirParameter"/>   
		 
<axsl:value-of select="$archiveNameParameter"/>  
		 
<axsl:value-of select="$fileNameParameter"/>  
		 
<axsl:value-of select="$fileDirParameter"/>
         </axsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://hl7.org/fhir"
                                             prefix="f"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xhtml"
                                             prefix="h"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:attribute name="name">Global</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/"
                               mode="M2"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:attribute name="name">Global 1</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/"
                               mode="M3"/>
         <svrl:active-pattern>
            <axsl:attribute name="document">
               <axsl:value-of select="document-uri(/)"/>
            </axsl:attribute>
            <axsl:attribute name="name">Bundle</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/"
                               mode="M4"/>
      </svrl:schematron-output>
   </axsl:template>
   <!--SCHEMATRON PATTERNS-->
   <!--PATTERN Global-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Global</svrl:text>
   <!--RULE -->
   <axsl:template match="f:extension"
                  priority="1001"
                  mode="M2">
      <svrl:fired-rule context="f:extension"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="exists(f:extension)!=exists(f:*[starts-with(local-name(.), 'value')])"/>
         <axsl:otherwise>
            <svrl:failed-assert test="exists(f:extension)!=exists(f:*[starts-with(local-name(.), 'value')])"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>ext-1: Must have either extensions or value[x], not both</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M2"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:modifierExtension"
                  priority="1000"
                  mode="M2">
      <svrl:fired-rule context="f:modifierExtension"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="exists(f:extension)!=exists(f:*[starts-with(local-name(.), 'value')])"/>
         <axsl:otherwise>
            <svrl:failed-assert test="exists(f:extension)!=exists(f:*[starts-with(local-name(.), 'value')])"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>ext-1: Must have either extensions or value[x], not both</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M2"/>
   </axsl:template>
   <axsl:template match="text()"
                  priority="-1"
                  mode="M2"/>
   <axsl:template match="@*|node()"
                  priority="-2"
                  mode="M2">
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M2"/>
   </axsl:template>
   <!--PATTERN Global 1-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Global 1</svrl:text>
   <!--RULE -->
   <axsl:template match="f:*"
                  priority="1000"
                  mode="M3">
      <svrl:fired-rule context="f:*"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="@value|f:*|h:div"/>
         <axsl:otherwise>
            <svrl:failed-assert test="@value|f:*|h:div"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>global-1: All FHIR elements must have a @value or children</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M3"/>
   </axsl:template>
   <axsl:template match="text()"
                  priority="-1"
                  mode="M3"/>
   <axsl:template match="@*|node()"
                  priority="-2"
                  mode="M3">
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M3"/>
   </axsl:template>
   <!--PATTERN Bundle-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Bundle</svrl:text>
   <!--RULE -->
   <axsl:template match="f:Bundle"
                  priority="1009"
                  mode="M4">
      <svrl:fired-rule context="f:Bundle"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="(f:type/@value = 'history') or (count(for $entry in f:entry[f:resource] return $entry[count(parent::f:Bundle/f:entry[f:fullUrl/@value=$entry/f:fullUrl/@value and ((not(f:resource/*/f:meta/f:versionId/@value) and not($entry/f:resource/*/f:meta/f:versionId/@value)) or f:resource/*/f:meta/f:versionId/@value=$entry/f:resource/*/f:meta/f:versionId/@value)])!=1])=0)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="(f:type/@value = 'history') or (count(for $entry in f:entry[f:resource] return $entry[count(parent::f:Bundle/f:entry[f:fullUrl/@value=$entry/f:fullUrl/@value and ((not(f:resource/*/f:meta/f:versionId/@value) and not($entry/f:resource/*/f:meta/f:versionId/@value)) or f:resource/*/f:meta/f:versionId/@value=$entry/f:resource/*/f:meta/f:versionId/@value)])!=1])=0)"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-7: FullUrl must be unique in a bundle, or else entries with the same fullUrl must have different meta.versionId (except in history bundles)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(f:type/@value = 'document') or exists(f:identifier/f:system) or exists(f:identifier/f:value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(f:type/@value = 'document') or exists(f:identifier/f:system) or exists(f:identifier/f:value)"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-9: A document must have an identifier with a system and a value</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(f:entry/f:request) or (f:type/@value = 'batch') or (f:type/@value = 'transaction') or (f:type/@value = 'history')"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(f:entry/f:request) or (f:type/@value = 'batch') or (f:type/@value = 'transaction') or (f:type/@value = 'history')"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-3: entry.request mandatory for batch/transaction/history, otherwise prohibited</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(f:entry/f:response) or (f:type/@value = 'batch-response') or (f:type/@value = 'transaction-response') or (f:type/@value = 'history')"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(f:entry/f:response) or (f:type/@value = 'batch-response') or (f:type/@value = 'transaction-response') or (f:type/@value = 'history')"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-4: entry.response mandatory for batch-response/transaction-response/history, otherwise prohibited</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(f:type/@value='message') or f:entry[1]/f:resource/f:MessageHeader"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(f:type/@value='message') or f:entry[1]/f:resource/f:MessageHeader"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-12: A message must have a MessageHeader as the first resource</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(f:total) or (f:type/@value = 'searchset') or (f:type/@value = 'history')"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(f:total) or (f:type/@value = 'searchset') or (f:type/@value = 'history')"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-1: total only when a search or history</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(f:entry/f:search) or (f:type/@value = 'searchset')"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(f:entry/f:search) or (f:type/@value = 'searchset')"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-2: entry.search only when a search</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(f:type/@value='document') or f:entry[1]/f:resource/f:Composition"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(f:type/@value='document') or f:entry[1]/f:resource/f:Composition"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-11: A document must have a Composition as the first resource</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(f:type/@value = 'document') or exists(f:timestamp/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(f:type/@value = 'document') or exists(f:timestamp/@value)"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-10: A document must have a date</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:Bundle/f:identifier/f:period"
                  priority="1008"
                  mode="M4">
      <svrl:fired-rule context="f:Bundle/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start/@value)) or not(exists(f:end/@value)) or (xs:dateTime(f:start/@value) &lt;= xs:dateTime(f:end/@value))"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start/@value)) or not(exists(f:end/@value)) or (xs:dateTime(f:start/@value) &lt;= xs:dateTime(f:end/@value))"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>per-1: If present, start SHALL have a lower value than end</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:Bundle/f:identifier/f:assigner"
                  priority="1007"
                  mode="M4">
      <svrl:fired-rule context="f:Bundle/f:identifier/f:assigner"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(starts-with(f:reference/@value, '#')) or exists(ancestor::*[self::f:entry or self::f:parameter]/f:resource/f:*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')]|/*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')])"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(starts-with(f:reference/@value, '#')) or exists(ancestor::*[self::f:entry or self::f:parameter]/f:resource/f:*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')]|/*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')])"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>ref-1: SHALL have a contained resource if a local reference is provided</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:Bundle/f:entry"
                  priority="1006"
                  mode="M4">
      <svrl:fired-rule context="f:Bundle/f:entry"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:fullUrl[contains(string(@value), '/_history/')]))"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:fullUrl[contains(string(@value), '/_history/')]))"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-8: fullUrl cannot be a version specific reference</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="exists(f:resource) or exists(f:request) or exists(f:response)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="exists(f:resource) or exists(f:request) or exists(f:response)"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>bdl-5: must be a resource unless there's a request or response</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:Bundle/f:signature/f:who"
                  priority="1005"
                  mode="M4">
      <svrl:fired-rule context="f:Bundle/f:signature/f:who"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(starts-with(f:reference/@value, '#')) or exists(ancestor::*[self::f:entry or self::f:parameter]/f:resource/f:*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')]|/*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')])"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(starts-with(f:reference/@value, '#')) or exists(ancestor::*[self::f:entry or self::f:parameter]/f:resource/f:*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')]|/*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')])"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>ref-1: SHALL have a contained resource if a local reference is provided</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:Bundle/f:signature/f:who/f:identifier/f:period"
                  priority="1004"
                  mode="M4">
      <svrl:fired-rule context="f:Bundle/f:signature/f:who/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start/@value)) or not(exists(f:end/@value)) or (xs:dateTime(f:start/@value) &lt;= xs:dateTime(f:end/@value))"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start/@value)) or not(exists(f:end/@value)) or (xs:dateTime(f:start/@value) &lt;= xs:dateTime(f:end/@value))"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>per-1: If present, start SHALL have a lower value than end</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:Bundle/f:signature/f:who/f:identifier/f:assigner"
                  priority="1003"
                  mode="M4">
      <svrl:fired-rule context="f:Bundle/f:signature/f:who/f:identifier/f:assigner"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(starts-with(f:reference/@value, '#')) or exists(ancestor::*[self::f:entry or self::f:parameter]/f:resource/f:*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')]|/*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')])"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(starts-with(f:reference/@value, '#')) or exists(ancestor::*[self::f:entry or self::f:parameter]/f:resource/f:*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')]|/*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')])"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>ref-1: SHALL have a contained resource if a local reference is provided</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:Bundle/f:signature/f:onBehalfOf"
                  priority="1002"
                  mode="M4">
      <svrl:fired-rule context="f:Bundle/f:signature/f:onBehalfOf"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(starts-with(f:reference/@value, '#')) or exists(ancestor::*[self::f:entry or self::f:parameter]/f:resource/f:*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')]|/*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')])"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(starts-with(f:reference/@value, '#')) or exists(ancestor::*[self::f:entry or self::f:parameter]/f:resource/f:*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')]|/*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')])"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>ref-1: SHALL have a contained resource if a local reference is provided</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:Bundle/f:signature/f:onBehalfOf/f:identifier/f:period"
                  priority="1001"
                  mode="M4">
      <svrl:fired-rule context="f:Bundle/f:signature/f:onBehalfOf/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start/@value)) or not(exists(f:end/@value)) or (xs:dateTime(f:start/@value) &lt;= xs:dateTime(f:end/@value))"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start/@value)) or not(exists(f:end/@value)) or (xs:dateTime(f:start/@value) &lt;= xs:dateTime(f:end/@value))"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>per-1: If present, start SHALL have a lower value than end</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:Bundle/f:signature/f:onBehalfOf/f:identifier/f:assigner"
                  priority="1000"
                  mode="M4">
      <svrl:fired-rule context="f:Bundle/f:signature/f:onBehalfOf/f:identifier/f:assigner"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(starts-with(f:reference/@value, '#')) or exists(ancestor::*[self::f:entry or self::f:parameter]/f:resource/f:*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')]|/*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')])"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(starts-with(f:reference/@value, '#')) or exists(ancestor::*[self::f:entry or self::f:parameter]/f:resource/f:*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')]|/*/f:contained/f:*[f:id/@value=substring-after(current()/f:reference/@value, '#')])"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>ref-1: SHALL have a contained resource if a local reference is provided</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <axsl:template match="text()"
                  priority="-1"
                  mode="M4"/>
   <axsl:template match="@*|node()"
                  priority="-2"
                  mode="M4">
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
</axsl:stylesheet>