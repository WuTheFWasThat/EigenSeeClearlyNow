THREE.Grid = (size, step) ->

  geometry = new THREE.Geometry()
  material = new THREE.LineBasicMaterial(vertexColors: THREE.VertexColors )

  @colorCenterLine = new THREE.Color(DEFAULT.GRID.COLOR_CENTER_LINE)
  @colorGrid = new THREE.Color(DEFAULT.GRID.COLOR_GRID)

  for gridLineIndex in (x for x in [-size..size] by step)

    if (gridLineIndex == 0)
      # TODO use @colorCenterLine
    else
      geometry.vertices.push(
        new THREE.Vector3( - size, 0, gridLineIndex ), new THREE.Vector3( size, 0, gridLineIndex ),
        new THREE.Vector3( gridLineIndex, 0, - size ), new THREE.Vector3( gridLineIndex, 0, size )
      )

      color = @colorGrid

      geometry.colors.push color, color, color, color

  THREE.Line.call @, geometry, material, THREE.LinePieces

THREE.Grid:: = Object.create(THREE.Line::)

THREE.Grid::.setColors = ( colorCenterLine, colorGrid ) ->

  @colorCenterLine.set colorCenterLine
  @colorGrid.set colorGrid

  @geometry.colorsNeedUpdate = true
