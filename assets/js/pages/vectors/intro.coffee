# From the three.js github example
init = ->

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
  # TODO get different colors and other half of axes,
  # otherwise write a buildAxes() function in utils
  axisLen = 800
  axisHelper = new THREE.AxisHelper(axisLen)
  scene.add axisHelper

  # Vector with arrow
  vectorColor = 0xCC0099
  arrowLen = 400
  arrowHead = 20
  arrow = new THREE.Vector3(1, 0, 1)
  vectorArrow = new THREE.ArrowHelper(arrow, origin, arrowLen, vectorColor, arrowHead, arrowHead)
  scene.add vectorArrow

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
    return

  return do animate
