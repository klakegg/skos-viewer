<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
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

        <rule context="s:PrefLabel | s:AltLabel | HiddenLabel | s:Note | s:ChangeNote | s:Definition | s:EditorialNote | s:Example | s:HistoryNote | s:ScopeNote">
            <assert id="SKOS-R005"
                    test="@lang"
                    flag="warning"><value-of select="local-name()"/> "<value-of select="text()" />" in '<value-of select="../@path" />' misses language declaration.</assert>
        </rule>

    </pattern>
</schema>