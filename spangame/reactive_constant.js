var ReactiveConstant,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

ReactiveConstant = (function(superClass) {
  extend(ReactiveConstant, superClass);

  function ReactiveConstant() {
    ReactiveConstant.__super__.constructor.apply(this, arguments);
    this.val = 0;
    return;
  }

  ReactiveConstant.prototype.change = function() {
    return this.emit('change', this.val);
  };

  ReactiveConstant.prototype.get = function() {
    return this.val;
  };

  ReactiveConstant.prototype.set = function(val) {
    this.val = val;
    return this.change();
  };

  ReactiveConstant.prototype.sum = function() {
    var i, len, results, setSum, summand, summands;
    summands = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    setSum = (function(_this) {
      return function() {
        var i, len, sum, summand;
        sum = 0;
        for (i = 0, len = summands.length; i < len; i++) {
          summand = summands[i];
          sum += summand.val;
        }
        _this.set(sum);
        return _this.change();
      };
    })(this);
    results = [];
    for (i = 0, len = summands.length; i < len; i++) {
      summand = summands[i];
      results.push(summand.on('change', setSum));
    }
    return results;
  };

  ReactiveConstant.prototype.setFromInput = function(constantInputId) {
    this.input = $('#' + constantInputId);
    $('.input', this.input).on('input change', _.throttle((function(_this) {
      return function() {
        _this.val = parseInt($('.input', _this.input).val());
        return _this.change();
      };
    })(this), 10));
    this.color = this.input.css('border-left-color');
    this.on('change', (function(_this) {
      return function(val) {
        $('.input-val', _this.input).text(val);
        return $('.input', _this.input).val(val);
      };
    })(this));
    this.val = parseInt($('.input', this.input).val());
    return this;
  };

  ReactiveConstant.prototype.times = function(multiplicand) {
    var product, setValues;
    if (multiplicand instanceof ReactiveVector) {
      product = new ReactiveVector();
      setValues = (function(_this) {
        return function() {
          var productVector;
          productVector = multiplicand.vector.clone().multiplyScalar(_this.val);
          return product.setVector(productVector);
        };
      })(this);
      this.on('change', setValues);
      multiplicand.on('change', setValues);
      setValues();
      return product;
    }
  };

  return ReactiveConstant;

})(Reactive);