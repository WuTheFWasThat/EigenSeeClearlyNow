class VectorSliderInput extends ReactiveVector
  constructor: (id) ->
      super

      @input = $('#' + id)

      binddim = (dim) =>
        $('.slider-input-' + dim, @input).on 'input change', _.throttle( =>
          prop = dim.toLowerCase()
          @[prop] = parseInt $('.slider-input-' + dim, @input).val()
          do @change
        , 10)

      for dim in ['X', 'Y', 'Z']
        binddim dim

      # @disabled = $('.slider-input-X', @input).attr('disabled')

      @color = @input.css('border-color')
      @on 'change', (x, y, z) =>
        $('.slider-input-X', @input).val(x)
        $('.slider-input-Y', @input).val(y)
        $('.slider-input-Z', @input).val(z)
        $('.slider-input-val-X', @input).text(x)
        $('.slider-input-val-Y', @input).text(y)
        $('.slider-input-val-Z', @input).text(z)

      @x = parseInt $('.slider-input-X', @input).val()
      @y = parseInt $('.slider-input-Y', @input).val()
      @z = parseInt $('.slider-input-Z', @input).val()

