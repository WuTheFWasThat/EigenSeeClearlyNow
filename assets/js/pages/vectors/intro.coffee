# Intro: One Vector
init_vector_intro = ->
  keyHandler = new KeyHandler()

  canvas = $("#canvas")

  # Setup scene, camera, renderer
  view = new View(canvas)

  vectorOptions = (
    lineWidth: 3
    headWidth: 12
    headLength: 10
  )

  # Setup axes, grid
  view.addAxes (
    axesLength: 200
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  # Vector with arrow

  vectorInput = new VectorSliderInput('vectorInput')
  vector = new VectorView(vectorOptions).set_trajectory do vectorInput.get_coordinates
  vectorInput.on 'change', (x, y, z) ->
    vector.set_trajectory([x, y, z])
  view.addVector vector

  # register view with keyboard handler
  keyHandler.register_view view

  # animate!
  do view.animate


