# Addition: Adding two vectors
INIT['vectors-addition'] = ->

  canvasA = $("#canvasA")
  viewA = new View(canvasA)

  vectorOptions = (
    lineWidth: 4
    headWidth: 12
    headLength: 10
  )

  setupInputVector = (sliderInput, vectorOptions, lineWidth) ->
    vector = new VectorView(vectorOptions).setReactiveTrajectory sliderInput
    vector.setColor sliderInput.color
    vector.setLineWidth lineWidth

  vectorInputA = new ReactiveVector().setFromInput('vectorA')
  vectorA = setupInputVector(vectorInputA, vectorOptions, 4)
  viewA.add vectorA

  canvasB = $("#canvasB")
  viewB = new View(canvasB)

  vectorInputB = new ReactiveVector().setFromInput('vectorB')
  vectorB = setupInputVector(vectorInputB, vectorOptions, 4)
  viewB.add vectorB

  ################
  # SUM
  ################

  canvasC = $("#canvasC")
  viewC = new View(canvasC)

  vectorSumA = setupInputVector(vectorInputA, vectorOptions, 2)

  vectorSumB = setupInputVector(vectorInputB, vectorOptions, 2)
               .setReactiveOffset vectorInputA

  vectorInputSum = new ReactiveVector().setFromInput('vectorSum')
  vectorInputSum.sum vectorInputA, vectorInputB

  vectorSum = setupInputVector(vectorInputSum, vectorOptions, 4)

  viewC.add vectorSumA, vectorSumB, vectorSum

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerViews viewA, viewB, viewC

  mouseHandler = new MouseHandler()
  mouseHandler.registerViews viewA, viewB, viewC

  # animate!
  do viewA.animate
  do viewB.animate
  do viewC.animate

