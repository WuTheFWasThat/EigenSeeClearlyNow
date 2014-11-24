# Matrices: Intro
INIT['matrices-intro'] = ->

  matrixInput = new ReactiveMatrix().setFromInput('matrixInput')

  canvas = $('#canvas')
  view = new View(canvas)

  # Draw faces and edges of matrix parallelepiped
  matrixView = new MatrixView({matrix: matrixInput.matrix})
  matrixView.drawMatrix view

  # Bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerView view

  mouseHandler = new MouseHandler()
  mouseHandler.registerView view

  # Animate!
  do view.animate
