# Span Game: Reach a point
INIT['vector_spaces-span_game'] = ->

  canvas = $("#canvas")
  view = new View(canvas)

  vectorOptions = (
    lineWidth: 2
    headWidth: 6
    headLength: 10
  )

  # Setup a vector hooked up to a scalar input slider
  setupScalingVector = (sliderName, vector) ->
    coefficient = new ReactiveConstant().setFromSliderInput(sliderName)
    scaledVector = coefficient.times new ReactiveVector().set_vector vector
    vector = new VectorView(vectorOptions)
    vector.set_reactive_trajectory scaledVector
    vector.set_color coefficient.color
    return [coefficient, vector, scaledVector]

  # Get a random coefficient value within the slider input values
  getRandomCoefficientValue = (sliderInputName) ->
    input = $('#' + sliderInputName + ' .slider-input')
    min = parseInt input.attr 'min'
    max = parseInt input.attr 'max'
    return Number.randInt min, max

  getRandomCoordinateValue = (maxabs) ->
    minabs = Math.floor(maxabs / 2)
    coordValue = Number.randInt minabs, maxabs
    if Math.round(Math.random()) == 0
      coordValue = -coordValue
    return coordValue

  # Get a THREE vector with a random set of coordinates
  # scaled down by the given scale factor
  getRandomVector = (sliderInputName) ->
    input = $('#' + sliderInputName + ' .slider-input')
    min_coefficient = parseInt input.attr 'min'
    max_coefficient = parseInt input.attr 'max'
    max_coefficient_abs = Math.max Math.abs(min_coefficient), Math.abs(max_coefficient), 1

    # max absolute value for vector coordinates, based on axis length divided by max coefficient
    max_abs = Math.floor(DEFAULT.AXIS.LENGTH / (max_coefficient_abs * 2))

    # Get random coordinate values, but vector should be nonzero
    x = getRandomCoordinateValue max_abs
    y = getRandomCoordinateValue max_abs
    z = getRandomCoordinateValue max_abs
    return new THREE.Vector3(x, y, z)

  # Create the initial three vectors and make them reactive to their scalar input sliders
  u_coefficient = getRandomCoefficientValue 'coefficient1'
  vectorU = getRandomVector 'coefficient1'
  [constantU, vectorViewU, reactiveVectorU] = setupScalingVector('coefficient1', vectorU)

  v_coefficient = getRandomCoefficientValue 'coefficient2'
  vectorV = getRandomVector 'coefficient2'
  [constantV, vectorViewV, reactiveVectorV] = setupScalingVector('coefficient2', vectorV)

  w_coefficient = getRandomCoefficientValue 'coefficient3'
  vectorW = getRandomVector 'coefficient3'
  [constantW, vectorViewW, reactiveVectorW] = setupScalingVector('coefficient3', vectorW)

  # Create the sum of the scaled vectors
  reactiveVectorSum = new ReactiveVector().sum reactiveVectorU, reactiveVectorV, reactiveVectorW
  vectorViewSum = new VectorView(vectorOptions)
                  .set_reactive_trajectory reactiveVectorSum
                  .set_color COLORS.GRAY
                  .set_line_width 4
                  .set_head_width 12

  # Add all vectors to the view
  view.add vectorViewU, vectorViewV, vectorViewW, vectorViewSum

  # Create a point sphere at the given coordinates
  createPoint = (x, y, z, color) ->
    sphereGeometry = new THREE.SphereGeometry( 5, 20, 20 )
    sphereMaterial = new THREE.MeshBasicMaterial( {color: color} )
    sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)
    sphere.position.set x, y, z
    return sphere

  # Calculate the answer vector by summing the scaled vectors
  calculateTargetVector = () ->
    scaledVectorU = vectorU.clone().multiplyScalar(u_coefficient)
    scaledVectorV = vectorV.clone().multiplyScalar(v_coefficient)
    scaledVectorW = vectorW.clone().multiplyScalar(w_coefficient)
    targetVector = scaledVectorU.add(scaledVectorV).add(scaledVectorW)
    return targetVector

  # The target point to reach (based on the coefficients above)
  targetVector = do calculateTargetVector
  targetPoint = createPoint(targetVector.x, targetVector.y, targetVector.z, COLORS.GRAY)
  view.add targetPoint

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
  #   vec2latexAligned(vectorU),
  #   vec2latexAligned(vectorV),
  #   vec2latexAligned(vectorW)
  # )
  # $('#vectorsEquations').text vectorsEquation

  $('#uEquation').text('$\\vec{u} = %s$'.format(vec2latex(vectorU)))
  $('#vEquation').text('$\\vec{v} = %s$'.format(vec2latex(vectorV)))
  $('#wEquation').text('$\\vec{w} = %s$'.format(vec2latex(vectorW)))

  reactiveVectorSum.on 'change', (x, y, z) ->
    curEquation = '$$\\begin{align}
    & c_u \\cdot \\vec{u} + c_v \\cdot \\vec{v} + c_w \\cdot \\vec{w} \\\\
    = \\quad & %s \\cdot %s + %s \\cdot %s + %s \\cdot %s \\\\
    = \\quad & %s
    \\end{align}$$'.format(
      constantU.get()
      vec2latex(vectorU)
      constantV.get()
      vec2latex(vectorV)
      constantW.get()
      vec2latex(vectorW)
      vec2latex({x: x, y: y, z:z})
    )

    $('#curEquation').text(curEquation)
    MathJax.Hub.Queue ['Typeset', MathJax.Hub]
    if x == targetVector.x and y == targetVector.y and z == targetVector.z
      vectorViewSum.set_color COLORS.LIGHT_YELLOW
      targetPoint.material.setValues(color: COLORS.LIGHT_YELLOW)
      $('#curEquationContainer').removeClass 'incorrect'
                                .addClass 'correct'
    else
      vectorViewSum.set_color COLORS.GRAY
      targetPoint.material.setValues(color: COLORS.GRAY)
      $('#curEquationContainer').removeClass 'correct'
                                .addClass 'incorrect'

  # console.log the answer hehehehehe
  console.log u_coefficient, v_coefficient, w_coefficient
  do reactiveVectorSum.change

  MathJax.Hub.Queue ['Typeset', MathJax.Hub]

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate

