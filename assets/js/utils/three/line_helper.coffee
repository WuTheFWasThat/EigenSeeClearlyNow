# Make a series of lines
buildLines = (vectors, lineType, color) ->
  # Make geometry
  geometry = new THREE.Geometry()
  for vector in vectors
    geometry.vertices.push(vector)

  # Make material
  material = new THREE.LineBasicMaterial({lineWidth: 1, color: color})

  # Update geometry and material if line type is dashed
  if (lineType == 'DASHED')
    geometry.computeLineDistances()
    material = new THREE.LineDashedMaterial({lineWidth: 1, color: color, dashSize: 10, gapSize: 10})
  lines = new THREE.Line(geometry, material, THREE.LineStrip)
  return lines


# Make a dashed line
buildDashedLine = (u, v, color) ->
  material = new THREE.LineDashedMaterial({lineWidth: 1, color: color, dashSize: 10, gapSize: 10})
  geometry = new THREE.Geometry()
  geometry.vertices.push(u)
  geometry.vertices.push(v)
  geometry.computeLineDistances()
  dashedLine = new THREE.Line(geometry, material, THREE.LinePieces)
  return dashedLine
