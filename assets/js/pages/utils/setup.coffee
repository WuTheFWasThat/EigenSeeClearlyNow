# Set up the basic necessities: scene, camera, renderer

# General constants
origin = new THREE.Vector3(0, 0, 0)

# Sets up default scene, camera, and renderer
class View
  constructor: (canvas, options) ->
    options = options or {}

    options.cameraDistance = options.cameraDistance or 200
    # Default scene
    buildScene = ->
      return new THREE.Scene()

    # angles in degrees
    theta = 45 # polar angle
    phi = 30 # azimuthal angle

    # Default orthographic camera
    buildCamera = ->
      width = 500
      height = 500

      frustumWidth = width / 2
      frustumHeight = height / 2

      near = -1000
      far = 1000

      x = (Math.cos (Math.PI * phi / 180)) * (Math.sin (Math.PI * theta / 180))
      y = Math.sin (Math.PI * phi / 180)
      z = (Math.cos (Math.PI * phi / 180)) * (Math.cos (Math.PI * theta / 180))

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

    @scene = buildScene()
    @camera = buildCamera()
    @renderer = buildRenderer(canvas)

    #console.log scene.position
    #camera.lookAt(scene.position)
    #console.log camera.position

  render: ->
    @renderer.render @scene, @camera


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

