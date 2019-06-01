<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:s="urn:fdc:difi.no:2019:data:Skos-1"
                xmlns="urn:fdc:difi.no:2019:data:Skos-1"
                exclude-result-prefixes="s">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="s:Skos">
        <Skos>
            <xsl:copy-of select="s:Config"/>
            <xsl:apply-templates select="s:ConceptScheme"/>
            <xsl:apply-templates select="s:Concept"/>
            <xsl:copy-of select="s:Collection"/>
        </Skos>
    </xsl:template>

    <xsl:template match="s:ConceptScheme">
        <xsl:variable name="ident" select="@path"/>

        <ConceptScheme path="{@path}">
            <xsl:copy-of select="s:Notation"/>
            <xsl:copy-of select="s:PrefLabel | s:AltLabel | s:HiddenLabel"/>
            <xsl:copy-of select="s:Note | s:ChangeNote | s:Definition | s:EditorialNote | s:Example | s:HistoryNote | s:ScopeNote"/>

            <!-- HasTopConcept -->
            <xsl:for-each select="distinct-values(s:HasTopConcept/text() | //s:Concept[s:TopConceptOf/text() = $ident]/@path)">
                <xsl:sort/>
                <HasTopConcept><xsl:value-of select="current()"/></HasTopConcept>
            </xsl:for-each>
        </ConceptScheme>
    </xsl:template>

    <xsl:template match="s:Concept">
        <xsl:variable name="ident" select="@path"/>

        <Concept path="{@path}">
            <xsl:copy-of select="s:Notation"/>
            <xsl:copy-of select="s:PrefLabel | s:AltLabel | s:HiddenLabel"/>
            <xsl:copy-of select="s:Note | s:ChangeNote | s:Definition | s:EditorialNote | s:Example | s:HistoryNote | s:ScopeNote"/>
            <xsl:copy-of select="s:InScheme"/>

            <!-- TopConceptOf -->
            <xsl:for-each select="distinct-values(s:TopConceptOf/text() | //s:ConceptScheme[s:HasTopConcept/text() = $ident]/@path)">
                <xsl:sort/>
                <TopConceptOf><xsl:value-of select="current()"/></TopConceptOf>
            </xsl:for-each>

            <xsl:copy-of select="s:SemanticRelation"/>

            <!-- Related -->
            <xsl:for-each select="distinct-values(s:Related/text() | //s:Concept[s:Related/text() = $ident]/@path)">
                <xsl:sort/>
                <Related><xsl:value-of select="current()"/></Related>
            </xsl:for-each>

            <!-- Broader -->
            <xsl:for-each select="distinct-values(s:Broader/text() | //s:Concept[s:Narrower/text() = $ident]/@path)">
                <xsl:sort/>
                <Broader><xsl:value-of select="current()"/></Broader>
            </xsl:for-each>

            <!-- Narrower -->
            <xsl:for-each select="distinct-values(s:Narrower/text() | //s:Concept[s:Broader/text() = $ident]/@path)">
                <xsl:sort/>
                <Narrower><xsl:value-of select="current()"/></Narrower>
            </xsl:for-each>

            <!-- BroaderTransitive -->
            <xsl:for-each select="distinct-values(s:BroaderTransitive/text() | //s:Concept[s:NarrowerTransitive/text() = $ident]/@path)">
                <xsl:sort/>
                <BroaderTransitive><xsl:value-of select="current()"/></BroaderTransitive>
            </xsl:for-each>

            <!-- NarrowerTransitive -->
            <xsl:for-each select="distinct-values(s:NarrowerTransitive/text() | //s:Concept[s:BroaderTransitive/text() = $ident]/@path)">
                <xsl:sort/>
                <NarrowerTransitive><xsl:value-of select="current()"/></NarrowerTransitive>
            </xsl:for-each>

            <xsl:copy-of select="s:MappingRelation | s:CloseMatch | s:ExactMatch | s:BroadMatch | s:NarrowMatch | s:RelatedMatch"/>
        </Concept>
    </xsl:template>

</xsl:stylesheet>