
vectorize = (coords) ->
  if coords.length == 3
    coords = {x: coords[0], y: coords[1], z: coords[2]}
  if not ('x' of coords and 'y' of coords and 'z' of coords)
    throw new Error ('Cannot vectorize ' + JSON.stringify coords)
  return new THREE.Vector3(coords.x, coords.y, coords.z)

class VectorView

  # Example: vector = new VectorView([100, 0, 0], color: 0xFF0000)
  # Example: var x = vector.trajectory.x
  constructor: (trajectory, options) ->
      options = options or {}

      # represents the direction
      @trajectory = vectorize(trajectory)

      # represents the start point of the vector
      options.offset = options.offset or {x: 0, y: 0, z: 0}
      offset = vectorize(options.offset)

      # three.js geometry
      @color = if options.color? then options.color else DEFAULT.VECTOR.COLOR

      headLength = options.headLength or DEFAULT.VECTOR.HEAD_LENGTH
      headWidth  = options.headWidth or DEFAULT.VECTOR.HEAD_WIDTH
      lineWidth = options.lineWidth or DEFAULT.VECTOR.THICKNESS

      @arrow = new THREE.Arrow(@trajectory.clone().normalize(), @trajectory.length(), offset, @color, headLength, headWidth, lineWidth)

  set_trajectory: (x, y, z) ->
      @trajectory = new THREE.Vector3(x, y, z)
      @arrow.setDirection @trajectory.clone().normalize()
      @arrow.setLength @trajectory.length()

  set_offset: (x, y, z) ->
      offset = new THREE.Vector3(x, y, z)
      @arrow.setOffset offset

  # draw!
  draw_on: (scene) ->
      scene.add @arrow
