<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir/env/mp/9.0.7/fhir-xsd/STU3-sch/clinicalimpression_svrl.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.0.7; 0.1; 2024-08-26T18:25:33.12+02:00 == -->
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
            <axsl:attribute name="name">ClinicalImpression</axsl:attribute>
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
   <!--PATTERN ClinicalImpression-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">ClinicalImpression</svrl:text>
   <!--RULE -->
   <axsl:template match="f:ClinicalImpression"
                  priority="1034"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(parent::f:contained and f:contained)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(parent::f:contained and f:contained)"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>dom-2: If the resource is contained in another resource, it SHALL NOT contain nested Resources</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(parent::f:contained and f:text)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(parent::f:contained and f:text)"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>dom-1: If the resource is contained in another resource, it SHALL NOT contain any narrative</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:contained/*/f:meta/f:versionId)) and not(exists(f:contained/*/f:meta/f:lastUpdated))"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:contained/*/f:meta/f:versionId)) and not(exists(f:contained/*/f:meta/f:lastUpdated))"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>dom-4: If a resource is contained in another resource, it SHALL NOT have a meta.versionId or a meta.lastUpdated</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(for $id in f:contained/*/@id return $id[not(ancestor::f:contained/parent::*/descendant::f:reference/@value=concat('#', $id))]))"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(for $id in f:contained/*/@id return $id[not(ancestor::f:contained/parent::*/descendant::f:reference/@value=concat('#', $id))]))"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>dom-3: If the resource is contained in another resource, it SHALL be referred to from elsewhere in the resource</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:ClinicalImpression/f:text/h:div"
                  priority="1033"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:text/h:div"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(descendant-or-self::*[not(local-name(.)=('a', 'abbr', 'acronym', 'b', 'big', 'blockquote', 'br', 'caption', 'cite', 'code', 'col', 'colgroup', 'dd', 'dfn', 'div', 'dl', 'dt', 'em', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'hr', 'i', 'img', 'li', 'ol', 'p', 'pre', 'q', 'samp', 'small', 'span', 'strong', 'sub', 'sup', 'table', 'tbody', 'td', 'tfoot', 'th', 'thead', 'tr', 'tt', 'ul', 'var'))]) and not(descendant-or-self::*/@*[not(name(.)=('abbr', 'accesskey', 'align', 'alt', 'axis', 'bgcolor', 'border', 'cellhalign', 'cellpadding', 'cellspacing', 'cellvalign', 'char', 'charoff', 'charset', 'cite', 'class', 'colspan', 'compact', 'coords', 'dir', 'frame', 'headers', 'height', 'href', 'hreflang', 'hspace', 'id', 'lang', 'longdesc', 'name', 'nowrap', 'rel', 'rev', 'rowspan', 'rules', 'scope', 'shape', 'span', 'src', 'start', 'style', 'summary', 'tabindex', 'title', 'type', 'valign', 'value', 'vspace', 'width'))])"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(descendant-or-self::*[not(local-name(.)=('a', 'abbr', 'acronym', 'b', 'big', 'blockquote', 'br', 'caption', 'cite', 'code', 'col', 'colgroup', 'dd', 'dfn', 'div', 'dl', 'dt', 'em', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'hr', 'i', 'img', 'li', 'ol', 'p', 'pre', 'q', 'samp', 'small', 'span', 'strong', 'sub', 'sup', 'table', 'tbody', 'td', 'tfoot', 'th', 'thead', 'tr', 'tt', 'ul', 'var'))]) and not(descendant-or-self::*/@*[not(name(.)=('abbr', 'accesskey', 'align', 'alt', 'axis', 'bgcolor', 'border', 'cellhalign', 'cellpadding', 'cellspacing', 'cellvalign', 'char', 'charoff', 'charset', 'cite', 'class', 'colspan', 'compact', 'coords', 'dir', 'frame', 'headers', 'height', 'href', 'hreflang', 'hspace', 'id', 'lang', 'longdesc', 'name', 'nowrap', 'rel', 'rev', 'rowspan', 'rules', 'scope', 'shape', 'span', 'src', 'start', 'style', 'summary', 'tabindex', 'title', 'type', 'valign', 'value', 'vspace', 'width'))])"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>txt-1: The narrative SHALL contain only the basic html formatting elements and attributes described in chapters 7-11 (except section 4 of chapter 9) and 15 of the HTML 4.0 standard, &lt;a&gt; elements (either name or href), images and internally contained style attributes</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="descendant::text()[normalize-space(.)!=''] or descendant::h:img[@src]"/>
         <axsl:otherwise>
            <svrl:failed-assert test="descendant::text()[normalize-space(.)!=''] or descendant::h:img[@src]"
                                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
               <axsl:attribute name="location">
                  <axsl:apply-templates select="."
                                        mode="schematron-select-full-path"/>
               </axsl:attribute>
               <svrl:text>txt-2: The narrative SHALL have some non-whitespace content</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="*|comment()|processing-instruction()"
                            mode="M4"/>
   </axsl:template>
   <!--RULE -->
   <axsl:template match="f:ClinicalImpression/f:identifier/f:period"
                  priority="1032"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:identifier/f:assigner"
                  priority="1031"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:identifier/f:assigner"
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
   <axsl:template match="f:ClinicalImpression/f:subject"
                  priority="1030"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:subject"
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
   <axsl:template match="f:ClinicalImpression/f:subject/f:identifier/f:period"
                  priority="1029"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:subject/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:subject/f:identifier/f:assigner"
                  priority="1028"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:subject/f:identifier/f:assigner"
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
   <axsl:template match="f:ClinicalImpression/f:context"
                  priority="1027"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:context"
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
   <axsl:template match="f:ClinicalImpression/f:context/f:identifier/f:period"
                  priority="1026"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:context/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:context/f:identifier/f:assigner"
                  priority="1025"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:context/f:identifier/f:assigner"
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
   <axsl:template match="f:ClinicalImpression/f:effectivePeriod"
                  priority="1024"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:effectivePeriod"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:assessor"
                  priority="1023"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:assessor"
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
   <axsl:template match="f:ClinicalImpression/f:assessor/f:identifier/f:period"
                  priority="1022"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:assessor/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:assessor/f:identifier/f:assigner"
                  priority="1021"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:assessor/f:identifier/f:assigner"
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
   <axsl:template match="f:ClinicalImpression/f:previous"
                  priority="1020"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:previous"
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
   <axsl:template match="f:ClinicalImpression/f:previous/f:identifier/f:period"
                  priority="1019"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:previous/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:previous/f:identifier/f:assigner"
                  priority="1018"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:previous/f:identifier/f:assigner"
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
   <axsl:template match="f:ClinicalImpression/f:problem"
                  priority="1017"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:problem"
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
   <axsl:template match="f:ClinicalImpression/f:problem/f:identifier/f:period"
                  priority="1016"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:problem/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:problem/f:identifier/f:assigner"
                  priority="1015"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:problem/f:identifier/f:assigner"
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
   <axsl:template match="f:ClinicalImpression/f:investigation/f:item"
                  priority="1014"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:investigation/f:item"
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
   <axsl:template match="f:ClinicalImpression/f:investigation/f:item/f:identifier/f:period"
                  priority="1013"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:investigation/f:item/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:investigation/f:item/f:identifier/f:assigner"
                  priority="1012"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:investigation/f:item/f:identifier/f:assigner"
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
   <axsl:template match="f:ClinicalImpression/f:finding/f:itemReference"
                  priority="1011"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:finding/f:itemReference"
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
   <axsl:template match="f:ClinicalImpression/f:finding/f:itemReference/f:identifier/f:period"
                  priority="1010"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:finding/f:itemReference/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:finding/f:itemReference/f:identifier/f:assigner"
                  priority="1009"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:finding/f:itemReference/f:identifier/f:assigner"
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
   <axsl:template match="f:ClinicalImpression/f:prognosisReference"
                  priority="1008"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:prognosisReference"
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
   <axsl:template match="f:ClinicalImpression/f:prognosisReference/f:identifier/f:period"
                  priority="1007"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:prognosisReference/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:prognosisReference/f:identifier/f:assigner"
                  priority="1006"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:prognosisReference/f:identifier/f:assigner"
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
   <axsl:template match="f:ClinicalImpression/f:action"
                  priority="1005"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:action"
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
   <axsl:template match="f:ClinicalImpression/f:action/f:identifier/f:period"
                  priority="1004"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:action/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:action/f:identifier/f:assigner"
                  priority="1003"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:action/f:identifier/f:assigner"
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
   <axsl:template match="f:ClinicalImpression/f:note/f:authorReference"
                  priority="1002"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:note/f:authorReference"
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
   <axsl:template match="f:ClinicalImpression/f:note/f:authorReference/f:identifier/f:period"
                  priority="1001"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:note/f:authorReference/f:identifier/f:period"
                       xmlns:svrl="http://purl.oclc.org/dsdl/svrl"/>
      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"/>
         <axsl:otherwise>
            <svrl:failed-assert test="not(exists(f:start)) or not(exists(f:end)) or (f:start/@value &lt;= f:end/@value)"
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
   <axsl:template match="f:ClinicalImpression/f:note/f:authorReference/f:identifier/f:assigner"
                  priority="1000"
                  mode="M4">
      <svrl:fired-rule context="f:ClinicalImpression/f:note/f:authorReference/f:identifier/f:assigner"
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