# Intro: One Vector
init_vector_addition= ->

  canvasA = $("#canvasA")
  viewA = new View(canvasA)
  do viewA.addAxes

  vectorInputA = new VectorSliderInput('vectorA')
  vectorA = new Vector(do vectorInputA.get_coordinates)
  vectorInputA.change (x, y, z) ->
    vectorA.set_trajectory(x, y, z)
  viewA.addVector vectorA

  canvasB = $("#canvasB")
  viewB = new View(canvasB)
  do viewB.addAxes

  vectorInputB = new VectorSliderInput('vectorB')
  vectorB = new Vector(do vectorInputB.get_coordinates)
  vectorInputB.change (x, y, z) ->
    vectorB.set_trajectory(x, y, z)
  viewB.addVector vectorB

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

