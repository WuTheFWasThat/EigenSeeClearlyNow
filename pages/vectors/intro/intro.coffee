# Intro: One Vector
INIT['vectors-intro'] = ->

  canvas = $("#canvas")

  # Setup scene, camera, renderer
  view = new View(canvas)

  vectorOptions = (
    lineWidth: 3
    headWidth: 12
    headLength: 10
  )

  # Vector with arrow

  vectorInput = new ReactiveVector().setFromInput('vectorInput')
  vector = new VectorView(vectorOptions).setReactiveTrajectory vectorInput
  view.add vector

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerView view

  mouseHandler = new MouseHandler()
  mouseHandler.registerView view

  # animate!
  do view.animate
