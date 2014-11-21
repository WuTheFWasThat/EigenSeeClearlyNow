# Commutativity: Showing vector addition is commutative
INIT['vectors-commutativity'] = ->

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

  ################
  # SUM
  ################

  canvas = $("#sumCanvas")
  view = new View(canvas)

  vectorAFromOrigin = setupInputVector(vectorInputA, vectorOptions, 2)

  vectorBFromA = setupInputVector(vectorInputB, vectorOptions, 2)
               .set_reactive_offset vectorInputA

  vectorBFromOrigin = setupInputVector(vectorInputB, vectorOptions, 2)

  vectorAFromB = setupInputVector(vectorInputA, vectorOptions, 2)
               .set_reactive_offset vectorInputB

  vectorInputSum = new ReactiveVector().setFromInput('vectorSum')
  vectorInputSum.sum vectorInputA, vectorInputB

  vectorSum = setupInputVector(vectorInputSum, vectorOptions, 4)

  view.add vectorAFromOrigin, vectorBFromA, vectorBFromOrigin, vectorAFromB, vectorSum

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate
