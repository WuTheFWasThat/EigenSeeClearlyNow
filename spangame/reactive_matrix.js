var ReactiveMatrix,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ReactiveMatrix = (function(superClass) {
  extend(ReactiveMatrix, superClass);

  function ReactiveMatrix() {
    ReactiveMatrix.__super__.constructor.apply(this, arguments);
    this.matrix = new THREE.Matrix3();
    return;
  }

  ReactiveMatrix.prototype.change = function() {
    return this.emit('change', this.matrix);
  };

  ReactiveMatrix.prototype.setMatrix = function(matrix) {
    this.matrix = matrix;
    this.change();
    return this;
  };

  ReactiveMatrix.prototype.getReactiveRows = function() {
    var rowX, rowY, rowZ, updateRows;
    rowX = new ReactiveVector();
    rowY = new ReactiveVector();
    rowZ = new ReactiveVector();
    updateRows = (function(_this) {
      return function() {
        var ref, x, y, z;
        ref = _this.matrix.getRows(), x = ref[0], y = ref[1], z = ref[2];
        rowX.setVector(x);
        rowY.setVector(y);
        return rowZ.setVector(z);
      };
    })(this);
    this.on('change', updateRows);
    updateRows();
    return [rowX, rowY, rowZ];
  };

  ReactiveMatrix.prototype.getReactiveColumns = function() {
    var colX, colY, colZ, updateColumns;
    colX = new ReactiveVector();
    colY = new ReactiveVector();
    colZ = new ReactiveVector();
    updateColumns = (function(_this) {
      return function() {
        var ref, x, y, z;
        ref = _this.matrix.getColumns(), x = ref[0], y = ref[1], z = ref[2];
        colX.setVector(x);
        colY.setVector(y);
        return colZ.setVector(z);
      };
    })(this);
    this.on('change', updateColumns);
    updateColumns();
    return [colX, colY, colZ];
  };

  ReactiveMatrix.prototype.fromReactiveRows = function(rowX, rowY, rowZ) {
    var update;
    update = (function(_this) {
      return function() {
        _this.matrix.setFromRows(rowX.vector, rowY.vector, rowZ.vector);
        return _this.change();
      };
    })(this);
    rowX.on('change', update);
    rowY.on('change', update);
    rowZ.on('change', update);
    return this;
  };

  ReactiveMatrix.prototype.setFromInput = function(matrixInputId) {
    var binddim, col, dim, elIndex, i, j, ref, ref1, row;
    this.input = $('#' + matrixInputId);
    this.color = this.input.css('border-left-color');
    this.on('change', (function(_this) {
      return function(matrix) {
        var col, dim, dimContainer, elIndex, i, j, ref, results, row, value;
        ref = ['x', 'y', 'z'];
        results = [];
        for (i in ref) {
          row = ref[i];
          results.push((function() {
            var ref1, results1;
            ref1 = ['x', 'y', 'z'];
            results1 = [];
            for (j in ref1) {
              col = ref1[j];
              dim = row + col;
              elIndex = (parseInt(i)) + 3 * (parseInt(j));
              value = matrix.elements[elIndex];
              dimContainer = $('.input-container-' + dim, this.input);
              $('.input-val', dimContainer).text(value);
              results1.push($('.input', dimContainer).val(value));
            }
            return results1;
          }).call(_this));
        }
        return results;
      };
    })(this));
    binddim = (function(_this) {
      return function(dim, elIndex) {
        var dimInput;
        dimInput = $('.input-container-' + dim + ' .input', _this.input);
        dimInput.on('input change', _.throttle(function() {
          _this.matrix.elements[elIndex] = parseInt(dimInput.val());
          return _this.change();
        }, 10));
        return _this.matrix.elements[elIndex] = parseInt(dimInput.val());
      };
    })(this);
    ref = ['x', 'y', 'z'];
    for (i in ref) {
      row = ref[i];
      ref1 = ['x', 'y', 'z'];
      for (j in ref1) {
        col = ref1[j];
        dim = row + col;
        elIndex = (parseInt(i)) + 3 * (parseInt(j));
        binddim(dim, elIndex);
      }
    }
    return this;
  };

  ReactiveMatrix.prototype.times = function(multiplicand) {
    var product, setValues;
    if (multiplicand instanceof ReactiveVector) {
      product = new ReactiveVector();
      setValues = (function(_this) {
        return function() {
          var productVector;
          productVector = multiplicand.vector.clone().applyMatrix3(_this.matrix);
          return product.setVector(productVector);
        };
      })(this);
      this.on('change', setValues);
      multiplicand.on('change', setValues);
      setValues();
      return product;
    }
  };

  return ReactiveMatrix;

})(Reactive);