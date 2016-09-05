var Reactive,
  slice = [].slice;

Reactive = (function() {
  function Reactive() {
    this.fns = {};
    return;
  }

  Reactive.prototype.emit = function() {
    var args, event_type, fn, i, len, ref, results;
    event_type = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    ref = this.get_fns(event_type);
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      fn = ref[i];
      results.push(fn.apply(fn, args));
    }
    return results;
  };

  Reactive.prototype.get_fns = function(event_type) {
    if (event_type in this.fns) {
      return this.fns[event_type];
    }
    return [];
  };

  Reactive.prototype.on = function(event_type, fn) {
    var fns;
    fns = this.get_fns(event_type);
    if (fns.length === 0) {
      this.fns[event_type] = fns;
    }
    return fns.push(fn);
  };

  return Reactive;

})();