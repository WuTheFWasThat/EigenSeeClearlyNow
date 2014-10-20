# Set up the basic necessities: scene, camera, renderer

# General constants
origin = new THREE.Vector3(0, 0, 0)

# Default scene
buildScene = ->
  return new THREE.Scene()

# Default orthographic camera
# points at the origin from (100, 70, 100)
buildCamera = ->
  width = 500
  height = 500
  angle = 45
  frustumScaleFactor = 2
  frustumWidth = width / frustumScaleFactor
  frustumHeight = height / frustumScaleFactor
  near = -1000
  far = 1000
  x = 100
  y = 70
  z = 100
  camera = new THREE.OrthographicCamera(-frustumWidth, frustumWidth, frustumHeight, -frustumHeight, near, far)
  camera.position.set x, y, z
  camera.lookAt origin
  return camera

# Default renderer uses antialiasing
# and uses WebGL if possible (for faster rendering)
buildRenderer = (canvas) ->
  color = 0x000066
  renderer = new THREE.Renderer({canvas: canvas[0], antialias: true})
  renderer.setSize canvas.width(), canvas.height()
  renderer.setClearColor color
  return renderer

# Sets up default scene, camera, and renderer
setupView = (canvas) ->
  scene = buildScene()
  camera = buildCamera()
  renderer = buildRenderer(canvas)
  return [scene, camera, renderer]

# Sets up default axes and grid
setupAxes = (scene) ->
  # TODO build our own axes wrapped in an Object3D
  axisLen = 300
  axes = new THREE.AxisHelper(axisLen)
  scene.add axes

  # TODO use grids or not?
  gridLen = axisLen
  gridStep = gridLen / 10
  gridColor = 0x3D3D5C
  buildGrids scene, gridLen, gridStep, gridColor
  return



