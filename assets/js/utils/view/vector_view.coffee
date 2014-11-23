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
      @trajectory = options.trajectory or new THREE.Vector3()

      # represents the start point of the vector
      @offset = options.offset or new THREE.Vector3()

      # three.js geometry
      @color = if options.color? then options.color else DEFAULT.VECTOR.COLOR

      headLength = options.headLength or DEFAULT.VECTOR.HEAD_LENGTH
      @headWidth  = options.headWidth or DEFAULT.VECTOR.HEAD_WIDTH
      @lineWidth = options.lineWidth or DEFAULT.VECTOR.THICKNESS

      @arrow = new THREE.Arrow(@trajectory.clone().normalize(), @trajectory.length(), @offset, @color, headLength, @headWidth, @lineWidth)
      return @

  set_trajectory: (trajectory) ->
      @trajectory = trajectory
      @arrow.setDirection @trajectory.clone().normalize()
      @arrow.setLength @trajectory.length()
      return @

  set_offset: (offset) ->
      @offset = offset
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
      @set_trajectory r_vector.vector
      r_vector.on 'change', (vector) =>
        @set_trajectory(vector)
      return @

  set_reactive_offset: (r_vector) ->
      @set_offset r_vector.vector
      r_vector.on 'change', (vector) =>
        @set_offset(vector)
      return @

  # draw!
  draw_on: (scene) ->
      scene.add @arrow
