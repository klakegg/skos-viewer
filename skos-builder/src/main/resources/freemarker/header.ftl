<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>${config.name}</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
    <style>
        dl.dl-horizontal dt { text-align: left; }
    </style>

    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>

<nav class="navbar navbar-default">
    <div class="container">
        <div class="navbar-header">
            <span class="navbar-brand">${config.name}</span>
        </div>
        <#if config.options['github']??>
        <ul class="nav navbar-nav navbar-right">
            <#if config.options['github']['repository']??><li><a href="${config.options['github']['repository']}">Github</a></li></#if>
            <#if config.options['github']['issues']??><li><a href="${config.options['github']['issues']}">Issues</a></li></#if>
        </ul>
        </#if>
    </div>
</nav>

<div class="container">
