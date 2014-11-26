# Takes in THREE.Vector3 of offset, u, v
# along with options for the material
THREE.Parallelepiped = (offset, u, v, w, options) ->
  THREE.Object3D.call @

  options = options or {}

  @faceColor = if options.color? then options.color else 0x000000
  @opacity = if options.opacity? then options.opacity else 0.5

  @offset = offset
  @u = u
  @v = v
  @w = w
  @faces = (new THREE.Parallelogram() for i in [0...6])

  do @updateFaces
  for face in @faces
    # do this elsewhere
    face.setOpacity @opacity
    @add face
  return

THREE.Parallelepiped:: = Object.create(THREE.Object3D::)

THREE.Parallelepiped::.updateFaces = () ->
  vertices = [@u, @v, @w]
  for i in [0...3]
    v1 = vertices[i]
    v2 = vertices[(i+1) % 3]
    v3 = vertices[(i+2) % 3]

    face = @faces[2*i]
    face.setOffset @offset
    face.setVectors v1, v2
    face.setColor @faceColor

    offsetShifted = @offset.clone().add v3

    face = @faces[2*i+1]
    face.setOffset offsetShifted
    face.setVectors v1, v2
    face.setColor @faceColor

THREE.Parallelepiped::.setOffset = (offset) ->
  @offset = offset
  do @updateFaces

THREE.Parallelepiped::.setVectors = (u, v, w) ->
  @u = u
  @v = v
  @w = w
  do @updateFaces

THREE.Parallelepiped::.setColor = (color) ->
  # todo: loop through faces?

THREE.Parallelepiped::.setOpacity = (opacity) ->
  # todo: loop through faces?

