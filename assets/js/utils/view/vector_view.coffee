###
Class representing a drawn vector
Options:
  trajectory: represents the direction the vector is pointing
  offset: represents the origin of the vector
###
class VectorView
  constructor: (options) ->
      options = options or {}

      @arrow = new THREE.Arrow()

      options.headLength = options.headLength or DEFAULT.VECTOR.HEAD_LENGTH
      @setHeadLength options.headLength
      options.headWidth  = options.headWidth or DEFAULT.VECTOR.HEAD_WIDTH
      @setHeadWidth options.headWidth
      options.lineWidth = options.lineWidth or DEFAULT.VECTOR.LINE_WIDTH
      @setLineWidth options.lineWidth

      # represents the direction
      options.trajectory = options.trajectory or new THREE.Vector3()
      if options.trajectory instanceof ReactiveVector
        @setReactiveTrajectory options.trajectory
      else
        @setTrajectory options.trajectory

      # represents the start point of the vector
      options.offset = options.offset or new THREE.Vector3()
      if options.offset instanceof ReactiveVector
        @setReactiveOffset options.offset
      else
        @setOffset options.offset

      # three.js geometry
      options.color = if options.color? then options.color else DEFAULT.VECTOR.COLOR
      @setColor options.color

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

  setHeadLength: (headLength) ->
      @headLength = headLength
      @arrow.setHeadLength @headLength
      return @

  setReactiveTrajectory: (reactiveVector) ->
      @setTrajectory reactiveVector.vector
      reactiveVector.on 'change', (vector) =>
        @setTrajectory vector
      return @

  setReactiveOffset: (reactiveVector) ->
      @setOffset reactiveVector.vector
      reactiveVector.on 'change', (vector) =>
        @setOffset vector
      return @

  drawOn: (scene) ->
      scene.add @arrow
