<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:s="urn:fdc:difi.no:2019:data:Skos-1"
                xmlns="urn:fdc:difi.no:2019:data:Skos-1"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                exclude-result-prefixes="s"
                version="2.0">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="root" select="/*"/>
    <xsl:variable name="config" select="//s:Config[1]"/>

    <xsl:template match="s:Skos">
        <xsl:apply-templates select="s:Collection"/>
    </xsl:template>

    <xsl:template match="s:Collection">
        <xsl:variable name="skos">
            <xsl:apply-templates select="s:Member"/>
        </xsl:variable>

        <xsl:variable name="washed">
            <xsl:apply-templates select="$skos" mode="wash">
                <xsl:with-param name="collection" select="$skos"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:variable name="schemes" select="$root/s:ConceptScheme[some $path in $washed//s:InScheme/text() satisfies $path = @path]"/>

        <xsl:variable name="result">
            <Skos>
                <xsl:for-each select="$washed/s:Concept | $schemes">
                    <xsl:sort select="@path"/>
                    <xsl:copy-of select="current()"/>
                </xsl:for-each>
            </Skos>
        </xsl:variable>

        <xsl:result-document href="{@path}/all.rdf">
            <xsl:apply-templates select="$result" mode="rdf"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="s:Member | s:Broader">
        <xsl:variable name="path" select="normalize-space()"/>
        <xsl:copy-of select="$root//*[@path = $path]"/>
        <xsl:apply-templates select="$root//*[@path = $path]/s:Broader"/>
    </xsl:template>



    <xsl:template match="node()|@*" mode="wash">
        <xsl:param name="collection"/>

        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="wash">
                <xsl:with-param name="collection" select="$collection"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="s:Narrower | s:Broader | s:Related" mode="wash">
        <xsl:param name="collection"/>

        <xsl:variable name="current" select="normalize-space()"/>

        <xsl:if test="count($collection/*[@path = $current])">
            <xsl:copy>
                <xsl:apply-templates select="node()|@*" mode="wash">
                    <xsl:with-param name="collection" select="$collection"/>
                </xsl:apply-templates>
            </xsl:copy>
        </xsl:if>
    </xsl:template>




    <xsl:template match="s:Skos" mode="rdf">
        <rdf:RDF>
            <xsl:for-each select="s:ConceptScheme">
                <xsl:sort select="@path"/>
                <xsl:apply-templates select="current()" mode="rdf"/>
            </xsl:for-each>
            <xsl:for-each select="s:Concept">
                <xsl:sort select="@path"/>
                <xsl:apply-templates select="current()" mode="rdf"/>
            </xsl:for-each>
        </rdf:RDF>
    </xsl:template>

    <xsl:template match="s:ConceptScheme" mode="rdf">
        <rdf:Description>
            <xsl:attribute name="rdf:about" select="concat($config/s:BaseURI, @path)"/>

            <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>

            <xsl:for-each select="s:HasTopConcept">
                <xsl:call-template name="resource">
                    <xsl:with-param name="tag">hasTopConcept</xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:call-template name="label"/>
            <xsl:call-template name="documentation"/>

        </rdf:Description>
    </xsl:template>

    <xsl:template match="s:Concept" mode="rdf">
        <rdf:Description>
            <xsl:attribute name="rdf:about" select="concat($config/s:BaseURI, @path)"/>

            <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>

            <xsl:for-each select="s:InScheme">
                <xsl:call-template name="resource">
                    <xsl:with-param name="tag">inScheme</xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="s:TopConceptOf">
                <xsl:call-template name="resource">
                    <xsl:with-param name="tag">topConceptOf</xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:call-template name="label"/>
            <xsl:call-template name="documentation"/>
            <xsl:call-template name="relation"/>
            <xsl:call-template name="mapping"/>

        </rdf:Description>
    </xsl:template>

    <xsl:template match="s:Collection" mode="rdf">
        <rdf:Description>
            <xsl:attribute name="rdf:about" select="concat($config/s:BaseURI, @path)"/>

            <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Collection"/>

            <xsl:call-template name="label"/>
            <xsl:call-template name="documentation"/>

            <xsl:for-each select="s:Member">
                <xsl:sort select="text()"/>
                <xsl:call-template name="resource">
                    <xsl:with-param name="tag">member</xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>

        </rdf:Description>
    </xsl:template>

    <xsl:template name="documentation">
        <xsl:for-each select="s:Note">
            <xsl:sort select="text()"/>
            <xsl:call-template name="value">
                <xsl:with-param name="tag">note</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:ChangeNote">
            <xsl:sort select="text()"/>
            <xsl:call-template name="value">
                <xsl:with-param name="tag">changeNote</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:Definition">
            <xsl:sort select="text()"/>
            <xsl:call-template name="value">
                <xsl:with-param name="tag">definition</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:EditorialNote">
            <xsl:sort select="text()"/>
            <xsl:call-template name="value">
                <xsl:with-param name="tag">editorialNote</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:Example">
            <xsl:sort select="text()"/>
            <xsl:call-template name="value">
                <xsl:with-param name="tag">example</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:HistoryNote">
            <xsl:sort select="text()"/>
            <xsl:call-template name="value">
                <xsl:with-param name="tag">historyNote</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:ScopeNote">
            <xsl:sort select="text()"/>
            <xsl:call-template name="value">
                <xsl:with-param name="tag">scopeNote</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="label">
        <xsl:for-each select="s:PrefLabel">
            <xsl:sort select="text()"/>
            <xsl:call-template name="value">
                <xsl:with-param name="tag">prefLabel</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:AltLabel">
            <xsl:sort select="text()"/>
            <xsl:call-template name="value">
                <xsl:with-param name="tag">altLabel</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:HiddenLabel">
            <xsl:sort select="text()"/>
            <xsl:call-template name="value">
                <xsl:with-param name="tag">hiddenLabel</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="mapping">
        <xsl:for-each select="s:MappingRelation">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">mappingRelation</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:CloseMatch">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">closeMatch</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:ExactMatch">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">exactMatch</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:BroadMatch">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">broadMatch</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:NarrowMatch">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">narrowMatch</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:RelatedMatch">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">relatedMatch</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="relation">
        <xsl:for-each select="s:SemanticRelation">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">semanticRelation</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:Related">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">related</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:Broader">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">broader</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:Narrower">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">narrower</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:BroaderTransitive">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">broaderTransitive</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="s:NarrowerTransitive">
            <xsl:call-template name="resource">
                <xsl:with-param name="tag">narrowerTransitive</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="value">
        <xsl:param name="tag"/>

        <xsl:element name="skos:{$tag}">
            <xsl:if test="@lang">
                <xsl:attribute name="lang" select="@lang"/>
            </xsl:if>
            <xsl:value-of select="normalize-space(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="resource">
        <xsl:param name="tag"/>

        <xsl:element name="skos:{$tag}">
            <xsl:attribute name="rdf:resource" select="if (starts-with(text(), 'http')) then text() else concat($config/s:BaseURI, text())"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>