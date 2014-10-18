# From the three.js github example
init = ->
  width = 1000
  height = 500
  scene = new THREE.Scene()
  camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000)
  camera.position.z = 5

  #axisHelper = new THREE.AxisHelper(10)
  #scene.add axisHelper
  boxLen = 1
  geometry = new THREE.BoxGeometry(boxLen, boxLen, boxLen)
  material = new THREE.MeshBasicMaterial(
    color: 0xff0000
    wireframe: true
  )
  mesh = new THREE.Mesh(geometry, material)
  scene.add mesh
  canvas = $("#mainCanvas")
  renderer = new THREE.CanvasRenderer(canvas: canvas[0])
  renderer.setSize width, height

  animate = ->
    requestAnimationFrame animate
    mesh.rotation.x += 0.01
    mesh.rotation.y += 0.02
    renderer.render scene, camera
    return

  return do animate

init()
