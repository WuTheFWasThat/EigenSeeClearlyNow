# Matrices: Intro
INIT['matrices-intro'] = ->

  vectorOptions = (
    lineWidth: 4
    headWidth: 12
    headLength: 10
  )

  # TODO put this method somewhere appropriate, shouldn't repeat it in demo coffee files
  setupInputVector = (sliderInput, vectorOptions, line_width) ->
    vector = new VectorView(vectorOptions).set_reactive_trajectory sliderInput
    vector.set_color sliderInput.color
    vector.set_line_width line_width

  vectorInputA = new ReactiveVector().setFromInput('vectorA')
  vectorInputB = new ReactiveVector().setFromInput('vectorB')
  vectorInputC = new ReactiveVector().setFromInput('vectorC')

  canvas = $("#canvas")
  view = new View(canvas)

  vectorAFromOrigin = setupInputVector(vectorInputA, vectorOptions, 2)

  #vectorBFromA = setupInputVector(vectorInputB, vectorOptions, 2)
  #.set_reactive_offset vectorInputA

  vectorBFromOrigin = setupInputVector(vectorInputB, vectorOptions, 2)

  # vectorAFromB = setupInputVector(vectorInputA, vectorOptions, 2)
  #.set_reactive_offset vectorInputB

  vectorCFromOrigin = setupInputVector(vectorInputC, vectorOptions, 2)

  view.add vectorAFromOrigin, vectorBFromOrigin, vectorCFromOrigin

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate
