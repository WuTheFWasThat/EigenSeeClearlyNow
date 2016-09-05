
/**
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
 */
THREE.Arrow = function(options) {
  var color, coneGeometry, direction, headLength, headWidth, length, lineGeometry, lineWidth, offset;
  THREE.Object3D.call(this);
  options = options || {};
  lineGeometry = new THREE.Geometry();
  lineGeometry.vertices.push(new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 1, 0));
  offset = options.offset || new THREE.Vector3();
  this.setOffset(offset);
  lineWidth = options.lineWidth != null ? options.lineWidth : 1;
  this.line = new THREE.Line(lineGeometry, new THREE.LineBasicMaterial({
    linewidth: lineWidth
  }));
  this.line.matrixAutoUpdate = false;
  this.add(this.line);
  coneGeometry = new THREE.CylinderGeometry(0, 0.5, 1, 16, 1);
  coneGeometry.applyMatrix(new THREE.Matrix4().makeTranslation(0, -0.5, 0));
  this.cone = new THREE.Mesh(coneGeometry, new THREE.MeshBasicMaterial());
  this.cone.matrixAutoUpdate = false;
  this.add(this.cone);
  direction = options.direction != null ? options.direction : new THREE.Vector3();
  this.setDirection(direction);
  color = options.color != null ? options.color : void 0;
  this.setColor(color);
  length = options.length != null ? options.length : 1;
  this.setLength(length);
  headLength = options.headLength != null ? options.headLength : 0;
  headWidth = options.headWidth != null ? options.headWidth : 0;
  this.setCone(headLength, headWidth);
};

THREE.Arrow.prototype = Object.create(THREE.Object3D.prototype);

THREE.Arrow.prototype.setDirection = function(dir) {
  var axis, radians;
  axis = new THREE.Vector3();
  if (dir.y > 0.99999) {
    this.quaternion.set(0, 0, 0, 1);
  } else if (dir.y < -0.99999) {
    this.quaternion.set(1, 0, 0, 0);
  } else {
    axis.set(dir.z, 0, -dir.x).normalize();
    radians = Math.acos(dir.y);
    this.quaternion.setFromAxisAngle(axis, radians);
  }
  return this;
};

THREE.Arrow.prototype.setLength = function(length) {
  this.length = length;
  this.line.scale.set(1, length - this.headLength, 1);
  this.line.updateMatrix();
  this.cone.position.y = length;
  this.cone.updateMatrix();
  this.cone.visible = (length > 0) && (this.headWidth > 0) && (this.headLength > 0);
  this.line.visible = length > 0;
  return this;
};

THREE.Arrow.prototype.setOffset = function(offset) {
  this.position.copy(offset);
  return this;
};

THREE.Arrow.prototype.setCone = function(headLength, headWidth) {
  this.headLength = headLength;
  this.headWidth = headWidth;
  this.cone.scale.set(headWidth, headLength, headWidth);
  this.cone.updateMatrix();
  return this;
};

THREE.Arrow.prototype.setColor = function(color) {
  this.line.material.color.set(color);
  this.cone.material.color.set(color);
  return this;
};

THREE.Arrow.prototype.setLineWidth = function(lineWidth) {
  this.line.material.linewidth = lineWidth;
  return this;
};

THREE.Arrow.prototype.setHeadWidth = function(headWidth) {
  this.setCone(this.headLength, headWidth);
  return this;
};

THREE.Arrow.prototype.setHeadLength = function(headLength) {
  this.setCone(headLength, this.headWidth);
  return this;
};