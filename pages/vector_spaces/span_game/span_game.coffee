# Addition: Adding two vectors
INIT['vector_spaces-span_game'] = ->

  canvas = $("#canvas")
  view = new View(canvas)
  view.addAxes(
    colors: [COLORS.RED, COLORS.GREEN, COLORS.BLUE]
  )

  vectorOptions = (
    lineWidth: 4
    headWidth: 12
    headLength: 10
  )


  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate

