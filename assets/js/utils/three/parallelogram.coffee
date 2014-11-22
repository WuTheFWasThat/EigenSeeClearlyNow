# Takes in THREE.Vector3 of offset, u, v
# along with options for the material
THREE.Parallelogram = (offset, u, v, options) ->
  options = options or {}

  @offset = offset
  @u = u
  @v = v

  color = if options.color? then options.color else DEFAULT.PARALLELOGRAM.COLOR
  opacity = if options.opacity? then options.opacity else DEFAULT.PARALLELOGRAM.OPACITY

  v1 = new THREE.Vector3()
  v2 = new THREE.Vector3()
  v3 = new THREE.Vector3()
  v4 = new THREE.Vector3()
  vertices = [v1, v2, v3, v4]

  @geometry = new THREE.PlaneGeometry()
  @geometry.verticesNeedUpdate = true
  @geometry.elementsNeedUpdate = true
  @geometry.vertices = vertices
  do @updateVertices

  @material = new THREE.MeshBasicMaterial()
  @setColor color
  @material.transparent = true
  @setOpacity opacity
  @material.side = THREE.DoubleSide

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

THREE.Parallelogram::.setColor = (color) ->
  @color = color
  @material.color = new THREE.Color @color

THREE.Parallelogram::.setOpacity = (opacity) ->
  @opacity = opacity
  @material.opacity = @opacity

