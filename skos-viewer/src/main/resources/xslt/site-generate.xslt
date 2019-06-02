<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:s="urn:fdc:difi.no:2019:data:Skos-1"
                exclude-result-prefixes="s">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="config" select="//s:Config[1]"/>
    <!-- <xsl:variable name="root" select="if ($config/s:Options[@key = 'site']/s:Option[@key = 'root']) then $config/s:Options[@key = 'site']/s:Option[@key = 'root'] else '/'"/> -->
    <xsl:variable name="root">/los/target/site/</xsl:variable>
    <xsl:variable name="lang" select="'nb'"/>
    <xsl:variable name="baseuri" select="$config/s:BaseURI/text()"/>

    <xsl:template match="s:Skos">
        <html>
            <xsl:call-template name="head"/>
            <body>
                <xsl:call-template name="navbar"/>

                <div class="container">
                    <xsl:apply-templates select="." mode="page"/>
                </div>
            </body>
        </html>

        <xsl:for-each select="s:ConceptScheme | s:Concept | s:Collection">
            <xsl:result-document href="{@path}.html">
                <html>
                    <xsl:call-template name="head"/>
                    <body>
                        <xsl:call-template name="navbar"/>

                        <div class="container">
                            <xsl:apply-templates select="current()" mode="page"/>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>

        <!--

        <rdf:RDF>
            <xsl:for-each select="s:ConceptScheme">
                <xsl:sort select="@path"/>

                <xsl:result-document href="{@path}.rdf">
                    <rdf:RDF>
                        <xsl:apply-templates select="current()"/>
                    </rdf:RDF>
                </xsl:result-document>

                <xsl:apply-templates select="current()"/>
            </xsl:for-each>
            <xsl:for-each select="s:Concept">
                <xsl:sort select="@path"/>

                <xsl:result-document href="{@path}.rdf">
                    <rdf:RDF>
                        <xsl:apply-templates select="current()"/>
                    </rdf:RDF>
                </xsl:result-document>

                <xsl:apply-templates select="current()"/>
            </xsl:for-each>
            <xsl:for-each select="s:Collection">
                <xsl:sort select="@path"/>

                <xsl:result-document href="{@path}.rdf">
                    <rdf:RDF>
                        <xsl:apply-templates select="current()"/>
                    </rdf:RDF>
                </xsl:result-document>

                <xsl:apply-templates select="current()"/>
            </xsl:for-each>
        </rdf:RDF> -->
    </xsl:template>

    <xsl:template name="head">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>

            <!-- Bootstrap CSS -->
            <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"/>

            <title><xsl:value-of select="$config/s:Name"/></title>
        </head>
    </xsl:template>

    <xsl:template name="navbar">
        <nav class="navbar navbar-expand-lg navbar-light bg-light mb-4">
            <div class="container">
                <a class="navbar-brand" href="{$root}"><xsl:value-of select="$config/s:Name"/></a>
            </div>
        </nav>
    </xsl:template>

    <xsl:template match="s:Skos" mode="page">
        <h1 class="mb-4"><xsl:value-of select="$config/s:Name"/><br/><small class="h3 text-muted">Home</small></h1>

        <ul>
            <xsl:for-each select="s:ConceptScheme">
                <xsl:sort select="s:PrefLabel[@lang=$lang]"/>

                <li><a href="{concat($root, @path, '.html')}"><xsl:value-of select="s:PrefLabel[@lang=$lang][1]" /></a></li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="s:ConceptScheme" mode="page">
        <xsl:variable name="current" select="."/>

        <h1 class="mb-4"><xsl:value-of select="s:PrefLabel[@lang=$lang]" /><br/><small class="h3 text-muted">ConceptScheme</small></h1>

        <xsl:call-template name="label"/>
        <xsl:call-template name="documentation"/>

        <h2>Scheme</h2>

        <xsl:choose>
            <xsl:when test="s:HasTopConcept">
                <ul>
                    <xsl:for-each select="s:HasTopConcept">
                        <xsl:sort select="//s:Concept[@path = current()/text()][1]/s:PrefLabel[@lang=$lang][1]"/>

                        <li><a href="{concat($root, text(), '.html')}"><xsl:value-of select="//s:Concept[@path = current()/text()][1]/s:PrefLabel[@lang=$lang][1]" /></a></li>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <ul>
                    <xsl:for-each select="//s:Concept[s:InScheme = $current/@path]">
                        <xsl:sort select="s:PrefLabel[@lang=$lang][1]"/>

                        <li><a href="{concat($root, @path, '.html')}"><xsl:value-of select="s:PrefLabel[@lang=$lang][1]" /></a></li>
                    </xsl:for-each>
                </ul>
            </xsl:otherwise>
        </xsl:choose>

        <!-- <rdf:Description>
            <xsl:attribute name="rdf:about" select="concat($config/s:BaseURI, @path)"/>
        </rdf:Description> -->
    </xsl:template>

    <xsl:template match="s:Concept" mode="page">
        <xsl:variable name="current" select="."/>

        <h1 class="mb-4"><xsl:value-of select="s:PrefLabel[@lang=$lang]" /><br/><small class="h3 text-muted">Concept</small></h1>

        <xsl:call-template name="label"/>
        <xsl:call-template name="documentation"/>
        <xsl:call-template name="relation"/>
        <xsl:call-template name="mapping"/>

    </xsl:template>

    <xsl:template match="s:Collection" mode="page">
        <xsl:variable name="current" select="."/>

        <h1 class="mb-4"><xsl:value-of select="s:PrefLabel[@lang=$lang]" /><br/><small class="h3 text-muted">Collection</small></h1>

        <xsl:call-template name="label"/>
        <xsl:call-template name="documentation"/>

        <h2 class="h4">Members</h2>

        <!-- <rdf:Description>
            <xsl:attribute name="rdf:about" select="concat($config/s:BaseURI, @path)"/>

            <xsl:for-each select="s:Member">
                <xsl:sort select="text()"/>
                <xsl:call-template name="resource">
                    <xsl:with-param name="tag">member</xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>

        </rdf:Description> -->
    </xsl:template>

    <xsl:template name="documentation">
        <xsl:if test="s:Note | s:ChangeNote | s:Definition | s:EditorialNote | s:Example | s:HistoryNote | s:ScopeNote">
            <h2 class="h4">Documentation</h2>
        </xsl:if>
        
        <!-- <xsl:for-each select="s:Note">
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
        </xsl:for-each> -->

    </xsl:template>

    <xsl:template name="label">
        <xsl:if test="s:PrefLabel | s:AltLabel | s:HiddenLabel">
            <h2 class="h4">Labels</h2>

        </xsl:if>

        <!-- <xsl:for-each select="s:PrefLabel">
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
        </xsl:for-each> -->
    </xsl:template>

    <xsl:template name="mapping">
        <xsl:if test="s:MappingRelation | s:CloseMatch | s:ExactMatch | s:BroadMatch | s:NarrowMatch | s:RelatedMatch">
            <h2 class="h4">Mappings</h2>

        </xsl:if>

        <!-- <xsl:for-each select="s:MappingRelation">
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
        </xsl:for-each> -->
    </xsl:template>

    <xsl:template name="relation">
        <xsl:if test="s:SemanticRelation | s:Related | s:Broader | s:Narrower | s:BroaderTransitive | s:NarrowerTransitive">
            <h2 class="h4">Relations</h2>

        </xsl:if>
        
        <!-- <xsl:for-each select="s:SemanticRelation">
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
        </xsl:for-each> -->
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