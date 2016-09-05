var View,
  slice = [].slice;

View = (function() {
  function View(canvas, options) {
    var backgroundColor;
    this.canvas = canvas;
    options = options || {};
    this.scene = new THREE.Scene();
    this.width = options.width || DEFAULT.CAMERA.WIDTH;
    this.height = options.height || DEFAULT.CAMERA.HEIGHT;
    this.zoomLevel = 0;
    this.camera = new THREE.OrthographicCamera();
    this.zoomCamera();
    this.theta = 45;
    this.phi = 30;
    this.positionCamera();
    backgroundColor = options.backgroundColor || DEFAULT.BACKGROUND.COLOR;
    options.square = options.square != null ? options.square : true;
    this.renderer = new THREE.Renderer({
      canvas: this.canvas[0],
      antialias: true
    });
    this.renderer.setClearColor(backgroundColor);
    this.resize();
    if (options.square) {
      $(window).resize((function(_this) {
        return function() {
          _this.canvas.height(_this.canvas.width());
          return _this.resize();
        };
      })(this));
      $(window).resize();
    }
    options.axes = options.axes != null ? options.axes : true;
    if (options.axes) {
      this.addAxes(options.axesOptions);
    }
  }

  View.prototype.resize = function() {
    return this.renderer.setSize(this.canvas.width(), this.canvas.height(), false);
  };

  View.prototype.render = function() {
    return this.renderer.render(this.scene, this.camera);
  };

  View.prototype.zoomCamera = function() {
    var far, frustumHeight, frustumWidth, near, zoomFactor;
    zoomFactor = Math.pow(2, this.zoomLevel);
    frustumWidth = this.width * zoomFactor / 2;
    frustumHeight = this.height * zoomFactor / 2;
    near = -this.width * 2 * zoomFactor;
    far = this.width * 2 * zoomFactor;
    this.camera.left = -frustumWidth;
    this.camera.right = frustumWidth;
    this.camera.top = frustumHeight;
    this.camera.bottom = -frustumHeight;
    this.camera.near = near;
    this.camera.far = far;
    return this.camera.updateProjectionMatrix();
  };

  View.prototype.positionCamera = function() {
    var x, y, z;
    x = (Math.cos(Math.PI * this.phi / 180)) * (Math.sin(Math.PI * this.theta / 180));
    y = Math.sin(Math.PI * this.phi / 180);
    z = (Math.cos(Math.PI * this.phi / 180)) * (Math.cos(Math.PI * this.theta / 180));
    this.camera.position.set(x, y, z);
    return this.camera.lookAt(new THREE.Vector3());
  };

  View.prototype.rotate = function(dtheta, dphi) {
    this.theta += dtheta;
    this.phi += dphi;
    this.theta = this.theta % 360;
    this.phi = Math.min(this.phi, 90);
    this.phi = Math.max(this.phi, -90);
    return this.positionCamera();
  };

  View.prototype.addAxes = function(options) {
    this.axes = new Axes(options);
    this.axes.drawOn(this);
  };

  View.prototype.add = function() {
    var i, len, object, objects, results;
    objects = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    results = [];
    for (i = 0, len = objects.length; i < len; i++) {
      object = objects[i];
      if (object instanceof VectorView) {
        results.push(object.drawOn(this.scene));
      } else if (object instanceof MatrixView) {
        results.push(object.drawOn(this.scene));
      } else {
        results.push(this.scene.add(object));
      }
    }
    return results;
  };

  View.prototype.zoom = function(zoomChange) {
    this.zoomLevel += zoomChange;
    this.zoomLevel = Math.max(this.zoomLevel, -5);
    this.zoomLevel = Math.min(this.zoomLevel, 5);
    return this.zoomCamera();
  };

  View.prototype.animate = function() {
    requestAnimationFrame(this.animate.bind(this));
    return this.render();
  };

  return View;

})();