# Matrices: Intro
INIT['matrices-intro'] = ->

  matrixOptions = (
    lineWidth: 4
  )

  matrixInput = new ReactiveMatrix().setFromInput('matrixInput')

  canvas = $("#canvas")
  view = new View(canvas)

  # vector = new VectorView(vectorOptions).set_reactive_trajectory sliderInput
  # vector.set_color sliderInput.color
  # vector.set_line_width line_width

  # view.add

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate
