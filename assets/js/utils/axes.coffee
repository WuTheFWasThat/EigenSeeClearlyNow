# Axes-related functions

# Basic XYZ axes (default colors: XYZ -> RGB)
buildAxes = (scene, options) ->
  options = options or {}
  axesLength = options.axesLength or 200
  colors = [DEFAULT.COLOR.AXIS, DEFAULT.COLOR.AXIS, DEFAULT.COLOR.AXIS]
  if options.color
    colors = [options.color, options.color, options.color]
  else if options.colors
    colors = options.colors

  axisX = buildAxis 'X', [axesLength, 0, 0], colors[0]
  axisY = buildAxis 'Y', [0, axesLength, 0], colors[1]
  axisZ = buildAxis 'Z', [0, 0, axesLength], colors[2]

  axes = new THREE.Object3D()
  axes.add axisX
  axes.add axisY
  axes.add axisZ
  scene.add axes
  return

# Basic axis with label
buildAxis = (axisLabel, axisCoords, axisColor) ->
  axisVector = new Vector(axisCoords, color: axisColor)
  label = buildAxisLabel axisLabel, axisVector
  axis = new THREE.Object3D()
  axis.add axisVector.arrow
  axis.add label
  return axis

# Basic axis label
buildAxisLabel = (labelText, axis) ->
  defaultLabelOptions = {
    size: 10,
    height: 4,
    curveSegments: 6,
    font: "helvetiker",
    style: "normal"
  }
  textGeometry = new THREE.TextGeometry(labelText, defaultLabelOptions)
  textMaterial = new THREE.MeshBasicMaterial({color: axis.color})
  text = new THREE.Mesh(textGeometry, textMaterial)
  textOffset = 30
  text.position.x = axis.trajectory.x + (if labelText == 'X' then textOffset else 0)
  text.position.y = axis.trajectory.y + (if labelText == 'Y' then textOffset else 0)
  text.position.z = axis.trajectory.z + (if labelText == 'Z' then textOffset else 0)
  # TODO text.rotation = camera.rotation...
  return text

# Basic XYZ grids
buildGrids = (scene, gridSize, gridStep, gridColor) ->
  gridXZ = new THREE.GridHelper(gridSize, gridStep)
  gridXZ.position = new THREE.Vector3(0, 0, 0)
  gridXZ.rotation = new THREE.Euler(0, 0, 0)
  gridXZ.setColors gridColor, gridColor
  scene.add gridXZ

  #gridXY = gridXZ.clone()
  #gridXY.rotation.x = Math.PI / 2
  #scene.add gridXY

  #gridYZ = gridXZ.clone()
  #gridYZ.rotation.z = Math.PI / 2
  #scene.add gridYZ

  return
