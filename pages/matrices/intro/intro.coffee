# Matrices: Intro
INIT['matrices-intro'] = ->

  canvas = $('#canvas')
  view = new View(canvas)

  # Draw faces and edges of matrix parallelepiped
  matrixInput = new ReactiveMatrix().setFromInput('matrixInput')
  matrixView = new MatrixView(matrix: matrixInput)
  view.add matrixView

  # Bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerView view

  mouseHandler = new MouseHandler()
  mouseHandler.registerView view

  # Animate!
  do view.animate
