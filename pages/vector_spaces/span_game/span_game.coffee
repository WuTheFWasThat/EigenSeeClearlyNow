# Span Game: Reach a point
INIT['vector_spaces-span_game'] = ->

  canvas = $("#canvas")
  view = new View(canvas)

  vectorOptions = (
    lineWidth: 4
    headWidth: 12
    headLength: 10
  )


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
  a_scalar = 3
  a_x = 5
  a_y = 10
  a_z = -15
  vectorA = new THREE.Vector3(a_x, a_y, a_z)
  [vectorViewA, reactiveVectorA] = setupScalingVector('coefficient1', vectorA)

  b_scalar = -2
  b_x = 12
  b_y = 4
  b_z = 20
  vectorB = new THREE.Vector3(b_x, b_y, b_z)
  [vectorViewB, reactiveVectorB] = setupScalingVector('coefficient2', vectorB)

  c_scalar = 1
  c_x = 26
  c_y = 40
  c_z = -10
  vectorC = new THREE.Vector3(c_x, c_y, c_z)
  [vectorViewC, reactiveVectorC] = setupScalingVector('coefficient3', vectorC)

  reactiveVectorSum = new ReactiveVector().sum reactiveVectorA, reactiveVectorB, reactiveVectorC
  vectorViewSum = new VectorView(vectorOptions)
                  .set_reactive_trajectory reactiveVectorSum
                  .set_color COLORS.GRAY

  view.add vectorViewA, vectorViewB, vectorViewC, vectorViewSum

  # Create a point sphere at the given coordinates
  createPoint = (x, y, z, color) ->
    sphereGeometry = new THREE.SphereGeometry( 5, 20, 20 )
    sphereMaterial = new THREE.MeshBasicMaterial( {color: color} )
    sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)
    sphere.position.set x, y, z
    return sphere

  # Calculate the answer vector by summing the scaled vectors
  calculateAnswerVector = () ->
    scaledVectorA = vectorA.clone().multiplyScalar(a_scalar)
    scaledVectorB = vectorB.clone().multiplyScalar(b_scalar)
    scaledVectorC = vectorC.clone().multiplyScalar(c_scalar)
    answerVector = scaledVectorA.add(scaledVectorB).add(scaledVectorC)
    return answerVector

  # The target point to reach
  answerVector = do calculateAnswerVector
  point = createPoint(answerVector.x, answerVector.y, answerVector.z, COLORS.GRAY)
  view.add point

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate

