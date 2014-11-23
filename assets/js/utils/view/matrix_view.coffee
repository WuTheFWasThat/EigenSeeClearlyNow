###
Class representing a drawn matrix as a parallelepiped
Options:
  vectors: array of vectors that make up the matrix
  offset: represents the origin of the matrix
###
class MatrixView
  constructor: (options) ->
      options = options or {}
      return @

  # Draw matrix as a parallelepiped
  # with faces and edges
  drawMatrix: (view, offset, u, v, w) ->
    faces = @getFaces offset, u, v, w
    for face in faces
      view.add face
    edges = @getEdges offset, u, v, w
    for edge in edges
      view.add edge
    return @

  # Get faces (parallelograms)
  getFaces: (offset, u, v, w) ->
    faces = []
    vertices = [u, v, w, v, w, u, w, u, v]
    for v1, i in vertices by 3
      v2 = vertices[i+1]
      v3 = vertices[i+2]
      faces.push new THREE.Parallelogram(offset, v1, v2)
      offsetShifted = offset.clone().add v3
      faces.push new THREE.Parallelogram(offsetShifted, v1, v2)
    return faces

  # Get edges (lines)
  getEdges: (offset, u, v, w) ->
    edges = []
    u = u.clone().add offset
    v = v.clone().add offset
    w = w.clone().add offset
    vectors = [u, v, w]
    sumOfThree = u.clone().add(v).add(w)
    for v1 in vectors
      edges.push buildLines [offset, v1], 'SOLID', COLORS.LIGHT_YELLOW
      for v2 in vectors
        if !v1.equals(v2)
          sumOfTwo = v1.clone().add(v2)
          edges.push buildLines [v1, sumOfTwo], 'SOLID', DEFAULT.VECTOR.COLOR
          edges.push buildLines [sumOfTwo, sumOfThree], 'SOLID', DEFAULT.VECTOR.COLOR

    return edges

  # Build lines given an array of THREE.Vector3
  buildLines: (vectors, lineType, color) ->
    geometry = new THREE.Geometry()
    for vector in vectors
      geometry.vertices.push(vector)

    material = new THREE.LineBasicMaterial({lineWidth: 1, color: color})

    if (lineType == 'DASHED')
      geometry.computeLineDistances()
      material = new THREE.LineDashedMaterial({lineWidth: 1, color: color, dashSize: 10, gapSize: 10})

    lines = new THREE.Line(geometry, material, THREE.LinePieces)
    return lines
