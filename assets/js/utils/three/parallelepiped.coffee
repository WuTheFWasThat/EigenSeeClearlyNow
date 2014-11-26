# Takes in THREE.Vector3 of offset, u, v
# along with options for the material
THREE.Parallelepiped = (offset, u, v, w, options) ->
  THREE.Object3D.call @

  options = options or {}

  @faces = (new THREE.Parallelogram() for i in [0...6])

  @offset = offset or new THREE.Vector3()
  @u = u or new THREE.Vector3()
  @v = v or new THREE.Vector3()
  @w = w or new THREE.Vector3()
  do @updateFaces

  faceColor = if options.faceColor? then options.faceColor else 0x000000
  @setFaceColor faceColor
  opacity = if options.opacity? then options.opacity else 0.5
  @setOpacity opacity

  for face in @faces
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

    offsetShifted = @offset.clone().add v3

    face = @faces[2*i+1]
    face.setOffset offsetShifted
    face.setVectors v1, v2

THREE.Parallelepiped::.setOffset = (offset) ->
  @offset = offset
  do @updateFaces

THREE.Parallelepiped::.setVectors = (u, v, w) ->
  @u = u
  @v = v
  @w = w
  do @updateFaces

THREE.Parallelepiped::.setFaceColor = (color) ->
  @faceColor = color
  for face in @faces
    face.setColor @faceColor

THREE.Parallelepiped::.setOpacity = (opacity) ->
  @opacity = opacity
  for face in @faces
    face.setOpacity @opacity

