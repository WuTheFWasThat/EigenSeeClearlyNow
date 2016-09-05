THREE.Parallelogram = function(u, v, options) {
  var color, i, offset, opacity;
  options = options || {};
  color = options.color != null ? options.color : 0x000000;
  opacity = options.opacity != null ? options.opacity : 0.5;
  this.geometry = new THREE.PlaneGeometry();
  this.geometry.verticesNeedUpdate = true;
  this.geometry.elementsNeedUpdate = true;
  this.geometry.vertices = (function() {
    var j, results;
    results = [];
    for (i = j = 0; j < 4; i = ++j) {
      results.push(new THREE.Vector3());
    }
    return results;
  })();
  this.u = u || new THREE.Vector3();
  this.v = v || new THREE.Vector3();
  this.updateVertices();
  this.material = new THREE.MeshBasicMaterial();
  this.material.side = THREE.DoubleSide;
  this.material.transparent = true;
  this.setOpacity(opacity);
  this.setColor(color);
  THREE.Mesh.call(this, this.geometry, this.material);
  offset = options.offset || new THREE.Vector3();
  return this.setOffset(offset);
};

THREE.Parallelogram.prototype = Object.create(THREE.Mesh.prototype);

THREE.Parallelogram.prototype.updateVertices = function() {
  var ref, v1, v2, v3, v4;
  ref = this.geometry.vertices, v1 = ref[0], v2 = ref[1], v3 = ref[2], v4 = ref[3];
  v1.set(0, 0, 0);
  v2.copy(this.u);
  v3.copy(this.v);
  v4.addVectors(this.u, this.v);
  return this.geometry.verticesNeedUpdate = true;
};

THREE.Parallelogram.prototype.setOffset = function(offset) {
  this.offset = offset;
  this.position.copy(offset);
  return this;
};

THREE.Parallelogram.prototype.setVectors = function(u, v) {
  this.u = u;
  this.v = v;
  return this.updateVertices();
};

THREE.Parallelogram.prototype.setColor = function(color) {
  this.color = color;
  return this.material.color = new THREE.Color(this.color);
};

THREE.Parallelogram.prototype.setOpacity = function(opacity) {
  this.opacity = opacity;
  return this.material.opacity = this.opacity;
};