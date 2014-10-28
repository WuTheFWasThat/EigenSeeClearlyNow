###*
@author WestLangley / http://github.com/WestLangley
@author zz85 / http://github.com/zz85
@author bhouston / http://exocortex.com

Creates an arrow for visualizing directions

Parameters:
dir - Vector3
origin - Vector3
length - Number
color - color in hex value
headLength - Number
headWidth - Number
###

( ->

  THREE.Arrow = (dir, length, origin, color, headLength, headWidth, lineWidth) ->
      # dir is assumed to be normalized
      THREE.Object3D.call this
      color = if color? then color else DEFAULT.COLOR.ARROW
      lineWidth = lineWidth or 1

      lineGeometry = new THREE.Geometry()
      lineGeometry.vertices.push new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 1, 0)

      @position.copy origin
      @line = new THREE.Line(lineGeometry, new THREE.LineBasicMaterial(color: color, linewidth: lineWidth))
      @line.matrixAutoUpdate = false
      @add @line

      coneGeometry = new THREE.CylinderGeometry(0, 0.5, 1, 5, 1)
      coneGeometry.applyMatrix new THREE.Matrix4().makeTranslation(0, -0.5, 0)

      @cone = new THREE.Mesh(coneGeometry, new THREE.MeshBasicMaterial(color: color))
      @cone.matrixAutoUpdate = false
      @add @cone
      @setDirection dir

      @length = length or 1
      @headLength = headLength or 0.2 * length
      @headWidth = headWidth or 0.2 * headLength

      @setLength @length
      @setCone @headLength, @headWidth
      return

  THREE.Arrow:: = Object.create(THREE.Object3D::)

  THREE.Arrow::setDirection = (dir) ->
      axis = new THREE.Vector3()

      # dir is assumed to be normalized
      if dir.y > 0.99999
        @quaternion.set 0, 0, 0, 1
      else if dir.y < -0.99999
        @quaternion.set 1, 0, 0, 0
      else
        axis.set(dir.z, 0, -dir.x).normalize()
        radians = Math.acos(dir.y)
        @quaternion.setFromAxisAngle axis, radians
      return

  THREE.Arrow::setLength = (length) ->
    @length = length
    @line.scale.set 1, length, 1
    @line.updateMatrix()
    @cone.position.y = length
    @cone.updateMatrix()

  THREE.Arrow::setCone = (headLength, headWidth) ->
    @headLength = headLength
    @headWidth = headWidth
    @cone.scale.set headWidth, headLength, headWidth
    @cone.updateMatrix()
    return

  THREE.Arrow::setColor = (color) ->
    @line.material.color.set color
    @cone.material.color.set color
    return

)()
