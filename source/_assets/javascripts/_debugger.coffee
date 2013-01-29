# debugger
$(->
  FROM_USER = "from-user"
  KEYS =
    TRIGGER: 192
    TAB: 9
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
  
  autoComplete = (input) ->
    pattern = new RegExp "^" + input, "g"
    
    for command of commands
      if command.match pattern
        return command
    
    return null
  
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
  
  notEnoughArgs = ->
    respond("Not enough arguments")
  
  $("body").keydown((event) ->
    return if event.altKey or event.controlKey or event.metaKey
    
    switch event.which
      when KEYS.TRIGGER
        toggle()
      when KEYS.TAB
        command = autoComplete($input.val())
        if command then makeInput command
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
    
    message.push "Here are a list of available commands:"
    
    for command of commands
      message.push "<em>#{command}</em> — #{commands[command].description}"
    
    respond message.join "\n"
  )
  
  addCommand("get", "Gets a session cookie (get mycookie)", (args) ->
    if args.length is 1
      val = Cookies.get args[0]
      if val? respond val else respond "undefined"
    else
      notEnoughArgs()
  )
  
  addCommand("set", "Sets a session cookie (set mycookie value)", (args) ->
    if args.length >= 1
      Cookies.set args[0], args[1]
      respond "Cookie \"#{args[0]}\" set to \"#{args[1]}\""
    else
      notEnoughArgs()
  )
  
  addCommand("goto", "Navigates to a page (goto [blog, about, resume])", (args) ->
    if args[0]
      window.location = "/#{args[0]}/"
    else
      notEnoughArgs()
  )
  
  addCommand("grayscale", "Makes things boring", (->
    KEY = "grayscale"
    state = false
    
    toggleGrayscale = -> $("html").toggleClass("grayscale")
    
    if Cookies.get(KEY)? and Cookies.get(KEY) is "true"
      state = true
      toggleGrayscale()
    
    (args) ->
      toggleGrayscale()
      state = !state
      Cookies.set(KEY, state)
    )()
  )
  
  addCommand("nyan", "Toggles Nyan Cat", (->
    isPlaying = false
    
    audio = new Audio
    audio.src = "/assets/audio/nyancat.mp3"
    audio.loop = true
    audio.autoplay = false
    
    image = new Image
    image.src = "/assets/images/fun/nyancat.gif"
    image.id = "nyancat"
    
    (args) ->
      if !isPlaying
        audio.play()
        document.body.appendChild image
      else
        audio.pause()
        document.body.removeChild image
      
      isPlaying = !isPlaying
    )()
  )
  
  respond "Type <em>help</em> to start fun"
)
