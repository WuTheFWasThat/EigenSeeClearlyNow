
vectorize = (vector) ->
  if 'x' of vector and 'y' of vector and 'z' of vector
    return vector
  if vector.length == 3
    return {x: vector[0], y: vector[1], z: vector[2]}

class Vector
  constructor: (vector, options) ->
      options = options or {}

      # represents the direction
      @vector = vectorize(vector)

      # represents the start point of the vector
      offset = options.offset or {x: 0, y:0, z:0}
      @offset = vectorize(offset)

      # three.js material

      material_options = options.material or {color: 0xffaaaa}
      @material = new THREE.LineBasicMaterial(material_options)

      # three.js geometry

      @start = new THREE.Vector3(0, 0, 0)
      @end = new THREE.Vector3(0, 0, 0)

      @geometry = new THREE.Geometry()
      @geometry.vertices.push(@start)
      @geometry.vertices.push(@end)
      do @set_geometry

      # three.js line

      @line = new THREE.Line(@geometry, @material)

  # todo: make this private
  # update the geometry so that the line redraws correctly
  set_geometry: () ->
      @start.x = @offset.x
      @start.y = @offset.y
      @start.z = @offset.z
      @end.x = @offset.x + @vector.x
      @end.y = @offset.y + @vector.y
      @end.z = @offset.z + @vector.z

  set_coordinates: (x, y, z) ->
      @vector.x = x
      @vector.y = y
      @vector.z = z
      do @set_geometry

  # draw!
  draw_on: (scene) ->
      scene.add @line
