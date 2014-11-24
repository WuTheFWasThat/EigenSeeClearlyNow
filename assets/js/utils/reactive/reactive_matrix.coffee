# represents a vector which responds to changes instantly

class ReactiveMatrix extends Reactive
  constructor: () ->
    super
    @matrix = new THREE.Matrix3()
    return

  change: () ->
    @emit 'change', @matrix

  setMatrix: (matrix) ->
    @matrix = matrix
    do @change
    return @

  getReactiveRows: () ->
    rowX = new ReactiveVector()
    rowY = new ReactiveVector()
    rowZ = new ReactiveVector()
    updateRows = () =>
      [u, v, w] = getVectorsFromMatrix @matrix
      rowX.setVector u
      rowY.setVector v
      rowZ.setVector w

    @on 'change', updateRows
    do updateRows
    return [rowX, rowY, rowZ]

  fromReactiveRows: (rowX, rowY, rowZ) ->
    update = () =>
      @matrix.set rowX.x, rowX.y, rowX.z, rowY.x, rowY.y, rowY.z, rowZ.x, rowZ.y, rowZ.z
      do @change
    rowX.on 'change', update
    rowY.on 'change', update
    rowZ.on 'change', update
    return @

  setFromInput: (matrixInputId) ->
    @input = $('#' + matrixInputId)

    # @disabled = $('.input-container-XX .input', @input).attr('disabled')

    # get color from border-color.  needs full property for FF
    @color = @input.css('border-left-color')

    @on 'change', (matrix) =>
      for i, row of ['x', 'y', 'z']
        for j, col of ['x', 'y', 'z']
          dim = row + col
          prop = 'n' + (1 + parseInt i) + (1 + parseInt j)
          value = matrix[prop]
          dimContainer = $('.input-container-' + dim, @input)
          $('.input-val', dimContainer).text value
          $('.input', dimContainer).val value

    binddim = (dim, prop) =>
      dimInput = $('.input-container-' + dim + ' .input', @input)
      dimInput.on 'input change', _.throttle( =>
        @matrix[prop] = parseInt dimInput.val()
        do @change
      , 10)
      @matrix[prop] = parseInt dimInput.val()

    for i, row of ['x', 'y', 'z']
      for j, col of ['x', 'y', 'z']
        dim = row + col
        prop = 'n' + (1 + parseInt i) + (1 + parseInt j)
        binddim dim, prop
    return @

  # Multiplies this reactive matrix by a reactive vector, resulting in a reactive vector
  times: (multiplicand) ->
    if multiplicand instanceof ReactiveVector
      product = new ReactiveVector()
      setValues = () =>
        productVector = multiplicand.vector.clone().applyMatrix3(@matrix)
        product.setVector productVector
      @.on 'change', setValues
      multiplicand.on 'change', setValues
      do setValues
      return product
