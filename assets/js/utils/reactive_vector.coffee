# represents a vector which responds to changes instantly

class ReactiveVector
  constructor: () ->
      do @_base_constructor

  _base_constructor: () ->
      @on_change_fns = []

      @x = 0
      @y = 0
      @z = 0

      return

  change: () ->
      for f in @on_change_fns
        f(@x, @y, @z)

  get_coordinates: () ->
      return [@x, @y, @z]

  set_coordinates: (x, y, z) ->
      @x = x
      @y = y
      @z = z
      do @change

  on: (ev, f) ->
    if ev == 'change'
      @on_change_fns.push f

  # add with another reactive vector, returns a new one
  sum: (others...) ->
    set_sum = () =>
      sum_x = 0
      sum_y = 0
      sum_z = 0
      for other in others
        sum_x += other.x
        sum_y += other.y
        sum_z += other.z
      @set_coordinates sum_x, sum_y, sum_z
      do @change

    for other in others
      other.on 'change', set_sum
