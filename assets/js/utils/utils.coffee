################################################################################
# javascript event handling
################################################################################

cancelEvent = (e) ->
  do e.stopPropagation
  do e.preventDefault
  return false

################################################################################
# strings
################################################################################

String::format = ->
  newStr = this
  i = 0
  while /%s/.test(newStr)
      newStr = newStr.replace('%s', arguments[i++])
  return newStr

################################################################################
# numbers
################################################################################

# get a random integer between min and max, inclusive
Number.randInt = (min, max) ->
  return Math.floor(min + Math.random() * (max - min + 1))

################################################################################
# mathjax
################################################################################

vec2latex = (vector) ->
  return '\\left(\\begin{array}{c}' + vector.x + '\\\\' + vector.y + '\\\\' + vector.z + '\\end{array}\\right)'

renderLatex = (div, latex) ->
  div.text latex
  MathJax.Hub.Queue ['Typeset', MathJax.Hub, div[0]]
