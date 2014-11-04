THREE.Grid = (size, step) ->

  geometry = new THREE.Geometry()
  material = new THREE.LineBasicMaterial(vertexColors: THREE.VertexColors )

  this.color1 = new THREE.Color( 0x444444 )
  this.color2 = new THREE.Color( 0x888888 )

  for i in (x for x in [-size..size] by step)

    geometry.vertices.push(
      new THREE.Vector3( - size, 0, i ), new THREE.Vector3( size, 0, i ),
      new THREE.Vector3( i, 0, - size ), new THREE.Vector3( i, 0, size )
    )

    color = if (i == 0) then @color1 else @color2

    geometry.colors.push color, color, color, color

  THREE.Line.call @, geometry, material, THREE.LinePieces

THREE.Grid:: = Object.create(THREE.Line::)

THREE.Grid::.setColors = ( colorCenterLine, colorGrid ) ->

  @color1.set colorCenterLine
  @color2.set colorGrid

  @geometry.colorsNeedUpdate = true
