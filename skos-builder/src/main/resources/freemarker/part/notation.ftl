<#if object.notation?has_content>
<h2>Notation</h2>

<ul class="list-unstyled">
    <#list object.notation?sort as value>
        <li>${value}</li>
    </#list>
</ul>
</#if>