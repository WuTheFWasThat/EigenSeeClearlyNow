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
  cameraXPos = -1600
  cameraYPos = 600
  cameraZPos = 1200
  camera = new THREE.PerspectiveCamera(45, width / height, 1, 10000)
  camera.position.set cameraXPos, cameraYPos, cameraZPos
  camera.lookAt origin

  # Axes
  # TODO get other half of axes,
  # otherwise write buildAxes() with an Object3D in utils
  axisLen = 800
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
  gridStep = 50
  gridColor = 0x0033CC
  buildGrids scene, gridSize, gridStep, gridColor

  #do buildAxes

  # Cube
  boxLen = 100
  geometry = new THREE.BoxGeometry(boxLen, boxLen, boxLen)
  material = new THREE.MeshBasicMaterial(
    color: 0x0000ff
    wireframe: true
  )
  mesh = new THREE.Mesh(geometry, material)
  scene.add mesh
  canvas = $("#mainCanvas")

  # Renderer
  rendererColor = 0x000066
  renderer = new THREE.Renderer(canvas: canvas[0])
  renderer.setSize width, height
  renderer.setClearColorHex rendererColor

  animate = ->
    requestAnimationFrame animate
    mesh.rotation.x += 0.01
    mesh.rotation.y += 0.02
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
