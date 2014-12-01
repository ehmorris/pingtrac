window.addEventListener 'load', ->
  new FastClick(document.body)
, false

window.addEventListener 'touchmove', (e) ->
  e.preventDefault()
