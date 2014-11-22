# Matrices: Intro
INIT['matrices-intro'] = ->

  matrixOptions = (
    lineWidth: 4
  )

  matrixInput = new ReactiveMatrix().setFromInput('matrixInput')

  canvas = $("#canvas")
  view = new View(canvas)

  # Build lines given an array of THREE.Vector3
  buildLines = (vectors, lineType, color) ->
    # Make geometry
    geometry = new THREE.Geometry()
    for vector in vectors
      geometry.vertices.push(vector)

    # Make material
    material = new THREE.LineBasicMaterial({lineWidth: 1, color: color})

    # Update geometry and material if line type is dashed
    if (lineType == 'DASHED')
      geometry.computeLineDistances()
      material = new THREE.LineDashedMaterial({lineWidth: 1, color: color, dashSize: 10, gapSize: 10})

    lines = new THREE.Line(geometry, material, THREE.LinePieces)
    return lines

  # Vectors
  origin = new THREE.Vector3(0, 0, 0)
  u = new THREE.Vector3(60, 20, 20)
  v = new THREE.Vector3(20, 60, 20)
  w = new THREE.Vector3(20, 20, 60)

  # Draw parallelepiped
  vectors = [u, v, w]
  sumOfThree = u.clone().add(v).add(w)
  for v1 in vectors
    line = buildLines [origin, v1], 'SOLID', COLORS.LIGHT_YELLOW
    view.add line
    for v2 in vectors
      if !v1.equals(v2)
        sumOfTwo = v1.clone().add(v2)
        line = buildLines [v1, sumOfTwo], 'SOLID', DEFAULT.VECTOR.COLOR
        view.add line
        line = buildLines [sumOfTwo, sumOfThree], 'SOLID', DEFAULT.VECTOR.COLOR
        view.add line

  # bind inputs
  keyHandler = new KeyHandler()
  keyHandler.register_view view

  mouseHandler = new MouseHandler()
  mouseHandler.register_view view

  # animate!
  do view.animate
