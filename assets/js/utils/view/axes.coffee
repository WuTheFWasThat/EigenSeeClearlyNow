# Axes in a 3D plane
class Axes
  constructor: (options) ->
    options = options or {}

    @axesLength = options.axesLength or DEFAULT.AXIS.LENGTH
    colors = DEFAULT.AXIS.COLORS
    if options.color
      colors = [options.color, options.color, options.color]
    else if options.colors
      colors = options.colors

    @axisX = @buildAxis 'X', [@axesLength, 0, 0], colors[0]
    @axisY = @buildAxis 'Y', [0, @axesLength, 0], colors[1]
    @axisZ = @buildAxis 'Z', [0, 0, @axesLength], colors[2]

    @axes = new THREE.Object3D()
    @axes.add @axisX
    @axes.add @axisY
    @axes.add @axisZ
    do @buildGrids

  drawOn: (view) ->
    view.scene.add @axes

  # Full axis with label
  buildAxis: (axisLabel, axisCoords, axisColor) ->
    posAxis = @buildPositiveAxis axisLabel, axisCoords, axisColor
    negAxis = @buildNegativeAxis axisCoords, axisColor
    fullAxis = new THREE.Object3D()
    fullAxis.add posAxis
    fullAxis.add negAxis
    return fullAxis

  # Positive axis is a solid vector with text label
  buildPositiveAxis: (axisLabel, axisCoords, axisColor) ->
    axisVector = new VectorView(color: axisColor).set_trajectory axisCoords
    label = @buildAxisLabel axisLabel, axisVector
    axis = new THREE.Object3D()
    axis.add axisVector.arrow
    axis.add label
    return axis

  # Negative axis is a dashed line
  buildNegativeAxis: (axisCoords, axisColor) ->
    axisLine = new THREE.LineDashedMaterial({lineWidth: 1, color: axisColor, dashSize: 10, gapSize: 10})
    axisGeometry = new THREE.Geometry()
    axisGeometry.vertices.push(new THREE.Vector3(0, 0, 0))
    axisGeometry.vertices.push(new THREE.Vector3(-axisCoords[0], -axisCoords[1], -axisCoords[2]))
    axisGeometry.computeLineDistances()
    axis = new THREE.Line(axisGeometry, axisLine, THREE.LinePieces)
    return axis

  # Basic axis label
  buildAxisLabel: (labelText, axis) ->
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
  buildGrids: (options) ->

    # TODO use grids or not?
    options = options or {}

    gridLength = options.gridLength or @axesLength
    numDividers = options.numDividers or 10
    gridStep = gridLength / numDividers
    gridColor = DEFAULT.GRID.COLOR

    gridXZ = new THREE.Grid(gridLength, gridStep)
    gridXZ.position = new THREE.Vector3(0, 0, 0)
    gridXZ.rotation = new THREE.Euler(0, 0, 0)
    gridXZ.setColors gridColor, gridColor
    @axes.add gridXZ

    #gridXY = gridXZ.clone()
    #gridXY.rotation.x = Math.PI / 2
    #@axes.add gridXY

    #gridYZ = gridXZ.clone()
    #gridYZ.rotation.z = Math.PI / 2
    #@axes.add gridYZ

    return
