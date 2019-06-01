
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

<#if config.options['piwik']??>
<script type="text/javascript">
    var pkBaseURL = (("https:" == document.location.protocol) ? "https://${config.options['piwik']['site']}/" : "http://${config.options['piwik']['id']}/");
    document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
    try {
        var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", ${config.options['piwik']['id']});
        piwikTracker.trackPageView();
        pageTracker._addOrganic("google.no","q");
        pageTracker._addOrganic("abcsok.no","q");
        pageTracker._addOrganic("verden.abcsok.no","q");
        piwikTracker.enableLinkTracking();
    } catch( err ) {}
</script>
<noscript><p><img src="https://${config.options['piwik']['site']}/piwik.php?idsite=${config.options['piwik']['id']}" style="border:0" alt="" /></p></noscript>
</#if>

</body>
</html>