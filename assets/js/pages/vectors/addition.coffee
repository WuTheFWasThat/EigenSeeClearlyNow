# Intro: One Vector
init_vector_addition= ->

  canvasA = $("#canvasA")
  viewA = new View(canvasA)
  viewA.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  vectorOptions = (
    lineWidth: 3
    headWidth: 12
    headLength: 10
  )

  cloneOptions = (options) ->
    newoptions = {}
    for k,v of options
      newoptions[k] = v
    return newoptions

  vectorInputA = new VectorSliderInput('vectorA')
  vectorA = new Vector(do vectorInputA.get_coordinates, vectorOptions)
  viewA.addVector vectorA

  canvasB = $("#canvasB")
  viewB = new View(canvasB)
  viewB.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  vectorInputB = new VectorSliderInput('vectorB')
  vectorB = new Vector(do vectorInputB.get_coordinates, vectorOptions)
  viewB.addVector vectorB

  ################
  # SUM
  ################

  canvasC = $("#canvasC")
  viewC = new View(canvasC)
  viewC.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  vectorSumA = new Vector(do vectorInputA.get_coordinates, vectorOptions)

  sumBOptions = cloneOptions vectorOptions
  sumBOptions.offset = do vectorInputA.get_coordinates
  vectorSumB = new Vector(do vectorInputB.get_coordinates, sumBOptions)

  trajectorySum = new THREE.Vector3().addVectors(vectorA.trajectory, vectorB.trajectory)

  vectorSum = new Vector(trajectorySum, vectorOptions)
  viewC.addVector vectorSumA
  viewC.addVector vectorSumB
  viewC.addVector vectorSum

  vectorInputA.change (x, y, z) ->
    vectorA.set_trajectory(x, y, z)
    vectorSumA.set_trajectory(x, y, z)
    vectorSumB.set_offset(x, y, z)

    vectorSum.set_trajectory(x + vectorB.trajectory.x,
                             y + vectorB.trajectory.y,
                             z + vectorB.trajectory.z)

  vectorInputB.change (x, y, z) ->
    vectorB.set_trajectory(x, y, z)
    vectorSumB.set_trajectory(x, y, z)

    vectorSum.set_trajectory(x + vectorA.trajectory.x,
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

