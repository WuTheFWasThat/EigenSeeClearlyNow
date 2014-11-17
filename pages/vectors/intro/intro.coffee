# Intro: One Vector
INIT['vectors-intro'] = ->

  canvas = $("#canvas")

  # Setup scene, camera, renderer
  view = new View(canvas)

  vectorOptions = (
    lineWidth: 3
    headWidth: 12
    headLength: 10
  )

  # Vector with arrow

  vectorInput = new ReactiveVector().setFromSliderInput('vectorInput')
  vector = new VectorView(vectorOptions).set_reactive_trajectory vectorInput
  view.add vector

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate
