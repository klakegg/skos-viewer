<#if !object.documentation.isEmpty()>
    <h2>Documentation</h2>

    <dl class="dl-horizontal">
        <#if object.documentation.note?has_content>
            <dt>Note</dt>
            <#list object.documentation.note?sort as value>
                <dd><#if value.language??><strong>${value.language}</strong> </#if>${value.value}</dd>
            </#list>
        </#if>

        <#if object.documentation.changeNote?has_content>
            <dt>Change Note</dt>
            <#list object.documentation.changeNote?sort as value>
                <dd><#if value.language??><strong>${value.language}</strong> </#if>${value.value}</dd>
            </#list>
        </#if>

        <#if object.documentation.definition?has_content>
            <dt>Definition</dt>
            <#list object.documentation.definition?sort as value>
                <dd><#if value.language??><strong>${value.language}</strong> </#if>${value.value}</dd>
            </#list>
        </#if>

        <#if object.documentation.editorialNote?has_content>
            <dt>Editorial Note</dt>
            <#list object.documentation.editorialNote?sort as value>
                <dd><#if value.language??><strong>${value.language}</strong> </#if>${value.value}</dd>
            </#list>
        </#if>

        <#if object.documentation.example?has_content>
            <dt>Example</dt>
            <#list object.documentation.example?sort as value>
                <dd><#if value.language??><strong>${value.language}</strong> </#if>${value.value}</dd>
            </#list>
        </#if>

        <#if object.documentation.historyNote?has_content>
            <dt>History Note</dt>
            <#list object.documentation.historyNote?sort as value>
                <dd><#if value.language??><strong>${value.language}</strong> </#if>${value.value}</dd>
            </#list>
        </#if>

        <#if object.documentation.scopeNote?has_content>
            <dt>Scope Note</dt>
            <#list object.documentation.scopeNote?sort as value>
                <dd><#if value.language??><strong>${value.language}</strong> </#if>${value.value}</dd>
            </#list>
        </#if>
    </dl>
</#if>