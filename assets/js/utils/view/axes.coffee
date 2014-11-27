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

    @axisX = @buildAxis 'X', @axesLength, colors[0]
    @axisY = @buildAxis 'Y', @axesLength, colors[1]
    @axisZ = @buildAxis 'Z', @axesLength, colors[2]

    @axes = new THREE.Object3D()
    @axes.add @axisX
    @axes.add @axisY
    @axes.add @axisZ
    do @buildGrids

  drawOn: (view) ->
    view.scene.add @axes

  # Full axis with label
  buildAxis: (axisLabel, axisLength, axisColor) ->
    posAxis = @buildPositiveAxis axisLabel, axisLength, axisColor
    negAxis = @buildNegativeAxis axisLabel, axisLength, axisColor
    fullAxis = new THREE.Object3D()
    fullAxis.add posAxis
    fullAxis.add negAxis
    return fullAxis

  # Positive axis is a solid vector with text label
  buildPositiveAxis: (axisLabel, axisLength, axisColor) ->
    vector = new THREE.Vector3()
    vector[axisLabel.toLowerCase()] = axisLength
    axisVector = new VectorView(color: axisColor, trajectory: vector)
    label = @buildAxisLabel axisLabel, axisVector
    axis = new THREE.Object3D()
    axis.add axisVector.arrow
    axis.add label
    return axis

  # Negative axis is a dashed line
  buildNegativeAxis: (axisLabel, axisLength, axisColor) ->
    vector = new THREE.Vector3()
    vector[axisLabel.toLowerCase()] = -axisLength
    origin = new THREE.Vector3()
    axis = buildDashedLine origin, vector, axisColor
    return axis
    #axisVector = new VectorView(color: axisColor, trajectory: vector, headWidth: 0, headLength: 0, lineWidth: 1)
    #return axisVector.arrow

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
