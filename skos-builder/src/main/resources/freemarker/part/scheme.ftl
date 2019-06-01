<#if !object.scheme.isEmpty()>
    <h2>Scheme</h2>

    <dl class="dl-horizontal">
        <#if object.scheme.in?has_content>
            <dt>In Scheme</dt>
            <#list object.scheme.in?sort as foreign>
                <dd><a href="${config.basePath}${foreign}.html">${config.baseUri}${foreign}</a></dd>
            </#list>
        </#if>
        <#if object.scheme.topOf?has_content>
            <dt>Top concept of</dt>
            <#list object.scheme.topOf?sort as foreign>
                <dd><a href="${config.basePath}${foreign}.html">${config.baseUri}${foreign}</a></dd>
            </#list>
        </#if>
        <#if object.scheme.hasTop?has_content>
            <dt>Has top concept</dt>
            <#list object.scheme.hasTop?sort as foreign>
                <dd><a href="${config.basePath}${foreign}.html">${config.baseUri}${foreign}</a></dd>
            </#list>
        </#if>
    </dl>
</#if>