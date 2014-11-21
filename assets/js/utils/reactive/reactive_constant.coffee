# represents a constant which responds to changes instantly

class ReactiveConstant extends Reactive
  constructor: () ->
      super
      @val = 0
      return

  change: () ->
      @emit 'change', @val

  get: () ->
      return @val

  set: (val) ->
      @val = val
      do @change

  # sets this reactive constant to be the sum of summand reactive constants
  sum: (summands...) ->
    set_sum = () =>
      sum = 0
      for summand in summands
        sum += summand.val
      @set sum
      do @change

    for summand in summands
      summand.on 'change', set_sum

  setFromInput: (constantInputId) ->
    @input = $('#' + constantInputId)

    $('.input', @input).on 'input change', _.throttle( =>
      @val = parseInt $('.input', @input).val()
      do @change
    , 10)

    # get color from border-color.  needs full property for FF
    @color = @input.css('border-left-color')

    @on 'change', (val) =>
      $('.input-val', @input).text val
      $('.input', @input).val val

    @val = parseInt $('.input', @input).val()
    return @

  # Multiplies this reactive constant by another reactive constant/vector, resulting in a reactive constant/vector
  times: (multiplicand) ->
    if multiplicand instanceof ReactiveVector
      product = new ReactiveVector()
      set_values = () =>
        product_vector = multiplicand.vector.clone().multiplyScalar(@val)
        product.set_vector product_vector
      @.on 'change', set_values
      multiplicand.on 'change', set_values
      do set_values
      return product
