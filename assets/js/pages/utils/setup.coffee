# Set up the basic necessities: scene, camera, renderer

# General constants
width = 500
height = 500
origin = new THREE.Vector3(0, 0, 0)

buildScene = ->
  return new THREE.Scene()

buildCamera = ->
  angle = 45
  aspect = width / height
  near = 1
  far = 10000
  x = 500
  y = 300
  z = 500
  camera = new THREE.PerspectiveCamera(angle, aspect, near, far)
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

