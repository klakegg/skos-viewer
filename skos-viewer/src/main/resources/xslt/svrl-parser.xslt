<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns="urn:fdc:difi.no:2019:data:Validation-1"
                exclude-result-prefixes="svrl">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="svrl:schematron-output">
        <Result>
            <xsl:apply-templates select="svrl:failed-assert"/>
        </Result>
    </xsl:template>

    <xsl:template match="svrl:failed-assert">
        <FailedAssert>
            <xsl:copy-of select="@id | @flag"/>
            <xsl:value-of select="svrl:text"/>
        </FailedAssert>
    </xsl:template>

</xsl:stylesheet>