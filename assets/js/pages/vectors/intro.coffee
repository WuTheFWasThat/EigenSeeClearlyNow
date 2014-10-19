# From the three.js github example
init = ->

  pageSelector = '#vectors-intro'

  # Constants
  width = 500
  height = 500
  origin = new THREE.Vector3(0, 0, 0)

  # Scene
  scene = new THREE.Scene()

  # Camera
  cameraAngle = 45
  cameraNear = 1
  cameraFar = 10000
  cameraXPos = 500
  cameraYPos = 500
  cameraZPos = 500
  camera = new THREE.PerspectiveCamera(cameraAngle, width / height, cameraNear, cameraFar)
  camera.position.set cameraXPos, cameraYPos, cameraZPos
  camera.lookAt origin

  # Axes
  # TODO get other half of axes,
  # otherwise write buildAxes() with an Object3D in utils
  axisLen = 500
  axisHelper = new THREE.AxisHelper(axisLen)
  scene.add axisHelper

  # Vector with arrow
  vectorColor = 0xCC0099
  arrowLen = 0
  arrowHead = 20
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
  canvas = $("#mainCanvas")
  rendererColor = 0x000066
  renderer = new THREE.Renderer({canvas: canvas[0], antialias: true})
  renderer.setSize width, height
  renderer.setClearColor rendererColor

  # Changes vector based on user input
  animate = ->
    requestAnimationFrame animate
    renderer.render scene, camera

    vectorXDir = parseInt $(pageSelector + ' .sliderX').val()
    vectorYDir = parseInt $(pageSelector + ' .sliderY').val()
    vectorZDir = parseInt $(pageSelector + ' .sliderZ').val()

    length = Math.sqrt( Math.pow(vectorXDir, 2) + Math.pow(vectorYDir, 2) + Math.pow(vectorZDir, 2))
    # console.log vectorXDir, vectorYDir, vectorZDir, length
    vectorArrow.setLength length
    vectorArrow.setDirection new THREE.Vector3(vectorXDir, vectorYDir, vectorZDir)

    return


  return do animate
