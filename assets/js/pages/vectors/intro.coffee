# From the three.js github example
init_vector_intro = ->

  # Scene
  scene = buildScene()

  # Camera
  camera = buildCamera()

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

  # Renderer
  renderer = buildRenderer()

  # Changes vector based on user input
  animate = ->
    requestAnimationFrame animate
    renderer.render scene, camera

    vectorXDir = parseInt $('#sliderX').val()
    vectorYDir = parseInt $('#sliderY').val()
    vectorZDir = parseInt $('#sliderZ').val()

    length = Math.sqrt( Math.pow(vectorXDir, 2) + Math.pow(vectorYDir, 2) + Math.pow(vectorZDir, 2))
    # console.log vectorXDir, vectorYDir, vectorZDir, length
    vectorArrow.setLength length
    vectorArrow.setDirection new THREE.Vector3(vectorXDir, vectorYDir, vectorZDir)

    return


  return do animate

