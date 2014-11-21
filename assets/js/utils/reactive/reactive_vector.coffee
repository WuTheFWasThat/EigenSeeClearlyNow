# represents a vector which responds to changes instantly

class ReactiveVector extends Reactive
  constructor: () ->
    super
    @vector = new THREE.Vector3()
    return

  change: () ->
    @emit 'change', @vector

  set_vector: (vector) ->
    @vector = vector
    do @change
    return @

  # sets this reactive vector to be the sum of summand reactive vectors
  sum: (summands...) ->
    set_sum = () =>
      sum = new THREE.Vector3()
      for summand in summands
        sum.add(summand.vector)
      @set_vector sum

    for summand in summands
      summand.on 'change', set_sum

    do set_sum

  setFromInput: (vectorInputID) ->
    @input = $('#' + vectorInputID)

    # @disabled = $('.input-container-X .input', @input).attr('disabled')

    # get color from border-color.  needs full property for FF
    @color = @input.css('border-left-color')

    @on 'change', (vector) =>
      for dim in ['X', 'Y', 'Z']
        value = vector[dim.toLowerCase()]
        dimContainer = $('.input-container-' + dim, @input)
        $('.input-val', dimContainer).text value
        $('.input', dimContainer).val value

    binddim = (dim) =>
      dimInput = $('.input-container-' + dim + ' .input', @input)
      dimInput.on 'input change', _.throttle( =>
        @vector[dim.toLowerCase()] = parseInt dimInput.val()
        do @change
      , 10)
      @vector[dim.toLowerCase()] = parseInt dimInput.val()

    for dim in ['X', 'Y', 'Z']
      binddim dim

    return @

