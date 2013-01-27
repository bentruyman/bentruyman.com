# debugger
$(->
  FROM_USER = "from-user"
  OPEN = "open"
  TRIGGER_KEY = 192
  $container = $("#debugger")
  $form = $("#debugger-form")
  $input = $form.find("input")
  $message = $("<li class=\"message\"></li>")
  $output = $("#debugger-output")
  $outputList = $output.find("ul")
  isOpen = false
  
  open = ->
    $container.addClass(OPEN)
    $input.focus()
    isOpen = true
  
  close = ->
    $container.removeClass(OPEN)
    isOpen = false
  
  handleInput = (command) ->
    if (command.length)
      respond command, true
  
  respond = (message, fromUser) ->
    item = $message.clone()
    
    if fromUser
      item.addClass FROM_USER
      item.text message
    
    $outputList.append item
    $output[0].scrollTop = $outputList.height()
  
  $('body').keydown((event) ->
    if event.which is TRIGGER_KEY
      if isOpen
        close()
      else
        open()
      
      event.preventDefault()
  )
  
  $form.on("submit", (event) ->
    handleInput $input.val()
    $input.val("")
    event.preventDefault()
  )
)

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
