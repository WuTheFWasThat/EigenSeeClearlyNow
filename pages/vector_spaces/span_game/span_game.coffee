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
    coefficient = new ReactiveConstant().setFromInput(sliderId)
    basis = new ReactiveVector()
    scaledBasis = coefficient.times basis
    scaledBasisView = new VectorView(vectorOptions)
    scaledBasisView.setReactiveTrajectory scaledBasis
    scaledBasisView.setColor coefficient.color
    return [coefficient, basis, scaledBasis, scaledBasisView]

  # Get a random coefficient value within the slider input values
  getRandomCoefficientValue = (sliderInputName) ->
    input = $('#' + sliderInputName + ' .input')
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
    input = $('#' + sliderInputName + ' .input')
    minCoefficient = parseInt input.attr 'min'
    maxCoefficient = parseInt input.attr 'max'
    maxCoefficientAbs = Math.max Math.abs(minCoefficient), Math.abs(maxCoefficient), 1

    # max absolute value for vector coordinates, based on axis length divided by max coefficient
    maxAbs = Math.floor(DEFAULT.AXIS.LENGTH / (maxCoefficientAbs * 2))

    # Get random coordinate values, but vector should be nonzero
    x = getRandomCoordinateValue maxAbs
    y = getRandomCoordinateValue maxAbs
    z = getRandomCoordinateValue maxAbs
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
  [constantU, basisU, scaledU, viewU] = setupScalingVector('coefficientU')
  [constantV, basisV, scaledV, viewV] = setupScalingVector('coefficientV')
  [constantW, basisW, scaledW, viewW] = setupScalingVector('coefficientW')

  # Create the sum of the scaled vectors
  reactiveVectorSum = new ReactiveVector().sum scaledU, scaledV, scaledW

  # answer
  answerCoefficientU = new ReactiveConstant()
  answerCoefficientV = new ReactiveConstant()
  answerCoefficientW = new ReactiveConstant()
  targetVector = new ReactiveVector().sum(
                     answerCoefficientU.times(basisU),
                     answerCoefficientV.times(basisV),
                     answerCoefficientW.times(basisW))


  # The target point to reach
  reactiveVectorSum.on 'change', (vector) ->
    curEquation = '$$\\begin{align}
    & c_u \\cdot \\vec{u} + c_v \\cdot \\vec{v} + c_w \\cdot \\vec{w} \\\\\\\\\
    = \\quad & %s \\cdot %s + %s \\cdot %s + %s \\cdot %s \\\\\\\\
    = \\quad & %s
    \\end{align}$$'.format(
      constantU.get()
      vec2latex(basisU.vector)
      constantV.get()
      vec2latex(basisV.vector)
      constantW.get()
      vec2latex(basisW.vector)
      vec2latex(vector)
    )

    $('#curEquation').text(curEquation)
    MathJax.Hub.Queue ['Typeset', MathJax.Hub]
    if vector.equals targetVector.vector
      viewSum.setColor COLORS.LIGHT_YELLOW
      targetPoint.material.setValues(color: COLORS.LIGHT_YELLOW)
      $('#curEquationContainer').removeClass 'incorrect'
                                .addClass 'correct'
    else
      viewSum.setColor COLORS.WHITE
      targetPoint.material.setValues(color: COLORS.WHITE)
      $('#curEquationContainer').removeClass 'correct'
                                .addClass 'incorrect'

  viewSum = new VectorView(vectorOptions)
                  .setReactiveTrajectory reactiveVectorSum
                  .setLineWidth 4
                  .setHeadWidth 12

  targetPoint = do createPoint
  targetVector.on 'change', (vector) ->
      # this only happens once per game
      targetPoint.position.set vector.x, vector.y, vector.z
      $('#targetEquation').text('$\\vec{t} = %s$'.format(vec2latex(targetVector.vector)))
  do targetVector.change

  # Add everything to the view
  view.add viewU, viewV, viewW, viewSum, targetPoint


  initGame = () ->
    $('#coefficientU .input').val(0).change()
    answerCoefficientU.set getRandomCoefficientValue 'coefficientU'
    basisU.setVector getRandomVector 'coefficientU'

    $('#coefficientV .input').val(0).change()
    answerCoefficientV.set getRandomCoefficientValue 'coefficientV'
    basisV.setVector getRandomVector 'coefficientV'

    $('#coefficientW .input').val(0).change()
    answerCoefficientW.set getRandomCoefficientValue 'coefficientW'
    basisW.setVector getRandomVector 'coefficientW'

    $('#uEquation').text('$\\vec{u} = %s$'.format(vec2latex(basisU.vector)))
    $('#vEquation').text('$\\vec{v} = %s$'.format(vec2latex(basisV.vector)))
    $('#wEquation').text('$\\vec{w} = %s$'.format(vec2latex(basisW.vector)))
    MathJax.Hub.Queue ['Typeset', MathJax.Hub]

    # console.log the answer hehehehehe
    console.log 'answer:', answerCoefficientU.val, answerCoefficientV.val, answerCoefficientW.val

  do initGame
  $('#reset_game').click initGame

  $('#reveal_hint').click ->
    $('#hint').removeClass 'hidden'

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerView view

  mouseHandler = new MouseHandler()
  mouseHandler.registerView view

  # animate!
  do view.animate

