# From the three.js github example
init_vector_intro = ->

  # Setup scene, camera, renderer
  [scene, camera, renderer] = setup()

  # TODO get other half of axes,
  # otherwise write buildAxes() with an Object3D in utils
  axisLen = 500
  axisHelper = new THREE.AxisHelper(axisLen)
  scene.add axisHelper

  # Vector with arrow
  vectorColor = 0xCC0099
  arrowLen = 0
  arrowHead = 50
  direction = new THREE.Vector3(1, 0, 0)
  vectorArrow = new THREE.ArrowHelper(direction, origin, arrowLen, vectorColor, arrowHead, arrowHead)
  scene.add vectorArrow

  # Grid
  gridSize = 800
  gridStep = gridSize / 10
  gridColor = 0x666699
  buildGrids scene, gridSize, gridStep, gridColor

  #do buildAxes

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
