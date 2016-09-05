var MouseHandler,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

MouseHandler = (function(superClass) {
  extend(MouseHandler, superClass);

  function MouseHandler() {
    MouseHandler.__super__.constructor.apply(this, arguments);
    this.mousewheelEventEmitters = {};
    this.mousedragEventEmitters = {};
  }

  MouseHandler.prototype.mousedrag = function(dx, dy) {
    return this.emit('mousedrag', dx, dy);
  };

  MouseHandler.prototype.registerMousedragOn = function(div) {
    var id, lastx, lasty, mousedown, touching, touchx, touchy;
    mousedown = false;
    lastx = null;
    lasty = null;
    div.mousedown(function(e) {
      mousedown = true;
      lastx = e.pageX;
      return lasty = e.pageY;
    });
    div.mouseup(function(e) {
      mousedown = false;
      lastx = null;
      return lasty = null;
    });
    div.mousemove((function(_this) {
      return function(e) {
        var dx, dy;
        if (mousedown) {
          dx = e.pageX - lastx;
          dy = e.pageY - lasty;
          lastx = e.pageX;
          lasty = e.pageY;
          return _this.mousedrag(-dx, dy);
        }
      };
    })(this));
    touching = false;
    touchx = null;
    touchy = null;
    div[0].addEventListener('touchstart', function(e) {
      if (e.touches.length === 1) {
        touching = true;
        touchx = e.touches[0].clientX;
        return touchy = e.touches[0].clientY;
      }
    });
    div[0].addEventListener('touchend', function(e) {
      touching = false;
      touchx = null;
      return touchy = null;
    });
    div[0].addEventListener('touchcancel', function(e) {
      touching = false;
      touchx = null;
      return touchy = null;
    });
    div[0].addEventListener('touchmove', (function(_this) {
      return function(e) {
        var dx, dy;
        if (touching) {
          dx = e.touches[0].clientX - touchx;
          dy = e.touches[0].clientY - touchy;
          touchx = e.touches[0].clientX;
          touchy = e.touches[0].clientY;
          _this.mousedrag(-dx, dy);
        }
        return cancelEvent(e);
      };
    })(this));
    id = 0;
    while (id in this.mousedragEventEmitters) {
      id += 1;
    }
    this.mousedragEventEmitters[id] = div;
    return id;
  };

  MouseHandler.prototype.unregisterMousedragOn = function(id) {
    var div;
    div = this.mousedragEventEmitters[id];
    div.unbind();
    return delete this.mousedragEventEmitters[id];
  };

  MouseHandler.prototype.mousewheel = function(d) {
    return this.emit('mousewheel', d);
  };

  MouseHandler.prototype.registerMousewheelOn = function(div) {
    var dist, id, pinching, wheelspeed;
    wheelspeed = wheelspeed || 10;
    div.bind('MozMousePixelScroll', cancelEvent);
    div.bind('mousewheel DOMMouseScroll', (function(_this) {
      return function(e) {
        var change;
        change = (e.originalEvent.wheelDelta / (wheelspeed * 120)) || (-e.originalEvent.detail / wheelspeed);
        _this.mousewheel(-change);
        return cancelEvent(e);
      };
    })(this));
    pinching = false;
    dist = null;
    div[0].addEventListener('touchstart', function(e) {
      var dx, dy;
      if (e.touches.length > 1) {
        pinching = true;
        dx = e.touches[0].clientX - e.touches[1].clientX;
        dy = e.touches[0].clientY - e.touches[1].clientY;
        return dist = Math.sqrt(dx * dx + dy * dy);
      }
    });
    div[0].addEventListener('touchend', function(e) {
      pinching = false;
      return dist = null;
    });
    div[0].addEventListener('touchcancel', function(e) {
      pinching = false;
      return dist = null;
    });
    div[0].addEventListener('touchmove', (function(_this) {
      return function(e) {
        var ddist, dx, dy, newdist;
        if (pinching) {
          dx = e.touches[0].clientX - e.touches[1].clientX;
          dy = e.touches[0].clientY - e.touches[1].clientY;
          newdist = Math.sqrt(dx * dx + dy * dy);
          ddist = (dist - newdist) / 100;
          dist = newdist;
          _this.mousewheel(ddist);
        }
        return cancelEvent(e);
      };
    })(this));
    id = 0;
    while (id in this.mousewheelEventEmitters) {
      id += 1;
    }
    this.mousewheelEventEmitters[id] = div;
    return id;
  };

  MouseHandler.prototype.unregisterMousewheelOn = function(id) {
    var div;
    div = this.mousewheelEventEmitters[id];
    div.unbind();
    return delete this.mousewheelEventEmitters[id];
  };

  MouseHandler.prototype.registerView = function(view) {
    var id1, id2;
    id1 = this.registerMousedragOn(view.canvas);
    this.on('mousedrag', view.rotate.bind(view));
    id2 = this.registerMousewheelOn(view.canvas);
    this.on('mousewheel', view.zoom.bind(view));
    return [id1, id2];
  };

  MouseHandler.prototype.registerViews = function() {
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

  return MouseHandler;

})(Reactive);