<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:s="urn:fdc:difi.no:2019:data:Skos-1"
                exclude-result-prefixes="s">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="config" select="//s:Config[1]"/>
    <!-- <xsl:variable name="root" select="if ($config/s:Options[@key = 'site']/s:Option[@key = 'root']) then $config/s:Options[@key = 'site']/s:Option[@key = 'root'] else '/'"/> -->
    <xsl:variable name="root">/los/target/site/</xsl:variable>
    <xsl:variable name="lang" select="if ($config/s:Options[@key = 'site']/s:Option[@key = 'lang']) then $config/s:Options[@key = 'site']/s:Option[@key = 'lang'] else 'nb'"/>
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
    </xsl:template>

    <xsl:template name="head">
        <head>
            <!-- Required meta tags -->
            <meta charset="utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>

            <!-- Bootstrap CSS -->
            <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
                  integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
                  crossorigin="anonymous"/>
            <style>
                dl { border-bottom: 1px solid #eee; }
                dd, dt { border-top: 1px solid #eee; padding-top: .5rem; }
            </style>

            <title><xsl:value-of select="$config/s:Name"/></title>
        </head>
    </xsl:template>

    <xsl:template name="navbar">
        <nav class="navbar navbar-expand-lg navbar-light bg-light mb-4">
            <div class="container">
                <a class="navbar-brand" href="{$root}">
                    <xsl:value-of select="$config/s:Name"/>
                </a>
            </div>
        </nav>
    </xsl:template>

    <xsl:template match="s:Skos" mode="page">
        <h1 class="mb-4">
            <xsl:value-of select="$config/s:Name"/>
            <br/>
            <small class="h3 text-muted">Home</small>
        </h1>

        <ul>
            <xsl:for-each select="s:ConceptScheme">
                <xsl:sort select="s:PrefLabel[@lang=$lang]"/>

                <li>
                    <a href="{concat($root, @path, '.html')}">
                        <xsl:value-of select="s:PrefLabel[@lang=$lang][1]"/>
                    </a>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="s:ConceptScheme" mode="page">
        <xsl:variable name="current" select="."/>

        <h1 class="mb-4">
            <xsl:value-of select="s:PrefLabel[@lang=$lang]"/>
            <br/>
            <small class="h3 text-muted">ConceptScheme</small>
        </h1>

        <dl class="row">
            <dt class="col-sm-2">Identifier</dt>
            <dd class="col-sm-10">
                <xsl:value-of select="$baseuri"/>
                <strong>
                    <xsl:value-of select="@path"/>
                </strong>
            </dd>
        </dl>

        <xsl:call-template name="label"/>
        <xsl:call-template name="documentation"/>

        <xsl:choose>
            <xsl:when test="s:HasTopConcept">
                <h2 id="scheme" class="h4">Scheme</h2>

                <dl class="row">
                    <xsl:call-template name="resources">
                        <xsl:with-param name="tag">HasTopConcept</xsl:with-param>
                        <xsl:with-param name="title">Top Concepts</xsl:with-param>
                    </xsl:call-template>
                </dl>
            </xsl:when>
            <xsl:otherwise>
                <ul>
                    <xsl:for-each select="//s:Concept[s:InScheme = $current/@path]">
                        <xsl:sort select="s:PrefLabel[@lang=$lang][1]"/>

                        <li>
                            <a href="{concat($root, @path, '.html')}">
                                <xsl:value-of select="s:PrefLabel[@lang=$lang][1]"/>
                            </a>
                        </li>
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

        <h1 class="mb-4">
            <xsl:value-of select="s:PrefLabel[@lang=$lang]"/>
            <br/>
            <small class="h3 text-muted">Concept</small>
        </h1>

        <dl class="row">
            <dt class="col-sm-2">Identifier</dt>
            <dd class="col-sm-10">
                <xsl:value-of select="$baseuri"/>
                <strong>
                    <xsl:value-of select="@path"/>
                </strong>
            </dd>

            <xsl:call-template name="resources">
                <xsl:with-param name="title">Scheme</xsl:with-param>
                <xsl:with-param name="tag">InScheme</xsl:with-param>
            </xsl:call-template>
        </dl>

        <xsl:call-template name="label"/>
        <xsl:call-template name="documentation"/>
        <xsl:call-template name="relation"/>
        <xsl:call-template name="mapping"/>

    </xsl:template>

    <xsl:template match="s:Collection" mode="page">
        <xsl:variable name="current" select="."/>

        <h1 class="mb-4">
            <xsl:value-of select="s:PrefLabel[@lang=$lang]"/>
            <br/>
            <small class="h3 text-muted">Collection</small>
        </h1>

        <dl class="row">
            <dt class="col-sm-2">Identifier</dt>
            <dd class="col-sm-10">
                <xsl:value-of select="$baseuri"/>
                <strong>
                    <xsl:value-of select="@path"/>
                </strong>
            </dd>
        </dl>

        <xsl:call-template name="label"/>
        <xsl:call-template name="documentation"/>

        <h2 id="members" class="h4">Members</h2>

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
            <h2 id="documentation" class="h4">Documentation</h2>
        </xsl:if>

        <dl class="row">
            <xsl:call-template name="values">
                <xsl:with-param name="tag">Note</xsl:with-param>
                <xsl:with-param name="title">Note</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="values">
                <xsl:with-param name="tag">ChangeNote</xsl:with-param>
                <xsl:with-param name="title">Change Note</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="values">
                <xsl:with-param name="tag">Definition</xsl:with-param>
                <xsl:with-param name="title">Definition</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="values">
                <xsl:with-param name="tag">EditorialNote</xsl:with-param>
                <xsl:with-param name="title">Editorial Note</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="values">
                <xsl:with-param name="tag">Example</xsl:with-param>
                <xsl:with-param name="title">Example</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="values">
                <xsl:with-param name="tag">HistoryNote</xsl:with-param>
                <xsl:with-param name="title">History Note</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="values">
                <xsl:with-param name="tag">ScopeNote</xsl:with-param>
                <xsl:with-param name="title">Scope Note</xsl:with-param>
            </xsl:call-template>
        </dl>
    </xsl:template>

    <xsl:template name="label">
        <xsl:if test="s:PrefLabel | s:AltLabel | s:HiddenLabel">
            <h2 id="labels" class="h4">Labels</h2>

            <dl class="row">
                <xsl:call-template name="values">
                    <xsl:with-param name="tag">PrefLabel</xsl:with-param>
                    <xsl:with-param name="title">Preferred</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="values">
                    <xsl:with-param name="tag">AltLabel</xsl:with-param>
                    <xsl:with-param name="title">Alternative</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="values">
                    <xsl:with-param name="tag">HiddenLabel</xsl:with-param>
                    <xsl:with-param name="title">Hidden</xsl:with-param>
                </xsl:call-template>
            </dl>
        </xsl:if>
    </xsl:template>

    <xsl:template name="mapping">
        <xsl:if test="s:MappingRelation | s:CloseMatch | s:ExactMatch | s:BroadMatch | s:NarrowMatch | s:RelatedMatch">
            <h2 id="mappings" class="h4">Mappings</h2>

            <dl class="row">
                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">MappingRelation</xsl:with-param>
                    <xsl:with-param name="title">Mapping Relation</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">CloseMatch</xsl:with-param>
                    <xsl:with-param name="title">Close Match</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">ExactMatch</xsl:with-param>
                    <xsl:with-param name="title">Exact Match</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">BroadMatch</xsl:with-param>
                    <xsl:with-param name="title">Broad Match</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">NarrowMatch</xsl:with-param>
                    <xsl:with-param name="title">Narrow Match</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">RelatedMatch</xsl:with-param>
                    <xsl:with-param name="title">Related Match</xsl:with-param>
                </xsl:call-template>
            </dl>
        </xsl:if>
    </xsl:template>

    <xsl:template name="relation">
        <xsl:if test="s:SemanticRelation | s:Related | s:Broader | s:Narrower | s:BroaderTransitive | s:NarrowerTransitive">
            <h2 id="relations" class="h4">Relations</h2>

            <dl class="row">
                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">SemanticRelation</xsl:with-param>
                    <xsl:with-param name="title">Semantic Relation</xsl:with-param>
                </xsl:call-template>

                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">Related</xsl:with-param>
                    <xsl:with-param name="title">Related</xsl:with-param>
                </xsl:call-template>

                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">Broader</xsl:with-param>
                    <xsl:with-param name="title">Broader</xsl:with-param>
                </xsl:call-template>

                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">Narrower</xsl:with-param>
                    <xsl:with-param name="title">Narrower</xsl:with-param>
                </xsl:call-template>

                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">BroaderTransitive</xsl:with-param>
                    <xsl:with-param name="title">Broader Transitive</xsl:with-param>
                </xsl:call-template>

                <xsl:call-template name="resources">
                    <xsl:with-param name="tag">NarrowerTransitive</xsl:with-param>
                    <xsl:with-param name="title">Narrower Transitive</xsl:with-param>
                </xsl:call-template>
            </dl>
        </xsl:if>
    </xsl:template>

    <xsl:template name="values">
        <xsl:param name="title"/>
        <xsl:param name="tag"/>

        <xsl:variable name="values">
            <xsl:for-each select="s:*[local-name() = $tag]">
                <xsl:sort select="text()"/>
                <xsl:copy-of select="current()"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="langs" select="distinct-values($values/*/@lang)"/>

        <xsl:if test="$values/*">
            <dt class="col-sm-2"><xsl:value-of select="$title"/></dt>
            <dd class="col-sm-10">
                <xsl:for-each select="$langs">
                    <xsl:sort/>

                    <xsl:variable name="lang" select="current()"/>
                    <xsl:variable name="values" select="$values/*[@lang = $lang]"/>

                    <div style="padding-left: 30pt;">
                        <span class="badge badge-info" style="margin-top: 2pt; margin-left: -30pt; float: left;"><xsl:value-of select="$lang"/></span>

                        <ul class="mb-0 list-unstyled">
                            <xsl:for-each select="$values">
                                <li><xsl:value-of select="current()"/></li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </xsl:for-each>
            </dd>
        </xsl:if>
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

    <xsl:template name="resources">
        <xsl:param name="title"/>
        <xsl:param name="tag"/>

        <xsl:variable name="resources" select="s:*[local-name() = $tag]"/>

        <xsl:if test="$resources">
            <dt class="col-sm-2"><xsl:value-of select="$title"/></dt>
            <dd class="col-sm-10">
                <div class="row">
                    <div class="col-sm-6">
                        <ul class="mb-0 list-unstyled">
                            <xsl:for-each select="$resources">
                                <xsl:if test="position() &lt;= ceiling(count($resources) div 2)">
                                    <li class="pb-2"><xsl:call-template name="resource"/></li>
                                </xsl:if>
                            </xsl:for-each>
                        </ul>
                    </div>
                    <xsl:if test="count($resources) > 1">
                        <div class="col-sm-6">
                            <ul class="pb-2 list-unstyled">
                                <xsl:for-each select="$resources">
                                    <xsl:if test="position() &gt; ceiling(count($resources) div 2)">
                                        <li class="pb-2"><xsl:call-template name="resource"/></li>
                                    </xsl:if>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </xsl:if>
                </div>
            </dd>
        </xsl:if>
    </xsl:template>

    <xsl:template name="resource">
        <xsl:param name="tag" select="''"/>

        <xsl:variable name="current" select="."/>

        <xsl:choose>
            <xsl:when test="starts-with(text(), 'http')">
                <span>
                    <xsl:value-of select="text()"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <a href="{concat($root, text(), '.html')}">
                    <xsl:value-of select="/s:Skos/s:*[@path = $current][1]/s:PrefLabel[@lang = $lang][1]/text()"/>
                <br/>
                <small class="text-muted">
                    <xsl:value-of select="$baseuri"/>
                    <strong>
                        <xsl:value-of select="text()"/>
                    </strong>
                </small>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>