################################################################################
# THREE.js helpers
################################################################################

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
  material = new THREE.LineBasicMaterial({linewidth: lineWidth, color: color})
  if (lineType == 'DASHED')
    geometry.computeLineDistances()
    material = new THREE.LineDashedMaterial({linewidth: lineWidth, color: color, dashSize: 10, gapSize: 10})
  lines = new THREE.Line(geometry, material, THREE.LinePieces)
  return lines

