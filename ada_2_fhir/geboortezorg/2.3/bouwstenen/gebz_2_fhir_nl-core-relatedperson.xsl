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

<xsl:stylesheet exclude-result-prefixes="#all" xmlns:f="http://hl7.org/fhir" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:local="urn:fhir:stu3:functions" xmlns:nf="http://www.nictiz.nl/functions" xmlns:nff="http://www.nictiz.nl/fhir-functions" xmlns:uuid="http://www.uuid.org" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!--<xsl:import href="../../../zibs2017/payload/all-zibs.xsl"/>
    <xsl:import href="gebz_mappings.xsl"/>-->
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xd:doc>
        <xd:desc>Converts ada partner to ada contactpersoon</xd:desc>
    </xd:doc>
    
    <xsl:template name="convert-partner-ada" mode="partner-ada" match="partner" as="element()*">
        <contactpersoon>
            <relatie value="DOMPART"/>
            <xsl:for-each select="persoonsnaam">
                <naamgegevens>
                <xsl:copy-of select="voornamen"/>
                <xsl:if test = "achternamen or voorvoegsel">
                    <geslachtsnaam>
                        <xsl:for-each select="achternamen">
                            <achternaam value="{@value}"/>
                        </xsl:for-each>
                        <xsl:for-each select="voorvoegsel">
                            <voorvoegsels value="{@value}"/>
                        </xsl:for-each>
                    </geslachtsnaam>                        
                </xsl:if>
                </naamgegevens>
            </xsl:for-each>
        </contactpersoon>     
    </xsl:template>
    
</xsl:stylesheet>