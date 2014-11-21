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
buildDashedLine = (offset, coords, color) ->
  material = new THREE.LineDashedMaterial({lineWidth: 1, color: color, dashSize: 10, gapSize: 10})
  geometry = new THREE.Geometry()
  geometry.vertices.push(new THREE.Vector3(offset[0], offset[1], offset[2]))
  geometry.vertices.push(new THREE.Vector3(coords[0], coords[1], coords[2]))
  geometry.computeLineDistances()
  dashedLine = new THREE.Line(geometry, material, THREE.LinePieces)
  return dashedLine
