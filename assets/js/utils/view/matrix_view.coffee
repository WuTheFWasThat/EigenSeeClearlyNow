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
    [u, v, w] = do @extractVectors
    @parallelepiped.setVectors u, v, w

  setOffset: (offset) ->
    @offset = offset
    @parallelepiped.setOffset @offset
    return @

  setOpacity: (opacity) ->
    @opacity = opacity
    @parallelepiped.setOpacity @opacity
    return @

  # Extract vector components of matrix
  extractVectors: () ->
    [@u, @v, @w] = getVectorsFromMatrix @matrix
    return [@u, @v, @w]

  # Get edges (lines)
  getEdges: () ->
    edges = []
    u = @u.clone().add @offset
    v = @v.clone().add @offset
    w = @w.clone().add @offset
    vectors = [u, v, w]
    sumOfThree = u.clone().add(v).add(w)
    for v1 in vectors
      edges.push buildLines [@offset, v1], {color: @vectorColor, lineWidth: 3}
      for v2 in vectors
        if !v1.equals(v2)
          sumOfTwo = v1.clone().add(v2)
          edges.push buildLines [v1, sumOfTwo], {color: @edgeColor, lineWidth: 1}
          edges.push buildLines [sumOfTwo, sumOfThree], {color: @edgeColor, lineWidth: 1}

    return edges

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
    edges = @getEdges()
    for edge in edges
      scene.add edge
    return @

