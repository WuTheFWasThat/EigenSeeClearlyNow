cancelEvent = (e) ->
  do e.stopPropagation
  do e.preventDefault
  return false
