# Addition: Adding two vectors
INIT['vectors-addition'] = ->

  canvasA = $("#canvasA")
  viewA = new View(canvasA)

  vectorOptions = (
    lineWidth: 4
    headWidth: 12
    headLength: 10
  )

  setupInputVector = (sliderInput, vectorOptions, line_width) ->
    vector = new VectorView(vectorOptions).set_reactive_trajectory sliderInput
    vector.set_color sliderInput.color
    vector.set_line_width line_width

  vectorInputA = new ReactiveVector().setFromSliderInput('vectorA')
  vectorA = setupInputVector(vectorInputA, vectorOptions, 4)
  viewA.add vectorA

  canvasB = $("#canvasB")
  viewB = new View(canvasB)

  vectorInputB = new ReactiveVector().setFromSliderInput('vectorB')
  vectorB = setupInputVector(vectorInputB, vectorOptions, 4)
  viewB.add vectorB

  ################
  # SUM
  ################

  canvasC = $("#canvasC")
  viewC = new View(canvasC)

  vectorSumA = setupInputVector(vectorInputA, vectorOptions, 2)

  vectorSumB = setupInputVector(vectorInputB, vectorOptions, 2)
               .set_reactive_offset vectorInputA

  vectorInputSum = new ReactiveVector().setFromSliderInput('vectorSum')
  vectorInputSum.sum vectorInputA, vectorInputB

  vectorSum = setupInputVector(vectorInputSum, vectorOptions, 4)

  viewC.add vectorSumA, vectorSumB, vectorSum

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_views viewA, viewB, viewC

  mouseHandler = new MouseHandler()
  mouseHandler.register_views viewA, viewB, viewC

  # animate!
  do viewA.animate
  do viewB.animate
  do viewC.animate

