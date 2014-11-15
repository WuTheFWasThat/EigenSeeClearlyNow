# represents a vector which responds to changes instantly

class ReactiveVector extends Reactive
  constructor: () ->
      super
      @x = 0
      @y = 0
      @z = 0
      return

  change: () ->
      @emit 'change', @x, @y, @z

  get_coordinates: () ->
      return [@x, @y, @z]

  set_coordinates: (x, y, z) ->
      @x = x
      @y = y
      @z = z
      do @change

  # sets this reactive vector to be the sum of summand reactive vectors
  sum: (summands...) ->
    set_sum = () =>
      sum_x = 0
      sum_y = 0
      sum_z = 0
      for summand in summands
        sum_x += summand.x
        sum_y += summand.y
        sum_z += summand.z
      @set_coordinates sum_x, sum_y, sum_z
      do @change

    for summand in summands
      summand.on 'change', set_sum

