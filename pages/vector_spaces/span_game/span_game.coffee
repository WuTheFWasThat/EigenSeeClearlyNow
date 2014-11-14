# Span Game: Reach a point
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

  createPoint = (x, y, z) ->
    sphereGeometry = new THREE.SphereGeometry( 5, 20, 20 )
    sphereMaterial = new THREE.MeshBasicMaterial( {color: COLORS.YELLOW} )
    sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)
    sphere.position.set x, y, z
    return sphere

  point = createPoint(50, 62, -45)
  view.add point

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate

