var buildLines, createPoint;

THREE.Vector3.prototype.randomize = function(fn) {
  return this.set(fn('x'), fn('y'), fn('z'));
};

THREE.Matrix3.prototype.randomize = function(fn) {
  return this.set(fn('x', 'x'), fn('x', 'y'), fn('x', 'z'), fn('y', 'x'), fn('y', 'y'), fn('y', 'z'), fn('z', 'x'), fn('z', 'y'), fn('z', 'z'));
};

THREE.Matrix3.prototype.getColumns = function() {
  var vectors;
  vectors = [];
  vectors.push(new THREE.Vector3(this.elements[0], this.elements[1], this.elements[2]));
  vectors.push(new THREE.Vector3(this.elements[3], this.elements[4], this.elements[5]));
  vectors.push(new THREE.Vector3(this.elements[6], this.elements[7], this.elements[8]));
  return vectors;
};

THREE.Matrix3.prototype.getRows = function() {
  var vectors;
  vectors = [];
  vectors.push(new THREE.Vector3(this.elements[0], this.elements[3], this.elements[6]));
  vectors.push(new THREE.Vector3(this.elements[1], this.elements[4], this.elements[7]));
  vectors.push(new THREE.Vector3(this.elements[2], this.elements[5], this.elements[8]));
  return vectors;
};

THREE.Matrix3.prototype.setFromRows = function(rowX, rowY, rowZ) {
  this.set(rowX.x, rowY.x, rowZ.x, rowX.y, rowY.y, rowZ.y, rowX.z, rowY.z, rowZ.z);
  return this;
};

THREE.Matrix3.prototype.setFromColumns = function(colX, colY, colZ) {
  this.set(colX.x, colX.y, colX.z, colY.x, colY.y, colY.z, colZ.x, colZ.y, colZ.z);
  return this;
};

buildLines = function(vectors, options) {
  var color, geometry, i, len, lineType, lineWidth, lines, material, vector;
  options = options || {};
  color = options.color || DEFAULT.VECTOR.COLOR;
  lineType = options.lineType || 'SOLID';
  lineWidth = options.lineWidth || 1;
  geometry = new THREE.Geometry();
  for (i = 0, len = vectors.length; i < len; i++) {
    vector = vectors[i];
    geometry.vertices.push(vector);
  }
  if (lineType === 'DASHED') {
    geometry.computeLineDistances();
    material = new THREE.LineDashedMaterial({
      linewidth: lineWidth,
      color: color,
      dashSize: 10,
      gapSize: 10
    });
  } else {
    material = new THREE.LineBasicMaterial({
      linewidth: lineWidth,
      color: color
    });
  }
  lines = new THREE.Line(geometry, material, THREE.LinePieces);
  return lines;
};

createPoint = function(options) {
  var heightSegments, radius, sphere, sphereGeometry, sphereMaterial, widthSegments;
  options = options || {};
  radius = options.radius || 5;
  widthSegments = options.widthSegments || 32;
  heightSegments = options.heightSegments || 32;
  sphereGeometry = new THREE.SphereGeometry(radius, widthSegments, heightSegments);
  sphereMaterial = new THREE.MeshBasicMaterial();
  sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
  return sphere;
};