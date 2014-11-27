# Span Game: Reach a point
INIT['vector_spaces-span_game'] = ->
  canvas = $('#canvas')
  view = new View(canvas)

  basisMatrix = new ReactiveMatrix()
  [basisU, basisV, basisW] = do basisMatrix.getReactiveRows

  # Setup a vector hooked up to a scalar input slider
  setupScalingVector = (sliderId, basis) ->
    coefficient = new ReactiveConstant().setFromInput(sliderId)
    scaledBasis = coefficient.times basis
    scaledBasisView = new VectorView(trajectory: scaledBasis, color: coefficient.color, lineWidth: 2)
    return [coefficient, scaledBasis, scaledBasisView]

  # Create the initial three vectors and make them reactive to their scalar input sliders
  [constantU, scaledU, viewU] = setupScalingVector 'coefficientU', basisU
  [constantV, scaledV, viewV] = setupScalingVector 'coefficientV', basisV
  [constantW, scaledW, viewW] = setupScalingVector 'coefficientW', basisW

  # Create the sum of the scaled vectors
  reactiveVectorSum = new ReactiveVector().sum scaledU, scaledV, scaledW

  # answer
  answer = new ReactiveVector()
  targetVector = basisMatrix.times answer

  updateEquation = _.debounce(() ->
    curEquation = '$$\\begin{align}
    & c_u \\cdot \\vec{u} + c_v \\cdot \\vec{v} + c_w \\cdot \\vec{w} \\\\\\\\\
    = \\quad & %s \\cdot %s + %s \\cdot %s + %s \\cdot %s \\\\\\\\
    = \\quad & %s
    \\end{align}$$'.format(
      constantU.get(), vec2latex(basisU.vector),
      constantV.get(), vec2latex(basisV.vector),
      constantW.get(), vec2latex(basisW.vector),
      vec2latex(reactiveVectorSum.vector)
    )
    $('#curEquation').text(curEquation)
    MathJax.Hub.Queue ['Typeset', MathJax.Hub, 'curEquation']
  , 100)

  # The target point to reach
  reactiveVectorSum.on 'change', (vector) ->
    do updateEquation

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
      targetPoint.position.copy vector
      $('#targetEquation').text('$\\vec{t} = %s$'.format(vec2latex(targetVector.vector)))
      MathJax.Hub.Queue ['Typeset', MathJax.Hub, 'targetEquation']
  do targetVector.change

  # Add everything to the view
  view.add viewU, viewV, viewW, viewSum, targetPoint

  # setup of actual values

  maxCoefficientAbs = parseInt $('#info').data('maxCoefficientAbs')
  # max length for vector basis, based on axis length divided by max coefficient
  maxBasisLength = Math.floor(DEFAULT.AXIS.LENGTH / maxCoefficientAbs)
  minBasisLength = maxBasisLength / 2

  # Get a random coefficient value within the slider input values
  getRandomCoefficientValue = () ->
    return Number.randInt -maxCoefficientAbs, maxCoefficientAbs

  # Get a THREE vector with a random set of coordinates, with length restriction
  getRandomBasisVector = () ->
    vector = new THREE.Vector3()
    while vector.length() < minBasisLength or vector.length() > maxBasisLength
      x = Number.randInt -maxBasisLength, maxBasisLength
      y = Number.randInt -maxBasisLength, maxBasisLength
      z = Number.randInt -maxBasisLength, maxBasisLength
      vector.set x, y, z
    return vector

  # get a basis.  keep the determinant big enough that it's not too hard
  getRandomBasisMatrix = () ->
    mat = new THREE.Matrix3()
    while Math.abs(mat.determinant()) < Math.pow(minBasisLength, 3)
      mat.setFromColumns (do getRandomBasisVector), (do getRandomBasisVector), (do getRandomBasisVector)
    return mat

  initGame = () ->
    answerVector = new THREE.Vector3 (do getRandomCoefficientValue), (do getRandomCoefficientValue), (do getRandomCoefficientValue)
    answer.setVector answerVector
    # console.log the answer hehehehehe
    console.log 'answer:', answerVector.x, answerVector.y, answerVector.z

    basisMatrix.setMatrix do getRandomBasisMatrix

    $('#coefficientU .input').val(1).change()
    $('#coefficientV .input').val(1).change()
    $('#coefficientW .input').val(1).change()

    $('#uEquation').text('$\\vec{u} = %s$'.format vec2latex basisU.vector)
    MathJax.Hub.Queue ['Typeset', MathJax.Hub, 'uEquation']
    $('#vEquation').text('$\\vec{v} = %s$'.format vec2latex basisV.vector)
    MathJax.Hub.Queue ['Typeset', MathJax.Hub, 'vEquation']
    $('#wEquation').text('$\\vec{w} = %s$'.format vec2latex basisW.vector)
    MathJax.Hub.Queue ['Typeset', MathJax.Hub, 'wEquation']

  do initGame
  $('#reset_game').click initGame

  $('#reveal_hint').click ->
    $('#hint').removeClass 'hidden'
    $('html, body').animate({
        scrollTop: $('#hint').offset().top
    }, 2000)
    $('#reveal_hint').addClass 'disabled'

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerView view

  mouseHandler = new MouseHandler()
  mouseHandler.registerView view

  # animate!
  do view.animate

