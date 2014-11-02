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
