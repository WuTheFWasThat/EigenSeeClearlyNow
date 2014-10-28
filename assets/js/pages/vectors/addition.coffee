# Intro: One Vector
init_vector_addition= ->

  canvasA = $("#canvasA")
  viewA = new View(canvasA)
  viewA.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  vectorInputA = new VectorSliderInput('vectorA')
  vectorA = new Vector(do vectorInputA.get_coordinates)
  viewA.addVector vectorA

  canvasB = $("#canvasB")
  viewB = new View(canvasB)
  viewB.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  vectorInputB = new VectorSliderInput('vectorB')
  vectorB = new Vector(do vectorInputB.get_coordinates)
  viewB.addVector vectorB

  canvasC = $("#canvasC")
  viewC = new View(canvasC)
  viewC.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )
  vectorC = new Vector(new THREE.Vector3().addVectors(
                        vectorA.trajectory,
                        vectorB.trajectory,
                      ))
  viewC.addVector vectorC

  vectorInputA.change (x, y, z) ->
    vectorA.set_trajectory(x, y, z)

    vectorC.set_trajectory(x + vectorB.trajectory.x,
                           y + vectorB.trajectory.y,
                           z + vectorB.trajectory.z)

  vectorInputB.change (x, y, z) ->
    vectorB.set_trajectory(x, y, z)

    vectorC.set_trajectory(x + vectorA.trajectory.x,
                           y + vectorA.trajectory.y,
                           z + vectorA.trajectory.z)

  # register view with keyboard handler
  keyHandler.register_view viewA
  keyHandler.register_view viewB
  keyHandler.register_view viewC

  # animate!
  do viewA.animate
  do viewB.animate
  do viewC.animate

