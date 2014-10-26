
vectorize = (coords) ->
  if coords.length == 3
    coords = {x: coords[0], y: coords[1], z: coords[2]}
  if not ('x' of coords and 'y' of coords and 'z' of coords)
    throw new Error ('Cannot vectorize ' + JSON.stringify coords)
  return new THREE.Vector3(coords.x, coords.y, coords.z)

class Vector

  # Example: vector = new Vector([100, 0, 0], color: 0xFF0000)
  # Example: var x = vector.trajectory.x
  constructor: (trajectory, options) ->
      options = options or {}

      # represents the direction
      @trajectory = vectorize(trajectory)

      # represents the start point of the vector
      options.offset = options.offset or {x: 0, y: 0, z: 0}
      offset = vectorize(options.offset)

      # three.js geometry
      @color = options.color or 0xCC0099

      headLength = options.headLength or 5
      headWidth  = options.headWidth or 5
      lineWidth = options.lineWidth or 1

      @arrow = new THREE.Arrow(@trajectory.clone().normalize(), @trajectory.length(), offset, @color, headLength, headWidth, lineWidth)

  set_trajectory: (x, y, z) ->
      @trajectory = new THREE.Vector3(x, y, z)
      @arrow.setDirection @trajectory.clone().normalize()
      @arrow.setLength @trajectory.length()

  # draw!
  draw_on: (scene) ->
      scene.add @arrow
