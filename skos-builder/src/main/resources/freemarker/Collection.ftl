<#include "header.ftl">

<h1>${config.baseUri}${key}<br /><small>${object.class.simpleName}</small></h1>

<div class="row">
    <div class="col-md-8">
        <#include "part/documentation.ftl">

        <#if object.member?has_content>
            <h2>Members</h2>

            <ul class="list-unstyled">
                <#list object.member?sort as foreign>
                    <li><a href="${config.basePath}${foreign}.html">${config.baseUri}${foreign}</a></li>
                </#list>
            </ul>
        </#if>
    </div>
    <div class="col-md-4">
        <#include "part/label.ftl">
        <#include "part/notation.ftl">
    </div>
</div>

<#include "footer.ftl">