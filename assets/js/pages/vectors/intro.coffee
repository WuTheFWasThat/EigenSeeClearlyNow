# Intro: One Vector
init_vector_intro = ->

  canvas = $("#canvas")

  # Setup scene, camera, renderer
  view = new View(canvas)

  # Setup axes, grid
  do view.addAxes

  # Vector with arrow
  view.addVectorFromSliderID 'vectorInput'

  # register view with keyboard handler
  keyHandler.register_view view

  # animate!
  do view.animate

