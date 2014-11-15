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

