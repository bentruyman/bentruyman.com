# handle disqus comments
$(->
  # comment count
  s = document.createElement "script"
  s.async = true
  s.type = "text/javascript"
  s.src = "http://bentruyman.disqus.com/count.js"
  
  (document.getElementsByTagName("HEAD")[0] || document.getElementsByTagName("body")[0]).appendChild(s)
)

$(->
  # comment box
  $container = $("#disqus_thread")
  
  if $container.length
    dsq = document.createElement("script")
    dsq.type = "text/javascript"
    dsq.async = true
    dsq.src = "http://bentruyman.disqus.com/embed.js"
    
    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq)
)
