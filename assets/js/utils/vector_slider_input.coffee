class VectorSliderInput
  constructor: (id) ->
      @input = $('#' + id)

      @change_fns = []

      do @get_coordinates

      binddim = (dim) =>
        $('.slider-input-' + dim, @input).on 'input change', _.throttle( =>
          @_change_dim dim
        , 10)

      for dim in ['X', 'Y', 'Z']
        binddim dim

      @color = @input.css('border-color')

  _change_dim: (dim) ->
      prop = dim.toLowerCase()
      @[prop] = parseInt $('.slider-input-' + dim, @input).val()
      $('.slider-input-val-' + dim, @input).text(@[prop])
      for f in @change_fns
        f(@x, @y, @z)

  change: () ->
      for dim in ['X', 'Y', 'Z']
        @_change_dim dim

  get_coordinates: () ->
      @x = parseInt $('.slider-input-X', @input).val()
      @y = parseInt $('.slider-input-Y', @input).val()
      @z = parseInt $('.slider-input-Z', @input).val()
      return [@x, @y, @z]

  set_coordinates: (x, y, z) ->
      $('.slider-input-X', @input).val(x)
      $('.slider-input-Y', @input).val(y)
      $('.slider-input-Z', @input).val(z)
      do @change

  on: (ev, f) ->
    if ev == 'change'
      @change_fns.push f
