<?xml version="1.0" encoding="UTF-8"?>
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
<xsl:stylesheet exclude-result-prefixes="#all" xmlns="http://hl7.org/fhir" xmlns:f="http://hl7.org/fhir" xmlns:local="urn:fhir:stu3:functions" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:nf="http://www.nictiz.nl/functions" xmlns:uuid="http://www.uuid.org" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!--<xsl:import href="../../fhir/2_fhir_fhir_include.xsl"/>
    <xsl:import href="ext-zib-medication-additional-information-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-copy-indicator-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-medication-treatment-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-period-of-use-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-repeat-period-cyclical-schedule-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-stop-type-2.0.xsl"/>
    <xsl:import href="ext-zib-medication-use-duration-2.0.xsl"/>-->

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="referById" as="xs:boolean" select="false()"/>

    <xd:doc>
        <xd:desc>Template based on FHIR Profile https://simplifier.net/NictizSTU3-Zib2017/ZIB-MedicationAgreement/ version 2.2 </xd:desc>
        <xd:param name="uuid">If true generate uuid from scratch. Defaults to false(). Generating a UUID from scratch limits reproduction of the same output as the UUIDs will be different every time.</xd:param>
        <xd:param name="adaPatient">Optional, but should be there. Patient this AllergyIntolerance is for.</xd:param>
        <xd:param name="dateT">Optional. dateT may be given for relative dates, only applicable for test instances</xd:param>
        <xd:param name="entryFullUrl">Optional. Value for the entry.fullUrl</xd:param>
        <xd:param name="fhirResourceId">Optional. Value for the entry.resource.AllergyIntolerance.id</xd:param>
        <xd:param name="searchMode">Optional. Value for entry.search.mode. Default: include</xd:param>
    </xd:doc>
    <xsl:template name="MedicationAgreementEntry-2.2" match="medicatieafspraak | medication_agreement" as="element()" mode="doMedicationAgreementEntry-2.2">
        <xsl:param name="uuid" select="false()" as="xs:boolean"/>
        <xsl:param name="adaPatient" select="(ancestor::*/patient[*//@value] | ancestor::*/bundle/subject/patient[*//@value])[1]" as="element()"/>
        <xsl:param name="dateT" as="xs:date?"/>
        <xsl:param name="entryFullUrl" select="nf:get-fhir-uuid(.)"/>
        <xsl:param name="fhirResourceId">
            <xsl:if test="$referById">
                <xsl:choose>
                    <xsl:when test="not($uuid) and string-length(nf:removeSpecialCharacters((identificatie | zibroot/identificatienummer | hcimroot/identification_number)/@value)) gt 0">
                        <xsl:value-of select="nf:removeSpecialCharacters(string-join((identificatie | zibroot/identificatienummer | hcimroot/identification_number)/@value, ''))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="nf:removeSpecialCharacters(replace($entryFullUrl, 'urn:[^i]*id:', ''))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:param>
        <xsl:param name="searchMode">include</xsl:param>

        <entry>
            <fullUrl value="{$entryFullUrl}"/>
            <resource>
                <xsl:call-template name="zib-MedicationAgreement-2.2">
                    <xsl:with-param name="in" select="."/>
                    <xsl:with-param name="logicalId" select="$fhirResourceId"/>
                    <xsl:with-param name="adaPatient" select="$adaPatient" as="element()"/>
                    <xsl:with-param name="dateT" select="$dateT"/>
                </xsl:call-template>
            </resource>
            <xsl:if test="string-length($searchMode) gt 0">
                <search>
                    <mode value="{$searchMode}"/>
                </search>
            </xsl:if>
        </entry>
    </xsl:template>

    <xd:doc>
        <xd:desc>Template based on FHIR Profile https://simplifier.net/nictizstu3-zib2017/zib-medicationagreement </xd:desc>
        <xd:param name="logicalId">Optional FHIR logical id for the record.</xd:param>
        <xd:param name="in">Node to consider in the creation of a AllergyIntolerance resource</xd:param>
        <xd:param name="adaPatient">Required. ADA patient concept to build a reference to from this resource</xd:param>
        <xd:param name="dateT">Optional. dateT may be given for relative dates, only applicable for test instances</xd:param>
    </xd:doc>
    <xsl:template name="zib-MedicationAgreement-2.2" match="medicatieafspraak[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)] | medication_agreement[not(@datatype = 'reference')][.//(@value | @code | @nullFlavor)]" mode="doZibMedicationAgreement-2.2" as="element()">
        <xsl:param name="in" select="." as="element()?"/>
        <xsl:param name="logicalId" as="xs:string?"/>
        <xsl:param name="adaPatient" select="(ancestor::*/patient[*//@value] | ancestor::*/bundle/subject/patient[*//@value])[1]" as="element()"/>
        <xsl:param name="dateT" as="xs:date?"/>
        <xsl:for-each select="$in">
            <MedicationRequest xsl:exclude-result-prefixes="#all">
                <xsl:for-each select="$logicalId[string-length(.) gt 0]">
                    <id value="{$logicalId}"/>
                </xsl:for-each>
                <meta>
                    <profile value="http://nictiz.nl/fhir/StructureDefinition/zib-MedicationAgreement"/>
                </meta>
                <!-- gebruiksperiode_start /eind -->
                <xsl:for-each select=".[(gebruiksperiode_start | gebruiksperiode_eind)//(@value)]">
                    <xsl:call-template name="ext-zib-Medication-Period-Of-Use-2.0">
                        <xsl:with-param name="start" select="gebruiksperiode_start"/>
                        <xsl:with-param name="end" select="gebruiksperiode_eind"/>
                    </xsl:call-template>
                </xsl:for-each>
                <!-- gebruiksperiode - duur -->
                <xsl:for-each select="gebruiksperiode[@value]">
                    <xsl:call-template name="ext-zib-Medication-Use-Duration"/>
                </xsl:for-each>
                <!-- aanvullende_informatie -->
                <xsl:for-each select="aanvullende_informatie[@code]">
                    <xsl:call-template name="ext-zib-Medication-AdditionalInformation-2.0"/>
                </xsl:for-each>
                <!-- relatie naar medicamenteuze behandeling -->
                <xsl:for-each select="../identificatie[@value]">
                    <xsl:call-template name="ext-zib-medication-medication-treatment-2.0"/>
                </xsl:for-each>
                <!-- kopie indicator -->
                <!-- het ada concept zit niet in alle transacties, eigenlijk alleen in medicatieoverzicht -->
                <xsl:for-each select="kopie_indicator[@value]">
                    <xsl:call-template name="ext-zib-Medication-CopyIndicator-2.0"/>
                </xsl:for-each>
                <!-- herhaalperiode cyclisch schema -->
                <xsl:for-each select="gebruiksinstructie/herhaalperiode_cyclisch_schema[.//(@value | @code)]">
                    <xsl:call-template name="ext-zib-Medication-RepeatPeriodCyclicalSchedule-2.0"/>
                </xsl:for-each>
                <!-- relatie naar medicatieafspraak of gebruik -->
                <xsl:for-each select="relatie_naar_afspraak_of_gebruik/(identificatie | identificatie_23288 | identificatie_23289)[@value]">
                    <extension url="http://nictiz.nl/fhir/StructureDefinition/zib-MedicationAgreement-BasedOnAgreementOrUse">
                        <valueReference>
                            <identifier>
                                <xsl:call-template name="id-to-Identifier">
                                    <xsl:with-param name="in" select="."/>
                                </xsl:call-template>
                            </identifier>
                            <display>
                                <xsl:attribute name="value">
                                    <xsl:choose>
                                        <xsl:when test="./name() = 'identificatie'">relatie naar medicatieafspraak: </xsl:when>
                                        <xsl:when test="./name() = 'identificatie_23288'">relatie naar toedieningsafspraak: </xsl:when>
                                        <xsl:when test="./name() = 'identificatie_23289'">relatie naar medicatiegebruik: </xsl:when>
                                    </xsl:choose>
                                    <xsl:value-of select="./string-join((@value, @root), ' || ')"/>
                                </xsl:attribute>
                            </display>
                        </valueReference>
                    </extension>
                </xsl:for-each>
                <!-- stoptype -->
                <xsl:for-each select="stoptype[@code]">
                    <xsl:call-template name="ext-zib-Medication-StopType-2.0"/>
                </xsl:for-each>
                <!-- MA id -->
                <xsl:for-each select="identificatie[@value]">
                    <identifier>
                        <xsl:call-template name="id-to-Identifier">
                            <xsl:with-param name="in" select="."/>
                        </xsl:call-template>
                    </identifier>
                </xsl:for-each>
                <!-- geannuleerd_indicator, in status -->
                <xsl:for-each select="geannuleerd_indicator[@value = 'true']">
                    <status value="entered-in-error"/>
                </xsl:for-each>
                <intent value="order"/>
                <!-- type bouwsteen, hier een medicatieafspraak -->
                <category>
                    <coding>
                        <system value="http://snomed.info/sct"/>
                        <code value="16076005"/>
                        <display value="Prescription (procedure)"/>
                    </coding>
                    <text value="Medicatieafspraak"/>
                </category>
                <!-- geneesmiddel -->
                <xsl:apply-templates select="afgesproken_geneesmiddel/product[.//(@value | @code)]" mode="doMedicationReference"/>
                <!-- patiënt -->
                <subject>
                    <xsl:apply-templates select="$adaPatient" mode="doPatientReference-2.1"/>
                </subject>
                <!-- relaties_ketenzorg -->
                <!-- We would love to tell you more about the encounter, but alas an id is all we have... based on R4 we will only support Encounter here. -->
                <xsl:for-each select="relaties_ketenzorg/identificatie_contactmoment[@value]">
                    <context>
                        <!--<reference value="{nf:getUriFromAdaId(.)}"/>-->
                        <identifier>
                            <xsl:call-template name="id-to-Identifier">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </identifier>
                        <display value="Contact ID: {string-join((@value, @root), ' ')}"/>
                    </context>
                </xsl:for-each>
                <!--<xsl:for-each select="relaties_ketenzorg/identificatie_contactmoment[@value]">
                    <context>
                        <identifier>
                            <xsl:call-template name="id-to-Identifier">
                                <xsl:with-param name="in" select="."/>
                            </xsl:call-template>
                        </identifier>
                        <display value="Relatie naar {replace(./local-name(),'identificatie_', '')} met identificatie {./@value} in identificerend systeem {./@root}."/>
                    </context>
                </xsl:for-each>-->
                <!-- lichaamslengte -->
                <xsl:for-each select="lichaamslengte[.//@value]">
                    <supportingInformation>
                        <reference value="{nf:getFullUrlOrId('LENGTE', nf:getGroupingKeyDefault(.), false())}"/>
                        <xsl:variable name="datum-string" select="
                                if (lengte_datum_tijd/@value castable as xs:dateTime) then
                                    format-dateTime(lengte_datum_tijd/@value, '[D01] [MN,*-3], [Y0001] [H01]:[m01]')
                                else
                                    if (lengte_datum_tijd/@value castable as xs:date) then
                                        format-date(lengte_datum_tijd/@value, '[D01] [MN,*-3], [Y0001]')
                                    else
                                        lengte_datum_tijd/@value"/>
                        <display value="{concat('Lengte: ', lengte_waarde/@value, ' ', lengte_waarde/@unit,'. Datum/tijd gemeten: ', $datum-string)}"/>
                    </supportingInformation>
                </xsl:for-each>
                <!-- lichaamsgewicht -->
                <xsl:for-each select="lichaamsgewicht[.//@value]">
                    <supportingInformation>
                        <reference value="{nf:getFullUrlOrId('GEWICHT', nf:getGroupingKeyDefault(.), false())}"/>
                        <xsl:variable name="datum-string" select="
                                if (gewicht_datum_tijd/@value castable as xs:dateTime) then
                                    format-dateTime(gewicht_datum_tijd/@value, '[D01] [MN,*-3], [Y0001] [H01]:[m01]')
                                else
                                    if (gewicht_datum_tijd/@value castable as xs:date) then
                                        format-date(gewicht_datum_tijd/@value, '[D01] [MN,*-3], [Y0001]')
                                    else
                                        gewicht_datum_tijd/@value"/>
                        <display value="{concat('Gewicht: ',gewicht_waarde/@value, ' ', gewicht_waarde/@unit,'. Datum/tijd gemeten: ', $datum-string)}"/>
                    </supportingInformation>
                </xsl:for-each>
                <!-- afspraakdatum -->
                <xsl:for-each select="afspraakdatum[@value]">
                    <authoredOn value="{nf:add-Amsterdam-timezone-to-dateTimeString(./@value)}"/>
                </xsl:for-each>
                <!-- voorschrijver -->
                <xsl:for-each select="voorschrijver/zorgverlener[.//(@value | @code)]">
                    <requester>
                        <agent>
                            <xsl:call-template name="practitionerRoleReference">
                                <xsl:with-param name="useExtension" select="true()"/>
                            </xsl:call-template>
                            <xsl:call-template name="practitionerReference"/>
                        </agent>
                      </requester>
                </xsl:for-each>
                
                <!-- reden afspraak -->
                <xsl:for-each select="(reden_afspraak | reden_wijzigen_of_staken)[@code]">
                    <reasonCode>
                        <xsl:call-template name="code-to-CodeableConcept">
                            <xsl:with-param name="in" select="."/>
                            <xsl:with-param name="treatNullFlavorAsCoding" select="@code = 'OTH' and @codeSystem = $oidHL7NullFlavor"/>
                        </xsl:call-template>
                    </reasonCode>
                </xsl:for-each>
                <!-- reden van voorschrijven -->
                <xsl:for-each select="reden_van_voorschrijven/probleem[.//@code]">
                    <reasonReference>
                        <reference value="{nf:getFullUrlOrId('REDENVOORSCHRIJVEN', nf:getGroupingKeyDefault(.), false())}"/>
                        <display value="{normalize-space(string-join(.//(@displayName|@originalText), ' '))}"/>
                    </reasonReference>
                </xsl:for-each>
                <!-- toelichting -->
                <xsl:for-each select="toelichting[@value]">
                    <note>
                        <text value="{./@value}"/>
                    </note>
                </xsl:for-each>
                <!-- gebruiksinstructie -->
                <xsl:apply-templates select="gebruiksinstructie" mode="handleGebruiksinstructie"/>
            </MedicationRequest>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>