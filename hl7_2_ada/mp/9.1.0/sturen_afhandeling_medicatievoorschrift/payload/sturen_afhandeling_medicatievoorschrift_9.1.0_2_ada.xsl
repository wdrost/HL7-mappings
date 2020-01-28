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
<xsl:stylesheet exclude-result-prefixes="#all" xmlns:nf="http://www.nictiz.nl/functions" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:sdtc="urn:hl7-org:sdtc" xmlns:pharm="urn:ihe:pharm:medication" xmlns:hl7="urn:hl7-org:v3" xmlns:hl7nl="urn:hl7-nl:v3" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:import href="../../../hl7_2_ada_mp_include.xsl"/>
    <xsl:import href="../../../../zibs2017/payload/all-zibs.xsl"/>
    <xd:doc>
        <xd:desc>Dit is een conversie van MP 9.1.0 naar ADA 9.1 sturen afhandeling medicatievoorschrift</xd:desc>
    </xd:doc>
    <xsl:output method="xml" indent="yes"/>
    <!-- de xsd variabelen worden gebruikt om de juiste conceptId's te vinden voor de ADA xml -->
    <xsl:param name="schema" select="document('../ada_schemas/sturen_afhandeling_medicatievoorschrift.xsd')"/>

    <xsl:variable name="schemaFragment" select="nf:getADAComplexType($schema, nf:getADAComplexTypeName($schema, 'medicamenteuze_behandeling'))"/>

    <xsl:variable name="templateId-toedieningsafspraak" select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9299', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9259'"/>
    <xsl:variable name="templateId-verstrekking" select="'2.16.840.1.113883.2.4.3.11.60.20.77.10.9294', '2.16.840.1.113883.2.4.3.11.60.20.77.10.9255'"/>
    <xsl:variable name="templateId-medicamenteuze-behandeling">2.16.840.1.113883.2.4.3.11.60.20.77.10.9084</xsl:variable>
    
    <xd:doc>
        <xd:desc> if this xslt is used stand alone the template below could be used. </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <!-- todo, add CDA-variant to xpath -->
        <xsl:variable name="lijst-90" select="//hl7:organizer[hl7:code[@code = '131'][@codeSystem = '2.16.840.1.113883.2.4.3.11.60.20.77.4']]"/>
        <xsl:call-template name="afhandeling_voorschrift_9">
            <xsl:with-param name="in" select="$lijst-90"/>
            <xsl:with-param name="schemaFragment" select="$schemaFragment"/>
        </xsl:call-template>
    </xsl:template>

    <xd:doc>
        <xd:desc>Handles HL7 9.1.0 afhandeling_voorschrift, transforms it to ada.</xd:desc>
        <xd:param name="in">HL7 9.1.0 organizer with afhandeling_voorschrift.</xd:param>
        <xd:param name="schemaFragment">Optional. SchemaFragment, in this case of medicamenteuze behandeling. Used for ada conceptIds.</xd:param>
    </xd:doc>
    <xsl:template name="afhandeling_voorschrift_9">
        <xsl:param name="in" select="//hl7:organizer[hl7:code[@code = '131'][@codeSystem = '2.16.840.1.113883.2.4.3.11.60.20.77.4']]"/>
        <xsl:param name="schemaFragment" as="node()?" select="$schemaFragment"/>
        <xsl:call-template name="doGeneratedComment">
            <xsl:with-param name="in" select="$in/ancestor::*[hl7:ControlActProcess]"/>
        </xsl:call-template>
        <adaxml xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="../ada_schemas/ada_sturen_afhandeling_medicatievoorschrift.xsd">
            <meta status="new" created-by="generated" last-update-by="generated">
                <xsl:attribute name="creation-date" select="current-dateTime()"/>
                <xsl:attribute name="last-update-date" select="current-dateTime()"/>
            </meta>
            <data>
                <xsl:for-each select="$in">
                    <xsl:call-template name="doGeneratedComment"/>
                    <xsl:variable name="patient" select="hl7:recordTarget/hl7:patientRole"/>
                    <sturen_afhandeling_medicatievoorschrift app="mp-mp910" shortName="sturen_afhandeling_medicatievoorschrift" formName="afhandelen_voorschrift" transactionRef="2.16.840.1.113883.2.4.3.11.60.20.77.4.131" transactionEffectiveDate="2016-07-12T11:39:14" prefix="mp-" language="nl-NL" title="Generated" id="TODO">
                        <xsl:variable name="filename" select="tokenize(document-uri(/), '/')[last()]"/>
                        <xsl:variable name="extension" select="tokenize($filename, '\.')[last()]"/>
                        <xsl:variable name="theId" select="replace($filename, concat('.', $extension, '$'), '')"/>
                        <xsl:attribute name="title" select="$theId"/>
                        <xsl:attribute name="id" select="$theId"/>

                        <xsl:for-each select="$patient">
                            <xsl:variable name="schemaFragment" select="nf:getADAComplexType($schema, nf:getADAComplexTypeName($schema, 'sturen_medicatiegebruik'))"/>
                            <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.3.10.1_20180601000000">
                                <xsl:with-param name="in" select="."/>
                                <xsl:with-param name="language" select="$language"/>
                                <xsl:with-param name="schema" select="$schema"/>
                                <xsl:with-param name="schemaFragment" select="nf:getADAComplexType($schema, nf:getADAComplexTypeName($schemaFragment, 'patient'))"/>
                            </xsl:call-template>
                        </xsl:for-each>
                        
                        <xsl:variable name="component" select=".//*[hl7:templateId/@root = ($templateId-toedieningsafspraak, $templateId-verstrekking)]"/>
                        <xsl:for-each-group select="$component" group-by="hl7:entryRelationship/hl7:procedure[hl7:templateId/@root = $templateId-medicamenteuze-behandeling]/hl7:id/concat(@root, @extension)">
                            <!-- medicamenteuze_behandeling -->
                            <xsl:variable name="elemName">medicamenteuze_behandeling</xsl:variable>
                            <xsl:element name="{$elemName}">
                                <xsl:copy-of select="nf:getADAComplexTypeConceptId($schemaFragment)"/>
                                
                                <!-- identificatie -->
                                <xsl:for-each select="hl7:entryRelationship/hl7:procedure[hl7:templateId/@root = $templateId-medicamenteuze-behandeling]/hl7:id">
                                    <xsl:variable name="elemName">identificatie</xsl:variable>
                                    <xsl:call-template name="handleII">
                                        <xsl:with-param name="conceptId" select="nf:getADAComplexTypeConceptId(nf:getADAComplexType($schema, nf:getADAComplexTypeName($schemaFragment, $elemName)))"/>
                                        <xsl:with-param name="elemName" select="$elemName"/>
                                    </xsl:call-template>
                                </xsl:for-each>
                                
                                <!-- toedieningsafspraak -->
                                <xsl:for-each select="current-group()[hl7:templateId/@root = $templateId-toedieningsafspraak]">
                                    <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9299_20191125140232">
                                        <xsl:with-param name="in" select="."/>
                                        <xsl:with-param name="schema" select="$schema"/>
                                        <xsl:with-param name="schemaFragment" select="$schemaFragment"/>
                                    </xsl:call-template>
                                </xsl:for-each>
                                
                                <!-- verstrekking -->
                                <xsl:for-each select="current-group()[hl7:templateId/@root = $templateId-verstrekking]">
                                    <xsl:call-template name="template_2.16.840.1.113883.2.4.3.11.60.20.77.10.9294_20191121175237">
                                        <xsl:with-param name="in" select="."/>
                                        <xsl:with-param name="schema" select="$schema"/>
                                        <xsl:with-param name="schemaFragment" select="$schemaFragment"/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:for-each-group>
                    </sturen_afhandeling_medicatievoorschrift>
                </xsl:for-each>
            </data>
        </adaxml>
        <!--<xsl:comment>Input HL7 xml below</xsl:comment>
		<xsl:call-template name="copyElementInComment">
			<xsl:with-param name="in" select="./*"/>
		</xsl:call-template>-->
    </xsl:template>
</xsl:stylesheet>