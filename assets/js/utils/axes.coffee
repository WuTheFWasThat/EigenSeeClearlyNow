# Axes-related functions

# Basic XYZ axes
buildAxes = (options) ->
  console.log 'dummy function'

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
