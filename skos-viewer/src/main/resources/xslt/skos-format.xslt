<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="urn:fdc:difi.no:2019:data:Skos-1">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="*:Skos">
        <Skos>
            <xsl:apply-templates select="*:Config"/>

            <xsl:for-each select="*:ConceptScheme">
                <xsl:sort select="@path"/>
                <xsl:apply-templates select="current()"/>
            </xsl:for-each>

            <xsl:for-each select="*:Concept">
                <xsl:sort select="@path"/>
                <xsl:apply-templates select="current()"/>
            </xsl:for-each>

            <xsl:for-each select="*:Collection">
                <xsl:sort select="@path"/>
                <xsl:apply-templates select="current()"/>
            </xsl:for-each>
        </Skos>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>