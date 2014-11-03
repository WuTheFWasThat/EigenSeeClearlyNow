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

  vectorInputA = new VectorSliderInput('vectorA')
  vectorAOptions = _.clone vectorOptions
  vectorAOptions.color = vectorInputA.color
  vectorA = new VectorView(vectorAOptions).set_reactive_trajectory vectorInputA
  viewA.addVector vectorA

  canvasB = $("#canvasB")
  viewB = new View(canvasB)
  viewB.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  vectorInputB = new VectorSliderInput('vectorB')
  vectorBOptions = _.clone vectorOptions
  vectorBOptions.color = vectorInputB.color
  vectorB = new VectorView(vectorBOptions).set_reactive_trajectory vectorInputB
  viewB.addVector vectorB

  vectorInputSum = new VectorSliderInput('vectorSum')
  vectorInputSum.sum vectorInputA, vectorInputB

  ################
  # SUM
  ################

  canvasC = $("#canvasC")
  viewC = new View(canvasC)
  viewC.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  sumAOptions = _.clone vectorAOptions
  vectorSumA = new VectorView(sumAOptions).set_reactive_trajectory vectorInputA

  sumBOptions = _.clone vectorBOptions
  vectorSumB = new VectorView(sumBOptions).set_reactive_trajectory vectorInputB
  vectorSumB.set_reactive_offset vectorInputA

  vectorOptions.color = vectorInputSum.color
  vectorSum = new VectorView(vectorOptions).set_reactive_trajectory vectorInputSum

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

