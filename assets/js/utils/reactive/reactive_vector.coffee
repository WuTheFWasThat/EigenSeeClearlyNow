# represents a vector which responds to changes instantly

class ReactiveVector extends Reactive
  constructor: () ->
    super
    @vector = new THREE.Vector3()
    return

  change: () ->
    @emit 'change', @vector.x, @vector.y, @vector.z

  get_coordinates: () ->
    return [@vector.x, @vector.y, @vector.z]

  set_coordinates: (x, y, z) ->
    @vector.set(x, y, z)
    do @change

  # sets this reactive vector to be the sum of summand reactive vectors
  sum: (summands...) ->
    set_sum = () =>
      sum = new THREE.Vector3()
      for summand in summands
        sum.add(summand.vector)
      @set_coordinates sum.x, sum.y, sum.z

    for summand in summands
      summand.on 'change', set_sum

    do set_sum
