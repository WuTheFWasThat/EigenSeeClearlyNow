# Deals with inputs via mouse dragging or wheeling over a div
# Listens to a set of views, rotates/zooms all of them together

class MouseHandler extends Reactive
  constructor: ->
    super
    @mousewheelEventEmitters = {}
    @mousedragEventEmitters = {}

  mousedrag: (dx, dy) ->
    @emit 'mousedrag', dx, dy

  registerMousedragOn: (div) ->

    # register mouse dragging
    mousedown = false
    lastx = null
    lasty = null

    div.mousedown (e) ->
      mousedown = true
      lastx = e.pageX
      lasty = e.pageY

    div.mouseup (e) ->
      mousedown = false
      lastx = null
      lasty = null

    div.mousemove (e) =>
      if mousedown
        dx = e.pageX - lastx
        dy = e.pageY - lasty
        lastx = e.pageX
        lasty = e.pageY
        @mousedrag -dx, dy

    # for mobile

    touching = false
    touchx = null
    touchy = null

    div[0].addEventListener 'touchstart', (e) ->
      if e.touches.length == 1
        touching = true
        touchx = e.touches[0].clientX
        touchy = e.touches[0].clientY

    div[0].addEventListener 'touchend', (e) ->
      touching = false
      touchx = null
      touchy = null

    div[0].addEventListener 'touchcancel', (e) ->
      touching = false
      touchx = null
      touchy = null

    div[0].addEventListener 'touchmove', (e) =>
      if touching
        dx = e.touches[0].clientX - touchx
        dy = e.touches[0].clientY - touchy
        touchx = e.touches[0].clientX
        touchy = e.touches[0].clientY
        @mousedrag -dx, dy
      return cancelEvent e

    id = 0
    while id of @mousedragEventEmitters
      id += 1
    @mousedragEventEmitters[id] = div
    return id

  unregisterMousedragOn: (id) ->
    div = @mousedragEventEmitters[id]
    do div.unbind
    delete @mousedragEventEmitters[id]

  mousewheel: (d) ->
    @emit 'mousewheel', d

  registerMousewheelOn: (div) ->
    wheelspeed = wheelspeed or 10

    div.bind 'MozMousePixelScroll', cancelEvent
    div.bind 'mousewheel DOMMouseScroll', (e) =>
      change = (e.originalEvent.wheelDelta / (wheelspeed * 120)) or
               (- e.originalEvent.detail / wheelspeed)
      @mousewheel -change
      return cancelEvent e

    # for mobile

    pinching = false
    dist = null

    div[0].addEventListener 'touchstart', (e) ->
      if e.touches.length > 1
        pinching = true
        dx = e.touches[0].clientX - e.touches[1].clientX
        dy = e.touches[0].clientY - e.touches[1].clientY
        dist = Math.sqrt(dx * dx + dy * dy)

    div[0].addEventListener 'touchend', (e) ->
      pinching = false
      dist = null

    div[0].addEventListener 'touchcancel', (e) ->
      pinching = false
      dist = null

    div[0].addEventListener 'touchmove', (e) =>
      if pinching
        dx = e.touches[0].clientX - e.touches[1].clientX
        dy = e.touches[0].clientY - e.touches[1].clientY
        newdist = Math.sqrt(dx * dx + dy * dy)
        ddist = (dist - newdist) / 100
        dist = newdist
        @mousewheel ddist
      return cancelEvent e

    id = 0
    while id of @mousewheelEventEmitters
      id += 1
    @mousewheelEventEmitters[id] = div
    return id

  unregisterMousewheelOn: (id) ->
    div = @mousewheelEventEmitters[id]
    do div.unbind
    delete @mousewheelEventEmitters[id]

  registerView: (view) ->
    id1 = @registerMousedragOn view.canvas
    @on 'mousedrag', view.rotate.bind(view)

    id2 = @registerMousewheelOn view.canvas
    @on 'mousewheel', view.zoom.bind(view)

    return [id1, id2]

  registerViews: (views...) ->
    return (@registerView view for view in views)

