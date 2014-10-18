
console.log 'General javascript stuff'
if window.WebGLRenderingContext
  THREE.Renderer = THREE.WebGLRenderer
else
  THREE.Renderer = THREE.CanvasRenderer
