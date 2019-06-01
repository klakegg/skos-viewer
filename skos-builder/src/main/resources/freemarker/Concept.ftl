<#include "header.ftl">

<h1>${config.baseUri}${key}<br /><small>${object.class.simpleName}</small></h1>

<div class="row">
    <div class="col-md-8">
        <#include "part/scheme.ftl">
        <#include "part/documentation.ftl">
        <#include "part/relation.ftl">
        <#include "part/mapping.ftl">
    </div>
    <div class="col-md-4">
        <#include "part/label.ftl">
        <#include "part/notation.ftl">
    </div>
</div>

<#include "footer.ftl">
