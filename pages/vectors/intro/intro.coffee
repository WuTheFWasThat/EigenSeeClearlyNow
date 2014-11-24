# Intro: One Vector
INIT['vectors-intro'] = ->

  canvas = $("#canvas")

  # Setup scene, camera, renderer
  view = new View(canvas)

  # Vector with arrow
  vectorInput = new ReactiveVector().setFromInput('vectorInput')
  vector = new VectorView().setReactiveTrajectory vectorInput
  view.add vector

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.registerView view

  mouseHandler = new MouseHandler()
  mouseHandler.registerView view

  # animate!
  do view.animate
