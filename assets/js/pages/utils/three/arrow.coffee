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

  lineGeometry = new THREE.Geometry()
  lineGeometry.vertices.push new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 1, 0)
  coneGeometry = new THREE.CylinderGeometry(0, 0.5, 1, 5, 1)
  coneGeometry.applyMatrix new THREE.Matrix4().makeTranslation(0, -0.5, 0)

  THREE.Arrow = (dir, origin, length, color, headLength, headWidth) ->
      # dir is assumed to be normalized
      THREE.Object3D.call this
      color = 0xffff00  if color is `undefined`
      length = 1  if length is `undefined`
      headLength = 0.2 * length  if headLength is `undefined`
      headWidth = 0.2 * headLength  if headWidth is `undefined`
      @position.copy origin
      @line = new THREE.Line(lineGeometry, new THREE.LineBasicMaterial(color: color))
      @line.matrixAutoUpdate = false
      @add @line
      @cone = new THREE.Mesh(coneGeometry, new THREE.MeshBasicMaterial(color: color))
      @cone.matrixAutoUpdate = false
      @add @cone
      @setDirection dir
      @setLength length, headLength, headWidth
      return

  THREE.Arrow:: = Object.create(THREE.Object3D::)

  axis = new THREE.Vector3()
  radians = undefined

  THREE.Arrow::setDirection = (dir) ->

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

  THREE.Arrow::setLength = (length, headLength, headWidth) ->
    headLength = 0.2 * length  if headLength is `undefined`
    headWidth = 0.2 * headLength  if headWidth is `undefined`
    @line.scale.set 1, length, 1
    @line.updateMatrix()
    @cone.scale.set headWidth, headLength, headWidth
    @cone.position.y = length
    @cone.updateMatrix()
    return

  THREE.Arrow::setColor = (color) ->
    @line.material.color.set color
    @cone.material.color.set color
    return

)()
