################################################################################
# THREE.js helpers
################################################################################

################################################################################
# vectors and matrices
################################################################################

THREE.Vector3.prototype.randomize = (fn) ->
  @set (fn 'x'), (fn 'y'), (fn 'z')

# randomizer takes 'row', 'col'
THREE.Matrix3.prototype.randomize = (fn) ->
  @set (fn 'x', 'x'), (fn 'x', 'y'), (fn 'x', 'z'),
       (fn 'y', 'x'), (fn 'y', 'y'), (fn 'y', 'z'),
       (fn 'z', 'x'), (fn 'z', 'y'), (fn 'z', 'z')

THREE.Matrix3.prototype.getColumns= () ->
  vectors = []
  vectors.push new THREE.Vector3 @elements[0], @elements[1], @elements[2]
  vectors.push new THREE.Vector3 @elements[3], @elements[4], @elements[5]
  vectors.push new THREE.Vector3 @elements[6], @elements[7], @elements[8]
  return vectors

THREE.Matrix3.prototype.getRows = () ->
  vectors = []
  vectors.push new THREE.Vector3 @elements[0], @elements[3], @elements[6]
  vectors.push new THREE.Vector3 @elements[1], @elements[4], @elements[7]
  vectors.push new THREE.Vector3 @elements[2], @elements[5], @elements[8]
  return vectors

THREE.Matrix3.prototype.setFromRows = (rowX, rowY, rowZ) ->
  @set rowX.x, rowY.x, rowZ.x, rowX.y, rowY.y, rowZ.y, rowX.z, rowY.z, rowZ.z
  return @

THREE.Matrix3.prototype.setFromColumns = (colX, colY, colZ) ->
  @set colX.x, colX.y, colX.z, colY.x, colY.y, colY.z, colZ.x, colZ.y, colZ.z
  return @

################################################################################
# other
################################################################################

# Build lines given an array of THREE.Vector3 with the following options:
# line type (DASHED or SOLID), color, and thickness
buildLines = (vectors, options) ->
  options = options or {}
  color = options.color or DEFAULT.VECTOR.COLOR
  lineType = options.lineType or 'SOLID'
  lineWidth = options.lineWidth or 1
  geometry = new THREE.Geometry()
  for vector in vectors
    geometry.vertices.push(vector)

  if (lineType == 'DASHED')
    geometry.computeLineDistances()
    material = new THREE.LineDashedMaterial({linewidth: lineWidth, color: color, dashSize: 10, gapSize: 10})
  else
    material = new THREE.LineBasicMaterial({linewidth: lineWidth, color: color})

  lines = new THREE.Line(geometry, material, THREE.LinePieces)
  return lines

# Create a point sphere at the given coordinates
createPoint = (options) ->
  options = options or {}
  radius = options.radius or 5
  widthSegments = options.widthSegments or 32
  heightSegments = options.heightSegments or 32

  sphereGeometry = new THREE.SphereGeometry( radius, widthSegments, heightSegments )
  sphereMaterial = new THREE.MeshBasicMaterial()
  sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)
  return sphere

