<?xml version="1.0" encoding="UTF-8"?>

<?yatc-distribution-provenance href="HL7-mappings/hl7_2_ada/hl7/hl7_2_ada_hl7_include.xsl"?>
<?yatc-distribution-info name="ketenzorg-3.0.2" timestamp="2024-06-28T14:38:20.79+02:00" version="1.4.28"?>
<!-- == Provenance: HL7-mappings/hl7_2_ada/hl7/hl7_2_ada_hl7_include.xsl == -->
<!-- == Distribution: ketenzorg-3.0.2; 1.4.28; 2024-06-28T14:38:20.79+02:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3"
                xmlns:util="urn:hl7:utilities"
                xmlns:sdtc="urn:hl7-org:sdtc"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:hl7nl="urn:hl7-nl:v3"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <xsl:import href="constants.xsl"/>
   <xsl:import href="datetime.xsl"/>
   <xsl:import href="units.xsl"/>
   <xsl:import href="utilities.xsl"/>
   <xsl:import href="uuid.xsl"/>
   <!-- ada output language -->
   <xsl:param name="language">nl-NL</xsl:param>
   <xd:doc>
      <xd:desc>Returns an ISO 8601 date or dateTime string based on HL7v3 ts input string, and calculated precision 
<xd:p>Calculation is done by calling nf:determine_date_precision($dateTime)</xd:p>
         <xd:p>Example nf:formatHL72XMLDate(hl7:effectiveTime/@value)</xd:p>
         <xd:p>
            <xd:b>return</xd:b> date or dateTime. If no date or dateTime can be produced, a non-fatal error is issued and $input-hl7-date is returned as-is</xd:p>
      </xd:desc>
      <xd:param name="input-hl7-date">HL7 ts date/time string expected format yyyymmddHHMMSS.sssss[+-]ZZzz</xd:param>
   </xd:doc>
   <xsl:function name="nf:formatHL72XMLDate"
                 as="xs:string">
      <xsl:param name="input-hl7-date"
                 as="xs:string"/>
      <xsl:value-of select="nf:formatHL72XMLDate($input-hl7-date, nf:determine_date_precision($input-hl7-date))"/>
   </xsl:function>
   <xd:doc>
      <xd:desc>Returns an ISO 8601 date or dateTime string based on HL7v3 ts input string, and requested precision. 
<xd:p>Example nf:formatHL72XMLDate(hl7:effectiveTime/@value, nf:determine_date_precision(hl7:effectiveTime/@value))</xd:p>
         <xd:p>
            <xd:b>return</xd:b> date or dateTime. If no date or dateTime can be produced, a non-fatal error is issued and 
<xd:ref type="parameter"
                    name="input-hl7-date"/> is returned as-is</xd:p>
      </xd:desc>
      <xd:param name="input-hl7-date">HL7 ts date/time string expected format yyyymmddHHMMSS.sssss[+-]ZZzz</xd:param>
      <xd:param name="precision">Coded string indicator for requested precision. Use DAY for date and SECOND for dateTime. Note that if the input does not allow for dateTime, fallback to date is applied.</xd:param>
   </xd:doc>
   <xsl:function name="nf:formatHL72XMLDate"
                 as="xs:string">
      <xsl:param name="input-hl7-date"
                 as="xs:string?"/>
      <!-- precision determines the picture of the date format, only use case for day or second. -->
      <!-- Use formatHL72VagueAdaDate for other formats, such as year / month / hour / minute -->
      <xsl:param name="precision"/>
      <xsl:variable name="yyyy"
                    as="xs:string?">
         <xsl:if test="string-length($input-hl7-date) ge 4">
            <xsl:value-of select="substring($input-hl7-date, 1, 4)"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="mm"
                    as="xs:string?">
         <xsl:if test="string-length($input-hl7-date) ge 6">
            <xsl:value-of select="substring($input-hl7-date, 5, 2)"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="dd"
                    as="xs:string?">
         <xsl:if test="string-length($input-hl7-date) ge 8">
            <xsl:value-of select="substring($input-hl7-date, 7, 2)"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="HH"
                    as="xs:string?">
         <xsl:if test="string-length($input-hl7-date) ge 10">
            <xsl:value-of select="substring($input-hl7-date, 9, 2)"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="MM"
                    as="xs:string?">
         <xsl:if test="string-length($input-hl7-date) ge 12">
            <xsl:value-of select="substring($input-hl7-date, 11, 2)"/>
         </xsl:if>
      </xsl:variable>
      <!-- http://hl7.org/fhir/datatypes.html#dateTime
            Seconds must be provided due to schema type constraints but may be zero-filled and may be ignored at receiver discretion. 
        -->
      <xsl:variable name="SS"
                    as="xs:string?">
         <xsl:choose>
            <xsl:when test="string-length($input-hl7-date) ge 14">
               <xsl:value-of select="substring($input-hl7-date, 13, 2)"/>
            </xsl:when>
            <xsl:when test="string-length($input-hl7-date) ge 12">
               <xsl:text>00</xsl:text>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="sss"
                    as="xs:string?">
         <xsl:if test="matches($input-hl7-date, '^\d+(\.\d+)')">
            <xsl:value-of select="replace($input-hl7-date, '^\d+(\.\d+)', '$1')"/>
         </xsl:if>
      </xsl:variable>
      <!-- http://hl7.org/fhir/datatypes.html#dateTime
            If hours and minutes are specified, a time zone SHALL be populated.
        -->
      <xsl:variable name="TZ"
                    as="xs:string?">
         <xsl:if test="matches($input-hl7-date, '^\d+(\.\d+)')">
            <xsl:value-of select="replace($input-hl7-date, '.*([+-]\d{2,4})$', '$1')"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="str_date"
                    select="concat($yyyy, '-', $mm, '-', $dd)"/>
      <xsl:variable name="str_time"
                    select="concat($HH, ':', $MM, ':', $SS, $sss, $TZ)"/>
      <xsl:variable name="str_datetime"
                    select="concat($str_date, 'T', $str_time)"/>
      <xsl:choose>
         <xsl:when test="upper-case($precision) = ('SECOND', 'SECONDE', 'SECONDS', 'SECONDEN', 'SEC', 'S') and $str_datetime castable as xs:dateTime">
            <xsl:value-of select="$str_datetime"/>
         </xsl:when>
         <xsl:when test="upper-case($precision) = ('DAY', 'DAG', 'DAYS', 'DAGEN', 'D') and $str_date castable as xs:date">
            <xsl:value-of select="$str_date"/>
         </xsl:when>
         <xsl:when test="$str_datetime castable as xs:dateTime">
            <xsl:value-of select="$str_datetime"/>
         </xsl:when>
         <xsl:when test="$str_date castable as xs:date">
            <xsl:value-of select="$str_date"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- let's do a best effort and fall back on vague date time, even though that is unexpected here -->
            <xsl:value-of select="nf:formatHL72VagueAdaDate($input-hl7-date, $precision)"/>
            <xsl:call-template name="util:logMessage">
               <xsl:with-param name="level"
                               select="$logWARN"/>
               <xsl:with-param name="msg">Could not determine a proper xml date (time) from input: '
<xsl:value-of select="$input-hl7-date"/>' with precision: '
<xsl:value-of select="$precision"/>'. Falling back on vague date time.</xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xd:doc>
      <xd:desc>Returns possibly vague date or dateTime string based on HL7v3 ts input string, and requested precision. 
<xd:p>Example nf:formatHL72VagueAdaDate(hl7:effectiveTime/@value, nf:determine_date_precision(hl7:effectiveTime/@value))</xd:p>
         <xd:p>
            <xd:b>return</xd:b> date or dateTime. If no date or dateTime can be produced, a non-fatal error is issued and 
<xd:ref type="parameter"
                    name="input-hl7-date"/> is returned as-is</xd:p>
      </xd:desc>
      <xd:param name="input-hl7-date">HL7 ts date/time string expected format yyyymmddHHMMSS.sssss[+-]ZZzz</xd:param>
      <xd:param name="precision">Coded string indicator for requested precision. For example: DAY, HOUR, MINUTE, SECOND.</xd:param>
   </xd:doc>
   <xsl:function name="nf:formatHL72VagueAdaDate"
                 as="xs:string">
      <xsl:param name="input-hl7-date"
                 as="xs:string"/>
      <xsl:param name="precision"/>
      <!-- year -->
      <xsl:variable name="yyyy">
         <xsl:if test="string-length($input-hl7-date) ge 4">
            <xsl:value-of select="substring($input-hl7-date, 1, 4)"/>
         </xsl:if>
      </xsl:variable>
      <!-- month -->
      <xsl:variable name="mm">
         <xsl:if test="string-length($input-hl7-date) ge 6">
            <xsl:value-of select="substring($input-hl7-date, 5, 2)"/>
         </xsl:if>
      </xsl:variable>
      <!-- day -->
      <xsl:variable name="dd"
                    as="xs:string?">
         <xsl:if test="string-length($input-hl7-date) ge 8">
            <xsl:value-of select="substring($input-hl7-date, 7, 2)"/>
         </xsl:if>
      </xsl:variable>
      <!-- hour -->
      <xsl:variable name="HH"
                    as="xs:string?">
         <xsl:if test="string-length($input-hl7-date) ge 10">
            <xsl:value-of select="substring($input-hl7-date, 9, 2)"/>
         </xsl:if>
      </xsl:variable>
      <!-- minute -->
      <xsl:variable name="MM"
                    as="xs:string?">
         <xsl:if test="string-length($input-hl7-date) ge 12">
            <xsl:value-of select="substring($input-hl7-date, 11, 2)"/>
         </xsl:if>
      </xsl:variable>
      <!-- second -->
      <xsl:variable name="SS"
                    as="xs:string?">
         <xsl:if test="string-length($input-hl7-date) ge 14">
            <xsl:value-of select="substring($input-hl7-date, 13, 2)"/>
         </xsl:if>
      </xsl:variable>
      <!-- millisecond -->
      <xsl:variable name="sss"
                    as="xs:string?">
         <xsl:if test="matches($input-hl7-date, '^\d+(\.\d+)')">
            <xsl:value-of select="replace($input-hl7-date, '^\d+(\.\d+)', '$1')"/>
         </xsl:if>
      </xsl:variable>
      <!-- timezone -->
      <xsl:variable name="TZ"
                    as="xs:string?">
         <xsl:if test="matches($input-hl7-date, '^\d+(\.\d+)')">
            <xsl:value-of select="replace($input-hl7-date, '.*([+-]\d{2,4})$', '$1')"/>
         </xsl:if>
      </xsl:variable>
      <xsl:variable name="str_date"
                    select="concat($yyyy, '-', $mm, '-', $dd)"/>
      <xsl:variable name="str_time"
                    select="concat($HH, ':', $MM, ':', $SS, $sss, $TZ)"/>
      <xsl:variable name="str_datetime"
                    select="concat($str_date, 'T', $str_time)"/>
      <xsl:choose>
         <xsl:when test="upper-case($precision) = ('SECOND', 'SECONDE', 'SECONDS', 'SECONDEN', 'SEC', 'S')">
            <xsl:value-of select="$str_datetime"/>
         </xsl:when>
         <xsl:when test="upper-case($precision) = ('MINUTE', 'MINUUT', 'MINUTES', 'MINUTEN', 'MIN', 'M')">
            <xsl:value-of select="substring($str_datetime, 1, 16)"/>
         </xsl:when>
         <xsl:when test="upper-case($precision) = ('HOUR', 'UUR', 'HOURS', 'UREN', 'HR', 'HH', 'H', 'U')">
            <xsl:value-of select="substring($str_datetime, 1, 13)"/>
         </xsl:when>
         <xsl:when test="upper-case($precision) = ('DAY', 'DAG', 'DAYS', 'DAGEN', 'D')">
            <xsl:value-of select="$str_date"/>
         </xsl:when>
         <xsl:when test="$str_date castable as xs:dateTime">
            <xsl:value-of select="$str_date"/>
         </xsl:when>
         <xsl:when test="$str_date castable as xs:date">
            <xsl:value-of select="$str_date"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$input-hl7-date"/>
            <xsl:call-template name="util:logMessage">
               <xsl:with-param name="level"
                               select="$logWARN"/>
               <xsl:with-param name="msg">Could not determine xml date from input: '
<xsl:value-of select="$input-hl7-date"/>' with precision: '
<xsl:value-of select="$precision"/>'.</xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xd:doc>
      <xd:desc>Returns YEAR, MONTH, DAY, HOUR or MINUTE depending on input string-length, or SECOND otherwise. </xd:desc>
      <xd:param name="input-hl7-date">HL7 ts date/time string expected format yyyymmddHHMMSS.sssss[+-]ZZzz</xd:param>
   </xd:doc>
   <xsl:function name="nf:determine_date_precision">
      <xsl:param name="input-hl7-date"/>
      <xsl:choose>
         <xsl:when test="string-length($input-hl7-date) le 4">YEAR</xsl:when>
         <xsl:when test="string-length($input-hl7-date) le 6">MONTH</xsl:when>
         <xsl:when test="string-length($input-hl7-date) le 8">DAY</xsl:when>
         <xsl:when test="string-length($input-hl7-date) = 10">HOUR</xsl:when>
         <xsl:when test="string-length($input-hl7-date) = 12">MINUTE</xsl:when>
         <xsl:otherwise>SECOND</xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xd:doc>
      <xd:desc>appends an HL7 date with zeros so that an XML dateTime can be created or dates can be compared </xd:desc>
      <xd:param name="inputDate">HL7 ts date/time string expected format yyyymmddHHMMSS.sssss[+-]ZZzz</xd:param>
   </xd:doc>
   <xsl:function name="nf:appendDate2DateTime"
                 as="xs:string?">
      <xsl:param name="inputDate"
                 as="xs:string?"/>
      <!-- split date/time from subseconds/timezone (if any) -->
      <xsl:variable name="yyyymmddHHMMSS"
                    select="replace($inputDate, '^(\d+).*', '$1')"/>
      <xsl:variable name="ssZZzz"
                    select="substring($inputDate, string-length(replace($inputDate, '^(\d+).*', '$1')) + 1)"/>
      <xsl:value-of select="concat(substring(concat($yyyymmddHHMMSS, '00000000000000'), 1, 14), $ssZZzz)"/>
   </xsl:function>
   <xd:doc>
      <xd:desc> appends an HL7 date with zeros so that an XML possibly vague date or dateTime can be created </xd:desc>
      <xd:param name="inputDate">HL7 ts date/time string expected format yyyymmddHHMMSS.sssss[+-]ZZzz</xd:param>
   </xd:doc>
   <xsl:function name="nf:appendDate2DateOrTime"
                 as="xs:string?">
      <xsl:param name="inputDate"/>
      <!-- split date/time from subseconds/timezone (if any) -->
      <xsl:variable name="yyyymmddHHMMSS"
                    select="replace($inputDate, '^(\d+).*', '$1')"/>
      <xsl:variable name="ssZZzz"
                    select="substring($inputDate, string-length(replace($inputDate, '^(\d+).*', '$1')) + 1)"/>
      <xsl:choose>
         <xsl:when test="string-length($yyyymmddHHMMSS) gt 8">
            <xsl:value-of select="concat(substring(concat($yyyymmddHHMMSS, '00000000000000'), 1, 14), $ssZZzz)"/>
         </xsl:when>
         <xsl:when test="string-length($yyyymmddHHMMSS) = 6">
            <!-- we have received year and month, but no day, we add first day of the month -->
            <xsl:value-of select="concat($yyyymmddHHMMSS, '01')"/>
         </xsl:when>
         <xsl:when test="string-length($yyyymmddHHMMSS) = 4">
            <!-- we have received year no month, but no day, we add first day of the month -->
            <xsl:value-of select="concat($yyyymmddHHMMSS, '0101')"/>
         </xsl:when>
         <xsl:otherwise>
            <!-- appending an incomplete date with '00000' does result in invalid date -->
            <xsl:value-of select="substring(concat($yyyymmddHHMMSS, '00000000'), 1, 8)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xd:doc>
      <xd:desc> Returns an array of ADA elements based on an array of HL7v3 AND elements that have an @xsi:type attribute to determine the type with. 
<xd:p>After the type is determined, the element is handed off to handleXX for further processing. Failure to determine type is a fatal error.</xd:p>
         <xd:p>Supported values for @xsi:type (datatypes releases 1 in namespace "urn:hl7-org:v3"): BL (boolean), CS (code), CV (code), CE (code), CD (code), CO (code), II (identifier), PQ (quantity), ST (string), TS (date)</xd:p>
      </xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="elemName">Required. Name of the ADA element to produce</xd:param>
      <xd:param name="dodatatype">Boolean. If true creates relevant @datatype attribute on the output.</xd:param>
      <xd:param name="codeMap">Array of map elements to be used to map input HL7v3 codes to output ADA codes if those differ. For codeMap expect one or more elements like this: 
<xd:p>
            <xd:pre>&lt;map inCode="xx" inCodeSystem="yy" value=".." code=".." codeSystem=".." codeSystemName=".." codeSystemVersion=".." displayName=".." originalText=".."/&gt;</xd:pre>
         </xd:p>
         <xd:p>If input @code | @codeSystem matches, copy the other attributes from this element. Expected are usually @code, @codeSystem, @displayName, others optional. In some cases the @value is required in ADA. The $codeMap may then to be used to supply that @value based on @inCode / @inCodeSystem. If the @code / @codeSystem are omitted, the mapping assumes you meant to copy the @inCode / @inCodeSystem.</xd:p>
         <xd:p>For @inCode and @inCodeSystem, first the input @code/@codeSystem is checked, with fallback onto @nullFlavor.</xd:p>
      </xd:param>
      <xd:param name="codeSystem">CS has no codeSystem so it has to be supplied from external. Usually 
<xd:ref type="variable"
                 name="oidHL7ActStatus"/> or 
<xd:ref type="variable"
                 name="oidHL7RoleStatus"/>
      </xd:param>
      <xd:param name="nullIfMissing">Optional. If there is no element, and this has a value, create element anyway with given nullFlavor as code/coodeSystem/displayName</xd:param>
   </xd:doc>
   <xsl:template name="handleANY">
      <xsl:param name="in"
                 select="."
                 as="element()*"/>
      <xsl:param name="elemName"
                 as="xs:string"
                 required="yes"/>
      <xsl:param name="dodatatype"
                 select="false()"
                 as="xs:boolean"/>
      <xsl:param name="codeMap"
                 as="element()*"/>
      <xsl:param name="codeSystem"
                 as="xs:string?"/>
      <xsl:param name="nullIfMissing"
                 as="xs:string?"/>
      <xsl:if test="empty($in) and string-length($nullIfMissing) gt 0">
         <xsl:element name="{$elemName}">
            <xsl:attribute name="nullFlavor"
                           select="$nullIfMissing"/>
         </xsl:element>
      </xsl:if>
      <xsl:for-each select="$in">
         <xsl:variable name="xsiType"
                       select="@xsi:type"/>
         <xsl:variable name="xsiTypePrefix"
                       select="                     if (contains($xsiType, ':')) then                         (substring-before($xsiType, ':'))                     else                         ('')"/>
         <xsl:variable name="xsiTypeName"
                       select="                     if (contains($xsiType, ':')) then                         (substring-after($xsiType, ':'))                     else                         ($xsiType)"/>
         <xsl:variable name="xsiTypeURI"
                       select="namespace-uri-for-prefix($xsiTypePrefix, .)"/>
         <xsl:variable name="xsiTypeURIName"
                       select="concat('{', $xsiTypeURI, '}:', $xsiTypeName)"/>
         <xsl:choose>
            <xsl:when test="$xsiTypeURIName = '{urn:hl7-org:v3}:BL'">
               <xsl:call-template name="handleBL">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
                  <xsl:with-param name="datatype">
                     <xsl:if test="$dodatatype">boolean</xsl:if>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xsiTypeURIName = '{urn:hl7-org:v3}:CS'">
               <xsl:call-template name="handleCS">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="codeSystem"
                                  select="$codeSystem"/>
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
                  <xsl:with-param name="datatype">
                     <xsl:if test="$dodatatype">code</xsl:if>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xsiTypeURIName = '{urn:hl7-org:v3}:CV' or $xsiTypeURIName = '{urn:hl7-org:v3}:CE' or $xsiTypeURIName = '{urn:hl7-org:v3}:CD' or $xsiTypeURIName = '{urn:hl7-org:v3}:CO'">
               <xsl:call-template name="handleCV">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
                  <xsl:with-param name="datatype">
                     <xsl:if test="$dodatatype">code</xsl:if>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xsiTypeURIName = '{urn:hl7-org:v3}:II'">
               <xsl:call-template name="handleII">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
                  <xsl:with-param name="datatype">
                     <xsl:if test="$dodatatype">identifier</xsl:if>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xsiTypeURIName = '{urn:hl7-org:v3}:INT'">
               <xsl:call-template name="handleINT">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
                  <xsl:with-param name="datatype">
                     <xsl:if test="$dodatatype">count</xsl:if>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xsiTypeURIName = '{urn:hl7-org:v3}:PQ'">
               <xsl:call-template name="handlePQ">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
                  <xsl:with-param name="datatype">
                     <xsl:if test="$dodatatype">quantity</xsl:if>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xsiTypeURIName = '{urn:hl7-org:v3}:REAL'">
               <xsl:call-template name="handleINT">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
                  <xsl:with-param name="datatype">
                     <xsl:if test="$dodatatype">decimal</xsl:if>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xsiTypeURIName = '{urn:hl7-org:v3}:ST'">
               <xsl:call-template name="handleST">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
                  <xsl:with-param name="datatype">
                     <xsl:if test="$dodatatype">string</xsl:if>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <!-- Handle IVL_TS with @value or @nullFlavor the same as TS -->
            <xsl:when test="$xsiTypeURIName = '{urn:hl7-org:v3}:TS' or ($xsiTypeURIName = '{urn:hl7-org:v3}:IVL_TS' and (@value | @nullFlavor))">
               <xsl:call-template name="handleTS">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="elemName"
                                  select="$elemName"/>
                  <xsl:with-param name="datatype">
                     <xsl:if test="$dodatatype">date</xsl:if>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logFATAL"/>
                  <xsl:with-param name="terminate"
                                  select="true()"/>
                  <xsl:with-param name="msg">Cannot determine the datatype based on @xsi:type, or value not supported: 
<xsl:value-of select="$xsiType"/>. Calculated QName 
<xsl:value-of select="$xsiTypeURIName"/>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Copy ENXP parts as faithful as possible to HCIM 2017 nl.zorg.part.NameInformation. Calculate name usage code. Submit unstructured name in last_name </xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="language">Optional. Default: nl-NL. Determines the name of the child elements to create for this datatype</xd:param>
      <xd:param name="unstructurednameElement">Name of the element to put stuff in if there are no name parts. The HCIM does not support this but the ADA format might.</xd:param>
      <xd:param name="outputNaamgebruik">Whether or not to output naamgebruik, which is 0..1 in zib. Defaults to outputting naamgebruik</xd:param>
   </xd:doc>
   <xsl:template name="handleENtoNameInformation">
      <xsl:param name="in"
                 as="element()*"
                 required="yes"/>
      <xsl:param name="language"
                 as="xs:string?">nl-NL</xsl:param>
      <xsl:param name="outputNaamgebruik"
                 as="xs:boolean"
                 select="true()"/>
      <xsl:param name="unstructurednameElement"
                 as="xs:string?"/>
      <!-- Element names based on language -->
      <xsl:variable name="elemNameInformation">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">name_information</xsl:when>
            <xsl:otherwise>naamgegevens</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmUnstructuredName">
         <xsl:choose>
            <xsl:when test="string-length($unstructurednameElement) gt 0">
               <xsl:value-of select="$unstructurednameElement"/>
            </xsl:when>
            <xsl:when test="$language = 'en-US'">unstructured_name</xsl:when>
            <xsl:otherwise>ongestructureerde_naam</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmFirstNames">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">first_names</xsl:when>
            <xsl:otherwise>voornamen</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmGivenName">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">given_name</xsl:when>
            <xsl:otherwise>roepnaam</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmInitials">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">initials</xsl:when>
            <xsl:otherwise>initialen</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elemNameUsage">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">name_usage</xsl:when>
            <xsl:otherwise>naamgebruik</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmLastName">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">last_name</xsl:when>
            <xsl:otherwise>geslachtsnaam</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmLastNamePrefix">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">prefix</xsl:when>
            <xsl:otherwise>voorvoegsels</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmLastNameLastName">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">last_name</xsl:when>
            <xsl:otherwise>achternaam</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmLastNamePartner">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">last_name_partner</xsl:when>
            <xsl:otherwise>geslachtsnaam_partner</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmLastNamePartnerPrefix">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">partner_prefix</xsl:when>
            <xsl:otherwise>voorvoegsels_partner</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmLastNamePartnerLastName">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">partner_last_name</xsl:when>
            <xsl:otherwise>achternaam_partner</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- See for the HL7 spec of name: http://www.hl7.nl/wiki/index.php/DatatypesR1:PN -->
      <xsl:for-each select="$in">
         <xsl:element name="{$elemNameInformation}">
            <xsl:choose>
               <!-- Just @nullFlavor -->
               <xsl:when test="@nullFlavor">
                  <xsl:copy-of select="@nullFlavor"/>
               </xsl:when>
               <xsl:when test="string-length(normalize-space(string-join(.//text(), ''))) = 0">
                  <xsl:attribute name="nullFlavor">NI</xsl:attribute>
               </xsl:when>
               <!-- Structured name -->
               <xsl:when test="*">
                  <xsl:variable name="firstNames"
                                select="normalize-space(string-join(hl7:given[tokenize(@qualifier, '\s') = 'BR' or not(@qualifier)], ' '))"/>
                  <xsl:variable name="givenName"
                                select="normalize-space(string-join(hl7:given[tokenize(@qualifier, '\s') = 'CL'], ' '))"/>
                  <!-- in HL7v3 mogen de initialen van officiële voornamen niet herhaald / gedupliceerd worden in het initialen veld -->
                  <!-- https://hl7.nl/wiki/index.php?title=DatatypesR1:PN -->
                  <!-- in de zib moeten de initialen juist compleet zijn, dus de initialen hier toevoegen van de officiële voornamen -->
                  <!-- "Esther F.A." maar ook "Esther F A" of "F A Esther" wordt 
                             E.F.A. -->
                  <!-- Als de HL7v3 instance niet correct is gevuld en de voornaam ook in de initialen staat, komt op deze manier onterecht tweemaal 
                            dezelfde initiaal door. Als de HL7v3 instance wel goed is gevuld en we vullen de voornaam-initiaal niet aan, dan raken we deze 
                            juist kwijt. Je kunt je voorstellen dat we kijken of de voornaam-initiaal al voorkomt en hem dan niet toevoegen, maar dan zou 
                            Martha M(aria) niet goed gaan. 
                            We zijn dus sterk afhankelijk van de kwaliteit van implementaties. -->
                  <!-- Als er in de HL7v3 instance géén initialen zijn opgenomen, dan simpelweg ook géén initialen in ada opnemen -->
                  <xsl:variable name="initials"
                                as="xs:string*">
                     <xsl:if test="hl7:given[tokenize(@qualifier, '\s') = 'IN']">
                        <xsl:for-each select="hl7:given[not(tokenize(@qualifier, '\s') = 'IN')][tokenize(@qualifier, '\s') = 'BR']/tokenize(normalize-space(replace(., '\.', ' ')), '\s')">
                           <xsl:value-of select="concat(substring(., 1, 1), '.')"/>
                        </xsl:for-each>
                        <xsl:for-each select="hl7:given[tokenize(@qualifier, '\s') = 'IN']/tokenize(normalize-space(replace(., '\.', ' ')), '\s')">
                           <xsl:value-of select="concat(., '.')"/>
                        </xsl:for-each>
                     </xsl:if>
                  </xsl:variable>
                  <xsl:variable name="nameUsage">
                     <xsl:choose>
                        <xsl:when test="hl7:family[tokenize(@qualifier, '\s') = 'BR'] and empty(hl7:family[tokenize(@qualifier, '\s') = 'SP'])">
                           <xsl:element name="{$elemNameUsage}">
                              <xsl:attribute name="code">NL1</xsl:attribute>
                              <xsl:attribute name="codeSystem">2.16.840.1.113883.2.4.3.11.60.101.5.4</xsl:attribute>
                              <xsl:attribute name="displayName">Eigen geslachtsnaam</xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test="hl7:family[tokenize(@qualifier, '\s') = 'SP'] and empty(hl7:family[not(tokenize(@qualifier, '\s') = 'SP')])">
                           <xsl:element name="{$elemNameUsage}">
                              <xsl:attribute name="code">NL2</xsl:attribute>
                              <xsl:attribute name="codeSystem">2.16.840.1.113883.2.4.3.11.60.101.5.4</xsl:attribute>
                              <xsl:attribute name="displayName">Geslachtsnaam partner</xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test="hl7:family[tokenize(@qualifier, '\s') = 'SP']/following-sibling::hl7:family[not(@qualifier) or tokenize(@qualifier, '\s') = 'BR']">
                           <xsl:element name="{$elemNameUsage}">
                              <xsl:attribute name="code">NL3</xsl:attribute>
                              <xsl:attribute name="codeSystem">2.16.840.1.113883.2.4.3.11.60.101.5.4</xsl:attribute>
                              <xsl:attribute name="displayName">Geslachtsnaam partner gevolgd door eigen geslachtsnaam</xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test="hl7:family[tokenize(@qualifier, '\s') = 'BR']/following-sibling::hl7:family[tokenize(@qualifier, '\s') = 'SP']">
                           <xsl:element name="{$elemNameUsage}">
                              <xsl:attribute name="code">NL4</xsl:attribute>
                              <xsl:attribute name="codeSystem">2.16.840.1.113883.2.4.3.11.60.101.5.4</xsl:attribute>
                              <xsl:attribute name="displayName">Eigen geslachtsnaam gevolgd door geslachtsnaam partner</xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:element name="{$elemNameUsage}">
                              <xsl:attribute name="code">UNK</xsl:attribute>
                              <xsl:attribute name="codeSystem"
                                             select="$oidHL7NullFlavor"/>
                              <xsl:attribute name="displayName">Unknown</xsl:attribute>
                           </xsl:element>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="last_name"
                                select="normalize-space(string-join(hl7:family[tokenize(@qualifier, '\s') = 'BR' or not(@qualifier)], ''))"/>
                  <xsl:variable name="last_name_prefix">
                     <xsl:if test="hl7:prefix">
                        <xsl:choose>
                           <!-- prefix of type VV and BR, don't look any further -->
                           <!-- no normalize space to preserve spaces behind prefixes -->
                           <xsl:when test="hl7:prefix[tokenize(@qualifier, '\s') = 'VV'][tokenize(@qualifier, '\s') = 'BR']">
                              <xsl:value-of select="string-join(hl7:prefix[tokenize(@qualifier, '\s') = 'VV'][tokenize(@qualifier, '\s') = 'BR'], '')"/>
                           </xsl:when>
                           <!-- prefix of type VV and no family with qualifier, assume BR for both -->
                           <xsl:when test="hl7:prefix[tokenize(@qualifier, '\s') = 'VV'][not(following-sibling::hl7:family/@qualifier)]">
                              <xsl:value-of select="string-join(hl7:prefix[tokenize(@qualifier, '\s') = 'VV'][not(following-sibling::hl7:family/@qualifier)], '')"/>
                           </xsl:when>
                           <!-- prefix of type VV and first following sibling family with qualifier BR, assume BR for both -->
                           <xsl:when test="hl7:prefix[tokenize(@qualifier, '\s') = 'VV'][following-sibling::hl7:family[1][tokenize(@qualifier, '\s') = 'BR']]">
                              <xsl:value-of select="string-join(hl7:prefix[tokenize(@qualifier, '\s') = 'VV'][following-sibling::hl7:family[1][tokenize(@qualifier, '\s') = 'BR']], '')"/>
                           </xsl:when>
                           <!-- prefix without qualifier and no family with qualifier, assume BR for both -->
                           <xsl:when test="hl7:prefix[not(@qualifier)][not(following-sibling::hl7:family/@qualifier)]">
                              <xsl:value-of select="string-join(hl7:prefix[not(@qualifier)][not(following-sibling::hl7:family/@qualifier)], '')"/>
                           </xsl:when>
                           <!-- prefix without qualifier and first following sibling family with qualifier BR, assume BR for both -->
                           <xsl:when test="hl7:prefix[not(@qualifier)][following-sibling::hl7:family[1][tokenize(@qualifier, '\s') = 'BR']]">
                              <xsl:value-of select="string-join(hl7:prefix[not(@qualifier)][following-sibling::hl7:family[1][tokenize(@qualifier, '\s') = 'BR']], '')"/>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:if>
                  </xsl:variable>
                  <xsl:variable name="last_name_partner"
                                select="normalize-space(string-join(hl7:family[tokenize(@qualifier, '\s') = 'SP'], ''))"/>
                  <xsl:variable name="last_name_partner_prefix">
                     <xsl:if test="hl7:prefix">
                        <xsl:choose>
                           <!-- prefix of type VV and BR, don't look any further -->
                           <xsl:when test="hl7:prefix[tokenize(@qualifier, '\s') = 'VV'][tokenize(@qualifier, '\s') = 'SP']">
                              <xsl:value-of select="string-join(hl7:prefix[tokenize(@qualifier, '\s') = 'VV'][tokenize(@qualifier, '\s') = 'SP'], '')"/>
                           </xsl:when>
                           <!-- prefix of type VV and first following sibling family with qualifier SP, assume SP for both -->
                           <xsl:when test="hl7:prefix[tokenize(@qualifier, '\s') = 'VV'][following-sibling::hl7:family[1][tokenize(@qualifier, '\s') = 'SP']]">
                              <xsl:value-of select="string-join(hl7:prefix[tokenize(@qualifier, '\s') = 'VV'][following-sibling::hl7:family[1][tokenize(@qualifier, '\s') = 'SP']], '')"/>
                           </xsl:when>
                           <!-- prefix without qualifier and first following sibling family with qualifier SP, assume SP for both -->
                           <xsl:when test="hl7:prefix[not(@qualifier)][following-sibling::hl7:family[1][tokenize(@qualifier, '\s') = 'SP']]">
                              <xsl:value-of select="string-join(hl7:prefix[not(@qualifier)][following-sibling::hl7:family[1][tokenize(@qualifier, '\s') = 'SP']], '')"/>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:if>
                  </xsl:variable>
                  <xsl:if test="string-length($firstNames) gt 0">
                     <xsl:element name="{$elmFirstNames}">
                        <xsl:attribute name="value"
                                       select="$firstNames"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="not(empty($initials))">
                     <xsl:element name="{$elmInitials}">
                        <xsl:attribute name="value"
                                       select="string-join($initials, '')"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="string-length($givenName) gt 0">
                     <xsl:element name="{$elmGivenName}">
                        <xsl:attribute name="value"
                                       select="$givenName"/>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="$outputNaamgebruik">
                     <xsl:copy-of select="$nameUsage"/>
                  </xsl:if>
                  <xsl:if test="string-length($last_name) gt 0">
                     <xsl:element name="{$elmLastName}">
                        <xsl:if test="string-length($last_name_prefix) gt 0">
                           <xsl:element name="{$elmLastNamePrefix}">
                              <xsl:attribute name="value"
                                             select="$last_name_prefix"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:element name="{$elmLastNameLastName}">
                           <xsl:attribute name="value"
                                          select="$last_name"/>
                        </xsl:element>
                     </xsl:element>
                  </xsl:if>
                  <xsl:if test="string-length($last_name_partner) gt 0">
                     <xsl:element name="{$elmLastNamePartner}">
                        <xsl:if test="string-length($last_name_partner_prefix) gt 0">
                           <xsl:element name="{$elmLastNamePartnerPrefix}">
                              <xsl:attribute name="value"
                                             select="$last_name_partner_prefix"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:element name="{$elmLastNamePartnerLastName}">
                           <xsl:attribute name="value"
                                          select="$last_name_partner"/>
                        </xsl:element>
                     </xsl:element>
                  </xsl:if>
               </xsl:when>
               <!-- No name parts.... assume unstructured name element was added -->
               <xsl:otherwise>
                  <xsl:element name="{$elmUnstructuredName}">
                     <xsl:attribute name="value"
                                    select="."/>
                  </xsl:element>
                  <xsl:element name="{$elmLastName}">
                     <xsl:element name="{$elmLastNameLastName}">
                        <xsl:attribute name="nullFlavor">NI</xsl:attribute>
                     </xsl:element>
                  </xsl:element>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc> Copy address parts as faithful as possible to HCIM 2017 nl.zorg.part.AddressInformation. Calculate address code. Submit unstructured address in street Note: copies @code and @codeSystem for city, county and country too... </xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="language">Optional. Default: nl-NL. Determines the name of the child elements to create for this datatype. Also determines the displayName for adress type, since this is not available in HL7 instances. This defaults to english due to backwards compatibility reasons.</xd:param>
   </xd:doc>
   <xsl:template name="handleADtoAddressInformation">
      <xsl:param name="in"
                 as="element()*"
                 required="yes"/>
      <xsl:param name="language"
                 as="xs:string?">nl-NL</xsl:param>
      <!-- Element names based on language -->
      <xsl:variable name="elmAddressInformation">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">address_information</xsl:when>
            <xsl:otherwise>adresgegevens</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmStreet">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">street</xsl:when>
            <xsl:otherwise>straat</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmHouseNumber">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">house_number</xsl:when>
            <xsl:otherwise>huisnummer</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmHouseNumberLetter">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">house_number_letter</xsl:when>
            <xsl:otherwise>huisnummerletter</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmHouseNumberAddition">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">house_number_addition</xsl:when>
            <xsl:otherwise>huisnummertoevoeging</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmHouseNumberIndication">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">house_number_indication</xsl:when>
            <xsl:otherwise>aanduiding_bij_nummer</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmPostcode">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">postcode</xsl:when>
            <xsl:otherwise>postcode</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmPlaceOfResidence">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">place_of_residence</xsl:when>
            <xsl:otherwise>woonplaats</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmMunicipality">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">municipality</xsl:when>
            <xsl:otherwise>gemeente</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmCountry">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">country</xsl:when>
            <xsl:otherwise>land</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmAdditionalInformation">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">additional_information</xsl:when>
            <xsl:otherwise>additionele_informatie</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmAddressType">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">address_type</xsl:when>
            <xsl:otherwise>adres_soort</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:for-each select="$in">
         <xsl:variable name="theUse"
                       select="tokenize(@use, '\s')"/>
         <xsl:variable name="addressType"
                       as="element()*">
            <xsl:choose>
               <xsl:when test="$theUse">
                  <xsl:for-each select="distinct-values($theUse)">
                     <xsl:choose>
                        <xsl:when test=". = 'PST'">
                           <xsl:element name="{$elmAddressType}">
                              <xsl:attribute name="code">PST</xsl:attribute>
                              <xsl:attribute name="codeSystem"
                                             select="$oidHL7AddressUse"/>
                              <xsl:attribute name="displayName">
                                 <xsl:choose>
                                    <xsl:when test="$language = 'nl-NL'">Postadres</xsl:when>
                                    <xsl:otherwise>Postal Addres</xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test=". = 'HP'">
                           <xsl:element name="{$elmAddressType}">
                              <xsl:attribute name="code">HP</xsl:attribute>
                              <xsl:attribute name="codeSystem"
                                             select="$oidHL7AddressUse"/>
                              <xsl:attribute name="displayName">
                                 <xsl:choose>
                                    <xsl:when test="$language = 'nl-NL'">Officieel adres</xsl:when>
                                    <xsl:otherwise>Primary Home</xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test=". = 'PHYS'">
                           <xsl:element name="{$elmAddressType}">
                              <xsl:attribute name="code">PHYS</xsl:attribute>
                              <xsl:attribute name="codeSystem"
                                             select="$oidHL7AddressUse"/>
                              <xsl:attribute name="displayName">
                                 <xsl:choose>
                                    <xsl:when test="$language = 'nl-NL'">Woon-/verblijfadres</xsl:when>
                                    <xsl:otherwise>Visit Address</xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test=". = 'TMP'">
                           <xsl:element name="{$elmAddressType}">
                              <xsl:attribute name="code">TMP</xsl:attribute>
                              <xsl:attribute name="codeSystem"
                                             select="$oidHL7AddressUse"/>
                              <xsl:attribute name="displayName">
                                 <xsl:choose>
                                    <xsl:when test="$language = 'nl-NL'">Tijdelijk adres</xsl:when>
                                    <xsl:otherwise>Tempory Address</xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test=". = 'WP'">
                           <xsl:element name="{$elmAddressType}">
                              <xsl:attribute name="code">WP</xsl:attribute>
                              <xsl:attribute name="codeSystem"
                                             select="$oidHL7AddressUse"/>
                              <xsl:attribute name="displayName">
                                 <xsl:choose>
                                    <xsl:when test="$language = 'nl-NL'">Werkadres</xsl:when>
                                    <xsl:otherwise>Work Place</xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                        <xsl:when test=". = 'HV'">
                           <xsl:element name="{$elmAddressType}">
                              <xsl:attribute name="code">HV</xsl:attribute>
                              <xsl:attribute name="codeSystem"
                                             select="$oidHL7AddressUse"/>
                              <xsl:attribute name="displayName">
                                 <xsl:choose>
                                    <xsl:when test="$language = 'nl-NL'">Vakantie adres</xsl:when>
                                    <xsl:otherwise>Vacation Home</xsl:otherwise>
                                 </xsl:choose>
                              </xsl:attribute>
                           </xsl:element>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:element name="{$elmAddressType}">
                     <xsl:attribute name="nullFlavor">NI</xsl:attribute>
                  </xsl:element>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="currentAddress"
                       select="."/>
         <!-- output an address for each type, but also one address when there is no type, which is why we put a nullFlavor in that variable -->
         <xsl:for-each select="$addressType">
            <xsl:variable name="currentAddressType"
                          select="."/>
            <xsl:for-each select="$currentAddress">
               <xsl:choose>
                  <xsl:when test="*">
                     <xsl:for-each select="*[not(self::hl7:streetName | self::hl7:houseNumber | self::hl7:buildingNumberSuffix | self::hl7:unitID | self::hl7:additionalLocator | self::hl7:postalCode | self::hl7:city | self::hl7:county | self::hl7:country | self::hl7:desc)]">
                        <xsl:call-template name="util:logMessage">
                           <xsl:with-param name="level"
                                           select="$logWARN"/>
                           <xsl:with-param name="msg">Address contains unsupported address part: 
<xsl:value-of select="name()"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>
                     <xsl:variable name="street"
                                   select="hl7:streetName[not(. = '')]"/>
                     <xsl:variable name="houseNumber"
                                   select="hl7:houseNumber[not(. = '')]"/>
                     <xsl:variable name="houseNumberLetter">
                        <xsl:choose>
                           <xsl:when test="hl7:buildingNumberSuffix[matches(., ' ')]">
                              <xsl:value-of select="hl7:buildingNumberSuffix/substring-before(., ' ')[not(. = '')]"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="hl7:buildingNumberSuffix[not(. = '')]"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="houseNumberAddition">
                        <xsl:choose>
                           <xsl:when test="hl7:buildingNumberSuffix[matches(., ' ')]">
                              <xsl:value-of select="hl7:buildingNumberSuffix/substring-after(., ' ')[not(. = '')]"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="hl7:unitID[not(. = '')]"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="houseNumberIndication"
                                   select="hl7:additionalLocator[not(. = '')]"/>
                     <xsl:variable name="postcode"
                                   select="hl7:postalCode[not(. = '')]"/>
                     <xsl:variable name="placeOfResidence"
                                   select="hl7:city[@* or not(. = '')]"/>
                     <xsl:variable name="municipality"
                                   select="hl7:county[@* or not(. = '')]"/>
                     <xsl:variable name="country"
                                   select="hl7:country[@* or not(. = '')]"/>
                     <xsl:variable name="additionalInformation"
                                   select="hl7:desc[not(. = '')]"/>
                     <xsl:element name="{$elmAddressInformation}">
                        <xsl:if test="$street">
                           <xsl:element name="{$elmStreet}">
                              <xsl:attribute name="value"
                                             select="$street"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="$houseNumber">
                           <xsl:element name="{$elmHouseNumber}">
                              <xsl:attribute name="value"
                                             select="$houseNumber"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="$houseNumberLetter[not(. = '')]">
                           <xsl:element name="{$elmHouseNumberLetter}">
                              <xsl:attribute name="value"
                                             select="$houseNumberLetter"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="$houseNumberAddition[not(. = '')]">
                           <xsl:element name="{$elmHouseNumberAddition}">
                              <xsl:attribute name="value"
                                             select="$houseNumberAddition"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="$houseNumberIndication">
                           <xsl:element name="{$elmHouseNumberIndication}">
                              <xsl:attribute name="value"
                                             select="$houseNumberIndication"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="$postcode">
                           <xsl:element name="{$elmPostcode}">
                              <xsl:attribute name="value"
                                             select="$postcode"/>
                           </xsl:element>
                        </xsl:if>
                        <!-- Codes? -->
                        <xsl:if test="$placeOfResidence">
                           <xsl:element name="{$elmPlaceOfResidence}">
                              <xsl:if test="$placeOfResidence/text()">
                                 <xsl:attribute name="value"
                                                select="$placeOfResidence/text()"/>
                              </xsl:if>
                              <xsl:if test="$placeOfResidence/@code">
                                 <xsl:copy-of select="$placeOfResidence/@code"/>
                                 <xsl:copy-of select="$placeOfResidence/@codeSystem"/>
                                 <xsl:choose>
                                    <xsl:when test="$placeOfResidence/@displayName">
                                       <xsl:attribute name="displayName"
                                                      select="$placeOfResidence"/>
                                    </xsl:when>
                                    <xsl:when test="$placeOfResidence/text()">
                                       <xsl:attribute name="displayName"
                                                      select="$placeOfResidence/text()"/>
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                        <!-- Codes? -->
                        <xsl:if test="$municipality">
                           <xsl:element name="{$elmMunicipality}">
                              <xsl:if test="$municipality/text()">
                                 <xsl:attribute name="value"
                                                select="$municipality/text()"/>
                              </xsl:if>
                              <xsl:if test="$municipality/@code">
                                 <xsl:copy-of select="$municipality/@code"/>
                                 <xsl:copy-of select="$municipality/@codeSystem"/>
                                 <xsl:choose>
                                    <xsl:when test="$municipality/@displayName">
                                       <xsl:attribute name="displayName"
                                                      select="$municipality"/>
                                    </xsl:when>
                                    <xsl:when test="$municipality/text()">
                                       <xsl:attribute name="displayName"
                                                      select="$municipality/text()"/>
                                    </xsl:when>
                                 </xsl:choose>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                        <!-- Codes? -->
                        <!-- country is an element of type code in ada, so do not map an uncoded string to the value attribute, as it will lead to ada validation issue -->
                        <xsl:if test="$country">
                           <xsl:element name="{$elmCountry}">
                              <xsl:choose>
                                 <xsl:when test="$country[@*]">
                                    <xsl:copy-of select="$country/@code"/>
                                    <xsl:copy-of select="$country/@codeSystem"/>
                                    <xsl:copy-of select="$country/@codeSystemVersion"/>
                                    <xsl:copy-of select="$country/@codeSystemName"/>
                                    <xsl:choose>
                                       <xsl:when test="$country/@displayName">
                                          <xsl:attribute name="displayName"
                                                         select="$country/@displayName"/>
                                       </xsl:when>
                                       <xsl:when test="$country/text()">
                                          <xsl:attribute name="displayName"
                                                         select="$country/text()"/>
                                       </xsl:when>
                                    </xsl:choose>
                                    <xsl:copy-of select="$country/@originalText"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <!-- no coded input, we'll do our best for Netherlands -->
                                    <xsl:if test="$country/text()">
                                       <xsl:choose>
                                          <xsl:when test="upper-case(normalize-space($country/text())) = ('NEDERLAND', 'THE NETHERLANDS')">
                                             <xsl:attribute name="code">NL</xsl:attribute>
                                             <xsl:attribute name="codeSystem">1.0.3166.1.2.2</xsl:attribute>
                                             <xsl:attribute name="displayName">Nederland</xsl:attribute>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <!-- not in value, due to validation errors -->
                                             <xsl:attribute name="displayName"
                                                            select="$country/text()"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </xsl:if>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="$additionalInformation">
                           <xsl:element name="{$elmAdditionalInformation}">
                              <xsl:attribute name="value"
                                             select="$additionalInformation"/>
                           </xsl:element>
                        </xsl:if>
                        <xsl:if test="$currentAddressType[@code]">
                           <xsl:copy-of select="$currentAddressType"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:element name="{$elmAddressInformation}">
                        <!-- No address parts... submit as street -->
                        <xsl:element name="{$elmStreet}">
                           <xsl:attribute name="value"
                                          select="."/>
                        </xsl:element>
                        <xsl:copy-of select="$currentAddressType"/>
                     </xsl:element>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc> Copy contact parts as faithful as possible to HCIM 2017 nl.zorg.part.ContactInformation. Calculate contact type code. </xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="language">Optional. Default: nl-NL. Determines the name of the child elements to create for this datatype</xd:param>
      <xd:param name="outputTelecomType">Optional, defaults to true(). Determines whether to output the ada element telecom_type.</xd:param>
   </xd:doc>
   <xsl:template name="handleTELtoContactInformation">
      <xsl:param name="in"
                 as="element()*"
                 required="yes"/>
      <xsl:param name="language"
                 as="xs:string?">nl-NL</xsl:param>
      <xsl:param name="outputTelecomType"
                 as="xs:boolean?"
                 select="true()"/>
      <!-- Element names based on language -->
      <xsl:variable name="elmContactInformation">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">contact_information</xsl:when>
            <xsl:otherwise>contactgegevens</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmTelephoneNumbers">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">telephone_numbers</xsl:when>
            <xsl:otherwise>telefoonnummers</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmTelephoneNumber">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">telephone_number</xsl:when>
            <xsl:otherwise>telefoonnummer</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmTelecomType">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">telecom_type</xsl:when>
            <xsl:otherwise>telecom_type</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmNumberType">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">number_type</xsl:when>
            <xsl:otherwise>nummer_soort</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmEmailAddresses">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">email_addresses</xsl:when>
            <xsl:otherwise>email_adressen</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmEmailAddress">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">email_address</xsl:when>
            <xsl:otherwise>email_adres</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmEmailAddressType">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">email_address_type</xsl:when>
            <xsl:otherwise>email_soort</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="$in">
         <xsl:variable name="telephoneNumbers"
                       select="$in[matches(@value, '^(tel|fax):')] | $in[matches(@value, '^[\d\s\(\)+-]+$')]"
                       as="element()*"/>
         <xsl:variable name="emailAddresses"
                       select="$in[matches(@value, '^mailto:')] | $in[matches(@value, '.+@[^\.]+\.')]"
                       as="element()*"/>
         <xsl:for-each select="$in[not(matches(@value, '^(tel|fax):')) and not(matches(@value, '^[\d\s\(\)+-]+$')) and not(matches(@value, '^mailto:')) and not(matches(@value, '.+@[^\.]+\.'))]">
            <xsl:call-template name="util:logMessage">
               <xsl:with-param name="level"
                               select="$logWARN"/>
               <xsl:with-param name="terminate"
                               select="false()"/>
               <xsl:with-param name="msg">Encountered a telecom value in HL7 which could not be translated into a telephone number or email address, the value that could not be translated: 
<xsl:value-of select="string-join(@value, ' ')"/>.</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
         <xsl:if test="$telephoneNumbers | $emailAddresses">
            <xsl:element name="{$elmContactInformation}">
               <xsl:for-each select="$telephoneNumbers">
                  <xsl:element name="{$elmTelephoneNumbers}">
                     <xsl:variable name="theUse"
                                   select="tokenize(@use, '\s')"/>
                     <xsl:variable name="telecomType"
                                   as="element()?">
                        <xsl:choose>
                           <!-- @use=MC or any of +316... +3106... 06... 6... are mobile numbers -->
                           <xsl:when test="tokenize(@use, '\s') = 'MC' or matches(replace(normalize-space(@value), '[^\d]', ''), '^(31)?0?6')">
                              <xsl:element name="{$elmTelecomType}">
                                 <xsl:attribute name="code">MC</xsl:attribute>
                                 <xsl:attribute name="codeSystem"
                                                select="$oidHL7AddressUse"/>
                                 <xsl:attribute name="displayName">Mobiele telefoon</xsl:attribute>
                              </xsl:element>
                           </xsl:when>
                           <!-- @use=PG is a pager -->
                           <xsl:when test="tokenize(@use, '\s') = 'PG'">
                              <xsl:element name="{$elmTelecomType}">
                                 <xsl:attribute name="code">PG</xsl:attribute>
                                 <xsl:attribute name="codeSystem"
                                                select="$oidHL7AddressUse"/>
                                 <xsl:attribute name="displayName">Pieper</xsl:attribute>
                              </xsl:element>
                           </xsl:when>
                           <!-- @value starts with fax: is a fax (note that this RFC is obsolete so in practice this scheme should not occur) -->
                           <xsl:when test="starts-with(@value, 'fax:')">
                              <xsl:element name="{$elmTelecomType}">
                                 <xsl:attribute name="code">FAX</xsl:attribute>
                                 <xsl:attribute name="codeSystem">2.16.840.1.113883.2.4.3.11.60.40.4.22.1</xsl:attribute>
                                 <xsl:attribute name="displayName">Fax</xsl:attribute>
                              </xsl:element>
                           </xsl:when>
                           <!-- anything else is a landline. hence this includes 0900, 0800 and 088 (national numbers). we do this not because 
                                            it is necessarily true, but because the HCIM says the element is required and LandLine is the best worst option
                                            https://zibs.nl/wiki/ContactInformation-v1.0(2017EN)
                                            NL-CM:20.6.5			TelecomType	1	The telecom or device type that the telephone number is connected to.
                                            
                                            https://bits.nictiz.nl/browse/ZIB-761
                                            https://bits.nictiz.nl/browse/ZIB-958
                                        -->
                           <xsl:otherwise>
                              <xsl:element name="{$elmTelecomType}">
                                 <!--<xsl:attribute name="code">LL</xsl:attribute>
                                                <xsl:attribute name="codeSystem">2.16.840.1.113883.2.4.3.11.60.40.4.22.1</xsl:attribute>
                                                <xsl:attribute name="displayName">Landline</xsl:attribute>-->
                                 <xsl:attribute name="code">UNK</xsl:attribute>
                                 <xsl:attribute name="codeSystem"
                                                select="$oidHL7NullFlavor"/>
                                 <xsl:attribute name="displayName">unknown</xsl:attribute>
                              </xsl:element>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="numberType"
                                   as="element()?">
                        <xsl:choose>
                           <xsl:when test="$theUse = 'WP'">
                              <xsl:element name="{$elmNumberType}">
                                 <xsl:attribute name="code">WP</xsl:attribute>
                                 <xsl:attribute name="codeSystem"
                                                select="$oidHL7AddressUse"/>
                                 <xsl:attribute name="displayName">Work place</xsl:attribute>
                              </xsl:element>
                           </xsl:when>
                           <xsl:when test="$theUse = 'HP'">
                              <xsl:element name="{$elmNumberType}">
                                 <xsl:attribute name="code">HP</xsl:attribute>
                                 <xsl:attribute name="codeSystem"
                                                select="$oidHL7AddressUse"/>
                                 <xsl:attribute name="displayName">Primary Home</xsl:attribute>
                              </xsl:element>
                           </xsl:when>
                           <xsl:when test="$theUse = 'TMP'">
                              <xsl:element name="{$elmNumberType}">
                                 <xsl:attribute name="code">TMP</xsl:attribute>
                                 <xsl:attribute name="codeSystem"
                                                select="$oidHL7AddressUse"/>
                                 <xsl:attribute name="displayName">Temporary Address</xsl:attribute>
                              </xsl:element>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:element name="{$elmTelephoneNumber}">
                        <!-- remove the tel: or fax: prefix, since that information is in telecomtype -->
                        <xsl:attribute name="value"
                                       select="replace(@value, '^((tel|fax):)(.+)', '$3')"/>
                     </xsl:element>
                     <xsl:if test="$outputTelecomType">
                        <xsl:copy-of select="$telecomType"/>
                     </xsl:if>
                     <xsl:copy-of select="$numberType"/>
                  </xsl:element>
               </xsl:for-each>
               <xsl:for-each select="$emailAddresses">
                  <xsl:element name="{$elmEmailAddresses}">
                     <xsl:variable name="theUse"
                                   select="tokenize(@use, '\s')"/>
                     <xsl:variable name="emailType"
                                   as="element()?">
                        <xsl:choose>
                           <xsl:when test="$theUse = 'WP'">
                              <xsl:element name="{$elmEmailAddressType}">
                                 <xsl:attribute name="code">WP</xsl:attribute>
                                 <xsl:attribute name="codeSystem"
                                                select="$oidHL7AddressUse"/>
                                 <xsl:attribute name="displayName">Work place</xsl:attribute>
                              </xsl:element>
                           </xsl:when>
                           <xsl:when test="$theUse = 'HP'">
                              <xsl:element name="{$elmEmailAddressType}">
                                 <xsl:attribute name="code">HP</xsl:attribute>
                                 <xsl:attribute name="codeSystem"
                                                select="$oidHL7AddressUse"/>
                                 <xsl:attribute name="displayName">Primary Home</xsl:attribute>
                              </xsl:element>
                           </xsl:when>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:element name="{$elmEmailAddress}">
                        <xsl:attribute name="value"
                                       select="replace(@value, '^(mailto:)(.+)', '$2')"/>
                     </xsl:element>
                     <xsl:if test="$emailType">
                        <xsl:copy-of select="$emailType"/>
                     </xsl:if>
                  </xsl:element>
               </xsl:for-each>
            </xsl:element>
         </xsl:if>
      </xsl:if>
   </xsl:template>
   <xd:doc>
      <xd:desc>Returns an array of ADA elements based on an array of HL7v3 CS elements. CS has no displayName. The code, e.g. active or completed, normally reflects the displayName too so copy code to displayName. 
<xd:p>Input is first rewritten into full CV elements, and then passed off to handleCV for producing the ADA output</xd:p>
      </xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="elemName">Required. Name of the ADA element to produce</xd:param>
      <xd:param name="datatype">Optional. If populated this is the value for the @datatype attribute on the output. No @datatype is created otherwise</xd:param>
      <xd:param name="codeMap">Array of map elements to be used to map input HL7v3 codes to output ADA codes if those differ. For codeMap expect one or more elements like this: 
<xd:p>
            <xd:pre>&lt;map inCode="xx" inCodeSystem="yy" value=".." code=".." codeSystem=".." codeSystemName=".." codeSystemVersion=".." displayName=".." originalText=".."/&gt;</xd:pre>
         </xd:p>
         <xd:p>If input @code | @codeSystem matches, copy the other attributes from this element. Expected are usually @code, @codeSystem, @displayName, others optional. In some cases the @value is required in ADA. The $codeMap may then to be used to supply that @value based on @inCode / @inCodeSystem. If the @code / @codeSystem are omitted, the mapping assumes you meant to copy the @inCode / @inCodeSystem.</xd:p>
         <xd:p>For @inCode and @inCodeSystem, first the input @code/@codeSystem is checked, with fallback onto @nullFlavor.</xd:p>
      </xd:param>
      <xd:param name="codeSystem">CS has no codeSystem so it has to be supplied from external. Usually 
<xd:ref type="variable"
                 name="oidHL7ActStatus"/> or 
<xd:ref type="variable"
                 name="oidHL7RoleStatus"/>
      </xd:param>
      <xd:param name="nullIfMissing">Optional. If there is no element, and this has a value, create element anyway with given nullFlavor as code/coodeSystem/displayName</xd:param>
   </xd:doc>
   <xsl:template name="handleCS">
      <xsl:param name="in"
                 select="."
                 as="element()*"/>
      <xsl:param name="elemName"
                 as="xs:string"
                 required="yes"/>
      <xsl:param name="datatype"
                 as="xs:string?"/>
      <xsl:param name="codeMap"
                 as="element()*"/>
      <xsl:param name="codeSystem"
                 as="xs:string"
                 required="yes"/>
      <xsl:param name="nullIfMissing"
                 as="xs:string?"/>
      <xsl:variable name="rewrite"
                    as="element()*">
         <xsl:for-each select="$in">
            <xsl:element name="{name(.)}">
               <xsl:copy-of select="@*"/>
               <xsl:if test="not(@codeSystem)">
                  <xsl:attribute name="codeSystem"
                                 select="$codeSystem"/>
               </xsl:if>
               <xsl:if test="not(@displayName)">
                  <xsl:attribute name="displayName"
                                 select="@code"/>
               </xsl:if>
               <xsl:copy-of select="node()"/>
            </xsl:element>
         </xsl:for-each>
      </xsl:variable>
      <xsl:call-template name="handleCV">
         <xsl:with-param name="in"
                         select="$rewrite"/>
         <xsl:with-param name="elemName"
                         select="$elemName"/>
         <xsl:with-param name="datatype"
                         select="$datatype"/>
         <xsl:with-param name="codeMap"
                         select="$codeMap"/>
         <xsl:with-param name="nullIfMissing"
                         select="$nullIfMissing"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc> Returns an array of ADA elements based on an array of HL7v3 CV elements. @nullFlavor is rewritten into ADA @code/@codeSystem attributes as ADA does not know @nullFlavor for coded elements.</xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="elemName">Required. Name of the ADA element to produce</xd:param>
      <xd:param name="datatype">Optional. If populated this is the value for the @datatype attribute on the output. No @datatype is created otherwise</xd:param>
      <xd:param name="codeMap">Array of map elements to be used to map input HL7v3 codes to output ADA codes if those differ. For codeMap expect one or more elements like this: 
<xd:p>
            <xd:pre>&lt;map inCode="xx" inCodeSystem="yy" value=".." code=".." codeSystem=".." codeSystemName=".." codeSystemVersion=".." displayName=".." originalText=".."/&gt;</xd:pre>
         </xd:p>
         <xd:p>If input @code | @codeSystem matches, copy the other attributes from this element. Expected are usually @code, @codeSystem, @displayName, others optional. In some cases the @value is required in ADA. The $codeMap may then to be used to supply that @value based on @inCode / @inCodeSystem. If the @code / @codeSystem are omitted, the mapping assumes you meant to copy the @inCode / @inCodeSystem.</xd:p>
         <xd:p>For @inCode and @inCodeSystem, first the input @code/@codeSystem is checked, with fallback onto @nullFlavor.</xd:p>
      </xd:param>
      <xd:param name="nullIfMissing">Optional. If there is no element, and this has a value, create element anyway with given nullFlavor as code/codeSystem/displayName</xd:param>
   </xd:doc>
   <xsl:template name="handleCV">
      <xsl:param name="in"
                 select="."
                 as="element()*"/>
      <xsl:param name="elemName"
                 as="xs:string"
                 required="yes"/>
      <xsl:param name="datatype"
                 as="xs:string?"/>
      <xsl:param name="codeMap"
                 as="element()*"/>
      <xsl:param name="nullIfMissing"
                 as="xs:string?"/>
      <!-- handle empty in element and still output null -->
      <xsl:if test="empty($in) and string-length($nullIfMissing) gt 0">
         <xsl:variable name="theCode"
                       select="$nullIfMissing"/>
         <xsl:variable name="theCodeSystem"
                       select="$oidHL7NullFlavor"/>
         <xsl:variable name="out"
                       as="element()">
            <xsl:choose>
               <xsl:when test="$codeMap[@inCode = $theCode][@inCodeSystem = $theCodeSystem]">
                  <xsl:copy-of select="$codeMap[@inCode = $theCode][@inCodeSystem = $theCodeSystem]"/>
               </xsl:when>
               <xsl:when test="$codeMap[@inCode = $theCode][@inCodeSystem = $theCodeSystem]">
                  <xsl:copy-of select="$codeMap[@inCode = $theCode][@inCodeSystem = $theCodeSystem]"/>
               </xsl:when>
               <xsl:otherwise>
                  <element code="{$nullIfMissing}"
                           codeSystem="{$theCodeSystem}"
                           displayName="{$nullIfMissing}"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:copy-of select="$out/@code"/>
            <xsl:copy-of select="$out/@codeSystem"/>
            <xsl:copy-of select="$out/@displayName"/>
         </xsl:element>
      </xsl:if>
      <!-- process the input element -->
      <xsl:for-each select="$in">
         <xsl:variable name="theCode">
            <xsl:choose>
               <xsl:when test="@code">
                  <xsl:value-of select="@code"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="@nullFlavor"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="theCodeSystem">
            <xsl:choose>
               <xsl:when test="@code">
                  <xsl:value-of select="@codeSystem"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$oidHL7NullFlavor"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="out"
                       as="element()">
            <xsl:choose>
               <xsl:when test="$codeMap[@inCode = $theCode][@inCodeSystem = $theCodeSystem]">
                  <xsl:copy-of select="$codeMap[@inCode = $theCode][@inCodeSystem = $theCodeSystem]"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="."/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:copy-of select="$out/@value"/>
            <xsl:choose>
               <xsl:when test="$out/@nullFlavor">
                  <xsl:attribute name="code"
                                 select="$out/@nullFlavor"/>
                  <xsl:attribute name="codeSystem"
                                 select="$oidHL7NullFlavor"/>
                  <xsl:choose>
                     <xsl:when test="$out/@displayName">
                        <xsl:copy-of select="$out/@displayName"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:copy-of select="$hl7NullFlavorMap[@hl7NullFlavor = $out/@nullFlavor]/@displayName"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:copy-of select="$out/@code"/>
                  <!-- In the case where codeMap if only used to add a @value for ADA, this saves having to repeat the @inCode and @inCodeSystem as @code resp. @codeSystem -->
                  <xsl:if test="not($out/@code) and not(empty($theCode))">
                     <xsl:attribute name="code"
                                    select="$theCode"/>
                  </xsl:if>
                  <xsl:copy-of select="$out/@codeSystem"/>
                  <xsl:if test="not($out/@codeSystem) and not(empty($theCodeSystem))">
                     <xsl:attribute name="codeSystem"
                                    select="$theCodeSystem"/>
                  </xsl:if>
                  <xsl:copy-of select="$out/@codeSystemName"/>
                  <xsl:copy-of select="$out/@codeSystemVersion"/>
                  <xsl:copy-of select="$out/@displayName"/>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="hl7:originalText">
               <xsl:attribute name="originalText"
                              select="hl7:originalText"/>
            </xsl:if>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Returns an array of ADA elements based on an array of HL7v3 BL elements.</xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="elemName">Required. Name of the ADA element to produce</xd:param>
      <xd:param name="datatype">Optional. If populated this is the value for the @datatype attribute on the output. No @datatype is created otherwise</xd:param>
      <xd:param name="nullIfMissing">Optional. If there is no element, and this has a value, create element anyway with given nullFlavor</xd:param>
   </xd:doc>
   <xsl:template name="handleBL">
      <xsl:param name="in"
                 as="element()*"
                 select="."/>
      <xsl:param name="elemName"
                 as="xs:string"
                 required="yes"/>
      <xsl:param name="datatype"
                 as="xs:string?"/>
      <xsl:param name="nullIfMissing"
                 as="xs:string?"/>
      <xsl:if test="empty($in) and string-length($nullIfMissing) gt 0">
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:attribute name="nullFlavor"
                           select="$nullIfMissing"/>
         </xsl:element>
      </xsl:if>
      <xsl:for-each select="$in">
         <xsl:if test="@value[not(. = ('true', 'false'))]">
            <xsl:call-template name="util:logMessage">
               <xsl:with-param name="level"
                               select="$logFATAL"/>
               <xsl:with-param name="msg">Message contains illegal boolean value. Expected 'true' or 'false'. Found: "
<xsl:value-of select="$in/@value"/>" </xsl:with-param>
               <xsl:with-param name="terminate"
                               select="true()"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:copy-of select="@value"/>
            <xsl:copy-of select="@nullFlavor"/>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Returns an array of ADA elements based on an array of HL7v3 II elements.</xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="elemName">Required. Name of the ADA element to produce</xd:param>
      <xd:param name="datatype">Optional. If populated this is the value for the @datatype attribute on the output. No @datatype is created otherwise</xd:param>
      <xd:param name="nullIfMissing">Optional. If there is no element, and this has a value, create element anyway with given nullFlavor</xd:param>
   </xd:doc>
   <xsl:template name="handleII">
      <xsl:param name="in"
                 select="."
                 as="element()*"/>
      <xsl:param name="elemName"
                 as="xs:string"
                 required="yes"/>
      <xsl:param name="datatype"
                 as="xs:string?"/>
      <xsl:param name="nullIfMissing"
                 as="xs:string?"/>
      <xsl:for-each select="$in[@root]">
         <xsl:choose>
            <xsl:when test="matches(@root, $OIDpattern)"/>
            <xsl:when test="matches(@root, $UUIDpattern)">
               <!-- Rare but technically possible -->
            </xsl:when>
            <xsl:when test="matches(@root, $OIDpatternlenient)">
               <xsl:call-template name="util:logMessage">
                  <xsl:with-param name="level"
                                  select="$logERROR"/>
                  <xsl:with-param name="msg">OID SHALL NOT have leading zeroes in its nodes: 
<xsl:value-of select="@root"/>. This MUST be fixed in the source application before continuing.</xsl:with-param>
                  <!-- Is this too strict? -->
                  <xsl:with-param name="terminate"
                                  select="true()"/>
               </xsl:call-template>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
      <xsl:if test="empty($in) and string-length($nullIfMissing) gt 0">
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:attribute name="nullFlavor"
                           select="$nullIfMissing"/>
         </xsl:element>
      </xsl:if>
      <xsl:for-each select="$in">
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:if test="@extension">
               <xsl:attribute name="value"
                              select="@extension"/>
            </xsl:if>
            <xsl:copy-of select="@root"/>
            <xsl:copy-of select="@nullFlavor"/>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Returns an array of ADA elements based on an array of HL7v3 INT elements.</xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="elemName">Required. Name of the ADA element to produce</xd:param>
      <xd:param name="datatype">Optional. If populated this is the value for the @datatype attribute on the output. No @datatype is created otherwise</xd:param>
      <xd:param name="nullIfMissing">Optional. If there is no element, and this has a value, create element anyway with given nullFlavor</xd:param>
   </xd:doc>
   <xsl:template name="handleINT">
      <xsl:param name="in"
                 select="."
                 as="element()*"/>
      <xsl:param name="elemName"
                 as="xs:string"
                 required="yes"/>
      <xsl:param name="datatype"
                 as="xs:string?"/>
      <xsl:param name="nullIfMissing"
                 as="xs:string?"/>
      <xsl:if test="empty($in) and string-length($nullIfMissing) gt 0">
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:attribute name="nullFlavor"
                           select="$nullIfMissing"/>
         </xsl:element>
      </xsl:if>
      <xsl:for-each select="$in">
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:copy-of select="@value"/>
            <xsl:copy-of select="@nullFlavor"/>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Returns an array of ADA elements based on an array of HL7v3 PQ elements.</xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="elemName">Required. Name of the ADA element to produce</xd:param>
      <xd:param name="datatype">Optional. If populated this is the value for the @datatype attribute on the output. No @datatype is created otherwise</xd:param>
      <xd:param name="nullIfMissing">Optional. If there is no element, and this has a value, create element anyway with given nullFlavor</xd:param>
   </xd:doc>
   <xsl:template name="handlePQ">
      <xsl:param name="in"
                 select="."
                 as="element()*"/>
      <xsl:param name="elemName"
                 as="xs:string"
                 required="yes"/>
      <xsl:param name="datatype"
                 as="xs:string?"/>
      <xsl:param name="nullIfMissing"
                 as="xs:string?"/>
      <xsl:if test="empty($in) and string-length($nullIfMissing) gt 0">
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:attribute name="nullFlavor"
                           select="$nullIfMissing"/>
         </xsl:element>
      </xsl:if>
      <xsl:for-each select="$in">
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:copy-of select="@value"/>
            <xsl:copy-of select="@unit[not(. = '1')]"/>
            <xsl:copy-of select="@nullFlavor"/>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Returns an array of ADA elements based on an array of HL7v3 ST elements.</xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="elemName">Required. Name of the ADA element to produce</xd:param>
      <xd:param name="datatype">Optional. If populated this is the value for the @datatype attribute on the output. No @datatype is created otherwise</xd:param>
      <xd:param name="nullIfMissing">Optional. If there is no element, and this has a value, create element anyway with given nullFlavor</xd:param>
   </xd:doc>
   <xsl:template name="handleST">
      <xsl:param name="in"
                 select="."
                 as="element()*"/>
      <xsl:param name="elemName"
                 as="xs:string"
                 required="yes"/>
      <xsl:param name="datatype"
                 as="xs:string?"/>
      <xsl:param name="nullIfMissing"
                 as="xs:string?"/>
      <xsl:if test="empty($in) and string-length($nullIfMissing) gt 0">
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:attribute name="nullFlavor"
                           select="$nullIfMissing"/>
         </xsl:element>
      </xsl:if>
      <xsl:for-each select="$in">
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:if test="text()[not(normalize-space() = '')]">
               <xsl:attribute name="value"
                              select="."/>
            </xsl:if>
            <xsl:copy-of select="@nullFlavor"/>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Returns an array of ADA elements based on an array of HL7v3 TS elements. The ADA attribute @value will be created, if the input has a @value, with as much precision as possible based on the input.</xd:desc>
      <xd:param name="in">Optional. Array of elements to process. If empty array, then no output is created.</xd:param>
      <xd:param name="elemName">Required. Name of the ADA element to produce</xd:param>
      <xd:param name="datatype">Optional. If populated this is the value for the @datatype attribute on the output. No @datatype is created otherwise</xd:param>
      <xd:param name="nullIfMissing">Optional. If there is no element, and this has a value, create element anyway with given nullFlavor</xd:param>
      <xd:param name="vagueDate">Optional, defaults to false. Whether vague date(time) is allowed as output (i.e. non-valid XML date(time))</xd:param>
   </xd:doc>
   <xsl:template name="handleTS">
      <xsl:param name="in"
                 select="."
                 as="element()*"/>
      <xsl:param name="elemName">value</xsl:param>
      <xsl:param name="datatype"
                 as="xs:string?"/>
      <xsl:param name="nullIfMissing"
                 as="xs:string?"/>
      <xsl:param name="vagueDate"
                 as="xs:boolean?"
                 select="false()"/>
      <xsl:if test="empty($in) and string-length($nullIfMissing) gt 0">
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:attribute name="nullFlavor"
                           select="$nullIfMissing"/>
         </xsl:element>
      </xsl:if>
      <xsl:for-each select="$in">
         <xsl:variable name="value"
                       as="xs:string?">
            <xsl:choose>
               <xsl:when test="@value and $vagueDate">
                  <xsl:value-of select="nf:formatHL72VagueAdaDate(@value, nf:determine_date_precision(@value))"/>
               </xsl:when>
               <xsl:when test="@value">
                  <xsl:value-of select="nf:formatHL72XMLDate(@value, nf:determine_date_precision(@value))"/>
               </xsl:when>
            </xsl:choose>
         </xsl:variable>
         <xsl:element name="{$elemName}">
            <xsl:if test="string-length($datatype) gt 0">
               <xsl:attribute name="datatype"
                              select="$datatype"/>
            </xsl:if>
            <xsl:if test="string-length($value) gt 0">
               <xsl:attribute name="value"
                              select="$value"/>
            </xsl:if>
            <xsl:copy-of select="@nullFlavor"/>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc> auteur - zib2020 </xd:desc>
      <xd:param name="in-hl7">hl7 element assigned Contents, typically an assignedAuthor or assignedEntity</xd:param>
      <xd:param name="generateId">whether or not to output an ada id on the root element of zorgverlener and zorgaanbieder, optional, default to false()</xd:param>
      <xd:param name="outputNaamgebruik">whether or not to output naamgebruik, default to true()</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.37_20210701">
      <xsl:param name="in-hl7"
                 select="."/>
      <xsl:param name="generateId"
                 as="xs:boolean?"
                 select="false()"/>
      <xsl:param name="outputNaamgebruik"
                 as="xs:boolean?"
                 select="true()"/>
      <xsl:for-each select="$in-hl7">
         <zorgverlener>
            <xsl:if test="$generateId">
               <xsl:attribute name="id">
                  <xsl:value-of select="generate-id()"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="handleII">
               <xsl:with-param name="in"
                               select="hl7:id"/>
               <xsl:with-param name="elemName">zorgverlener_identificatienummer</xsl:with-param>
            </xsl:call-template>
            <!-- naamgegevens -->
            <xsl:call-template name="handleENtoNameInformation">
               <xsl:with-param name="in"
                               select="hl7:assignedPerson/hl7:name"/>
               <xsl:with-param name="language">nl-NL</xsl:with-param>
               <xsl:with-param name="unstructurednameElement">ongestructureerde_naam</xsl:with-param>
               <xsl:with-param name="outputNaamgebruik"
                               select="$outputNaamgebruik"/>
            </xsl:call-template>
            <!-- specialisme -->
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="hl7:code"/>
               <xsl:with-param name="elemName">specialisme</xsl:with-param>
            </xsl:call-template>
            <!-- geslacht, new hl7nl element from zib-2020 -->
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="hl7:assignedPerson/hl7nl:administrativeGenderCode"/>
               <xsl:with-param name="elemName">geslacht</xsl:with-param>
            </xsl:call-template>
            <!-- adresgegevens -->
            <xsl:call-template name="handleADtoAddressInformation">
               <xsl:with-param name="in"
                               select="hl7:addr"/>
            </xsl:call-template>
            <!-- contactgegevens -->
            <xsl:call-template name="handleTELtoContactInformation">
               <xsl:with-param name="in"
                               select="hl7:telecom"/>
            </xsl:call-template>
            <!-- zorgaanbieder -->
            <xsl:for-each select="hl7:representedOrganization">
               <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.33_20210701">
                  <xsl:with-param name="hl7-current-organization"
                                  select="."/>
                  <xsl:with-param name="generateId"
                                  select="$generateId"/>
               </xsl:call-template>
            </xsl:for-each>
            <!-- zorgverlener_rol -->
            <!-- no mapping in HL7 on this valueset, it is typically implicit / derivable from context, 
                    for example in the location of the zorgverlener in the surrounding zib (author/performer) -->
         </zorgverlener>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc> uitvoerende - zib2020 </xd:desc>
      <xd:param name="in-hl7">hl7 element performer</xd:param>
      <xd:param name="generateId">whether or not to output an ada id on the root element of zorgverlener and zorgaanbieder, optional, default to false()</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.43_20210701">
      <xsl:param name="in-hl7"
                 select="."/>
      <xsl:param name="generateId"
                 as="xs:boolean?"
                 select="false()"/>
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.37_20210701">
         <xsl:with-param name="in-hl7"
                         select="$in-hl7/hl7:assignedEntity"/>
         <xsl:with-param name="generateId"
                         select="$generateId"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>CDArecordTargetSDTC</xd:desc>
      <xd:param name="in">hl7 patient to be converted</xd:param>
      <xd:param name="language">optional, defaults to nl-NL</xd:param>
      <xd:param name="generateAttributeId">Whether to generate an id attribute for the ada patient. Depends on ada xsd whether this is applicable. Defaults to false.</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1_20180601000000"
                 match="hl7:patient | hl7:patientRole">
      <xsl:param name="in"
                 as="node()?"
                 select="."/>
      <xsl:param name="language"
                 as="xs:string?">nl-NL</xsl:param>
      <xsl:param name="generateAttributeId"
                 as="xs:boolean?"
                 select="false()"/>
      <xsl:variable name="current-patient"
                    select="$in"/>
      <!-- Element names based on language -->
      <xsl:variable name="elmPatient">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">patient</xsl:when>
            <xsl:otherwise>patient</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmId">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">patient-identification-number</xsl:when>
            <xsl:otherwise>identificatienummer</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmBirthdat">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">date-of-birth</xsl:when>
            <xsl:otherwise>geboortedatum</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmGender">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">gender</xsl:when>
            <xsl:otherwise>geslacht</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmMultipleBirthInd">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">multiple_birth_indicator</xsl:when>
            <xsl:otherwise>meerling_indicator</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- ada output for patient -->
      <xsl:element name="{$elmPatient}">
         <xsl:if test="$generateAttributeId">
            <xsl:attribute name="id"
                           select="generate-id(.)"/>
         </xsl:if>
         <!-- naamgegevens -->
         <xsl:for-each select="$current-patient/(hl7:Person | hl7:patient)/hl7:name">
            <xsl:call-template name="handleENtoNameInformation">
               <xsl:with-param name="in"
                               select="."/>
               <xsl:with-param name="language"
                               select="$language"/>
            </xsl:call-template>
         </xsl:for-each>
         <!-- adresgegevens -->
         <xsl:for-each select="$current-patient/hl7:addr">
            <xsl:call-template name="handleADtoAddressInformation">
               <xsl:with-param name="in"
                               select="."/>
               <xsl:with-param name="language"
                               select="$language"/>
            </xsl:call-template>
         </xsl:for-each>
         <!-- contactgegevens -->
         <xsl:call-template name="handleTELtoContactInformation">
            <xsl:with-param name="in"
                            select="$current-patient/hl7:telecom"/>
            <xsl:with-param name="language"
                            select="$language"/>
         </xsl:call-template>
         <!-- identificatienummer -->
         <xsl:call-template name="handleII">
            <xsl:with-param name="in"
                            select="$current-patient/hl7:id"/>
            <xsl:with-param name="elemName"
                            select="$elmId"/>
         </xsl:call-template>
         <!-- geboortedatum -->
         <xsl:call-template name="handleTS">
            <xsl:with-param name="in"
                            select="$current-patient/(hl7:Person | hl7:patient)/hl7:birthTime"/>
            <xsl:with-param name="elemName"
                            select="$elmBirthdat"/>
         </xsl:call-template>
         <!-- geslacht -->
         <xsl:call-template name="handleCV">
            <xsl:with-param name="in"
                            select="$current-patient/(hl7:Person | hl7:patient)/hl7:administrativeGenderCode"/>
            <xsl:with-param name="elemName"
                            select="$elmGender"/>
         </xsl:call-template>
         <!-- meerlingindicator -->
         <xsl:call-template name="handleBL">
            <xsl:with-param name="in"
                            select="$current-patient/(hl7:Person | hl7:patient)/(hl7:multipleBirthInd | sdtc:multipleBirthInd)"/>
            <xsl:with-param name="elemName"
                            select="$elmMultipleBirthInd"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xd:doc>
      <xd:desc> CDArecordTargetSDTC-NL-BSN-Minimal </xd:desc>
      <xd:param name="in"/>
      <xd:param name="elementName"/>
      <xd:param name="language"/>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.2_20170602000000">
      <xsl:param name="in"
                 select="."
                 as="element()*"/>
      <xsl:param name="elementName"
                 as="xs:string?"/>
      <xsl:param name="language">nl-NL</xsl:param>
      <!-- Element names -->
      <xsl:variable name="elmPatient">
         <xsl:choose>
            <xsl:when test="not(empty($elementName))">
               <xsl:value-of select="$elementName"/>
            </xsl:when>
            <xsl:when test="$language = 'en-US'">patient</xsl:when>
            <xsl:otherwise>patient</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmPatientIdentificationNumber">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">patient_identification_number</xsl:when>
            <xsl:otherwise>identificatienummer</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmDateOfBirth">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">date_of_birth</xsl:when>
            <xsl:otherwise>geboortedatum</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmGender">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">gender</xsl:when>
            <xsl:otherwise>geslacht</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmMultipleBirthInd">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">multiple_birth_indicator</xsl:when>
            <xsl:otherwise>meerling_indicator</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmDeceasedInd">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">deceased_indicator</xsl:when>
            <xsl:otherwise>overlijdens_indicator</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="elmDeceasedDate">
         <xsl:choose>
            <xsl:when test="$language = 'en-US'">date_of_death</xsl:when>
            <xsl:otherwise>datum_overlijden</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:element name="{$elmPatient}">
         <xsl:call-template name="handleENtoNameInformation">
            <xsl:with-param name="in"
                            select="$in/hl7:patient/hl7:name"/>
            <xsl:with-param name="language"
                            select="$language"/>
         </xsl:call-template>
         <xsl:call-template name="handleADtoAddressInformation">
            <xsl:with-param name="in"
                            select="$in/hl7:addr"/>
            <xsl:with-param name="language"
                            select="$language"/>
         </xsl:call-template>
         <xsl:call-template name="handleTELtoContactInformation">
            <xsl:with-param name="in"
                            select="$in/hl7:telecom"/>
            <xsl:with-param name="language"
                            select="$language"/>
         </xsl:call-template>
         <xsl:call-template name="handleII">
            <xsl:with-param name="in"
                            select="$in/hl7:id"/>
            <xsl:with-param name="elemName"
                            select="$elmPatientIdentificationNumber"/>
         </xsl:call-template>
         <xsl:call-template name="handleTS">
            <xsl:with-param name="in"
                            select="$in/hl7:patient/hl7:birthTime"/>
            <xsl:with-param name="elemName"
                            select="$elmDateOfBirth"/>
         </xsl:call-template>
         <xsl:call-template name="handleCV">
            <xsl:with-param name="in"
                            select="$in/hl7:patient/hl7:administrativeGenderCode"/>
            <xsl:with-param name="elemName"
                            select="$elmGender"/>
         </xsl:call-template>
         <xsl:call-template name="handleBL">
            <xsl:with-param name="in"
                            select="$in/hl7:patient/*:multipleBirthInd"/>
            <xsl:with-param name="elemName"
                            select="$elmMultipleBirthInd"/>
         </xsl:call-template>
         <xsl:call-template name="handleBL">
            <xsl:with-param name="in"
                            select="$in/hl7:patient/*:deceasedInd"/>
            <xsl:with-param name="elemName"
                            select="$elmDeceasedInd"/>
         </xsl:call-template>
         <xsl:call-template name="handleTS">
            <xsl:with-param name="in"
                            select="$in/hl7:patient/*:deceasedTime"/>
            <xsl:with-param name="elemName"
                            select="$elmDeceasedDate"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xd:doc>
      <xd:desc> contactpersoon as relatedEntity - zib2020 </xd:desc>
      <xd:param name="in-hl7">hl7 element containing the relatedEntity</xd:param>
      <xd:param name="generateId">whether or not to output an ada id on the root element, optional, default to false()</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.30_20210701">
      <xsl:param name="in-hl7"
                 select="."/>
      <xsl:param name="generateId"
                 as="xs:boolean?"
                 select="false()"/>
      <contactpersoon>
         <xsl:if test="$generateId = true()">
            <xsl:attribute name="id"
                           select="generate-id()"/>
         </xsl:if>
         <!-- naam -->
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.36_naam_20210701">
            <xsl:with-param name="in-hl7"
                            select="hl7:relatedPerson[hl7:name]"/>
         </xsl:call-template>
         <!-- adres / contact / rol -->
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.31_20210701">
            <xsl:with-param name="in-hl7"
                            select="."/>
         </xsl:call-template>
         <!-- relatie -->
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.36_relatie_20210701">
            <xsl:with-param name="in-hl7"
                            select="hl7:relatedPerson[sdtc:asPatientRelationship]"/>
         </xsl:call-template>
      </contactpersoon>
   </xsl:template>
   <xd:doc>
      <xd:desc> shared part 1 of contactpersoon - zib2020 </xd:desc>
      <xd:param name="in-hl7">hl7 element containing the contact person code/address/telecom</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.31_20210701">
      <xsl:param name="in-hl7"
                 select="."/>
      <xsl:for-each select="$in-hl7">
         <!-- contactgegevens -->
         <xsl:call-template name="handleTELtoContactInformation">
            <xsl:with-param name="in"
                            select="hl7:telecom"/>
            <xsl:with-param name="language"
                            select="$language"/>
         </xsl:call-template>
         <!-- adresgegevens -->
         <!-- address information -->
         <xsl:call-template name="handleADtoAddressInformation">
            <xsl:with-param name="in"
                            select="hl7:addr"/>
            <xsl:with-param name="language"
                            select="$language"/>
         </xsl:call-template>
         <!-- rol -->
         <xsl:for-each select="hl7:code">
            <xsl:call-template name="handleCV">
               <xsl:with-param name="elemName">rol</xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc> auteur - zib2020 </xd:desc>
      <xd:param name="author-hl7">hl7 element author</xd:param>
      <xd:param name="generateId">whether or not to output an ada id on the root element of zorgverlener and zorgaanbieder, optional, default to false()</xd:param>
      <xd:param name="outputNaamgebruik">whether or not to output naamgebruik, default to true()</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.32_20210701">
      <xsl:param name="author-hl7"
                 select="."/>
      <xsl:param name="generateId"
                 as="xs:boolean?"
                 select="false()"/>
      <xsl:param name="outputNaamgebruik"
                 as="xs:boolean?"
                 select="true()"/>
      <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.37_20210701">
         <xsl:with-param name="in-hl7"
                         select="$author-hl7/hl7:assignedAuthor"/>
         <xsl:with-param name="generateId"
                         select="$generateId"/>
         <xsl:with-param name="outputNaamgebruik"
                         select="$outputNaamgebruik"/>
      </xsl:call-template>
   </xsl:template>
   <xd:doc>
      <xd:desc>zib2020 zorgaanbieder</xd:desc>
      <xd:param name="hl7-current-organization">input hl7 organization</xd:param>
      <xd:param name="generateId">whether or not to output an ada id on the root element, optional, default to false()</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.33_20210701">
      <xsl:param name="hl7-current-organization"/>
      <xsl:param name="generateId"
                 as="xs:boolean?"
                 select="false()"/>
      <xsl:for-each select="$hl7-current-organization">
         <zorgaanbieder>
            <xsl:if test="$generateId">
               <xsl:attribute name="id">
                  <xsl:value-of select="generate-id()"/>
               </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="handleII">
               <xsl:with-param name="in"
                               select="hl7:id"/>
               <xsl:with-param name="elemName">zorgaanbieder_identificatienummer</xsl:with-param>
            </xsl:call-template>
            <!-- organisatienaam has 1..1 R in MP 9 ADA transactions, but is not always present in HL7 input messages.  -->
            <!-- fill with nullFlavor if necessary -->
            <xsl:call-template name="handleST">
               <xsl:with-param name="in"
                               select="hl7:name"/>
               <xsl:with-param name="elemName">organisatie_naam</xsl:with-param>
               <xsl:with-param name="nullIfMissing">NI</xsl:with-param>
            </xsl:call-template>
            <!-- afdeling_specialisme -->
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="hl7:asOrganizationPartOf/hl7:code"/>
               <xsl:with-param name="elemName">afdeling_specialisme</xsl:with-param>
            </xsl:call-template>
            <!-- contactgegevens -->
            <xsl:call-template name="handleTELtoContactInformation">
               <xsl:with-param name="in"
                               select="hl7:telecom"/>
            </xsl:call-template>
            <!-- adresgegevens -->
            <xsl:call-template name="handleADtoAddressInformation">
               <xsl:with-param name="in"
                               select="hl7:addr"/>
               <xsl:with-param name="language">nl-NL</xsl:with-param>
            </xsl:call-template>
            <!-- organisatie_type -->
            <xsl:call-template name="handleCV">
               <xsl:with-param name="in"
                               select="hl7:standardIndustryClassCode"/>
               <xsl:with-param name="elemName">organisatie_type</xsl:with-param>
            </xsl:call-template>
         </zorgaanbieder>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc> contactpersoon as author/assignedAuthor or performer/assignedEntity - zib2020 </xd:desc>
      <xd:param name="in-hl7">hl7 element containing the assignedAuthor or assignedEntity</xd:param>
      <xd:param name="generateId">whether or not to output an ada id on the root element, optional, default to false()</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.35_20210701">
      <xsl:param name="in-hl7"
                 select="."/>
      <xsl:param name="generateId"
                 as="xs:boolean?"
                 select="false()"/>
      <contactpersoon>
         <xsl:if test="$generateId = true()">
            <xsl:attribute name="id"
                           select="generate-id()"/>
         </xsl:if>
         <!-- naam -->
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.36_naam_20210701">
            <xsl:with-param name="in-hl7"
                            select="hl7:assignedPerson[hl7:name]"/>
         </xsl:call-template>
         <!-- adres / contact / rol -->
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.31_20210701">
            <xsl:with-param name="in-hl7"
                            select="."/>
         </xsl:call-template>
         <!-- relatie -->
         <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.36_relatie_20210701">
            <xsl:with-param name="in-hl7"
                            select="hl7:assignedPerson[sdtc:asPatientRelationship]"/>
         </xsl:call-template>
      </contactpersoon>
   </xsl:template>
   <xd:doc>
      <xd:desc> shared part 2 of contactpersoon - zib2020 - only name </xd:desc>
      <xd:param name="in-hl7">hl7 element containing the contact person name</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.36_naam_20210701">
      <xsl:param name="in-hl7"
                 select="."/>
      <xsl:for-each select="$in-hl7">
         <!-- naamgegevens -->
         <xsl:for-each select="hl7:name">
            <!-- naamgegevens -->
            <xsl:call-template name="handleENtoNameInformation">
               <xsl:with-param name="in"
                               select="."/>
               <xsl:with-param name="language"
                               select="$language"/>
               <!-- naamgebruik is not part of the MP transactions for voorschrijver -->
               <xsl:with-param name="outputNaamgebruik"
                               select="false()"/>
            </xsl:call-template>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc> shared part 2 of contactpersoon - zib2020 - only relation</xd:desc>
      <xd:param name="in-hl7">hl7 element containing the relation to the patient</xd:param>
   </xd:doc>
   <xsl:template name="template_2.16.840.1.113883.2.4.3.11.60.121.10.36_relatie_20210701">
      <xsl:param name="in-hl7"
                 select="."/>
      <!-- relatie -->
      <xsl:for-each select="$in-hl7/sdtc:asPatientRelationship[sdtc:code]">
         <xsl:call-template name="handleCV">
            <xsl:with-param name="in"
                            select="sdtc:code"/>
            <xsl:with-param name="elemName">relatie</xsl:with-param>
         </xsl:call-template>
      </xsl:for-each>
   </xsl:template>
   <xd:doc>
      <xd:desc>Returns an XML comment on the output that marks that the output is generated content, and shows what instance (element name + hl7:id or hl7:code or hl7:templateId) it came from</xd:desc>
      <xd:param name="in">Optional explicit element to start from, if not the context node.</xd:param>
   </xd:doc>
   <xsl:template name="doGeneratedComment">
      <xsl:param name="in"
                 select="."
                 as="node()*"/>
      <xsl:variable name="firstHL7Element"
                    select="$in/descendant-or-self::hl7:*[1]"
                    as="element()?"/>
      <xsl:comment>
         <xsl:text>Generated from HL7v3 </xsl:text>
         <xsl:choose>
            <xsl:when test="$firstHL7Element">
               <xsl:value-of select="$firstHL7Element/local-name()"/>
               <xsl:text>
               </xsl:text>
            </xsl:when>
            <xsl:otherwise/>
         </xsl:choose>
         <xsl:text>instance</xsl:text>
         <xsl:choose>
            <xsl:when test="$firstHL7Element/hl7:id">
               <xsl:text> with: </xsl:text>
               <xsl:text>&lt;id</xsl:text>
               <xsl:for-each select="($firstHL7Element/hl7:id)[1]/@*">
                  <xsl:value-of select="concat(' ', name(), '=&#34;', ., '&#34;')"/>
               </xsl:for-each>
               <xsl:text>/&gt;</xsl:text>
            </xsl:when>
            <xsl:when test="$firstHL7Element/hl7:code">
               <xsl:text> with: </xsl:text>
               <xsl:text>&lt;code</xsl:text>
               <xsl:for-each select="($firstHL7Element/hl7:code)[1]/@*">
                  <xsl:value-of select="concat(' ', name(), '=&#34;', ., '&#34;')"/>
               </xsl:for-each>
               <xsl:text>/&gt;</xsl:text>
            </xsl:when>
            <xsl:when test="$firstHL7Element/hl7:templateId">
               <xsl:text> with: </xsl:text>
               <xsl:text>&lt;templateId</xsl:text>
               <xsl:for-each select="($firstHL7Element/hl7:templateId)[1]/@*">
                  <xsl:value-of select="concat(' ', name(), '=&#34;', ., '&#34;')"/>
               </xsl:for-each>
               <xsl:text>/&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>.</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:comment>
      <xsl:text>
      </xsl:text>
   </xsl:template>
   <xd:doc>
      <xd:desc>Copy template with specific mode adaOutput, to output the actual ada xml</xd:desc>
   </xd:doc>
   <xsl:template match="@* | node()"
                 mode="adaOutput">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"
                              mode="adaOutput"/>
      </xsl:copy>
   </xsl:template>
   <xd:doc>
      <xd:desc>Do not copy elements with id, they should be copied by other template/mode, for example mode adaOutputHcim</xd:desc>
   </xd:doc>
   <xsl:template match="*[@id]"
                 mode="adaOutput">
      <!-- this is the actual ada hcim do nothing here -->
   </xsl:template>
   <xd:doc>
      <xd:desc>Copy template with specific mode adaOutputHcim, to output the Hcim's being referred to at the correct place in the transaction</xd:desc>
   </xd:doc>
   <xsl:template match="*[@id]"
                 mode="adaOutputHcim">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"
                              mode="adaOutput"/>
      </xsl:copy>
   </xsl:template>
   <xd:doc>
      <xd:desc>If 
<xd:ref name="in"
                 type="parameter"/> holds a value, return the upper-cased combined string of @value/@root/@unit/@code/@codeSystem/@nullFlavor. Else return empty</xd:desc>
      <xd:param name="in">The ada element for which to return a default key to determine uniqueness of the contents of the element</xd:param>
   </xd:doc>
   <xsl:function name="nf:getGroupingKeyDefaulthl72ada"
                 as="xs:string?">
      <xsl:param name="in"
                 as="element()?"/>
      <xsl:if test="$in">
         <xsl:value-of select="upper-case(string-join(($in//@value, $in//@root, $in//@unit, $in//@code, $in//@codeSystem, $in//@nullFlavor)/normalize-space(), ''))"/>
      </xsl:if>
   </xsl:function>
</xsl:stylesheet>