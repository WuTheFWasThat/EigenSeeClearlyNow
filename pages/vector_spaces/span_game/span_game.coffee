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
    scalar = new ReactiveConstant().setFromSliderInput(sliderName)
    scaledVector = scalar.times new ReactiveVector().set_vector vector
    vector = new VectorView(vectorOptions)
    vector.set_reactive_trajectory scaledVector
    vector.set_color scalar.color
    return [scalar, vector, scaledVector]

  # Get a random scalar value within the slider input values
  getRandomScalarValue = (sliderInputName) ->
    input = $('#' + sliderInputName + ' .slider-input')
    min = parseInt input.attr 'min'
    max = parseInt input.attr 'max'
    range = max - min
    scalarValue = Math.floor(min + Math.random() * (range + 1))
    return scalarValue

  # Get a random coordinate value within the axis length
  # scaled down by the given scale factor
  getRandomCoordValue = (scaleFactor) ->
    if (scaleFactor == 0)
      scaleFactor = 1
    min = 5
    axisLenBuffer = 100  # buffer to stay within reasonable viewing bounds
    max = Math.floor((DEFAULT.AXIS.LENGTH - axisLenBuffer) / Math.abs(scaleFactor))
    range = max - min
    coordValue = Math.floor(min + Math.random() * (range + 1))
    if (Math.round(Math.random()) == 0)
      coordValue = -coordValue
    return coordValue

  # Get a THREE vector with a random set of coordinates
  # scaled down by the given scale factor
  getRandomVector = (scaleFactor) ->
    x = getRandomCoordValue scaleFactor
    y = getRandomCoordValue scaleFactor
    z = getRandomCoordValue scaleFactor
    return new THREE.Vector3(x, y, z)

  # Create the initial three vectors and make them reactive to their scalar input sliders
  a_scalar = getRandomScalarValue 'coefficient1'
  vectorA = getRandomVector a_scalar
  [constantA, vectorViewA, reactiveVectorA] = setupScalingVector('coefficient1', vectorA)

  b_scalar = getRandomScalarValue 'coefficient2'
  vectorB = getRandomVector b_scalar
  [constantB, vectorViewB, reactiveVectorB] = setupScalingVector('coefficient2', vectorB)

  c_scalar = getRandomScalarValue 'coefficient1'
  vectorC = getRandomVector c_scalar
  [constantC, vectorViewC, reactiveVectorC] = setupScalingVector('coefficient3', vectorC)

  # Create the sum of the scaled vectors
  reactiveVectorSum = new ReactiveVector().sum reactiveVectorA, reactiveVectorB, reactiveVectorC
  vectorViewSum = new VectorView(vectorOptions)
                  .set_reactive_trajectory reactiveVectorSum
                  .set_color COLORS.GRAY

  # Add all vectors to the view
  view.add vectorViewA, vectorViewB, vectorViewC, vectorViewSum

  # Create a point sphere at the given coordinates
  createPoint = (x, y, z, color) ->
    sphereGeometry = new THREE.SphereGeometry( 5, 20, 20 )
    sphereMaterial = new THREE.MeshBasicMaterial( {color: color} )
    sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)
    sphere.position.set x, y, z
    return sphere

  # Calculate the answer vector by summing the scaled vectors
  calculateTargetVector = () ->
    scaledVectorA = vectorA.clone().multiplyScalar(a_scalar)
    scaledVectorB = vectorB.clone().multiplyScalar(b_scalar)
    scaledVectorC = vectorC.clone().multiplyScalar(c_scalar)
    targetVector = scaledVectorA.add(scaledVectorB).add(scaledVectorC)
    return targetVector

  # The target point to reach (based on the scalars above)
  targetVector = do calculateTargetVector
  point = createPoint(targetVector.x, targetVector.y, targetVector.z, COLORS.GRAY)
  view.add point

  vec2latex = (vector) ->
    return '(' + vector.x + ' , ' + vector.y + ' , ' + vector.z + ')'

  vec2latexAligned = (vector) ->
    return '& (\\,' + vector.x + ' && , \\,' + vector.y + ' && , \\,' + vector.z + ' & )'
    # this one works well in texshop...
    # return '&& ( && ' + vector.x + ' && , && ' + vector.y + ' && , && ' + vector.z + ' & )'
    # return '& (\\qquad' + vector.x + ' && , \\qquad' + vector.y + ' && , \\qquad' + vector.z + ' & )'


  $('#targetEquation').text('$\\vec{t} = %s$'.format(vec2latex(targetVector)))

  # vectorsEquation = '$$\\begin{alignat}{2}
  #   \\vec{u} = %s \\\\
  #   \\vec{v} = %s \\\\
  #   \\vec{w} = %s \\\\
  # \\end{alignat}
  # $$'.format(
  #   vec2latexAligned(vectorA),
  #   vec2latexAligned(vectorB),
  #   vec2latexAligned(vectorC)
  # )
  # $('#vectorsEquations').text vectorsEquation

  $('#uEquation').text('$\\vec{u} = %s$'.format(vec2latex(vectorA)))
  $('#vEquation').text('$\\vec{v} = %s$'.format(vec2latex(vectorB)))
  $('#wEquation').text('$\\vec{w} = %s$'.format(vec2latex(vectorC)))

  reactiveVectorSum.on 'change', (x, y, z) ->
    curEquation = '$$\\begin{align}
    & c_u \\cdot \\vec{u} + c_v \\cdot \\vec{v} + c_w \\cdot \\vec{w} \\\\
    = \\quad & %s \\cdot %s + %s \\cdot %s + %s \\cdot %s \\\\
    = \\quad & %s
    \\end{align}$$'.format(
      constantA.get()
      vec2latex(vectorA)
      constantB.get()
      vec2latex(vectorB)
      constantC.get()
      vec2latex(vectorC)
      vec2latex({x: x, y: y, z:z})
    )

    $('#curEquation').text(curEquation)
    MathJax.Hub.Queue ['Typeset', MathJax.Hub]
  do reactiveVectorSum.change

  MathJax.Hub.Queue ['Typeset', MathJax.Hub]

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate

