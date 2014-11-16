cancelEvent = (e) ->
  do e.stopPropagation
  do e.preventDefault
  return false

String::format = ->
  newStr = this
  i = 0
  while /%s/.test(newStr)
      newStr = newStr.replace('%s', arguments[i++])
  return newStr

