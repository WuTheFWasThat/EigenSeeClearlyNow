# Intro: One Vector
init_vector_intro = ->

  canvas = $("#canvas")
  # Setup scene, camera, renderer
  view = new View(canvas)

  # Setup axes, grid
  setupAxes view.scene

  # Vector with arrow
  # TODO build our own vector arrow
  vector = new Vector([1, 0, 0])
  vector.draw_on view.scene

  # Changes vector based on user input
  animate = ->
    requestAnimationFrame animate
    do view.render

    x = parseInt $('#sliderX').val()
    y = parseInt $('#sliderY').val()
    z = parseInt $('#sliderZ').val()

    $('#sliderXVal').text(x)
    $('#sliderYVal').text(y)
    $('#sliderZVal').text(z)

    vector.set_trajectory(x, y, z)
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
