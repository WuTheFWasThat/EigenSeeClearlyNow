var ReactiveVector,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

ReactiveVector = (function(superClass) {
  extend(ReactiveVector, superClass);

  function ReactiveVector() {
    ReactiveVector.__super__.constructor.apply(this, arguments);
    this.vector = new THREE.Vector3();
    return;
  }

  ReactiveVector.prototype.change = function() {
    return this.emit('change', this.vector);
  };

  ReactiveVector.prototype.setVector = function(vector) {
    this.vector = vector;
    this.change();
    return this;
  };

  ReactiveVector.prototype.sum = function() {
    var i, len, setSum, summand, summands;
    summands = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    setSum = (function(_this) {
      return function() {
        var i, len, sum, summand;
        sum = new THREE.Vector3();
        for (i = 0, len = summands.length; i < len; i++) {
          summand = summands[i];
          sum.add(summand.vector);
        }
        return _this.setVector(sum);
      };
    })(this);
    for (i = 0, len = summands.length; i < len; i++) {
      summand = summands[i];
      summand.on('change', setSum);
    }
    return setSum();
  };

  ReactiveVector.prototype.fromReactiveConstants = function(c1, c2, c3) {
    var update;
    update = (function(_this) {
      return function() {
        _this.vector.set(c1.val, c2.val, c3.val);
        return _this.change();
      };
    })(this);
    c1.on('change', update);
    c2.on('change', update);
    c3.on('change', update);
    return this;
  };

  ReactiveVector.prototype.setFromInput = function(vectorInputID) {
    var binddim, dim, i, len, ref;
    this.input = $('#' + vectorInputID);
    this.color = this.input.css('border-left-color');
    this.on('change', (function(_this) {
      return function(vector) {
        var dim, dimContainer, i, len, ref, results, value;
        ref = ['x', 'y', 'z'];
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          dim = ref[i];
          value = vector[dim];
          dimContainer = $('.input-container-' + dim, _this.input);
          $('.input-val', dimContainer).text(value);
          results.push($('.input', dimContainer).val(value));
        }
        return results;
      };
    })(this));
    binddim = (function(_this) {
      return function(dim) {
        var dimInput;
        dimInput = $('.input-container-' + dim + ' .input', _this.input);
        dimInput.on('input change', _.throttle(function() {
          _this.vector[dim] = parseInt(dimInput.val());
          return _this.change();
        }, 10));
        return _this.vector[dim] = parseInt(dimInput.val());
      };
    })(this);
    ref = ['x', 'y', 'z'];
    for (i = 0, len = ref.length; i < len; i++) {
      dim = ref[i];
      binddim(dim);
    }
    return this;
  };

  return ReactiveVector;

})(Reactive);