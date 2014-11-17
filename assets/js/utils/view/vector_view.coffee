vectorize = (coords) ->
  if coords.length == 3
    coords = {x: coords[0], y: coords[1], z: coords[2]}
  if not ('x' of coords and 'y' of coords and 'z' of coords)
    throw new Error ('Cannot vectorize ' + JSON.stringify coords)
  return new THREE.Vector3(coords.x, coords.y, coords.z)

###
Class representing a drawn vector
Options:
  trajectory: represents the direction the vector is pointing
  offset: represents the origin of the vector
###
class VectorView
  constructor: (options) ->
      options = options or {}

      # represents the direction
      options.trajectory = options.trajectory or {x: 0, y: 0, z: 0}
      @trajectory = vectorize(options.trajectory)

      # represents the start point of the vector
      options.offset = options.offset or {x: 0, y: 0, z: 0}
      @offset = vectorize(options.offset)

      # three.js geometry
      @color = if options.color? then options.color else DEFAULT.VECTOR.COLOR

      headLength = options.headLength or DEFAULT.VECTOR.HEAD_LENGTH
      @headWidth  = options.headWidth or DEFAULT.VECTOR.HEAD_WIDTH
      @lineWidth = options.lineWidth or DEFAULT.VECTOR.THICKNESS

      @arrow = new THREE.Arrow(@trajectory.clone().normalize(), @trajectory.length(), @offset, @color, headLength, @headWidth, @lineWidth)
      return @

  set_trajectory: (trajectory) ->
      @trajectory = vectorize(trajectory)
      @arrow.setDirection @trajectory.clone().normalize()
      @arrow.setLength @trajectory.length()
      return @

  set_offset: (offset) ->
      @offset = vectorize(offset)
      @arrow.setOffset @offset
      return @

  set_color: (color) ->
      @color = color
      @arrow.setColor @color
      return @

  set_line_width: (lineWidth) ->
      @lineWidth = lineWidth
      @arrow.setLineWidth @lineWidth
      return @

  set_head_width: (headWidth) ->
      @headWidth = headWidth
      @arrow.setHeadWidth @headWidth
      return @

  set_reactive_trajectory: (r_vector) ->
      @set_trajectory do r_vector.get_coordinates
      r_vector.on 'change', (vector) =>
        @set_trajectory(vector)
      return @

  set_reactive_offset: (r_vector) ->
      @set_offset do r_vector.get_coordinates
      r_vector.on 'change', (vector) =>
        @set_offset(vector)
      return @

  # draw!
  draw_on: (scene) ->
      scene.add @arrow
