<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        schemaVersion="iso" queryBinding="xslt2">

    <title>Skos validation</title>

    <ns prefix="s" uri="urn:fdc:difi.no:2019:data:Skos-1"/>

    <pattern>
        <rule context="s:InScheme">
            <let name="current" value="current()"/>

            <assert id="EHF-ESPD-R120"
                    test="//s:ConceptScheme[@path = normalize-space($current/text())]"
                    flag="fatal">Unable to find concept scheme '<value-of select="text()"/>' referenced in '<value-of select="parent::element()/@path"/>'.</assert>
        </rule>

        <rule context="s:Broader | s:Narrower | s:BroaderTransitive | s:NarrowerTransitive | s:Related | s:SemanticRelation">
            <let name="current" value="current()"/>

            <assert id="EHF-ESPD-R120"
                    test="//s:Concept[@path = normalize-space($current/text())]"
                    flag="fatal">Unable to find concept '<value-of select="text()"/>' referenced in '<value-of select="parent::element()/@path"/>'.</assert>
        </rule>
    </pattern>
</schema>