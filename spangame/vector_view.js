
/*
Class representing a drawn vector
Options:
  trajectory: represents the direction the vector is pointing
  offset: represents the origin of the vector
 */
var VectorView;

VectorView = (function() {
  function VectorView(options) {
    options = options || {};
    this.arrow = new THREE.Arrow();
    options.headLength = options.headLength != null ? options.headLength : DEFAULT.VECTOR.HEAD_LENGTH;
    this.setHeadLength(options.headLength);
    options.headWidth = options.headWidth != null ? options.headWidth : DEFAULT.VECTOR.HEAD_WIDTH;
    this.setHeadWidth(options.headWidth);
    options.lineWidth = options.lineWidth != null ? options.lineWidth : DEFAULT.VECTOR.LINE_WIDTH;
    this.setLineWidth(options.lineWidth);
    options.trajectory = options.trajectory || new THREE.Vector3();
    if (options.trajectory instanceof ReactiveVector) {
      this.setReactiveTrajectory(options.trajectory);
    } else {
      this.setTrajectory(options.trajectory);
    }
    options.offset = options.offset || new THREE.Vector3();
    if (options.offset instanceof ReactiveVector) {
      this.setReactiveOffset(options.offset);
    } else {
      this.setOffset(options.offset);
    }
    options.color = options.color != null ? options.color : DEFAULT.VECTOR.COLOR;
    this.setColor(options.color);
    return this;
  }

  VectorView.prototype.setTrajectory = function(trajectory) {
    this.trajectory = trajectory;
    this.arrow.setDirection(this.trajectory.clone().normalize());
    this.arrow.setLength(this.trajectory.length());
    return this;
  };

  VectorView.prototype.setOffset = function(offset) {
    this.offset = offset;
    this.arrow.setOffset(this.offset);
    return this;
  };

  VectorView.prototype.setColor = function(color) {
    this.color = color;
    this.arrow.setColor(this.color);
    return this;
  };

  VectorView.prototype.setLineWidth = function(lineWidth) {
    this.lineWidth = lineWidth;
    this.arrow.setLineWidth(this.lineWidth);
    return this;
  };

  VectorView.prototype.setHeadWidth = function(headWidth) {
    this.headWidth = headWidth;
    this.arrow.setHeadWidth(this.headWidth);
    return this;
  };

  VectorView.prototype.setHeadLength = function(headLength) {
    this.headLength = headLength;
    this.arrow.setHeadLength(this.headLength);
    return this;
  };

  VectorView.prototype.setReactiveTrajectory = function(reactiveVector) {
    this.setTrajectory(reactiveVector.vector);
    reactiveVector.on('change', (function(_this) {
      return function(vector) {
        return _this.setTrajectory(vector);
      };
    })(this));
    return this;
  };

  VectorView.prototype.setReactiveOffset = function(reactiveVector) {
    this.setOffset(reactiveVector.vector);
    reactiveVector.on('change', (function(_this) {
      return function(vector) {
        return _this.setOffset(vector);
      };
    })(this));
    return this;
  };

  VectorView.prototype.drawOn = function(scene) {
    return scene.add(this.arrow);
  };

  return VectorView;

})();