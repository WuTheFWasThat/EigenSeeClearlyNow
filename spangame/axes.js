var Axes;

Axes = (function() {
  function Axes(options) {
    var colors;
    options = options || {};
    this.axesLength = options.axesLength || DEFAULT.AXIS.LENGTH;
    colors = DEFAULT.AXIS.COLORS;
    if (options.color) {
      colors = [options.color, options.color, options.color];
    } else if (options.colors) {
      colors = options.colors;
    }
    this.axisX = this.buildAxis('X', this.axesLength, colors[0]);
    this.axisY = this.buildAxis('Y', this.axesLength, colors[1]);
    this.axisZ = this.buildAxis('Z', this.axesLength, colors[2]);
    this.axes = new THREE.Object3D();
    this.axes.add(this.axisX);
    this.axes.add(this.axisY);
    this.axes.add(this.axisZ);
    this.buildGrids();
  }

  Axes.prototype.drawOn = function(view) {
    return view.scene.add(this.axes);
  };

  Axes.prototype.buildAxis = function(axisLabel, axisLength, axisColor) {
    var fullAxis, negAxis, posAxis;
    posAxis = this.buildPositiveAxis(axisLabel, axisLength, axisColor);
    negAxis = this.buildNegativeAxis(axisLabel, axisLength, axisColor);
    fullAxis = new THREE.Object3D();
    fullAxis.add(posAxis);
    fullAxis.add(negAxis);
    return fullAxis;
  };

  Axes.prototype.buildPositiveAxis = function(axisLabel, axisLength, axisColor) {
    var axis, axisVector, label, vector;
    vector = new THREE.Vector3();
    vector[axisLabel.toLowerCase()] = axisLength;
    axisVector = new VectorView({
      color: axisColor,
      trajectory: vector
    });
    label = this.buildAxisLabel(axisLabel, axisVector);
    axis = new THREE.Object3D();
    axis.add(axisVector.arrow);
    axis.add(label);
    return axis;
  };

  Axes.prototype.buildNegativeAxis = function(axisLabel, axisLength, axisColor) {
    var axis, origin, vector;
    vector = new THREE.Vector3();
    vector[axisLabel.toLowerCase()] = -axisLength;
    origin = new THREE.Vector3();
    axis = buildLines([origin, vector], {
      color: axisColor,
      lineType: 'DASHED'
    });
    return axis;
  };

  Axes.prototype.buildAxisLabel = function(labelText, axis) {
    var defaultLabelOptions, text, textGeometry, textMaterial, textOffset;
    defaultLabelOptions = {
      size: 10,
      height: 4,
      curveSegments: 6,
      font: "helvetiker",
      style: "normal"
    };
    textGeometry = new THREE.TextGeometry(labelText, defaultLabelOptions);
    textMaterial = new THREE.MeshBasicMaterial({
      color: axis.color
    });
    text = new THREE.Mesh(textGeometry, textMaterial);
    textOffset = 30;
    text.position.x = axis.trajectory.x + (labelText === 'X' ? textOffset : 0);
    text.position.y = axis.trajectory.y + (labelText === 'Y' ? textOffset : 0);
    text.position.z = axis.trajectory.z + (labelText === 'Z' ? textOffset : 0);
    return text;
  };

  Axes.prototype.buildGrids = function(options) {
    var gridColor, gridLength, gridStep, gridXZ, numDividers;
    options = options || {};
    gridLength = options.gridLength || this.axesLength;
    numDividers = options.numDividers || 10;
    gridStep = gridLength / numDividers;
    gridColor = DEFAULT.GRID.COLOR;
    gridXZ = new THREE.Grid(gridLength, gridStep);
    gridXZ.position = new THREE.Vector3(0, 0, 0);
    gridXZ.rotation = new THREE.Euler(0, 0, 0);
    gridXZ.setColors(gridColor, gridColor);
    this.axes.add(gridXZ);
  };

  return Axes;

})();