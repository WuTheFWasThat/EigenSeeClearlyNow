# Intro: One Vector
init_vector_addition= ->

  canvasA = $("#canvasA")
  viewA = new View(canvasA)
  do viewA.addAxes
  viewA.addVectorFromSliderID 'vectorA'

  canvasB = $("#canvasB")
  viewB = new View(canvasB)
  do viewB.addAxes
  viewB.addVectorFromSliderID 'vectorB'

  canvasC = $("#canvasC")
  viewC = new View(canvasC)
  do viewC.addAxes

  # register view with keyboard handler
  keyHandler.register_view viewA
  keyHandler.register_view viewB
  keyHandler.register_view viewC

  # animate!
  do viewA.animate
  do viewB.animate
  do viewC.animate

