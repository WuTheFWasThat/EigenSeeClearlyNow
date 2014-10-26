# Axes-related functions

# Basic XYZ axes (default colors: XYZ -> RGB)
buildAxes = (scene, axesLength) ->
  axisX = new Vector([axesLength, 0, 0], color: 0xFF0000)
  axisY = new Vector([0, axesLength, 0], color: 0x00FF00)
  axisZ = new Vector([0, 0, axesLength], color: 0x0000FF)
  axes = new THREE.Object3D()
  axes.add axisX.arrow
  axes.add axisY.arrow
  axes.add axisZ.arrow
  scene.add axes
  return

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
