# Takes in THREE.Vector3 of offset, u, v
# along with options for the material
THREE.Parallelogram = (offset, u, v, options) ->
  options = options or {}

  color = if options.color? then options.color else DEFAULT.PARALLELOGRAM.COLOR
  opacity = if options.opacity? then options.opacity else DEFAULT.PARALLELOGRAM.OPACITY

  @geometry = new THREE.PlaneGeometry()
  @geometry.verticesNeedUpdate = true
  @geometry.elementsNeedUpdate = true
  @geometry.vertices = (new THREE.Vector3() for i in [0...4])

  @offset = offset or new THREE.Vector3()
  @u = u or new THREE.Vector3()
  @v = v or new THREE.Vector3()
  do @updateVertices

  @material = new THREE.MeshBasicMaterial()
  @material.side = THREE.DoubleSide
  @material.transparent = true
  @setOpacity opacity
  @setColor color

  THREE.Mesh.call @, @geometry, @material

THREE.Parallelogram:: = Object.create(THREE.Mesh::)

THREE.Parallelogram::.updateVertices = () ->
  [v1, v2, v3, v4] = @geometry.vertices
  v1.set @offset.x, @offset.y, @offset.z
  v2.addVectors(@offset, @u)
  v3.addVectors(@offset, @v)
  v4.addVectors(v3, @u)

THREE.Parallelogram::.setOffset = (offset) ->
  @offset = offset
  do @updateVertices

THREE.Parallelogram::.setVectors = (u, v) ->
  @u = u
  @v = v
  do @updateVertices

THREE.Parallelogram::.setColor = (color) ->
  @color = color
  @material.color = new THREE.Color @color

THREE.Parallelogram::.setOpacity = (opacity) ->
  @opacity = opacity
  @material.opacity = @opacity

