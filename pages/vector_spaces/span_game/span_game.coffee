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
  setupScalingVector = (sliderId) ->
    coefficient = new ReactiveConstant().setFromSliderInput(sliderId)
    basis = new ReactiveVector()
    scaledBasis = coefficient.times basis
    scaledBasisView = new VectorView(vectorOptions)
    scaledBasisView.set_reactive_trajectory scaledBasis
    scaledBasisView.set_color coefficient.color
    return [coefficient, basis, scaledBasis, scaledBasisView]

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

  # Create a point sphere at the given coordinates
  createPoint = () ->
    radius = 5
    widthSegments = 32
    heightSegments = 32
    sphereGeometry = new THREE.SphereGeometry( radius, widthSegments, heightSegments )
    sphereMaterial = new THREE.MeshBasicMaterial()
    sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)
    return sphere

  # Create the initial three vectors and make them reactive to their scalar input sliders
  [constantU, basisU, scaledU, viewU] = setupScalingVector('coefficient1')
  [constantV, basisV, scaledV, viewV] = setupScalingVector('coefficient2')
  [constantW, basisW, scaledW, viewW] = setupScalingVector('coefficient3')

  # Create the sum of the scaled vectors
  reactiveVectorSum = new ReactiveVector().sum scaledU, scaledV, scaledW

  # The target point to reach
  targetVector = new THREE.Vector3()

  reactiveVectorSum.on 'change', (x, y, z) ->
    curEquation = '$$\\begin{align}
    & c_u \\cdot \\vec{u} + c_v \\cdot \\vec{v} + c_w \\cdot \\vec{w} \\\\
    = \\quad & %s \\cdot %s + %s \\cdot %s + %s \\cdot %s \\\\
    = \\quad & %s
    \\end{align}$$'.format(
      constantU.get()
      vec2latex(basisU.vector)
      constantV.get()
      vec2latex(basisV.vector)
      constantW.get()
      vec2latex(basisW.vector)
      vec2latex({x: x, y: y, z:z})
    )

    $('#curEquation').text(curEquation)
    MathJax.Hub.Queue ['Typeset', MathJax.Hub]
    if x == targetVector.x and y == targetVector.y and z == targetVector.z
      viewSum.set_color COLORS.LIGHT_YELLOW
      targetPoint.material.setValues(color: COLORS.LIGHT_YELLOW)
      $('#curEquationContainer').removeClass 'incorrect'
                                .addClass 'correct'
    else
      viewSum.set_color COLORS.GRAY
      targetPoint.material.setValues(color: COLORS.GRAY)
      $('#curEquationContainer').removeClass 'correct'
                                .addClass 'incorrect'

  viewSum = new VectorView(vectorOptions)
                  .set_reactive_trajectory reactiveVectorSum
                  .set_line_width 4
                  .set_head_width 12

  targetPoint = do createPoint

  # Add everything to the view
  view.add viewU, viewV, viewW, viewSum, targetPoint

  u_coefficient = getRandomCoefficientValue 'coefficient1'
  basisU.set_vector getRandomVector 'coefficient1'

  v_coefficient = getRandomCoefficientValue 'coefficient2'
  basisV.set_vector getRandomVector 'coefficient2'

  w_coefficient = getRandomCoefficientValue 'coefficient3'
  basisW.set_vector getRandomVector 'coefficient3'

  calculateTargetVector = () ->
    scaledAnswerU = basisU.vector.clone().multiplyScalar(u_coefficient)
    scaledAnswerV = basisV.vector.clone().multiplyScalar(v_coefficient)
    scaledAnswerW = basisW.vector.clone().multiplyScalar(w_coefficient)
    targetVector = new THREE.Vector3().add(scaledAnswerU).add(scaledAnswerV).add(scaledAnswerW)
    return targetVector

  targetVector = do calculateTargetVector
  targetPoint.position.set targetVector.x, targetVector.y, targetVector.z

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

  $('#uEquation').text('$\\vec{u} = %s$'.format(vec2latex(basisU.vector)))
  $('#vEquation').text('$\\vec{v} = %s$'.format(vec2latex(basisV.vector)))
  $('#wEquation').text('$\\vec{w} = %s$'.format(vec2latex(basisW.vector)))
  MathJax.Hub.Queue ['Typeset', MathJax.Hub]

  # console.log the answer hehehehehe
  console.log u_coefficient, v_coefficient, w_coefficient
  do reactiveVectorSum.change

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate

