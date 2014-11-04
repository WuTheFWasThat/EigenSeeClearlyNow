# Intro: One Vector
INIT['vectors-addition'] = ->

  canvasA = $("#canvasA")
  viewA = new View(canvasA)
  viewA.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  vectorOptions = (
    lineWidth: 4
    headWidth: 12
    headLength: 10
  )

  setupInputVector = (sliderInput, vectorOptions, line_width) ->
    vector = new VectorView(vectorOptions).set_reactive_trajectory sliderInput
    vector.set_color sliderInput.color
    vector.set_line_width line_width

  vectorInputA = new VectorSliderInput('vectorA')
  vectorA = setupInputVector(vectorInputA, vectorOptions, 4)
  viewA.addVector vectorA

  canvasB = $("#canvasB")
  viewB = new View(canvasB)
  viewB.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  vectorInputB = new VectorSliderInput('vectorB')
  vectorB = setupInputVector(vectorInputB, vectorOptions, 4)
  viewB.addVector vectorB

  ################
  # SUM
  ################

  canvasC = $("#canvasC")
  viewC = new View(canvasC)
  viewC.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  vectorSumA = setupInputVector(vectorInputA, vectorOptions, 2)

  vectorSumB = setupInputVector(vectorInputB, vectorOptions, 2)
               .set_reactive_offset vectorInputA

  vectorInputSum = new VectorSliderInput('vectorSum')
  vectorInputSum.sum vectorInputA, vectorInputB

  vectorSum = setupInputVector(vectorInputSum, vectorOptions, 4)

  viewC.addVector vectorSumA
  viewC.addVector vectorSumB
  viewC.addVector vectorSum

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view viewA
  keyHandler.register_view viewB
  keyHandler.register_view viewC

  mouseHandler = new MouseHandler()
  mouseHandler.register_view viewA
  mouseHandler.register_view viewB
  mouseHandler.register_view viewC

  # animate!
  do viewA.animate
  do viewB.animate
  do viewC.animate

