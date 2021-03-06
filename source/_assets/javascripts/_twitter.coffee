# JSON-P Twitter fetcher for Octopress
# (c) Brandon Mathis // MIT License

linkifyTweet = (text, url) ->
  # Linkify urls, usernames, hashtags
  text = text.replace(/(https?:\/\/)([\w\-:;?&=+.%#\/]+)/gi, '<a href="$1$2">$2</a>')
    .replace(/(^|\W)@(\w+)/g, '$1<a href="https://twitter.com/$2">@$2</a>')
    .replace(/(^|\W)#(\w+)/g, '$1<a href="https://search.twitter.com/search?q=%23$2">#$2</a>');

  # Use twitter's api to replace t.co shortened urls with expanded ones.
  for u in url
    if u.expanded_url != null 
      shortUrl = new RegExp u.url, 'g'
      text = text.replace shortUrl, u.expanded_url
      shortUrl = new RegExp ">" + u.url.replace(/https?:\/\//, ""), "g"
      text = text.replace(shortUrl, ">"+u.display_url);
  
  return text

showTwitterFeed = (tweets, twitter_user) ->
  timeline = document.getElementById("tweets")
  content = []
  
  for tweet in tweets
    content.push "<li><p>"
    content.push linkifyTweet(tweet.text.replace(/\n/g, "<br>"), tweet.entities.urls)
    content.push "<a href=\"https://twitter.com/#{twitter_user}/status/#{tweet.id_str}\" class=\"created-at\">#{tweet.created_at}</a>"
    content.push "</p></li>"
  
  timeline.innerHTML = content.join "";

getTwitterFeed = (user, count, replies) ->
  count = parseInt count, 10
  $.getJSON("/tweets?callback=?")
    .error((err) -> $("#tweets li.loading").addClass("error").text "Twitter's busted")
    .success((data) -> showTwitterFeed(data.slice(0, count), user))

getTwitterFeed "bentruyman", 2, false
