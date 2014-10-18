# From the three.js github example
init = ->
  scene = new THREE.Scene()
  camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000)
  camera.position.z = 1000
  geometry = new THREE.BoxGeometry(200, 200, 200)
  material = new THREE.MeshBasicMaterial(
    color: 0xff0000
    wireframe: true
  )
  mesh = new THREE.Mesh(geometry, material)
  scene.add mesh
  canvas = $("#mainCanvas")
  renderer = new THREE.CanvasRenderer(canvas: canvas[0])
  renderer.setSize 500, 500

  animate = ->
    requestAnimationFrame animate
    mesh.rotation.x += 0.01
    mesh.rotation.y += 0.02
    renderer.render scene, camera
    return

  return do animate

init()
