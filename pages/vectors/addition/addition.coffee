# Addition: Adding two vectors
INIT['vectors-addition'] = ->

  canvasA = $("#canvasA")
  viewA = new View(canvasA)

  vectorInputA = new ReactiveVector().setFromInput('vectorA')
  vectorA = new VectorView(color: vectorInputA.color, trajectory: vectorInputA)
  viewA.add vectorA

  canvasB = $("#canvasB")
  viewB = new View(canvasB)

  vectorInputB = new ReactiveVector().setFromInput('vectorB')
  vectorB = new VectorView(color: vectorInputB.color, trajectory: vectorInputB)
  viewB.add vectorB

  ################
  # SUM
  ################

  canvasC = $("#canvasC")
  viewC = new View(canvasC)

  vectorSumA = new VectorView(color: vectorInputA.color, trajectory: vectorInputA, lineWidth: 2)

  vectorSumB = new VectorView(color: vectorInputB.color, trajectory: vectorInputB, offset: vectorInputA, lineWidth: 2)

  vectorInputSum = new ReactiveVector().setFromInput('vectorSum')
  vectorInputSum.sum vectorInputA, vectorInputB

  vectorSum = new VectorView(color: vectorInputSum.color, trajectory: vectorInputSum, lineWidth: 4)

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

