# debugger
$(->
  FROM_USER = "from-user"
  KEYS =
    TRIGGER: 192
    UP: 38
    DOWN: 40
  OPEN = "open"
  $container = $("#debugger")
  $form = $("#debugger-form")
  $input = $form.find("input")
  $message = $("<li class=\"message\"></li>")
  $output = $("#debugger-output")
  $outputList = $output.find("ul")
  $trigger = $("#debugger-trigger").find("a")
  isFocused = false
  isOpen = false
  commands = {}
  commandHistory = []
  historyIndex = 0
  
  toggle = ->
    if isOpen
      close()
    else
      open()
  
  open = ->
    $container.addClass(OPEN)
    $input.focus()
    isOpen = true
  
  close = ->
    $container.removeClass(OPEN)
    isOpen = false
  
  handleInput = (input) ->
    if input.length
      respond input, true
      commandHistory.push input
      handleCommand parseInput input
      historyIndex = commandHistory.length
  
  addCommand = (command, description, callback) ->
    commands[command] =
      description: description
      callback: callback
  
  removeCommand = (command) ->
    delete commands[command]
  
  handleCommand = (command) ->
    if commands[command.command]?
      commands[command.command.toLowerCase()].callback(command.args)
    else
      respond "Command \"#{command.command}\" not found."
  
  parseInput = (input) ->
    pieces = input.split " "
    
    command: pieces[0]
    args: pieces[1...]
  
  makeInput = (input) ->
    $input.val(input)
  
  respond = (message, fromUser) ->
    item = $message.clone()
    
    if fromUser
      item.addClass FROM_USER
    
    item.html message
    
    $outputList.append item
    $output[0].scrollTop = $outputList.height()
  
  $("body").keydown((event) ->
    switch event.which
      when KEYS.TRIGGER
        toggle()
      when KEYS.UP
        if isFocused
          historyIndex = Math.max(0, historyIndex - 1)
          makeInput(commandHistory[historyIndex])
      when KEYS.DOWN
        if isFocused
          if commandHistory[historyIndex + 1]?
            historyIndex = Math.min(commandHistory.length - 1, historyIndex + 1)
            makeInput(commandHistory[historyIndex])
          else
            makeInput ""
    
    for key of KEYS
      if event.which is KEYS[key]
        event.preventDefault()
        break
  )
  
  $trigger.on("click", (event) ->
    toggle()
    event.preventDefault()
  )
  
  $form.on("submit", (event) ->
    handleInput $input.val()
    $input.val("")
    event.preventDefault()
  )
  
  $input.on("focus", -> isFocused = true)
  $input.on("blur",  -> isFocused = false)
  
  addCommand("help", "Displays this message", (args) ->
    message = []
    
    for command of commands
      console.log command
      message.push "#{command} — #{commands[command].description}"
    
    respond message.join "<br>"
  )
  
  addCommand("lol", "idk", (args) ->
    respond "jk jk"
  )
  
  respond "Type <em>help</em> to start fun"
  open()
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
