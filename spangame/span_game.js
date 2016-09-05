INIT['vector_spaces-span_game'] = function() {
  var answer, basisMatrix, basisU, basisV, basisW, canvas, constantU, constantV, constantW, getRandomBasisMatrix, getRandomBasisVector, initGame, keyHandler, maxBasisLength, maxCoefficientAbs, minBasisLength, mouseHandler, reactiveVectorSum, ref, ref1, ref2, ref3, scaledU, scaledV, scaledW, setupScalingVector, targetPoint, targetVector, updateEquation, view, viewSum, viewU, viewV, viewW;
  canvas = $('#canvas');
  view = new View(canvas);
  basisMatrix = new ReactiveMatrix();
  ref = basisMatrix.getReactiveColumns(), basisU = ref[0], basisV = ref[1], basisW = ref[2];
  setupScalingVector = function(sliderId, basis) {
    var coefficient, scaledBasis, scaledBasisView;
    coefficient = new ReactiveConstant().setFromInput(sliderId);
    scaledBasis = coefficient.times(basis);
    scaledBasisView = new VectorView({
      trajectory: scaledBasis,
      color: coefficient.color,
      lineWidth: 2
    });
    return [coefficient, scaledBasis, scaledBasisView];
  };
  ref1 = setupScalingVector('coefficientU', basisU), constantU = ref1[0], scaledU = ref1[1], viewU = ref1[2];
  ref2 = setupScalingVector('coefficientV', basisV), constantV = ref2[0], scaledV = ref2[1], viewV = ref2[2];
  ref3 = setupScalingVector('coefficientW', basisW), constantW = ref3[0], scaledW = ref3[1], viewW = ref3[2];
  reactiveVectorSum = new ReactiveVector().sum(scaledU, scaledV, scaledW);
  answer = new ReactiveVector();
  targetVector = basisMatrix.times(answer);
  updateEquation = _.debounce(function() {
    var curEquation;
    curEquation = '$$\\begin{align} & c_u \\cdot \\vec{u} + c_v \\cdot \\vec{v} + c_w \\cdot \\vec{w} \\\\\\\\= \\quad & %s \\cdot %s + %s \\cdot %s + %s \\cdot %s \\\\\\\\ = \\quad & %s \\end{align}$$'.format(constantU.get(), vec2latex(basisU.vector), constantV.get(), vec2latex(basisV.vector), constantW.get(), vec2latex(basisW.vector), vec2latex(reactiveVectorSum.vector));
    return renderLatex($('#curEquation'), curEquation);
  }, 100);
  reactiveVectorSum.on('change', function(vector) {
    updateEquation();
    if (vector.equals(targetVector.vector)) {
      viewSum.setColor(COLORS.LIGHT_YELLOW);
      targetPoint.material.setValues({
        color: COLORS.LIGHT_YELLOW
      });
      return $('#curEquationContainer').removeClass('incorrect').addClass('correct');
    } else {
      viewSum.setColor(COLORS.WHITE);
      targetPoint.material.setValues({
        color: COLORS.WHITE
      });
      return $('#curEquationContainer').removeClass('correct').addClass('incorrect');
    }
  });
  viewSum = new VectorView({
    trajectory: reactiveVectorSum,
    lineWidth: 4
  });
  targetPoint = createPoint();
  targetVector.on('change', function(vector) {
    targetPoint.position.copy(vector);
    return renderLatex($('#targetEquation'), '$\\vec{t} = %s$'.format(vec2latex(targetVector.vector)));
  });
  targetVector.change();
  view.add(viewU, viewV, viewW, viewSum, targetPoint);
  maxCoefficientAbs = parseInt($('#info').data('maxCoefficientAbs'));
  maxBasisLength = Math.floor(DEFAULT.AXIS.LENGTH / maxCoefficientAbs);
  minBasisLength = maxBasisLength / 2;
  getRandomBasisVector = function() {
    var vector;
    vector = new THREE.Vector3();
    while (vector.length() < minBasisLength || vector.length() > maxBasisLength) {
      vector.randomize(function() {
        return Number.randInt(-maxBasisLength, maxBasisLength);
      });
    }
    return vector;
  };
  getRandomBasisMatrix = function() {
    var mat;
    mat = new THREE.Matrix3();
    while (Math.abs(mat.determinant()) < Math.pow(minBasisLength, 3)) {
      mat.setFromColumns(getRandomBasisVector(), getRandomBasisVector(), getRandomBasisVector());
    }
    return mat;
  };
  initGame = function() {
    var answerVector;
    answerVector = new THREE.Vector3().randomize(function() {
      return Number.randInt(-maxCoefficientAbs, maxCoefficientAbs);
    });
    answer.setVector(answerVector);
    console.log('answer:', answerVector.x, answerVector.y, answerVector.z);
    basisMatrix.setMatrix(getRandomBasisMatrix());
    $('#coefficientU .input').val(1).change();
    $('#coefficientV .input').val(1).change();
    $('#coefficientW .input').val(1).change();
    renderLatex($('#uEquation'), '$\\vec{u} = %s$'.format(vec2latex(basisU.vector)));
    renderLatex($('#vEquation'), '$\\vec{v} = %s$'.format(vec2latex(basisV.vector)));
    return renderLatex($('#wEquation'), '$\\vec{w} = %s$'.format(vec2latex(basisW.vector)));
  };
  initGame();
  $('#reset_game').click(initGame);
  $('#reveal_hint').click(function() {
    $('#hint').removeClass('hidden');
    $('html, body').animate({
      scrollTop: $('#hint').offset().top
    }, 2000);
    return $('#reveal_hint').addClass('disabled');
  });
  keyHandler = new KeyHandler();
  keyHandler.registerView(view);
  mouseHandler = new MouseHandler();
  mouseHandler.registerView(view);
  return view.animate();
};