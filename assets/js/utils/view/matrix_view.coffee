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

      @matrix = options.matrix or new THREE.Matrix3()
      @offset = options.offset or new THREE.Vector3()
      @faceColor = options.faceColor or DEFAULT.PARALLELOGRAM.COLOR
      @edgeColor = options.edgeColor or COLORS.PURPLE
      @vectorColor = options.vectorColor or DEFAULT.VECTOR.COLOR
      do @extractVectors

      return @

  # Extract vector components of matrix
  extractVectors: () ->
    [@u, @v, @w] = getVectorsFromMatrix @matrix
    return [@u, @v, @w]

  # Draw matrix as a parallelepiped
  # with faces and edges
  drawMatrix: (view) ->
    faces = @getFaces()
    for face in faces
      view.add face
    edges = @getEdges()
    for edge in edges
      view.add edge
    return @

  # Get faces (parallelograms)
  getFaces: () ->
    faces = []
    vertices = [@u, @v, @w, @v, @w, @u, @w, @u, @v]
    for v1, i in vertices by 3
      v2 = vertices[i+1]
      v3 = vertices[i+2]
      faces.push new THREE.Parallelogram(@offset, v1, v2, {color: @faceColor})
      offsetShifted = @offset.clone().add v3
      faces.push new THREE.Parallelogram(offsetShifted, v1, v2, {color: @faceColor})
    return faces

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

