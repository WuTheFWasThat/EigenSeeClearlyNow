################################################################################
# THREE.js helpers
################################################################################

# Extract vectors from THREE.Matrix3 (row-major form)
# where each vector is a row of the matrix
getVectorsFromMatrix = (matrix) ->
  vectors = []
  vectors.push new THREE.Vector3(matrix.n11, matrix.n12, matrix.n13)
  vectors.push new THREE.Vector3(matrix.n21, matrix.n22, matrix.n23)
  vectors.push new THREE.Vector3(matrix.n31, matrix.n32, matrix.n33)
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

################################################################################
# javascript event handling
################################################################################

cancelEvent = (e) ->
  do e.stopPropagation
  do e.preventDefault
  return false

################################################################################
# strings
################################################################################

String::format = ->
  newStr = this
  i = 0
  while /%s/.test(newStr)
      newStr = newStr.replace('%s', arguments[i++])
  return newStr

################################################################################
# numbers
################################################################################

# get a random integer between min and max, inclusive
Number.randInt = (min, max) ->
  return Math.floor(min + Math.random() * (max - min + 1))

################################################################################
# mathjax
################################################################################

vec2latex = (vector) ->
  return '\\left(\\begin{array}{c}' + vector.x + '\\\\' + vector.y + '\\\\' + vector.z + '\\end{array}\\right)'

