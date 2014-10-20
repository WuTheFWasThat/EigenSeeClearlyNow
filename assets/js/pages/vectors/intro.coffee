# Intro: One Vector
init_vector_intro = ->

  # Setup scene, camera, renderer
  [scene, camera, renderer] = setupView()

  # Setup axes, grid
  setupAxes scene

  # Vector with arrow
  # TODO build our own vector arrow
  vectorColor = 0xCC0099
  arrowLen = 0
  arrowHead = 50
  direction = new THREE.Vector3(1, 0, 0)
  vectorArrow = new THREE.ArrowHelper(direction, origin, arrowLen, vectorColor, arrowHead, arrowHead)
  scene.add vectorArrow

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

    length = Math.sqrt( Math.pow(vectorXVal, 2) + Math.pow(vectorYVal, 2) + Math.pow(vectorZVal, 2))
    # console.log vectorXVal, vectorYVal, vectorZVal, length
    vectorArrow.setLength length
    vectorArrow.setDirection new THREE.Vector3(vectorXVal, vectorYVal, vectorZVal)

    return


  return do animate
