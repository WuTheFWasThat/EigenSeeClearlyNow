################################################################################
# THREE.js helpers
################################################################################

# Extract vectors from THREE.Matrix3 (row-major form)
# where each vector is a row of the matrix
THREE.Matrix3.prototype.getRows = () ->
  vectors = []
  vectors.push new THREE.Vector3 @n11, @n12, @n13
  vectors.push new THREE.Vector3 @n21, @n22, @n23
  vectors.push new THREE.Vector3 @n31, @n32, @n33
  return vectors


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

