# Takes in THREE.Vector3 of offset, u, v
# along with options for the material
THREE.Parallelepiped = (u, v, w, options) ->
  THREE.Object3D.call @

  options = options or {}
  @u = u or new THREE.Vector3()
  @v = v or new THREE.Vector3()
  @w = w or new THREE.Vector3()
  @faces = (new THREE.Parallelogram() for i in [0...6])

  @edges = []
  for i in [0...12]
    geometry = new THREE.Geometry()
    geometry.vertices.push new THREE.Vector3()
    geometry.vertices.push new THREE.Vector3()
    material = new THREE.LineBasicMaterial()
    edge = new THREE.Line(geometry, material, THREE.LinePieces)
    @edges.push edge

  offset = options.offset or new THREE.Vector3()
  @setOffset offset

  do @updateFaces
  do @updateEdges

  faceColor = if options.faceColor? then options.faceColor else 0x000000
  @setFaceColor faceColor
  opacity = if options.opacity? then options.opacity else 0.5
  @setOpacity opacity

  for face in @faces
    @add face

  for edge in @edges
    @add edge
  return

THREE.Parallelepiped:: = Object.create(THREE.Object3D::)

  # Get edges (lines)
THREE.Parallelepiped::.updateEdges = () ->
    origin = new THREE.Vector3()
    vectors = [@u, @v, @w]
    sumOfThree = @u.clone().add(@v).add(@w)
    edgeColors = [COLORS.RED, COLORS.GREEN, COLORS.BLUE]

    for i in [0...3]
      v1 = vectors[i]
      v2 = vectors[(i+1) % 3]
      v3 = vectors[(i+2) % 3]
      sum = new THREE.Vector3().addVectors(v2, v3)
      color = edgeColors[i]

      @setEdge (4*i+0), origin, v1, {color: color, lineWidth: 40}
      @setEdge (4*i+1), v2, v1, {color: color, lineWidth: 1}
      @setEdge (4*i+2), v3, v1, {color: color, lineWidth: 1}
      @setEdge (4*i+3), sum, v1, {color: color, lineWidth: 1}
    return

THREE.Parallelepiped::.setEdge = (i, p1, d, options) ->
  edge = @edges[i]

  [v1, v2] = edge.geometry.vertices
  v1.copy p1
  v2.copy(p1).add(d)
  edge.geometry.verticesNeedUpdate = true

  options = options or {}

  color = options.color or DEFAULT.VECTOR.COLOR
  edge.material.color = new THREE.Color color

  lineWidth = options.lineWidth or 1
  edge.material.linewidth = lineWidth

  return

THREE.Parallelepiped::.setOffset = (offset) ->
  @offset = offset
  @position.copy offset
  return @

THREE.Parallelepiped::.updateFaces = () ->
  vertices = [@u, @v, @w]
  for i in [0...3]
    v1 = vertices[i]
    v2 = vertices[(i+1) % 3]
    v3 = vertices[(i+2) % 3]

    face = @faces[2*i]
    face.setVectors v1, v2

    face = @faces[2*i+1]
    face.setOffset v3
    face.setVectors v1, v2

THREE.Parallelepiped::.setVectors = (u, v, w) ->
  @u = u
  @v = v
  @w = w
  do @updateFaces
  do @updateEdges

THREE.Parallelepiped::.setFaceColor = (color) ->
  @faceColor = color
  for face in @faces
    face.setColor @faceColor

THREE.Parallelepiped::.setOpacity = (opacity) ->
  @opacity = opacity
  for face in @faces
    face.setOpacity @opacity

