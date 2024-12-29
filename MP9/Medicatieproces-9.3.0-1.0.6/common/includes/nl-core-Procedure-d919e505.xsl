<?xml version="1.0" encoding="UTF-8"?>

<!-- == Provenance: YATC-internal/ada-2-fhir-r4/env/zibs/2020/payload/0.5-beta1/nl-core-Procedure.xsl == -->
<!-- == Distribution: MP9-Medicatieproces-9.3.0; 1.0.6; 2024-12-29T15:47:03.74+01:00 == -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://hl7.org/fhir"
                xmlns:util="urn:hl7:utilities"
                xmlns:f="http://hl7.org/fhir"
                xmlns:nf="http://www.nictiz.nl/functions"
                xmlns:yatcs="https://nictiz.nl/ns/YATC-shared"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:uuid="http://www.uuid.org"
                xmlns:local="#local.2024111408213041789710100"
                xmlns:nm="http://www.nictiz.nl/mappings">
   <!-- ================================================================== -->
   <!--
        Converts ADA verrichting to FHIR Procedure resource conforming to profile nl-core-Procedure-event or FHIR ServiceRequest resource conforming to profile nl-core-Procedure-request.
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
   <xsl:output method="xml"
               indent="yes"/>
   <xsl:strip-space elements="*"/>
   <xsl:variable name="profileNameProcedureEvent">nl-core-Procedure-event</xsl:variable>
   <xsl:variable name="profileNameProcedureRequest">nl-core-Procedure-request</xsl:variable>
   <!-- ================================================================== -->
   <xsl:template match="verrichting"
                 name="nl-core-Procedure-event"
                 mode="nl-core-Procedure-event"
                 as="element(f:Procedure)">
      <!-- Creates an nl-core-Procedure-event instance as a Procedure FHIR instance from ADA verrichting element. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?">
         <!-- Optional ADA instance or ADA reference element for the patient. -->
      </xsl:param>
      <xsl:param name="report"
                 as="element(tekst_uitslag)?">
         <!-- The Report concept as ADA 'tekst_uitslag' element or reference. -->
      </xsl:param>
      <xsl:for-each select="$in">
         <Procedure>
            <xsl:variable name="startDate"
                          select="verrichting_start_datum"/>
            <xsl:variable name="endDate"
                          select="verrichting_eind_datum"/>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameProcedureEvent"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profileNameProcedureEvent)}"/>
            </meta>
            <xsl:for-each select="verrichting_methode">
               <extension url="http://nictiz.nl/fhir/StructureDefinition/ext-Procedure.ProcedureMethod">
                  <valueCodeableConcept>
                     <xsl:call-template name="code-to-CodeableConcept">
                        <xsl:with-param name="in"
                                        select="."/>
                     </xsl:call-template>
                  </valueCodeableConcept>
               </extension>
            </xsl:for-each>
            <xsl:for-each select="aanvrager">
               <basedOn>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="$in"/>
                     <xsl:with-param name="profile"
                                     select="$profileNameProcedureRequest"/>
                  </xsl:call-template>
               </basedOn>
            </xsl:for-each>
            <status>
               <!--  
                    * When the ProcedureStartDate is in the future, `.status` will usually be set to _preparation_.
                    * When ProcedureStartDate is in the past and ProcedureEndDate is in the future, `.status` will usually be set to _in-progress_.
                    * When ProcedureEndDate is in the past, `.status` will usually be set to _completed_.
                    * When ProcedureStartDate is in the past and ProcedureEndDate is missing, it may be assumed that the Procedure was recorded as a point in time and `.status` will usually be set to _completed_.
                    -->
               <xsl:attribute name="value">
                  <xsl:choose>
                     <xsl:when test="$startDate and nf:isFuture($startDate/@value)">preparation</xsl:when>
                     <xsl:when test="$startDate and $endDate and nf:isPast($startDate/@value) and nf:isFuture($endDate/@value)">in-progress</xsl:when>
                     <xsl:when test="$endDate and nf:isPast($endDate/@value)">completed</xsl:when>
                     <xsl:when test="$startDate and nf:isPast($startDate/@value) and not($endDate)">completed</xsl:when>
                     <xsl:otherwise>unknown</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
            </status>
            <xsl:for-each select="verrichting_type">
               <code>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </code>
            </xsl:for-each>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:choose>
               <xsl:when test="$startDate and $endDate">
                  <performedPeriod>
                     <xsl:call-template name="startend-to-Period">
                        <xsl:with-param name="start"
                                        select="$startDate"/>
                        <xsl:with-param name="end"
                                        select="$endDate"/>
                     </xsl:call-template>
                  </performedPeriod>
               </xsl:when>
               <xsl:when test="$startDate">
                  <performedDateTime>
                     <xsl:attribute name="value">
                        <xsl:call-template name="format2FHIRDate">
                           <xsl:with-param name="dateTime"
                                           select="xs:string($startDate/@value)"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </performedDateTime>
               </xsl:when>
            </xsl:choose>
            <xsl:for-each select="uitvoerder">
               <performer>
                  <actor>
                     <xsl:call-template name="makeReference">
                        <xsl:with-param name="in"
                                        select="zorgverlener"/>
                        <xsl:with-param name="profile"
                                        select="$profileNameHealthProfessionalPractitionerRole"/>
                     </xsl:call-template>
                  </actor>
               </performer>
            </xsl:for-each>
            <xsl:for-each select="locatie">
               <location>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="zorgaanbieder"/>
                     <xsl:with-param name="profile"
                                     select="$profileNameHealthcareProvider"/>
                  </xsl:call-template>
               </location>
            </xsl:for-each>
            <xsl:for-each select="indicatie">
               <reasonReference>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="probleem"/>
                     <xsl:with-param name="profile"
                                     select="$profileNameProblem"/>
                  </xsl:call-template>
               </reasonReference>
            </xsl:for-each>
            <xsl:for-each select="verrichting_anatomische_locatie">
               <bodySite>
                  <xsl:call-template name="nl-core-AnatomicalLocation"/>
               </bodySite>
            </xsl:for-each>
            <xsl:for-each select="$report">
               <xsl:call-template name="makeReference">
                  <xsl:with-param name="in"
                                  select="."/>
                  <xsl:with-param name="profile"
                                  select="$profileNameTextResult"/>
                  <xsl:with-param name="wrapIn"
                                  select="'report'"/>
               </xsl:call-template>
            </xsl:for-each>
         </Procedure>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="verrichting"
                 name="nl-core-Procedure-request"
                 mode="nl-core-Procedure-request"
                 as="element(f:ServiceRequest)">
      <!-- Creates an nl-core-Procedure-request instance as a ServiceRequest FHIR instance from ADA verrichting element. -->
      <xsl:param name="in"
                 select="."
                 as="element()?">
         <!-- ADA element as input. Defaults to self. -->
      </xsl:param>
      <xsl:param name="subject"
                 select="patient/*"
                 as="element()?">
         <!-- Optional ADA instance or ADA reference element for the patient. -->
      </xsl:param>
      <xsl:param name="report"
                 as="element(tekst_uitslag)?"/>
      <xsl:for-each select="$in">
         <ServiceRequest>
            <xsl:variable name="startDate"
                          select="verrichting_start_datum"/>
            <xsl:variable name="endDate"
                          select="verrichting_eind_datum"/>
            <xsl:call-template name="insertLogicalId">
               <xsl:with-param name="profile"
                               select="$profileNameProcedureRequest"/>
            </xsl:call-template>
            <meta>
               <profile value="{concat($urlBaseNictizProfile, $profileNameProcedureRequest)}"/>
            </meta>
            <status>
               <!--    
                    * When the ProcedureStartDate is in the future, `.status` will usually be set to _active_.
                    * When the ProcedureStartDate is in the past, `.status` will usually be set to _completed_.
                    * When ProcedureEndDate is in the past, `.status` will usually be set to _completed_.
                    -->
               <xsl:attribute name="value">
                  <xsl:choose>
                     <xsl:when test="$startDate and nf:isFuture($startDate/@value)">active</xsl:when>
                     <xsl:when test="$endDate and nf:isPast($endDate/@value)">completed</xsl:when>
                     <xsl:when test="$startDate and nf:isPast($startDate/@value) and not($endDate)">completed</xsl:when>
                     <xsl:otherwise>unknown</xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
            </status>
            <!-- Unless intent is explicitly recorded and a more appropriate code is known, the value can be set to _order_ because a Procedure should authorize an action for a patient, pharmacist, professional administrator et cetera. -->
            <intent value="order"/>
            <xsl:for-each select="verrichting_type">
               <code>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </code>
            </xsl:for-each>
            <xsl:for-each select="verrichting_methode">
               <orderDetail>
                  <xsl:call-template name="code-to-CodeableConcept">
                     <xsl:with-param name="in"
                                     select="."/>
                  </xsl:call-template>
               </orderDetail>
            </xsl:for-each>
            <xsl:call-template name="makeReference">
               <xsl:with-param name="in"
                               select="$subject"/>
               <xsl:with-param name="wrapIn"
                               select="'subject'"/>
            </xsl:call-template>
            <xsl:choose>
               <xsl:when test="$startDate and $endDate">
                  <occurrencePeriod>
                     <xsl:call-template name="startend-to-Period">
                        <xsl:with-param name="start"
                                        select="verrichting_start_datum"/>
                        <xsl:with-param name="end"
                                        select="$endDate"/>
                     </xsl:call-template>
                  </occurrencePeriod>
               </xsl:when>
               <xsl:when test="$startDate">
                  <occurrenceDateTime>
                     <xsl:attribute name="value">
                        <xsl:call-template name="format2FHIRDate">
                           <xsl:with-param name="dateTime"
                                           select="xs:string(./@value)"/>
                        </xsl:call-template>
                     </xsl:attribute>
                  </occurrenceDateTime>
               </xsl:when>
            </xsl:choose>
            <xsl:for-each select="aanvrager">
               <requester>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="zorgverlener"/>
                     <xsl:with-param name="profile"
                                     select="$profileNameHealthProfessionalPractitionerRole"/>
                  </xsl:call-template>
               </requester>
            </xsl:for-each>
            <xsl:for-each select="uitvoerder">
               <!--
                        Does not support the comment in the profile yet.
                        "If multiple performers are present, it is interpreted as a list of *alternative* performers without any preference regardless of order. This deviates from the zib definition where multiple references to the zib Healthprofessional should be interperted as all the performers of the procedure. If order of preference is needed use the [request-performerOrder extension](extension-request-performerorder.html).  Use CareTeam to represent a group of performers (for example, Practitioner A *and* Practitioner B)." -->
               <performer>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="zorgverlener"/>
                     <xsl:with-param name="profile"
                                     select="$profileNameHealthProfessionalPractitionerRole"/>
                  </xsl:call-template>
               </performer>
            </xsl:for-each>
            <xsl:for-each select="locatie">
               <locationReference>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="zorgaanbieder"/>
                     <xsl:with-param name="profile"
                                     select="$profileNameHealthcareProvider"/>
                  </xsl:call-template>
               </locationReference>
            </xsl:for-each>
            <xsl:for-each select="indicatie">
               <reasonReference>
                  <xsl:call-template name="makeReference">
                     <xsl:with-param name="in"
                                     select="probleem"/>
                     <xsl:with-param name="profile"
                                     select="$profileNameProblem"/>
                  </xsl:call-template>
               </reasonReference>
            </xsl:for-each>
            <xsl:for-each select="verrichting_anatomische_locatie">
               <bodySite>
                  <xsl:call-template name="nl-core-AnatomicalLocation"/>
               </bodySite>
            </xsl:for-each>
         </ServiceRequest>
      </xsl:for-each>
   </xsl:template>
   <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
   <xsl:template match="verrichting"
                 mode="_generateDisplay">
      <!-- Template to generate a display that can be shown when referencing this instance. -->
      <xsl:variable name="parts"
                    as="item()*">
         <xsl:text>Procedure</xsl:text>
         <xsl:if test="verrichting_type/@displayName">
            <xsl:value-of select="concat('type: ', verrichting_type/@displayName)"/>
         </xsl:if>
         <xsl:if test="verrichting_methode/@displayName">
            <xsl:value-of select="concat('method: ', verrichting_methode/@displayName)"/>
         </xsl:if>
      </xsl:variable>
      <xsl:value-of select="string-join($parts[. != ''], ', ')"/>
   </xsl:template>
</xsl:stylesheet>