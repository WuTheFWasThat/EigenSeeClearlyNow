# Intro: One Vector
init_vector_intro = ->

  canvas = $("#canvas")
  # Setup scene, camera, renderer
  view = new View(canvas)

  # Setup axes, grid
  setupAxes view.scene

  # Vector with arrow
  # TODO build our own vector arrow
  vectorColor = 0xCC0099
  vectorDirection = new THREE.Vector3(1, 0, 0)
  vectorLen = 1
  headLength = 5
  headWidth = 5
  vector = new THREE.ArrowHelper(vectorDirection, origin, vectorLen, vectorColor, headLength, headWidth)
  view.scene.add vector

  # Changes vector based on user input
  animate = ->
    requestAnimationFrame animate
    do view.render

    vectorXVal = parseInt $('#sliderX').val()
    vectorYVal = parseInt $('#sliderY').val()
    vectorZVal = parseInt $('#sliderZ').val()

    $('#sliderXVal').text(vectorXVal)
    $('#sliderYVal').text(vectorYVal)
    $('#sliderZVal').text(vectorZVal)

    newVector = new THREE.Vector3(vectorXVal, vectorYVal, vectorZVal)
    vector.setLength newVector.length()
    vector.setDirection newVector.normalize()
    return

  $(document).keydown (e) ->
    cancel = () ->
      do e.preventDefault
      return false

    speed = 2

    switch e.keyCode
      when 37 # left
        view.rotate -speed, 0
        return do cancel
      when 38 # up
        view.rotate 0, speed
        return do cancel
      when 39 # right
        view.rotate speed, 0
        return do cancel
      when 40 # down
        view.rotate 0, -speed
        return do cancel

  return do animate
