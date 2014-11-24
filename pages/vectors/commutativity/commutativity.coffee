# Commutativity: Showing vector addition is commutative
INIT['vectors-commutativity'] = ->

  vectorInputA = new ReactiveVector().setFromInput('vectorA')
  vectorInputB = new ReactiveVector().setFromInput('vectorB')

  ################
  # SUM
  ################

  canvas = $("#sumCanvas")
  view = new View(canvas)

  vectorAFromOrigin = new VectorView(color: vectorInputA.color, trajectory: vectorInputA, lineWidth: 2)
  vectorBFromA      = new VectorView(color: vectorInputB.color, trajectory: vectorInputB, lineWidth: 2, offset: vectorInputA)
  vectorBFromOrigin = new VectorView(color: vectorInputB.color, trajectory: vectorInputB, lineWidth: 2)
  vectorAFromB      = new VectorView(color: vectorInputA.color, trajectory: vectorInputA, lineWidth: 2, offset: vectorInputB)

  vectorInputSum = new ReactiveVector().setFromInput('vectorSum')
  vectorInputSum.sum vectorInputA, vectorInputB

  vectorSum = new VectorView(color: vectorInputSum.color, trajectory: vectorInputSum, lineWidth: 4)

  view.add vectorAFromOrigin, vectorBFromA, vectorBFromOrigin, vectorAFromB, vectorSum

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerView view

  mouseHandler = new MouseHandler()
  mouseHandler.registerView view

  # animate!
  do view.animate
