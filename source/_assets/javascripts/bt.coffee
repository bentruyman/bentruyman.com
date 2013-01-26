# page loader
BODY_MATCH = /<body id="(.+?)">/
CONTAINER_SELECTOR = "#page-body"
LOADING = "loading"

$pageBody = $(CONTAINER_SELECTOR)

$("body").on "click", "a", (event)->
  domainMatch = new RegExp("^" + window.location.origin, "g")
  el = event.currentTarget;
  
  # if the clicked anchor is for an internal page, load it via AJAX
  if el.href && el.href.match(domainMatch)
    if window.location.pathname != el.pathname
      $pageBody.addClass LOADING
      
      # request the next page
      $.get el.pathname, (html)->
        newContainer = $(CONTAINER_SELECTOR, html).get(0)
        $pageBody.html(newContainer.innerHTML)
        
        $pageBody.removeClass LOADING
        
        window.history.pushState {}, "", el.pathname
        
        match = html.match(BODY_MATCH)
        bodyId = match[1]
        
        document.body.id = bodyId
        
        return
    
    # prevent the link from following
    event.preventDefault()
  
  return
