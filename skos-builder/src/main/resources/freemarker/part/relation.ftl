<#if !object.relation.isEmpty()>
    <h2>Relations</h2>

    <dl class="dl-horizontal">
        <#if object.relation.broader?has_content>
            <dt>Broader</dt>
            <#list object.relation.broader?sort as foreign>
                <dd><a href="${config.basePath}${foreign}.html">${config.baseUri}${foreign}</a></dd>
            </#list>
        </#if>

        <#if object.relation.narrower?has_content>
            <dt>Narrower</dt>
            <#list object.relation.narrower?sort as foreign>
                <dd><a href="${config.basePath}${foreign}.html">${config.baseUri}${foreign}</a></dd>
            </#list>
        </#if>

        <#if object.relation.broaderTransitive?has_content>
            <dt>Broader Transitive</dt>
            <#list object.relation.broaderTransitive?sort as foreign>
                <dd><a href="${config.basePath}${foreign}.html">${config.baseUri}${foreign}</a></dd>
            </#list>
        </#if>

        <#if object.relation.narrowerTransitive?has_content>
            <dt>Narrower Transitive</dt>
            <#list object.relation.narrowerTransitive?sort as foreign>
                <dd><a href="${config.basePath}${foreign}.html">${config.baseUri}${foreign}</a></dd>
            </#list>
        </#if>

        <#if object.relation.related?has_content>
            <dt>Related</dt>
            <#list object.relation.related?sort as foreign>
                <dd><a href="${config.basePath}${foreign}.html">${config.baseUri}${foreign}</a></dd>
            </#list>
        </#if>

        <#if object.relation.semanticRelation?has_content>
            <dt>Semantic Relation</dt>
            <#list object.relation.semanticRelation?sort as foreign>
                <dd><a href="${config.basePath}${foreign}.html">${config.baseUri}${foreign}</a></dd>
            </#list>
        </#if>
    </dl>
</#if>