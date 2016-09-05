
/*
Class representing a drawn matrix as a parallelepiped
Options:
  matrix: a THREE.Matrix3
  offset: a THREE.Vector3
  faceColor: a hex string (i.e. from COLORS constants)
  edgeColor: a hex string
  vectorColor: a hex string
 */
var MatrixView;

MatrixView = (function() {
  function MatrixView(options) {
    var faceColor, opacity;
    options = options || {};
    this.parallelepiped = new THREE.Parallelepiped();
    faceColor = options.faceColor != null ? options.faceColor : DEFAULT.MATRIX.FACECOLOR;
    this.setFaceColor(faceColor);
    this.edgeColor = options.edgeColor || COLORS.PURPLE;
    this.vectorColor = options.vectorColor || DEFAULT.VECTOR.COLOR;
    opacity = options.opacity != null ? options.opacity : DEFAULT.MATRIX.OPACITY;
    this.setOpacity(opacity);
    options.matrix = options.matrix || new THREE.Matrix3();
    if (options.matrix instanceof ReactiveMatrix) {
      this.setReactiveMatrix(options.matrix);
    } else {
      this.setMatrix(options.matrix);
    }
    options.offset = options.offset || new THREE.Vector3();
    if (options.offset instanceof ReactiveVector) {
      this.setReactiveOffset(options.offset);
    } else {
      this.setOffset(options.offset);
    }
    return this;
  }

  MatrixView.prototype.setMatrix = function(matrix) {
    var ref;
    this.matrix = matrix;
    ref = matrix.getColumns(), this.u = ref[0], this.v = ref[1], this.w = ref[2];
    return this.parallelepiped.setVectors(this.u, this.v, this.w);
  };

  MatrixView.prototype.setOffset = function(offset) {
    this.offset = offset;
    this.parallelepiped.setOffset(this.offset);
    return this;
  };

  MatrixView.prototype.setOpacity = function(opacity) {
    this.opacity = opacity;
    this.parallelepiped.setOpacity(this.opacity);
    return this;
  };

  MatrixView.prototype.setReactiveMatrix = function(reactiveMatrix) {
    this.setMatrix(reactiveMatrix.matrix);
    reactiveMatrix.on('change', (function(_this) {
      return function(matrix) {
        return _this.setMatrix(matrix);
      };
    })(this));
    return this;
  };

  MatrixView.prototype.setReactiveOffset = function(reactiveVector) {
    this.setOffset(reactiveVector.vector);
    reactiveVector.on('change', (function(_this) {
      return function(vector) {
        return _this.setOffset(vector);
      };
    })(this));
    return this;
  };

  MatrixView.prototype.setFaceColor = function(color) {
    this.faceColor = color;
    this.parallelepiped.setFaceColor(color);
    return this;
  };

  MatrixView.prototype.drawOn = function(scene) {
    scene.add(this.parallelepiped);
    return this;
  };

  return MatrixView;

})();