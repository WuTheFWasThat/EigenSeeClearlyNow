# Span Game: Reach a point
INIT['vector_spaces-span_game'] = ->

  canvas = $("#canvas")
  view = new View(canvas)

  vectorOptions = (
    lineWidth: 4
    headWidth: 12
    headLength: 10
  )

  # Create a point sphere at the given coordinates
  createPoint = (x, y, z, color) ->
    sphereGeometry = new THREE.SphereGeometry( 5, 20, 20 )
    sphereMaterial = new THREE.MeshBasicMaterial( {color: color} )
    sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)
    sphere.position.set x, y, z
    return sphere

  # The target point to reach
  # TODO randomize
  point = createPoint(50, 62, -45, COLORS.GRAY)
  view.add point

  # Setup a vector hooked up to a scalar input slider
  setupScalingVector = (sliderName, vector) ->
    sliderInput = new ReactiveConstant().setFromSliderInput(sliderName)
    scaledVector = sliderInput.times new ReactiveVector().set_vector vector
    vector = new VectorView(vectorOptions)
    vector.set_reactive_trajectory scaledVector
    vector.set_color sliderInput.color
    return [vector, scaledVector]

  # The three vectors and their scalar input sliders
  # TODO change these initial coordinates
  a_x = 10
  a_y = 60
  a_z = 5
  [vectorViewA, vectorA] = setupScalingVector('coefficient1', new THREE.Vector3(a_x, a_y, a_z))

  b_x = Math.floor((Math.random() - 0.5) * 60)
  b_y = 30
  b_z = 15
  [vectorViewB, vectorB] = setupScalingVector('coefficient2', new THREE.Vector3(b_x, b_y, b_z))

  c_x = Math.floor((Math.random() - 0.5) * 60)
  c_y = -10
  c_z = 50
  [vectorViewC, vectorC] = setupScalingVector('coefficient3', new THREE.Vector3(c_x, c_y, c_z))

  vectorSum = new ReactiveVector().sum vectorA, vectorB, vectorC
  vectorViewSum = new VectorView(vectorOptions)
                  .set_reactive_trajectory vectorSum
                  .set_color COLORS.GRAY

  view.add vectorViewA, vectorViewB, vectorViewC, vectorViewSum

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate

