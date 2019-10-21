<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        schemaVersion="iso" queryBinding="xslt2">

    <title>Skos validation</title>

    <ns prefix="s" uri="urn:fdc:difi.no:2019:data:Skos-1"/>

    <pattern>
        <rule context="s:InScheme">
            <let name="ref" value="normalize-space(text())"/>

            <assert id="SKOS-R001"
                    test="//s:ConceptScheme[@path = $ref]"
                    flag="fatal">Unable to find concept scheme '<value-of select="text()"/>' referenced in '<value-of select="parent::element()/@path"/>'.</assert>
        </rule>

        <rule context="s:Broader | s:Narrower | s:BroaderTransitive | s:NarrowerTransitive | s:Related | s:SemanticRelation">
            <let name="ref" value="normalize-space(text())"/>

            <assert id="SKOS-R002"
                    test="//s:Concept[@path = $ref]"
                    flag="fatal">Unable to find concept '<value-of select="text()"/>' referenced in '<value-of select="parent::element()/@path"/>'.</assert>
        </rule>

        <rule context="s:Member">
            <let name="ref" value="normalize-space(text())"/>

            <assert id="SKOS-R003"
                    test="//s:Concept[@path = $ref] | //s:ConceptScheme[@path = $ref]"
                    flag="fatal">Unable to find concept '<value-of select="text()"/>' referenced in '<value-of select="parent::element()/@path"/>'.</assert>
        </rule>

        <rule context="s:Concept | s:ConceptScheme | s:Collection">
            <let name="path" value="normalize-space(@path)"/>

            <assert id="SKOS-R004"
                    test="count(//s:Concept[normalize-space(@path) = $path] | //s:ConceptScheme[normalize-space(@path) = $path] | //s:Collection[normalize-space(@path) = $path]) = 1"
                    flag="fatal">More than one item has path '<value-of select="$path"/>'.</assert>
        </rule>

        <rule context="s:PrefLabel | s:AltLabel | HiddenLabel">
            <assert id="SKOS-R005"
                    test="@lang"
                    flag="warning"><value-of select="local-name()"/> "<value-of select="text()"/>" in '<value-of select="../@path"/>' misses language declaration.</assert>
        </rule>

        <rule context="s:Note | s:ChangeNote | s:Definition | s:EditorialNote | s:Example | s:HistoryNote | s:ScopeNote">
            <let name="type" value="local-name()"/>
            <let name="lang" value="@lang"/>

            <assert id="SKOS-R006"
                    test="@lang"
                    flag="warning"><value-of select="local-name()"/> "<value-of select="text()"/>" in '<value-of select="../@path"/>' misses language declaration.</assert>
            <assert id="SKOS-R007"
                    test="not(@lang) or count(../*[local-name() = $type][@lang = $lang]) = 1"
                    flag="warning">Multiple <value-of select="lower-case($type)"/> with language '<value-of select="$lang"/>' in '<value-of select="../@path"/>'.</assert>
        </rule>

    </pattern>

    <pattern>
        <let name="languages_all" value="distinct-values(//@lang)"/>
        <let name="languages_no" value="tokenize('nb nn', '\s')"/>

        <rule context="s:PrefLabel[1]">
            <let name="type" value="local-name()"/>

            <assert id="SKOS-R008"
                    test="every $lang in $languages_all satisfies ../*[local-name() = $type][@lang = $lang]"
                    flag="warning">Incomplete language support for '<value-of select="../@path"/>' in <value-of select="lower-case($type)"/>.</assert>
        </rule>

        <rule context="s:Note[1] | s:Definition[1] | s:Example[1] | s:HistoryNote[1] | s:ScopeNote[1]">
            <let name="type" value="local-name()"/>

            <assert id="SKOS-R009"
                    test="every $lang in $languages_no satisfies ../*[local-name() = $type][@lang = $lang]"
                    flag="warning">Incomplete language support for '<value-of select="../@path"/>' in <value-of select="lower-case($type)"/>.</assert>
        </rule>
    </pattern>
</schema>