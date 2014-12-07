###
Class representing a drawn matrix as a parallelepiped
Options:
  matrix: a THREE.Matrix3
  offset: a THREE.Vector3
  faceColor: a hex string (i.e. from COLORS constants)
  edgeColor: a hex string
  vectorColor: a hex string
###
class MatrixView
  constructor: (options) ->
      options = options or {}

      @parallelepiped = new THREE.Parallelepiped()

      faceColor = if options.faceColor? then options.faceColor else DEFAULT.MATRIX.FACECOLOR
      @setFaceColor faceColor
      @edgeColor = options.edgeColor or COLORS.PURPLE
      @vectorColor = options.vectorColor or DEFAULT.VECTOR.COLOR

      opacity = if options.opacity? then options.opacity else DEFAULT.MATRIX.OPACITY
      @setOpacity opacity

      options.matrix = options.matrix or new THREE.Matrix3()
      if options.matrix instanceof ReactiveMatrix
        @setReactiveMatrix options.matrix
      else
        @setMatrix options.matrix

      # represents the start point of the vector
      options.offset = options.offset or new THREE.Vector3()
      if options.offset instanceof ReactiveVector
        @setReactiveOffset options.offset
      else
        @setOffset options.offset

      return @

  setMatrix: (matrix) ->
    @matrix = matrix
    [@u, @v, @w] = do matrix.getColumns
    @parallelepiped.setVectors @u, @v, @w

  setOffset: (offset) ->
    @offset = offset
    @parallelepiped.setOffset @offset
    return @

  setOpacity: (opacity) ->
    @opacity = opacity
    @parallelepiped.setOpacity @opacity
    return @

  setReactiveMatrix: (reactiveMatrix) ->
    @setMatrix reactiveMatrix.matrix
    reactiveMatrix.on 'change', (matrix) =>
      @setMatrix matrix
    return @

  setReactiveOffset: (reactiveVector) ->
    @setOffset reactiveVector.vector
    reactiveVector.on 'change', (vector) =>
      @setOffset vector
    return @

  setFaceColor: (color) ->
    @faceColor = color
    @parallelepiped.setFaceColor color
    return @

  # Draw matrix as a parallelepiped with faces and edges
  drawOn: (scene) ->
    scene.add @parallelepiped
    return @

