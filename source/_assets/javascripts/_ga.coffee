_gaq = _gaq or []
_gaq.push ["_setAccount", "UA-15406998-1"]
_gaq.push ["_setDomainName", "bentruyman.com"]
_gaq.push ["_trackPageview"]

ga = document.createElement("script"); ga.type = "text/javascript";
ga.async = true;
ga.src = "http://www.google-analytics.com/ga.js";
s = document.getElementsByTagName("script")[0]
s.parentNode.insertBefore(ga, s)
