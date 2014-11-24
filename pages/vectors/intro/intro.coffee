# Intro: One Vector
INIT['vectors-intro'] = ->

  canvas = $('#canvas')
  view = new View(canvas)

  # Draw vector as an arrow
  vectorInput = new ReactiveVector().setFromInput('vectorInput')
  vector = new VectorView(trajectory: vectorInput)
  view.add vector

  # Bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerView view

  mouseHandler = new MouseHandler()
  mouseHandler.registerView view

  # Animate!
  do view.animate
