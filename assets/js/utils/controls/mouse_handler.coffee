# Deals with inputs via mouse dragging or wheeling over a div
# Listens to a set of views, rotates/zooms all of them together

class MouseHandler extends Reactive
  constructor: ->
    super
    @mousewheel_event_emitters = {}
    @mousedrag_event_emitters = {}

  mousedrag: (dx, dy) ->
    @emit 'mousedrag', dx, dy

  register_mousedrag_on: (div) ->

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
    while id of @mousedrag_event_emitters
      id += 1
    @mousedrag_event_emitters[id] = div
    return id

  unregister_mousedrag_on: (id) ->
    div = @mousedrag_event_emitters[id]
    do div.unbind
    delete @mousedrag_event_emitters[id]

  mousewheel: (d) ->
    @emit 'mousewheel', d

  register_mousewheel_on: (div) ->
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
    while id of @mousewheel_event_emitters
      id += 1
    @mousewheel_event_emitters[id] = div
    return id

  unregister_mousewheel_on: (id) ->
    div = @mousewheel_event_emitters[id]
    do div.unbind
    delete @mousewheel_event_emitters[id]

  register_view: (view) ->
    id1 = @register_mousedrag_on view.canvas
    @on 'mousedrag', view.rotate.bind(view)

    id2 = @register_mousewheel_on view.canvas
    @on 'mousewheel', view.zoom.bind(view)

    return [id1, id2]

  register_views: (views...) ->
    return (@register_view view for view in views)

