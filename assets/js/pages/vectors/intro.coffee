# Intro: One Vector
init_vector_intro = ->

  canvas = $("#canvas")
  # Setup scene, camera, renderer
  [scene, camera, renderer] = setupView(canvas)

  # Setup axes, grid
  setupAxes scene

  # Vector with arrow
  # TODO build our own vector arrow
  vectorColor = 0xCC0099
  arrowLen = 0
  arrowHead = 50

  vector = new Vector([100, 0, 0])

  vector.draw_on scene

  # Changes vector based on user input
  animate = ->
    requestAnimationFrame animate
    renderer.render scene, camera

    vectorXVal = parseInt $('#sliderX').val()
    vectorYVal = parseInt $('#sliderY').val()
    vectorZVal = parseInt $('#sliderZ').val()

    $('#sliderXVal').text(vectorXVal)
    $('#sliderYVal').text(vectorYVal)
    $('#sliderZVal').text(vectorZVal)

    timer = new Date().getTime() * 0.0005
    camera.position.x = Math.floor(Math.cos( timer ) * 200)
    camera.position.z = Math.floor(Math.sin( timer ) * 200)
    #console.log scene.position
    camera.lookAt(scene.position)
    #console.log camera.position

    vector.set_coordinates vectorXVal, vectorYVal, vectorZVal

    return


  return do animate
