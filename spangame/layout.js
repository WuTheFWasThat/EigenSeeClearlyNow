var INIT;

INIT = {};

$(document).ready(function() {
  var bodyClass, hasWebGL;
  hasWebGL = function() {
    var canvas, error, error1, gl, x;
    canvas = document.createElement('canvas');
    gl = null;
    try {
      gl = canvas.getContext('webgl');
    } catch (error) {
      x = error;
    }
    if (gl === null) {
      try {
        gl = canvas.getContext('experimental-webgl');
      } catch (error1) {
        x = error1;
      }
    }
    return !!gl;
  };
  if (hasWebGL()) {
    THREE.Renderer = THREE.WebGLRenderer;
  } else {
    THREE.Renderer = THREE.CanvasRenderer;
    if (!$.cookie('noWebGL')) {
      $('#noWebGLDismiss').click(function() {
        $.cookie('noWebGL', 'acknowledged', {
          path: '/'
        });
        return $('#noWebGL').addClass('hidden');
      });
      $('#noWebGLReason').text(window.WebGLRenderingContext ? 'browser' : 'graphics card');
      $('#noWebGL').removeClass('hidden');
    }
  }
  $('#sidebarToggle').click(function() {
    $('body').toggleClass('sidebar_active sidebar_inactive');
    return $('#sidebarToggle .glyphicon').toggleClass('glyphicon-chevron-left glyphicon-chevron-right');
  });
  bodyClass = $('body').attr('class').split(' ')[0];
  if (INIT[bodyClass]) {
    return INIT[bodyClass]();
  }
});