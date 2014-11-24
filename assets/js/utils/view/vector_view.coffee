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

  setTrajectory: (trajectory) ->
      @trajectory = trajectory
      @arrow.setDirection @trajectory.clone().normalize()
      @arrow.setLength @trajectory.length()
      return @

  setOffset: (offset) ->
      @offset = offset
      @arrow.setOffset @offset
      return @

  setColor: (color) ->
      @color = color
      @arrow.setColor @color
      return @

  setLineWidth: (lineWidth) ->
      @lineWidth = lineWidth
      @arrow.setLineWidth @lineWidth
      return @

  setHeadWidth: (headWidth) ->
      @headWidth = headWidth
      @arrow.setHeadWidth @headWidth
      return @

  setReactiveTrajectory: (reactiveVector) ->
      @setTrajectory reactiveVector.vector
      reactiveVector.on 'change', (vector) =>
        @setTrajectory(vector)
      return @

  setReactiveOffset: (reactiveVector) ->
      @setOffset reactiveVector.vector
      reactiveVector.on 'change', (vector) =>
        @setOffset(vector)
      return @

  # draw!
  drawOn: (scene) ->
      scene.add @arrow
