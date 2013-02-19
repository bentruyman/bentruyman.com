owa_baseUrl = 'http://owa.bentruyman.com/'
owa_cmds = owa_cmds || []
owa_cmds.push(['setSiteId', '2863f91112b8c03c5295e4e35ffd6bb6'])
owa_cmds.push(['trackPageView'])
owa_cmds.push(['trackClicks'])
owa_cmds.push(['trackDomStream'])

_owa = document.createElement('script')
_owa.type = 'text/javascript'
_owa.async = true
_owa.src = owa_baseUrl + 'modules/base/js/owa.tracker-combined-min.js'
_owa_s = document.getElementsByTagName('script')[0]
_owa_s.parentNode.insertBefore(_owa, _owa_s)
