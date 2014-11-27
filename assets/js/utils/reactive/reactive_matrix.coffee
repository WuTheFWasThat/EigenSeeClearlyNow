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
      [x, y, z] = do @matrix.getRows
      rowX.setVector x
      rowY.setVector y
      rowZ.setVector z

    @on 'change', updateRows
    do updateRows
    return [rowX, rowY, rowZ]

  getReactiveColumns: () ->
    colX = new ReactiveVector()
    colY = new ReactiveVector()
    colZ = new ReactiveVector()
    updateColumns= () =>
      [x, y, z] = do @matrix.getColumns
      colX.setVector x
      colY.setVector y
      colZ.setVector z

    @on 'change', updateColumns
    do updateColumns
    return [colX, colY, colZ]

  fromReactiveRows: (rowX, rowY, rowZ) ->
    update = () =>
      @matrix.setFromRows rowX.vector, rowY.vector, rowZ.vector
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
          elIndex = (parseInt i) + 3 * (parseInt j)
          value = matrix.elements[elIndex]
          dimContainer = $('.input-container-' + dim, @input)
          $('.input-val', dimContainer).text value
          $('.input', dimContainer).val value

    binddim = (dim, elIndex) =>
      dimInput = $('.input-container-' + dim + ' .input', @input)
      dimInput.on 'input change', _.throttle( =>
        @matrix.elements[elIndex] = parseInt dimInput.val()
        do @change
      , 10)
      @matrix.elements[elIndex] = parseInt dimInput.val()

    for i, row of ['x', 'y', 'z']
      for j, col of ['x', 'y', 'z']
        dim = row + col
        elIndex = (parseInt i) + 3 * (parseInt j)
        binddim dim, elIndex
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
