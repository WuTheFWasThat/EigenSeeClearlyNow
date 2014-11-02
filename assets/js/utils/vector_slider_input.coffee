class VectorSliderInput extends ReactiveVector
  constructor: (id) ->
      do @_base_constructor

      @input = $('#' + id)

      @x = parseInt $('.slider-input-X', @input).val()
      @y = parseInt $('.slider-input-Y', @input).val()
      @z = parseInt $('.slider-input-Z', @input).val()

      binddim = (dim) =>
        $('.slider-input-' + dim, @input).on 'input change', _.throttle( =>
          prop = dim.toLowerCase()
          @[prop] = parseInt $('.slider-input-' + dim, @input).val()
          do @change
        , 10)

      for dim in ['X', 'Y', 'Z']
        binddim dim

      @color = @input.css('border-color')
      @on 'change', (x, y, z) =>
        $('.slider-input-val-X', @input).text(x)
        $('.slider-input-val-Y', @input).text(y)
        $('.slider-input-val-Z', @input).text(z)

