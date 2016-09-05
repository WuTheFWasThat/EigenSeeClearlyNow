var KeyHandler,
  slice = [].slice;

KeyHandler = (function() {
  function KeyHandler() {
    this.views = {};
    $(document).keydown((function(_this) {
      return function(e) {
        var id, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, speed, view;
        switch (e.keyCode) {
          case 37:
            ref = _this.views;
            for (id in ref) {
              ref1 = ref[id], view = ref1[0], speed = ref1[1];
              view.rotate(-speed, 0);
            }
            return cancelEvent(e);
          case 38:
            ref2 = _this.views;
            for (id in ref2) {
              ref3 = ref2[id], view = ref3[0], speed = ref3[1];
              view.rotate(0, speed);
            }
            return cancelEvent(e);
          case 39:
            ref4 = _this.views;
            for (id in ref4) {
              ref5 = ref4[id], view = ref5[0], speed = ref5[1];
              view.rotate(speed, 0);
            }
            return cancelEvent(e);
          case 40:
            ref6 = _this.views;
            for (id in ref6) {
              ref7 = ref6[id], view = ref7[0], speed = ref7[1];
              view.rotate(0, -speed);
            }
            return cancelEvent(e);
        }
      };
    })(this));
  }

  KeyHandler.prototype.registerView = function(view, speed) {
    var id;
    if (speed == null) {
      speed = 2;
    }
    id = 0;
    while (id in this.views) {
      id += 1;
    }
    this.views[id] = [view, speed];
    return id;
  };

  KeyHandler.prototype.registerViews = function() {
    var view, views;
    views = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return (function() {
      var i, len, results;
      results = [];
      for (i = 0, len = views.length; i < len; i++) {
        view = views[i];
        results.push(this.registerView(view));
      }
      return results;
    }).call(this);
  };

  KeyHandler.prototype.unregisterView = function(id) {
    return delete this.views[id];
  };

  KeyHandler.prototype.unregisterViews = function() {
    var id, ids;
    ids = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return (function() {
      var i, len, results;
      results = [];
      for (i = 0, len = ids.length; i < len; i++) {
        id = ids[i];
        results.push(this.unregisterView(id));
      }
      return results;
    }).call(this);
  };

  return KeyHandler;

})();