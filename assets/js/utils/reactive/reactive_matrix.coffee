# represents a vector which responds to changes instantly

class ReactiveMatrix extends Reactive
  constructor: () ->
    super
    @matrix = new THREE.Matrix3()
    return

  change: () ->
    @emit 'change', @matrix

  set_matrix: (matrix) ->
    @matrix = matrix
    do @change
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

