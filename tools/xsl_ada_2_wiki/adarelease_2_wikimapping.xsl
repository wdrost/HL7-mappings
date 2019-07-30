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
<xsl:stylesheet xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>Produces a wiki mapping table for ADA/<xd:ref name="dataset-name" type="parameter"/> to/from <xd:ref name="otherStandard" type="parameter"/> for upload to e.g. somewhere on the <xd:a href="https://informatiestandaarden.nictiz.nl/wiki/Categorie:Mappings">Nictiz Information Standards wiki</xd:a>
            <xd:p><xd:b>Expected input</xd:b> ADA release file containing ADA community info that holds relevant mapping information. Use tool "adarelease_2_adacommunity.xsl" (should be where you found this tool) to set set up the initial community for upload on ART-DECOR</xd:p>
            <xd:p><xd:b>History:</xd:b>
            <xd:ul>
                <xd:li>2018-06-20 version 0.1 AW <xd:ul><xd:li>Intial version as ZIB_ADA2Wiki_Tabel.xsl</xd:li></xd:ul></xd:li>
                <xd:li>2019-07-12 version 0.2 AH <xd:ul><xd:li>UTF-8 instead of UTF-16</xd:li><xd:li>make sure lines don't get too long</xd:li><xd:li>character escaping</xd:li><xd:li>add support for ANY.png</xd:li></xd:ul></xd:li>
                <xd:li>2019-07-30 version 0.3 AH <xd:ul><xd:li>Moved to consolidated tool location</xd:li><xd:li>Changed name to adarelease_2_wikimapping.xsl</xd:li></xd:ul></xd:li>
            </xd:ul>
        </xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="text" encoding="UTF-8"/>
    <!--<xsl:param name="communityName" select="'kz-voorschrift_2.10.3_zib'"/>
    <xsl:param name="otherStandard" select="'Ketenzorg 2.10.3 Voorschrift'"/>
    <xsl:param name="otherStandardURL" select="'https://www.nictiz.nl/Paginas/Informatiestandaard-ketenzorg.aspx'"/>
    -->

    <!--<xsl:param name="communityName" select="'prica6.10.01_2_zib'"/>
    <xsl:param name="otherStandard" select="'HWG 6.10 Voorschrift'"/>
    <xsl:param name="otherStandardURL" select="'https://www.nictiz.nl/Paginas/Informatiestandaard%20huisartswaarneming.aspx'"/>
    -->
    
    <xd:doc>
        <xd:desc>Required: Name of the ADA community to look for in building info</xd:desc>
    </xd:doc>
    <xsl:param name="communityName">kz-3.0.2-v3-Lab-Results-Response-to-Dataset</xsl:param>
    <xd:doc>
        <xd:desc>Required: view/@shortName to process in the ADA Release file</xd:desc>
    </xd:doc>
    <xsl:param name="ada-view-shortname">lab_results_response</xsl:param>
    <xd:doc>
        <xd:desc>Required: Name of the standard (e.g. HL7 V3 template / FHIR profile title) we are mapping to/from</xd:desc>
    </xd:doc>
    <xsl:param name="otherStandard">Ketenzorg v3.0.2 Beschikbaarstellen Lab Results</xsl:param>
    <xd:doc>
        <xd:desc>Required: URL for the <xd:ref name="otherStandard" type="parameter"/></xd:desc>
    </xd:doc>
    <xsl:param name="otherStandardURL">https://www.nictiz.nl/standaardisatie/informatiestandaarden/ketenzorg/</xsl:param>
    <xd:doc>
        <xd:desc>Required: Name of the ADA/DECOR Dataset we are mapping to/from</xd:desc>
    </xd:doc>
    <xsl:param name="dataset-name">Ketenzorg 3.0</xsl:param>
    <xd:doc>
        <xd:desc>Optional: Array of concept/@shortName values that should not be included in the output</xd:desc>
    </xd:doc>
    <xsl:param name="concept-2b-omitted" as="xs:string*"/>
    <xd:doc>
        <xd:desc>Optional: Array of concept/@shortName values that mark where an HCIM/zib starts. This influences the output icon for that row</xd:desc>
    </xd:doc>
    <xsl:param name="concept-zib" as="xs:string*">
        <xsl:value-of select="'allergy_intolerance'"/>
    </xsl:param>
    <xd:doc>
        <xd:desc>Required: Leave default value 'other2zib' (going from <xd:ref name="otherStandard" type="parameter"/> to <xd:ref name="dataset-name" type="parameter"/>) or use any other value to go vice versa. This influnces the order of columns in the table</xd:desc>
    </xd:doc>
    <xsl:param name="mapDirection">other2zib</xsl:param>

    <xd:doc>
        <xd:desc>Determine direction and call the correct template to create a wiki table</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:variable name="concept" select="ada/applications//view[implementation/@shortName = $ada-view-shortname]/dataset/concept"/>
        <xsl:for-each select="$concept[not(@shortName = $concept-2b-omitted)]">
            <xsl:choose>
                <xsl:when test="$mapDirection = 'other2zib'">
                    <xsl:call-template name="makeTableOther2ZIB">
                        <xsl:with-param name="concept" select="."/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="makeTableZIB2Other">
                        <xsl:with-param name="concept" select="."/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Start table for  the root concepts of the dataset</xd:desc>
        <xd:param name="concept"/>
    </xd:doc>
    <xsl:template name="makeTableZIB2Other">
        <xsl:param name="concept"/>
        <!-- Tabel starten -->
        <xsl:text>
{| class="wikitable" 
| style="background-color: #1F497D;; color: white; font-weight: bold; text-align:center;"  colspan="3" | zib || style="background-color: #1F497D;; color: white; font-weight: bold; text-align:center;" colspan="3" | </xsl:text>
        <xsl:value-of select="$otherStandard"/>
        <xsl:text> || style="background-color: #1F497D;; color: white; font-weight: bold; text-align:center;" | Conversie beschrijving (mapping)
|-style="background-color: #1F497D;; color: white; text-align:left;"
|style="width:30px;"| Type 
|| Concept 
|style="width:40px;"| Card || Type 
|| Concept 
|style="width:40px;"| Card 
|| </xsl:text>
        <!-- Eerste rij, van de titel van een bovenste data-element -->
        <xsl:text>
|-style="vertical-align:top; background-color: #E3E3E3; " 
|</xsl:text>
        <xsl:choose>
            <xsl:when test="$concept/@shortName = $concept-zib">
                <xsl:text>[[Bestand:Zib.png|30px|link=]] </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[[Bestand:Container.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>|| </xsl:text>
        <xsl:value-of select="$concept/name"/>
        <xsl:text> || </xsl:text>
        <xsl:value-of select="$concept/@minimumMultiplicity"/>
        <xsl:text> .. </xsl:text>
        <xsl:value-of select="$concept/@maximumMultiplicity"/>
        <xsl:text> || </xsl:text>
        <xsl:call-template name="addOtherStandard">
            <xsl:with-param name="concept" select="$concept"/>
        </xsl:call-template>

        <!-- De rest van de rijen -->
        <xsl:apply-templates select="./concept"/>

        <!-- Tabel afsluiten -->
        <xsl:text>
|}
</xsl:text>

    </xsl:template>
    
    <xd:doc>
        <xd:desc>Start table for the root concepts of the dataset</xd:desc>
        <xd:param name="concept"/>
    </xd:doc>
    <xsl:template name="makeTableOther2ZIB">
        <xsl:param name="concept"/>
        <!-- Tabel starten -->
        <xsl:text>
{| class="wikitable" 
| style="background-color: #1F497D;; color: white; font-weight: bold; text-align:center;"  colspan="3" | </xsl:text>
        <xsl:value-of select="$otherStandard"/>
        <xsl:text> || style="background-color: #1F497D;; color: white; font-weight: bold; text-align:center;" | Conversie beschrijving (mapping) </xsl:text>
        <xsl:text> || style="background-color: #1F497D;; color: white; font-weight: bold; text-align:center;" colspan="4" | </xsl:text>
        <xsl:value-of select="$dataset-name"/>
        <xsl:text>
|-style="background-color: #1F497D;; color: white; text-align:left;" 
|style="width:30px;"| Type 
|style="width:150px;"| Concept 
|style="width:40px;"| Card 
|style="width:200px;"| 
|style="width:30px;"| Type 
|style="width:150px;"| Concept 
|style="width:40px;"| # 
|style="width:40px;"| Card </xsl:text>
        <!-- Eerste rij, van de titel van het root dataset concept -->
        <xsl:text>
|-style="vertical-align:top; background-color: #E3E3E3; "</xsl:text>
        <xsl:text>
|</xsl:text>
        <xsl:call-template name="addOtherStandard">
            <xsl:with-param name="concept" select="$concept"/>
        </xsl:call-template>
        <xsl:text>|| </xsl:text>
        <xsl:choose>
            <xsl:when test="$concept/@shortName = $concept-zib">
                <xsl:text>[[Bestand:Zib.png|30px|link=]] </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[[Bestand:Container.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>|| </xsl:text>
        <xsl:value-of select="$concept/name"/>
        <xsl:text>|| </xsl:text>
        <xsl:value-of select="tokenize($concept/@id, '\.')[last()]"/>
        <xsl:text> || </xsl:text>
        <xsl:value-of select="$concept/@minimumMultiplicity"/>
        <xsl:text> .. </xsl:text>
        <xsl:value-of select="$concept/@maximumMultiplicity"/>

        <!-- De rest van de rijen -->
        <xsl:apply-templates select="./concept[not(@shortName = $concept-2b-omitted)]"/>

        <!-- Tabel afsluiten -->
        <xsl:text>
|}
</xsl:text>

    </xsl:template>
    
    <xd:doc>
        <xd:desc>Creates concept rows in a top level group</xd:desc>
    </xd:doc>
    <xsl:template match="concept">
        <xsl:choose>
            <xsl:when test="$mapDirection = 'other2zib'">
                <xsl:call-template name="makeTableRowOther2Zib">
                    <xsl:with-param name="concept" select="."/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="makeTableRowZib2Other">
                    <xsl:with-param name="concept" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:apply-templates select="./concept"/>

    </xsl:template>

    <xd:doc>
        <xd:desc>Ignores valueSet elements for now</xd:desc>
    </xd:doc>
    <xsl:template match="valueSet">
        <!--<xsl:for-each select="./conceptList/concept">
            <xsl:call-template name="makeTableRowCode">
                <xsl:with-param name="code" select="."/>
            </xsl:call-template>
        </xsl:for-each>-->
    </xsl:template>

    <xd:doc>
        <xd:desc>Creates a mapping row for a concept when <xd:ref name="otherStandard" type="parameter"/> is not other2zib</xd:desc>
        <xd:param name="concept">Concept to process</xd:param>
    </xd:doc>
    <xsl:template name="makeTableRowZib2Other">
        <xsl:param name="concept"/>
        <xsl:text>
|-</xsl:text>
        <!-- Type dependent stuff -->
        <xsl:choose>
            <xsl:when test="$concept/@type = 'group'">
                <xsl:text>style="vertical-align:top; background-color: #E8D7BE;"
|</xsl:text>
                <xsl:call-template name="addType">
                    <xsl:with-param name="type" select="$concept/@type"/>
                </xsl:call-template>
                <xsl:text> || </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>
|</xsl:text>
                <xsl:call-template name="addType">
                    <xsl:with-param name="type" select="$concept/valueDomain/@type"/>
                </xsl:call-template>
                <xsl:text> ||</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:for-each select="$concept/ancestor::concept">
            <xsl:text disable-output-escaping="yes"><![CDATA[&#160;&#160;&#160;]]></xsl:text>
        </xsl:for-each>
        <xsl:value-of select="$concept/name"/>
        <xsl:text> || </xsl:text>
        <xsl:value-of select="$concept/@minimumMultiplicity"/>
        <xsl:text> .. </xsl:text>
        <xsl:value-of select="$concept/@maximumMultiplicity"/>

        <xsl:call-template name="addOtherStandard">
            <xsl:with-param name="concept" select="$concept"/>
        </xsl:call-template>
    </xsl:template>

    <xd:doc>
        <xd:desc>Creates a mapping row for a concept when <xd:ref name="otherStandard" type="parameter"/> is other2zib</xd:desc>
        <xd:param name="concept">Concept to process</xd:param>
    </xd:doc>
    <xsl:template name="makeTableRowOther2Zib">
        <xsl:param name="concept"/>
        <!-- nieuwe regel -->
        <xsl:text>
|-</xsl:text>
        <!-- style informatie voor groep in ZIB -->
        <xsl:if test="$concept/@type = 'group'">
            <xsl:text>style="vertical-align:top; background-color: #E3E3E3; "</xsl:text>
        </xsl:if>
        <xsl:text>
|</xsl:text>

        <xsl:call-template name="addOtherStandard">
            <xsl:with-param name="concept" select="$concept"/>
        </xsl:call-template>
        <xsl:text>
| </xsl:text>
        <!-- Type dependent stuff -->
        <xsl:choose>
            <xsl:when test="$concept/@type = 'item'">
                <xsl:call-template name="addType">
                    <xsl:with-param name="type" select="$concept/valueDomain/@type"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- group -->
                <xsl:variable name="type">
                    <xsl:choose>
                        <xsl:when test="$concept/@shortName = $concept-zib">zib</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$concept/@type"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="addType">
                    <xsl:with-param name="type" select="$type"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> || </xsl:text>
        <xsl:for-each select="$concept/ancestor::concept">
            <xsl:text disable-output-escaping="yes"><![CDATA[&#160;&#160;&#160;]]></xsl:text>
        </xsl:for-each>
        <xsl:value-of select="$concept/name"/>
        <xsl:text> || </xsl:text>
        <xsl:value-of select="tokenize($concept/@id, '\.')[last()]"/>
        <xsl:text> || </xsl:text>
        <xsl:value-of select="$concept/@minimumMultiplicity"/>
        <xsl:text> .. </xsl:text>
        <xsl:value-of select="$concept/@maximumMultiplicity"/>
    </xsl:template>

    <xd:doc>
        <xd:desc>Creates a row  for concepts in a (valueSet/valueDomain) conceptList, indenting codes based on the number ancestor concepts</xd:desc>
        <xd:param name="code"/>
    </xd:doc>
    <xsl:template name="makeTableRowCode">
        <xsl:param name="code"/>
        <xsl:text>
|-
|  ||</xsl:text>
        <xsl:for-each select="$code/ancestor::concept">
            <xsl:text disable-output-escaping="yes"><![CDATA[&#160;&#160;&#160;]]></xsl:text>
        </xsl:for-each>
        <xsl:text disable-output-escaping="yes"><![CDATA[&#160;&#160;&#160;&#160;&#160;]]> * </xsl:text>
        <xsl:value-of select="$code/name"/>
        <xsl:text> || - </xsl:text>
        <xsl:text> || - || - || - || -</xsl:text>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="concept"/>
    </xd:doc>
    <xsl:template name="addOtherStandard">
        <xsl:param name="concept"/>
        <!-- the type of the concept of the other standard -->
        <xsl:call-template name="addType">
            <xsl:with-param name="type" select="$concept/community[@name = $communityName]/data[@type = 'mapType']"/>
        </xsl:call-template>
        <xsl:text>||</xsl:text>
        <!-- the concept name of the other standard -->
        <xsl:call-template name="AddCommunityInfo">
            <xsl:with-param name="concept" select="$concept"/>
            <xsl:with-param name="communityType" select="'mapConcept'"/>
        </xsl:call-template>
        <xsl:text>||</xsl:text>
        <!-- the cardinality of the concept of the other standard -->
        <xsl:call-template name="AddCommunityInfo">
            <xsl:with-param name="concept" select="$concept"/>
            <xsl:with-param name="communityType" select="'mapCard'"/>
        </xsl:call-template>
        <xsl:text>||</xsl:text>
        <!-- mapping description -->
        <xsl:call-template name="AddCommunityInfo">
            <xsl:with-param name="concept" select="$concept"/>
            <xsl:with-param name="communityType" select="'mapDescription'"/>
        </xsl:call-template>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="concept"/>
        <xd:param name="communityType"/>
    </xd:doc>
    <xsl:template name="AddCommunityInfo">
        <xsl:param name="concept"/>
        <xsl:param name="communityType"/>
        <xsl:variable name="communityText" select="$concept/community[@name = $communityName]/data[@type = $communityType]"/>
        <xsl:choose>
            <xsl:when test="$communityText">
                <xsl:apply-templates select="$communityText" mode="doCopy"/>
                <xsl:text>
</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> - </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Copy while preserving XML elements and attributes, but while respecting wiki</xd:desc>
    </xd:doc>
    <xsl:template match="data" mode="doCopy">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Don't want processing instructions</xd:desc>
    </xd:doc>
    <xsl:template match="processing-instruction()" mode="doCopy">
        <!-- skip -->
    </xsl:template>
    
    <xd:doc>
        <xd:desc>skip empty leading text()</xd:desc>
    </xd:doc>
    <xsl:template match="text()[parent::data][normalize-space() = ''][not(preceding-sibling::node())]" mode="doCopy">
        <!-- skip empty leading text() -->
    </xsl:template>
    
    <xd:doc>
        <xd:desc>skip empty trailing text()</xd:desc>
    </xd:doc>
    <xsl:template match="text()[parent::data][normalize-space() = ''][not(following-sibling::node())]" mode="doCopy">
        <!-- skip empty trailing text() -->
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Copy text after some cleaning for too long lines and escaping</xd:desc>
    </xd:doc>
    <xsl:template match="text()" mode="doCopy">
        <xsl:apply-templates select="." mode="replaceChars"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Copy comments... who knows</xd:desc>
    </xd:doc>
    <xsl:template match="comment()" mode="doCopy">
        <xsl:text>&lt;!--</xsl:text>
        <xsl:apply-templates select="." mode="replaceChars"/>
        <xsl:text>--&gt;</xsl:text>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Create textual attributes from input</xd:desc>
    </xd:doc>
    <xsl:template match="@*" mode="doCopy">
        <xsl:text> </xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>="</xsl:text>
        <xsl:apply-templates select="." mode="replaceChars"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Create textual elements from input</xd:desc>
    </xd:doc>
    <xsl:template match="*" mode="doCopy">
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:apply-templates select="@*" mode="#current"/>
        <xsl:if test="empty(node())">
            <xsl:text>/</xsl:text>
        </xsl:if>
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates mode="#current"/>
        <xsl:if test="not(empty(node()))">
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>&gt;</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Break up lines containing more than 80 consecutive characters. First try if adding 
            spaces around equal signs helps. Benefit: xpaths are still valid. If that does not help, 
            add a space after every /. This renders the paths invalid as-is though</xd:desc>
    </xd:doc>
    <xsl:template match="text()" mode="replaceChars">
        <xsl:variable name="applySpacingAroundEqualSigns" select="replace(., '(\S)([&lt;&gt;=])([^\s=])', '$1 $2 $3')" as="xs:string"/>
        <xsl:variable name="applySpacingAfterSlashes" as="xs:string">
            <xsl:choose>
                <xsl:when test="matches($applySpacingAroundEqualSigns, '\S{80}')">
                    <xsl:value-of select="replace($applySpacingAroundEqualSigns, '([^/])/(\S)', '$1/ $2')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$applySpacingAroundEqualSigns"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="replace($applySpacingAfterSlashes, '([\[\]])', '&lt;nowiki>$1&lt;/nowiki>')"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Return linked icon for datatypes if possible. Return type as-is if not.</xd:desc>
        <xd:param name="type">Required. Datatype string to link. E.g. boolean, code, date, ...</xd:param>
    </xd:doc>
    <xsl:template name="addType">
        <xsl:param name="type"/>
        <!-- Type dependent stuff -->
        <xsl:choose>
            <xsl:when test="$type = 'boolean'">
                <xsl:text>[[Bestand:BL.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'blob'">
                <xsl:text>blob </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'code'">
                <xsl:text>[[Bestand:CD.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'count'">
                <xsl:text>[[Bestand:INT.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'date'">
                <xsl:text>[[Bestand:TS.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'datetime'">
                <xsl:text>[[Bestand:TS.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'duration'">
                <xsl:text>[[Bestand:PQ.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'decimal'">
                <xsl:text>REAL </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'group'">
                <xsl:text>[[Bestand:Container.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'identifier'">
                <xsl:text>[[Bestand:II.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'quantity'">
                <xsl:text>[[Bestand:PQ.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'string'">
                <xsl:text>[[Bestand:ST.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'complex'">
                <xsl:text>[[Bestand:ANY.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'text'">
                <xsl:text>[[Bestand:ST.png|16px|link=Beschrijving_en_gebruik_datatypes]] </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'zib'">
                <xsl:text>[[Bestand:Zib.png|30px|link=]] </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <!-- an unknown type -->
                <xsl:value-of select="$type"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>