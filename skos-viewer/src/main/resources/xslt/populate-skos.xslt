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
            <xsl:copy-of select="s:ConceptScheme"/>
            <xsl:copy-of select="s:Concept"/>
            <xsl:copy-of select="s:Collection"/>
        </Skos>
    </xsl:template>

</xsl:stylesheet>