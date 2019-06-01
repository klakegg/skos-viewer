<#if !object.mapping.isEmpty()>
    <h2>Mapping</h2>

    <dl class="dl-horizontal">
        <#if object.mapping.mappingRelation?has_content>
            <dt>Mapping relation</dt>
            <#list object.mapping.mappingRelation?sort as foreign>
                <dd>${foreign}</a></dd>
            </#list>
        </#if>
        <#if object.mapping.closeMatch?has_content>
            <dt>Close match</dt>
            <#list object.mapping.closeMatch?sort as foreign>
                <dd>${foreign}</a></dd>
            </#list>
        </#if>
        <#if object.mapping.exactMatch?has_content>
            <dt>Exact match</dt>
            <#list object.mapping.exactMatch?sort as foreign>
                <dd>${foreign}</a></dd>
            </#list>
        </#if>
        <#if object.mapping.broadMatch?has_content>
            <dt>Broad match</dt>
            <#list object.mapping.broadMatch?sort as foreign>
                <dd>${foreign}</a></dd>
            </#list>
        </#if>
        <#if object.mapping.narrowMatch?has_content>
            <dt>Narrow match</dt>
            <#list object.mapping.narrowMatch?sort as foreign>
                <dd>${foreign}</a></dd>
            </#list>
        </#if>
        <#if object.mapping.relatedMatch?has_content>
            <dt>Related match</dt>
            <#list object.mapping.relatedMatch?sort as foreign>
                <dd>${foreign}</a></dd>
            </#list>
        </#if>
    </dl>
</#if>