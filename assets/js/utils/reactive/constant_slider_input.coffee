class ConstantSliderInput extends ReactiveConstant
  constructor: (id) ->
      super

      @input = $('#' + id)

      $('.slider-input', @input).on 'input change', _.throttle( =>
        @val = parseInt $('.slider-input', @input).val()
        do @change
      , 10)

      # get color from border-color.  needs full property for FF
      @color = @input.css('border-left-color')

      @on 'change', (val) =>
        $('.slider-input', @input).val(val)
        $('.slider-input-val', @input).text(val)

      @val = parseInt $('.slider-input', @input).val()

