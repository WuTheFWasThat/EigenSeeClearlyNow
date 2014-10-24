# Intro: One Vector
init_vector_intro = ->

  canvas = $("#canvas")

  # Setup scene, camera, renderer
  view = new View(canvas)

  # Setup axes, grid
  do view.addAxes

  # Vector with arrow
  view.addVectorFromSliderID 'vectorInput'

  keyHandler.register_view view
  do view.animate

