$(->
  $container = $('#gh_repos')
  
  $.ajax(
    url: "https://api.github.com/users/bentruyman/repos?callback=?"
    dataType: "jsonp"
    error: -> $container.addClass("error").text("Error loading feed")
    success: (resp) ->
      if (!resp || !resp.data)
        return
      
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
