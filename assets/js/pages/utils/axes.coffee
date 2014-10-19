# Axes-related functions

# Basic XYZ axes
buildAxes = (options) ->
  console.log 'dummy function'

# Basic XYZ grids
buildGrids = (scene, gridSize, gridStep, gridColor) ->
  grid1 = new THREE.GridHelper(gridSize, gridStep)
  grid1.position = new THREE.Vector3(0, 0, 0)
  grid1.rotation = new THREE.Euler(0, 0, 0)
  grid1.setColors gridColor, gridColor
  scene.add grid1

  grid2 = grid1.clone()
  grid2.rotation = new THREE.Euler(0, 0, Math.PI / 2)
  scene.add grid2

  grid3 = grid1.clone()
  grid3.rotation = new THREE.Euler(Math.PI / 2, 0, Math.PI / 2)
  scene.add grid3

  return
