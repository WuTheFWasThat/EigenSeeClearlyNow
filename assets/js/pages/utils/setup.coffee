# Set up the basic necessities: scene, camera, renderer

# General constants
width = 500
height = 500
origin = new THREE.Vector3(0, 0, 0)

buildScene = ->
  return new THREE.Scene()

buildCamera = ->
  angle = 45
  frustumScaleFactor = 2
  frustumWidth = width / frustumScaleFactor
  frustumHeight = height / frustumScaleFactor
  near = -1000
  far = 1000
  x = 100
  y = 70
  z = 100
  camera = new THREE.OrthographicCamera(-frustumWidth, frustumWidth, frustumHeight,-frustumHeight, near, far)
  camera.position.set x, y, z
  camera.lookAt origin
  return camera

buildRenderer = ->
  canvas = $("#mainCanvas")
  color = 0x000066
  renderer = new THREE.Renderer({canvas: canvas[0], antialias: true})
  renderer.setSize width, height
  renderer.setClearColor color
  return renderer

setup = ->
  scene = buildScene()
  camera = buildCamera()
  renderer = buildRenderer()
  return [scene, camera, renderer]

