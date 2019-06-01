<#if !object.label.isEmpty()>
    <h2>Labels</h2>

    <dl>
        <#if object.label.preferred?has_content>
            <dt>Preferred label</dt>
            <#list object.label.preferred?sort as value>
                <dd><#if value.language??><strong>${value.language}</strong> </#if>${value.value}</dd>
            </#list>
        </#if>

        <#if object.label.alternative?has_content>
            <dt>Alternative label</dt>
            <#list object.label.alternative?sort as value>
                <dd><#if value.language??><strong>${value.language}</strong> </#if>${value.value}</dd>
            </#list>
        </#if>

        <#if object.label.hidden?has_content>
            <dt>Hidden label</dt>
            <#list object.label.hidden?sort as value>
                <dd><#if value.language??><strong>${value.language}</strong> </#if>${value.value}</dd>
            </#list>
        </#if>
    </dl>
</#if>