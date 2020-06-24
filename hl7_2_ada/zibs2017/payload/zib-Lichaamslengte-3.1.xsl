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
<xsl:stylesheet exclude-result-prefixes="#all" xmlns:hl7="urn:hl7-org:v3" xmlns:local="urn:fhir:stu3:functions" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:nf="http://www.nictiz.nl/functions" xmlns:uuid="http://www.uuid.org" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--    <xsl:import href="_zib2017.xsl"/>-->
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="language" as="xs:string?">nl-NL</xsl:param>
    <!-- de schema (xsd) parameter bevat het ada xsd om de juiste conceptId's te vinden voor de ADA xml, ada xsd verschilt per ad transactie -->
    <!-- indien niet gevuld, heeft de ada output geen conceptId's -->
    <xsl:param name="schema"/>

    <xd:doc>
        <xd:desc>Mapping of HL7 CDA template 2.16.840.1.113883.2.4.3.11.60.7.10.30 20171025 to zib nl.zorg.Lichaamslengte 3.1 concept in ADA. 
                 Created for MP voorschrift, currently only supports fields used in those scenario's</xd:desc>
        <xd:param name="in">HL7 Node to consider in the creation of the ada element</xd:param>
        <xd:param name="schemaFragment">The schemaFragment of the parent element of the element to be outputted. Defaults to stylesheet parameter $schema.</xd:param>
        <xd:param name="zibroot">Optional. The ada zibroot element to be outputted with this HCIM, will be copied in ada element</xd:param>
    </xd:doc>
    <xsl:template name="zib-Lichaamslengte-3.1" match="hl7:observation" as="element()*" mode="doZibLichaamslengte-3.1">
        <xsl:param name="in" select="." as="element()?"/>
        <xsl:param name="schemaFragment" as="node()?" select="$schema"/>
        <xsl:param name="zibroot" as="element()?"/>

        <xsl:for-each select="$in">
            <!-- body_height -->
            <xsl:variable name="elemName">
                <xsl:choose>
                    <xsl:when test="$language = 'nl-NL'">lichaamslengte</xsl:when>
                    <xsl:otherwise>body_height</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="schemaFragment" select="nf:getADAComplexType($schema, nf:getADAComplexTypeName($schemaFragment, $elemName))"/>
            <xsl:element name="{$elemName}">
                <xsl:copy-of select="nf:getADAComplexTypeConceptId($schemaFragment)"/>

                <!-- zibroot -->
                <xsl:copy-of select="$zibroot"/>

                <!-- height_value -->
                <xsl:variable name="elemName">
                    <xsl:choose>
                        <xsl:when test="$language = 'nl-NL'">lengte_waarde</xsl:when>
                        <xsl:otherwise>height_value_code</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="handlePQ">
                    <xsl:with-param name="in" select="hl7:value[@value | @unit | @nullFlavor]"/>
                    <xsl:with-param name="elemName" select="$elemName"/>
                    <xsl:with-param name="conceptId" select="nf:getADAComplexTypeConceptId(nf:getADAComplexType($schema, nf:getADAComplexTypeName($schemaFragment, $elemName)))"/>
                </xsl:call-template>

                <!-- height_date_time -->
                <xsl:variable name="elemName">
                    <xsl:choose>
                        <xsl:when test="$language = 'nl-NL'">lengte_datum_tijd</xsl:when>
                        <xsl:otherwise>height_date_time</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="handleTS">
                    <xsl:with-param name="in" select="hl7:effectiveTime[@value | @nullFlavor] | hl7:effectiveTime/hl7:low"/>
                    <xsl:with-param name="elemName" select="$elemName"/>
                    <xsl:with-param name="conceptId" select="nf:getADAComplexTypeConceptId(nf:getADAComplexType($schema, nf:getADAComplexTypeName($schemaFragment, $elemName)))"/>
                </xsl:call-template>

            </xsl:element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
