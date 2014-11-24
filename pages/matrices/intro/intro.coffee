# Matrices: Intro
INIT['matrices-intro'] = ->

  matrixOptions = (
    lineWidth: 4
  )

  matrixInput = new ReactiveMatrix().setFromInput('matrixInput')
  [rowX, rowY, rowZ] = do matrixInput.getReactiveRows

  canvas = $("#canvas")
  view = new View(canvas)

  # Vectors
  origin = new THREE.Vector3(0, 0, 0)
  u = rowX.vector
  v = rowY.vector
  w = rowZ.vector

  # Draw faces and edges of matrix parallelepiped
  matrixView = new MatrixView()
  matrixView.drawMatrix view, origin, u, v, w

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerView view

  mouseHandler = new MouseHandler()
  mouseHandler.registerView view

  # animate!
  do view.animate
