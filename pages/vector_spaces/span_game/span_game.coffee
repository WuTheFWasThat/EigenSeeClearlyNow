# Span Game: Reach a point
INIT['vector_spaces-span_game'] = ->

  canvas = $('#canvas')
  view = new View(canvas)

  # Get a random coefficient value within the slider input values
  getRandomCoefficientValue = (sliderInputName) ->
    input = $('#' + sliderInputName + ' .input')
    return Number.randInt parseInt(input.attr 'min'), parseInt(input.attr 'max')

  getRandomCoordinateValue = (maxlen) ->
    return Number.randInt -maxlen, maxlen

  # Get a THREE vector with a random set of coordinates
  # scaled down by the given scale factor
  getRandomBasisVector = (sliderInputName) ->
    input = $('#' + sliderInputName + ' .input')
    minCoefficient = parseInt input.attr 'min'
    maxCoefficient = parseInt input.attr 'max'
    maxCoefficientAbs = Math.max Math.abs(minCoefficient), Math.abs(maxCoefficient), 1

    # max absolute value for vector coordinates, based on axis length divided by max coefficient
    maxLength = Math.floor(DEFAULT.AXIS.LENGTH / maxCoefficientAbs)
    minLength = maxLength / 2

    # Get random coordinate values, but vector should be nonzero
    vector = new THREE.Vector3()
    while vector.length() < minLength or vector.length() > maxLength
      x = getRandomCoordinateValue maxLength
      y = getRandomCoordinateValue maxLength
      z = getRandomCoordinateValue maxLength
      vector.set x, y, z
    return vector

  getRandomBasisMatrix = (cU, cV, cW) ->
    vU = getRandomBasisVector cU
    vV = getRandomBasisVector cV
    vW = getRandomBasisVector cW
    return new THREE.Matrix3 vU.x, vU.y, vU.z, vV.x, vV.y, vV.z, vW.x, vW.y, vW.z

  # Create a point sphere at the given coordinates
  createPoint = () ->
    radius = 5
    widthSegments = 32
    heightSegments = 32
    sphereGeometry = new THREE.SphereGeometry( radius, widthSegments, heightSegments )
    sphereMaterial = new THREE.MeshBasicMaterial()
    sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)
    return sphere

  # Setup a vector hooked up to a scalar input slider
  setupScalingVector = (sliderId, basis) ->
    coefficient = new ReactiveConstant().setFromInput(sliderId)
    scaledBasis = coefficient.times basis
    scaledBasisView = new VectorView(trajectory: scaledBasis, color: coefficient.color, lineWidth: 2)
    return [coefficient, scaledBasis, scaledBasisView]

  basisMatrix = new ReactiveMatrix()
  [basisU, basisV, basisW] = do basisMatrix.getReactiveRows

  # Create the initial three vectors and make them reactive to their scalar input sliders
  [constantU, scaledU, viewU] = setupScalingVector 'coefficientU', basisU
  [constantV, scaledV, viewV] = setupScalingVector 'coefficientV', basisV
  [constantW, scaledW, viewW] = setupScalingVector 'coefficientW', basisW

  # Create the sum of the scaled vectors
  reactiveVectorSum = new ReactiveVector().sum scaledU, scaledV, scaledW

  # answer
  answer = new ReactiveVector()
  targetVector = basisMatrix.times answer

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
      $('#curEquationContainer').removeClass('incorrect').addClass('correct')
    else
      viewSum.setColor COLORS.WHITE
      targetPoint.material.setValues(color: COLORS.WHITE)
      $('#curEquationContainer').removeClass('correct').addClass('incorrect')

  viewSum = new VectorView(trajectory: reactiveVectorSum, lineWidth: 4)

  targetPoint = do createPoint
  targetVector.on 'change', (vector) ->
      # this only happens once per game
      targetPoint.position.set vector.x, vector.y, vector.z
      $('#targetEquation').text('$\\vec{t} = %s$'.format(vec2latex(targetVector.vector)))
  do targetVector.change

  # Add everything to the view
  view.add viewU, viewV, viewW, viewSum, targetPoint

  initGame = () ->
    answerVector = new THREE.Vector3( getRandomCoefficientValue('coefficientU'),
                                      getRandomCoefficientValue('coefficientV'),
                                      getRandomCoefficientValue('coefficientW'))
    # console.log the answer hehehehehe
    console.log 'answer:', answerVector.x, answerVector.y, answerVector.z
    answer.setVector answerVector

    basisMatrix.setMatrix getRandomBasisMatrix 'coefficientU', 'coefficientV', 'coefficientW'

    $('#coefficientU .input').val(1).change()
    $('#coefficientV .input').val(1).change()
    $('#coefficientW .input').val(1).change()

    $('#uEquation').text('$\\vec{u} = %s$'.format(vec2latex(basisU.vector)))
    $('#vEquation').text('$\\vec{v} = %s$'.format(vec2latex(basisV.vector)))
    $('#wEquation').text('$\\vec{w} = %s$'.format(vec2latex(basisW.vector)))
    MathJax.Hub.Queue ['Typeset', MathJax.Hub]

  do initGame
  $('#reset_game').click initGame

  $('#reveal_hint').click ->
    $('#hint').removeClass 'hidden'
    $('#reveal_hint').addClass 'disabled'

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerView view

  mouseHandler = new MouseHandler()
  mouseHandler.registerView view

  # animate!
  do view.animate

