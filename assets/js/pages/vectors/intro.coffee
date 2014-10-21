# Intro: One Vector
init_vector_intro = ->

  canvas = $("#canvas")
  # Setup scene, camera, renderer
  view = new View(canvas)

  # Setup axes, grid
  setupAxes view.scene

  # Vector with arrow
  # TODO build our own vector arrow
  vectorColor = 0xCC0099
  arrowLen = 0
  arrowHead = 50

  vector = new Vector([100, 0, 0])

  vector.draw_on view.scene

  # Changes vector based on user input
  animate = ->
    requestAnimationFrame animate
    do view.render

    vectorXVal = parseInt $('#sliderX').val()
    vectorYVal = parseInt $('#sliderY').val()
    vectorZVal = parseInt $('#sliderZ').val()

    $('#sliderXVal').text(vectorXVal)
    $('#sliderYVal').text(vectorYVal)
    $('#sliderZVal').text(vectorZVal)

    vector.set_coordinates vectorXVal, vectorYVal, vectorZVal
    #view.rotate 5, 1

    return


  return do animate
