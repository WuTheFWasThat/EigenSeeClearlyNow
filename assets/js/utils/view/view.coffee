# Set up the basic necessities: scene, camera, renderer


# Sets up default scene, camera, and renderer
class View
  constructor: (canvas, options) ->
    @canvas = canvas
    options = options or {}

    #######################
    # SCENE
    #######################

    @scene = new THREE.Scene()

    #######################
    # CAMERA
    #######################

    @width = options.width or DEFAULT.CAMERA.WIDTH
    @height = options.height or DEFAULT.CAMERA.HEIGHT
    @zoomLevel = 0

    @camera = new THREE.OrthographicCamera()
    do @zoomCamera

    # angles in degrees
    @theta = 45 # polar angle
    @phi = 30 # azimuthal angle

    do @positionCamera

    #######################
    # MAIN SCENE
    #######################

    backgroundColor = options.backgroundColor or DEFAULT.BACKGROUND.COLOR

    options.square = if options.square? then options.square else true

    # Default renderer uses antialiasing and uses WebGL if possible (for faster rendering)
    @renderer = new THREE.Renderer({canvas: @canvas[0], antialias: true})
    @renderer.setClearColor backgroundColor
    do @resize

    if options.square
        $(window).resize =>
            @canvas.height(@canvas.width())
            do @resize
        $(window).resize()

    #######################
    # AXES AND GRID
    #######################

    options.axes = if options.axes? then options.axes else true
    if options.axes
      @addAxes options.axesOptions

    #console.log scene.position
    #camera.lookAt(scene.position)
    #console.log camera.position

  resize: ->
    @renderer.setSize @canvas.width(), @canvas.height(), false

  render: ->
    @renderer.render @scene, @camera

  zoomCamera: ->
    zoomFactor = Math.pow(2, @zoomLevel)
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
    @camera.lookAt ORIGIN

  rotate: (dtheta, dphi) ->
    @theta += dtheta
    @phi += dphi

    # normalize
    @theta = @theta % 360
    # limit
    @phi = Math.min @phi, 90
    @phi = Math.max @phi, 0

    do @positionCamera

  addAxes: (options) ->
    @axes = new Axes(options)
    @axes.drawOn @
    return

  addVector: (vector) ->
    vector.draw_on @scene
    return vector

  add: (object) ->
    @scene.add object

  zoom: (zoomChange) ->
      @zoomLevel += zoomChange
      @zoomLevel = Math.max(@zoomLevel, -5)
      @zoomLevel = Math.min(@zoomLevel, 5)
      do @zoomCamera

  # Changes vector based on user input
  animate: ->
    requestAnimationFrame @animate.bind(this)
    do @render

