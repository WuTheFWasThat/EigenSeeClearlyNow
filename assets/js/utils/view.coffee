# Set up the basic necessities: scene, camera, renderer

# General constants
origin = new THREE.Vector3(0, 0, 0)

# Sets up default scene, camera, and renderer
class View
  constructor: (canvas, options) ->
    options = options or {}

    options.cameraDistance = options.cameraDistance or 200

    #######################
    # SCENE
    #######################

    @scene = new THREE.Scene()

    #######################
    # CAMERA
    #######################

    width = options.width or 500
    height = options.height or 500

    frustumWidth = width / 2
    frustumHeight = height / 2

    near = -1000
    far = 1000

    @camera = new THREE.OrthographicCamera(-frustumWidth, frustumWidth, frustumHeight, -frustumHeight, near, far)

    # angles in degrees
    @theta = 45 # polar angle
    @phi = 30 # azimuthal angle

    do @positionCamera

    #######################
    # CAMERA
    #######################

    backgroundColor = options.backgroundColor or DEFAULT.BACKGROUND.COLOR

    # Default renderer uses antialiasing and uses WebGL if possible (for faster rendering)
    @renderer = new THREE.Renderer({canvas: canvas[0], antialias: true})
    @renderer.setSize canvas.width(), canvas.height()
    @renderer.setClearColor backgroundColor

    #console.log scene.position
    #camera.lookAt(scene.position)
    #console.log camera.position

  render: ->
    @renderer.render @scene, @camera

  positionCamera: ->
    x = (Math.cos (Math.PI * @phi / 180)) * (Math.sin (Math.PI * @theta / 180))
    y = Math.sin (Math.PI * @phi / 180)
    z = (Math.cos (Math.PI * @phi / 180)) * (Math.cos (Math.PI * @theta / 180))
    @camera.position.set x, y, z
    @camera.lookAt origin

  rotate: (dtheta, dphi) ->
    @theta += dtheta
    @phi += dphi

    # normalize
    @theta = @theta % 360
    # limit
    @phi = Math.min @phi, 90
    @phi = Math.max @phi, -90

    do @positionCamera

  addAxes: (options) ->
    buildAxes @scene, options

    # TODO use grids or not?
    gridLen = 200
    gridStep = gridLen / 10
    gridColor = DEFAULT.GRID.COLOR
    buildGrids @scene, gridLen, gridStep, gridColor
    return

  addVector: (vector) ->
    vector.draw_on @scene
    return vector

  # Changes vector based on user input
  animate: ->
    requestAnimationFrame @animate.bind(this)
    do @render

