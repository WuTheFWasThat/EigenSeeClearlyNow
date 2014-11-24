# represents a vector which responds to changes instantly

class ReactiveVector extends Reactive
  constructor: () ->
    super
    @vector = new THREE.Vector3()
    return

  change: () ->
    @emit 'change', @vector

  setVector: (vector) ->
    @vector = vector
    do @change
    return @

  # sets this reactive vector to be the sum of summand reactive vectors
  sum: (summands...) ->
    setSum = () =>
      sum = new THREE.Vector3()
      for summand in summands
        sum.add(summand.vector)
      @setVector sum

    for summand in summands
      summand.on 'change', setSum

    do setSum

  fromReactiveConstants: (c1, c2, c3) ->
    update = () =>
      @vector.set c1.val, c2.val, c3.val
      do @change
    c1.on 'change', update
    c2.on 'change', update
    c3.on 'change', update
    return @

  setFromInput: (vectorInputID) ->
    @input = $('#' + vectorInputID)

    # @disabled = $('.input-container-X .input', @input).attr('disabled')

    # get color from border-color.  needs full property for FF
    @color = @input.css('border-left-color')

    @on 'change', (vector) =>
      for dim in ['x', 'y', 'z']
        value = vector[dim]
        dimContainer = $('.input-container-' + dim, @input)
        $('.input-val', dimContainer).text value
        $('.input', dimContainer).val value

    binddim = (dim) =>
      dimInput = $('.input-container-' + dim + ' .input', @input)
      dimInput.on 'input change', _.throttle( =>
        @vector[dim] = parseInt dimInput.val()
        do @change
      , 10)
      @vector[dim] = parseInt dimInput.val()

    for dim in ['x', 'y', 'z']
      binddim dim

    return @

