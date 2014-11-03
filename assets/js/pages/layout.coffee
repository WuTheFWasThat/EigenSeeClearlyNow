$(document).ready ->
  hasWebGL = ->
    canvas = document.createElement 'canvas'
    gl = null
    try
      gl = canvas.getContext('webgl')
    catch x
    if gl is null
      try
        gl = canvas.getContext('experimental-webgl')
      catch x
    return !!gl

  if do hasWebGL
    THREE.Renderer = THREE.WebGLRenderer
  else
    THREE.Renderer = THREE.CanvasRenderer
    if not $.cookie('noWebGL')
      $('#noWebGLDismiss').click ->
        $.cookie('noWebGL', 'acknowledged')
        $('#noWebGL').addClass 'hidden'
      $('#noWebGLReason').text(if window.WebGLRenderingContext then 'browser' else 'graphics card')
      $('#noWebGL').removeClass 'hidden'

