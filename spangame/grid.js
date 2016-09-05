THREE.Grid = function(size, step, lineWidth) {
  var color, geometry, gridLineIndex, i, len, material, ref, x;
  lineWidth = lineWidth || 2;
  geometry = new THREE.Geometry();
  material = new THREE.LineBasicMaterial({
    vertexColors: THREE.VertexColors,
    linewidth: lineWidth
  });
  this.colorCenterLine = new THREE.Color(DEFAULT.GRID.COLOR_CENTER_LINE);
  this.colorGrid = new THREE.Color(DEFAULT.GRID.COLOR_GRID);
  ref = (function() {
    var j, ref, ref1, ref2, results;
    results = [];
    for (x = j = ref = -size, ref1 = size, ref2 = step; ref2 > 0 ? j <= ref1 : j >= ref1; x = j += ref2) {
      results.push(x);
    }
    return results;
  })();
  for (i = 0, len = ref.length; i < len; i++) {
    gridLineIndex = ref[i];
    if (gridLineIndex === 0) {

    } else {
      geometry.vertices.push(new THREE.Vector3(-size, 0, gridLineIndex), new THREE.Vector3(size, 0, gridLineIndex), new THREE.Vector3(gridLineIndex, 0, -size), new THREE.Vector3(gridLineIndex, 0, size));
      color = this.colorGrid;
      geometry.colors.push(color, color, color, color);
    }
  }
  return THREE.Line.call(this, geometry, material, THREE.LinePieces);
};

THREE.Grid.prototype = Object.create(THREE.Line.prototype);

THREE.Grid.prototype.setColors = function(colorCenterLine, colorGrid) {
  this.colorCenterLine.set(colorCenterLine);
  this.colorGrid.set(colorGrid);
  return this.geometry.colorsNeedUpdate = true;
};