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
