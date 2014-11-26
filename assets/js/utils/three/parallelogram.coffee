# Takes in THREE.Vector3 of offset, u, v
# along with options for the material
THREE.Parallelogram = (u, v, options) ->
  options = options or {}

  color = if options.color? then options.color else 0x000000
  opacity = if options.opacity? then options.opacity else 0.5

  @geometry = new THREE.PlaneGeometry()
  @geometry.verticesNeedUpdate = true
  @geometry.elementsNeedUpdate = true
  @geometry.vertices = (new THREE.Vector3() for i in [0...4])


  @u = u or new THREE.Vector3()
  @v = v or new THREE.Vector3()
  do @updateVertices

  @material = new THREE.MeshBasicMaterial()
  @material.side = THREE.DoubleSide
  @material.transparent = true
  @setOpacity opacity
  @setColor color

  THREE.Mesh.call @, @geometry, @material

  offset = options.offset or new THREE.Vector3()
  @setOffset offset

THREE.Parallelogram:: = Object.create(THREE.Mesh::)

THREE.Parallelogram::.updateVertices = () ->
  [v1, v2, v3, v4] = @geometry.vertices
  v1.set 0, 0, 0
  v2.copy @u
  v3.copy @v
  v4.addVectors @u, @v

THREE.Parallelogram::.setOffset = (offset) ->
  @offset = offset
  @position.copy offset
  return @

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

