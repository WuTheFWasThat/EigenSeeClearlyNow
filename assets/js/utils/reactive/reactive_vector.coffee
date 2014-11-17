# represents a vector which responds to changes instantly

class ReactiveVector extends Reactive
  constructor: () ->
    super
    @vector = new THREE.Vector3()
    return

  change: () ->
    @emit 'change', @vector

  get_coordinates: () ->
    return [@vector.x, @vector.y, @vector.z]

  set_coordinates: (x, y, z) ->
    @vector.set(x, y, z)
    do @change
    return @

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

  setFromSliderInput: (sliderInputId) ->
    @input = $('#' + sliderInputId)

    binddim = (dim) =>
      $('.slider-input-' + dim, @input).on 'input change', _.throttle( =>
        prop = dim.toLowerCase()
        @vector[prop] = parseInt $('.slider-input-' + dim, @input).val()
        do @change
      , 10)

    for dim in ['X', 'Y', 'Z']
      binddim dim

    # @disabled = $('.slider-input-X', @input).attr('disabled')

    # get color from border-color.  needs full property for FF
    @color = @input.css('border-left-color')

    @on 'change', (vector) =>
      $('.slider-input-X', @input).val(vector.x)
      $('.slider-input-Y', @input).val(vector.y)
      $('.slider-input-Z', @input).val(vector.z)
      $('.slider-input-val-X', @input).text(vector.x)
      $('.slider-input-val-Y', @input).text(vector.y)
      $('.slider-input-val-Z', @input).text(vector.z)

    @vector.x = parseInt $('.slider-input-X', @input).val()
    @vector.y = parseInt $('.slider-input-Y', @input).val()
    @vector.z = parseInt $('.slider-input-Z', @input).val()

    return @

