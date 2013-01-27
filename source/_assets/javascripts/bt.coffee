# list out most popular github repos
$(->
  $container = $("#gh_repos")
  
  if $container.length
    handleError = ->
      $container.addClass("error").text("Error loading feed")
    
    $.ajax(
      url: "https://api.github.com/users/bentruyman/repos?callback=?"
      dataType: "jsonp"
      error: -> handleError
      success: (resp) ->
        if (!resp || !resp.data || resp.meta.status != "403")
          return handleError()
        
        repos = resp.data
        
        repos.sort((a, b) ->
          aScore = a.watchers
          bScore = b.watchers
          
          bScore - aScore
        )
        
        $container.empty()
        
        for i in [0...5]
          $container.append "<li><a href=\"#{repos[i].html_url}\">#{repos[i].name}</a></li>"
    )
)

# handle disqus comments
$(->
  # comment count
  s = document.createElement "script"
  s.async = true
  s.type = "text/javascript"
  s.src = "http://bentruyman.disqus.com/count.js"
  
  (document.getElementsByTagName("HEAD")[0] || document.getElementsByTagName("BODY")[0]).appendChild(s)
  
  # comment box
  dsq = document.createElement('script')
  dsq.type = 'text/javascript'
  dsq.async = true
  dsq.src = 'http://bentruyman.disqus.com/embed.js'
  
  (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
)
