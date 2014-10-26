# Intro: One Vector
init_vector_intro = ->

  canvas = $("#canvas")

  # Setup scene, camera, renderer
  view = new View(canvas)

  # Setup axes, grid
  do view.addAxes

  # Vector with arrow

  vectorInput = new VectorSliderInput('vectorInput')
  vector = new Vector(do vectorInput.get_coordinates)
  vectorInput.change (x, y, z) ->
    vector.set_trajectory(x, y, z)
  view.addVector vector

  # register view with keyboard handler
  keyHandler.register_view view

  # animate!
  do view.animate


