# Set up the basic necessities: scene, camera, renderer

# General constants
origin = new THREE.Vector3(0, 0, 0)

# Sets up default scene, camera, and renderer
class View
  constructor: (canvas, options) ->
    @canvas = canvas
    options = options or {}

    options.bindMouseWheel = if options.bindMouseWheel? then options.bindMouseWheel else true
    if options.bindMouseWheel
      do @bindMouseWheel

    #######################
    # SCENE
    #######################

    @scene = new THREE.Scene()

    #######################
    # CAMERA
    #######################

    @width = options.width or DEFAULT.CAMERA.WIDTH
    @height = options.height or DEFAULT.CAMERA.HEIGHT
    @zoomlevel = 0

    @camera = new THREE.OrthographicCamera()
    do @zoomCamera

    # angles in degrees
    @theta = 45 # polar angle
    @phi = 30 # azimuthal angle

    do @positionCamera

    #######################
    # CAMERA
    #######################

    backgroundColor = options.backgroundColor or DEFAULT.BACKGROUND.COLOR

    # Default renderer uses antialiasing and uses WebGL if possible (for faster rendering)
    @renderer = new THREE.Renderer({canvas: @canvas[0], antialias: true})
    @renderer.setSize @canvas.width(), @canvas.height()
    @renderer.setClearColor backgroundColor

    #console.log scene.position
    #camera.lookAt(scene.position)
    #console.log camera.position

  render: ->
    @renderer.render @scene, @camera

  zoomCamera: ->
    zoomFactor = Math.pow(2, @zoomlevel)
    frustumWidth = @width * zoomFactor / 2
    frustumHeight = @height * zoomFactor / 2

    near = -@width * 2 * zoomFactor
    far =  @width * 2 * zoomFactor
    @camera.left = -frustumWidth
    @camera.right = frustumWidth
    @camera.top = frustumHeight
    @camera.bottom = - frustumHeight
    @camera.near = near
    @camera.far = far
    do @camera.updateProjectionMatrix

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

  bindMouseWheel: (wheelspeed) ->
    wheelspeed = wheelspeed or 1000
    @canvas.bind 'mousewheel', (e) =>
      change = e.originalEvent.wheelDelta / wheelspeed
      @zoomlevel -= change
      do @zoomCamera
      do e.preventDefault
      return false

  # Changes vector based on user input
  animate: ->
    requestAnimationFrame @animate.bind(this)
    do @render

