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

THREE.Arrow = (options) ->
    # dir is assumed to be normalized
    THREE.Object3D.call this

    options = options or {}

    lineGeometry = new THREE.Geometry()
    lineGeometry.vertices.push new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 1, 0)

    offset = options.offset or new THREE.Vector3()
    @setOffset offset

    lineWidth = if options.lineWidth? then options.lineWidth else 1
    @line = new THREE.Line lineGeometry, new THREE.LineBasicMaterial(linewidth: lineWidth)
    @line.matrixAutoUpdate = false
    @add @line

    # radiusTop, radiusBottom, height, radiusSegments, heightSegments, openEnded
    coneGeometry = new THREE.CylinderGeometry(0, 0.5, 1, 16, 1)
    coneGeometry.applyMatrix new THREE.Matrix4().makeTranslation(0, -0.5, 0)

    @cone = new THREE.Mesh coneGeometry, new THREE.MeshBasicMaterial()
    @cone.matrixAutoUpdate = false
    @add @cone

    direction = if options.direction? then options.direction else new THREE.Vector3()
    @setDirection direction

    color = if options.color? then options.color else
    @setColor color

    length = if options.length? then options.length else 1
    @setLength length

    headLength = if options.headLength? then options.headLength else 0
    headWidth = if options.headWidth? then options.headWidth else 0
    @setCone headLength, headWidth
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
    return @

THREE.Arrow::setLength = (length) ->
  @length = length
  @line.scale.set 1, (length-@headLength), 1
  @line.updateMatrix()
  @cone.position.y = length
  @cone.updateMatrix()

  @cone.visible = (length > 0)
  @line.visible = (length > 0)
  return @

THREE.Arrow::setOffset = (offset) ->
  @position.copy offset
  return @

THREE.Arrow::setCone = (headLength, headWidth) ->
  @headLength = headLength
  @headWidth = headWidth
  @cone.scale.set headWidth, headLength, headWidth
  @cone.updateMatrix()
  return @

THREE.Arrow::setColor = (color) ->
  @line.material.color.set color
  @cone.material.color.set color
  return @

# NOTE: this doesnt update it right away
THREE.Arrow::setLineWidth = (lineWidth) ->
  @line.material.linewidth = lineWidth
  return @

THREE.Arrow::setHeadWidth = (headWidth) ->
  @setCone @headLength, headWidth
  return @

THREE.Arrow::setHeadLength = (headLength) ->
  @setCone headLength, @headWidth
  return @
