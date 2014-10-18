
console.log 'General javascript stuff'

hasWebGL = ->
  canvas = document.createElement 'canvas'
  gl = null
  try
    gl = canvas.getContext('webgl')
  catch x
    gl = null
  if gl is null
    try
      gl = canvas.getContext('experimental-webgl')
      glExperimental = true
    catch x
      gl = null
  if gl
    return true
  else
    return false

if do hasWebGL
  THREE.Renderer = THREE.WebGLRenderer
else
  THREE.Renderer = THREE.CanvasRenderer
