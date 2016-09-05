THREE.Parallelepiped = function(u, v, w, options) {
  var edge, face, faceColor, geometry, i, j, k, l, len, len1, material, offset, opacity, ref, ref1;
  THREE.Object3D.call(this);
  options = options || {};
  this.u = u || new THREE.Vector3();
  this.v = v || new THREE.Vector3();
  this.w = w || new THREE.Vector3();
  this.faces = (function() {
    var j, results;
    results = [];
    for (i = j = 0; j < 6; i = ++j) {
      results.push(new THREE.Parallelogram());
    }
    return results;
  })();
  this.edges = [];
  for (i = j = 0; j < 12; i = ++j) {
    geometry = new THREE.Geometry();
    geometry.vertices.push(new THREE.Vector3());
    geometry.vertices.push(new THREE.Vector3());
    material = new THREE.LineBasicMaterial();
    edge = new THREE.Line(geometry, material, THREE.LinePieces);
    this.edges.push(edge);
  }
  offset = options.offset || new THREE.Vector3();
  this.setOffset(offset);
  this.updateFaces();
  this.updateEdges();
  faceColor = options.faceColor != null ? options.faceColor : 0x000000;
  this.setFaceColor(faceColor);
  opacity = options.opacity != null ? options.opacity : 0.5;
  this.setOpacity(opacity);
  ref = this.faces;
  for (k = 0, len = ref.length; k < len; k++) {
    face = ref[k];
    this.add(face);
  }
  ref1 = this.edges;
  for (l = 0, len1 = ref1.length; l < len1; l++) {
    edge = ref1[l];
    this.add(edge);
  }
};

THREE.Parallelepiped.prototype = Object.create(THREE.Object3D.prototype);

THREE.Parallelepiped.prototype.updateEdges = function() {
  var color, edgeColors, i, j, origin, sum, sumOfThree, v1, v2, v3, vectors;
  origin = new THREE.Vector3();
  vectors = [this.u, this.v, this.w];
  sumOfThree = this.u.clone().add(this.v).add(this.w);
  edgeColors = [COLORS.RED, COLORS.GREEN, COLORS.BLUE];
  for (i = j = 0; j < 3; i = ++j) {
    v1 = vectors[i];
    v2 = vectors[(i + 1) % 3];
    v3 = vectors[(i + 2) % 3];
    sum = new THREE.Vector3().addVectors(v2, v3);
    color = edgeColors[i];
    this.setEdge(4 * i + 0, origin, v1, {
      color: color,
      lineWidth: 40
    });
    this.setEdge(4 * i + 1, v2, v1, {
      color: color,
      lineWidth: 1
    });
    this.setEdge(4 * i + 2, v3, v1, {
      color: color,
      lineWidth: 1
    });
    this.setEdge(4 * i + 3, sum, v1, {
      color: color,
      lineWidth: 1
    });
  }
};

THREE.Parallelepiped.prototype.setEdge = function(i, p1, d, options) {
  var color, edge, lineWidth, ref, v1, v2;
  edge = this.edges[i];
  ref = edge.geometry.vertices, v1 = ref[0], v2 = ref[1];
  v1.copy(p1);
  v2.copy(p1).add(d);
  edge.geometry.verticesNeedUpdate = true;
  options = options || {};
  color = options.color || DEFAULT.VECTOR.COLOR;
  edge.material.color = new THREE.Color(color);
  lineWidth = options.lineWidth || 1;
  edge.material.linewidth = lineWidth;
};

THREE.Parallelepiped.prototype.setOffset = function(offset) {
  this.offset = offset;
  this.position.copy(offset);
  return this;
};

THREE.Parallelepiped.prototype.updateFaces = function() {
  var face, i, j, results, v1, v2, v3, vertices;
  vertices = [this.u, this.v, this.w];
  results = [];
  for (i = j = 0; j < 3; i = ++j) {
    v1 = vertices[i];
    v2 = vertices[(i + 1) % 3];
    v3 = vertices[(i + 2) % 3];
    face = this.faces[2 * i];
    face.setVectors(v1, v2);
    face = this.faces[2 * i + 1];
    face.setOffset(v3);
    results.push(face.setVectors(v1, v2));
  }
  return results;
};

THREE.Parallelepiped.prototype.setVectors = function(u, v, w) {
  this.u = u;
  this.v = v;
  this.w = w;
  this.updateFaces();
  return this.updateEdges();
};

THREE.Parallelepiped.prototype.setFaceColor = function(color) {
  var face, j, len, ref, results;
  this.faceColor = color;
  ref = this.faces;
  results = [];
  for (j = 0, len = ref.length; j < len; j++) {
    face = ref[j];
    results.push(face.setColor(this.faceColor));
  }
  return results;
};

THREE.Parallelepiped.prototype.setOpacity = function(opacity) {
  var face, j, len, ref, results;
  this.opacity = opacity;
  ref = this.faces;
  results = [];
  for (j = 0, len = ref.length; j < len; j++) {
    face = ref[j];
    results.push(face.setOpacity(this.opacity));
  }
  return results;
};