# Deals with inputs via mouse dragging or wheeling over a div
# Listens to a set of views, rotates/zooms all of them together

class MouseHandler
  constructor: ->
    @mousewheel_event_emitters = {}
    @mousewheel_event_handlers = []
    @mousedrag_event_emitters = {}
    @mousedrag_event_handlers = []

  on: (type, fn) ->
    if type == 'mousewheel'
      @mousewheel_event_handlers.push fn
    else if type == 'mousedrag'
      @mousedrag_event_handlers.push fn

  mousedrag: (dx, dy) ->
    for fn in @mousedrag_event_handlers
      fn dx, dy

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
    for fn in @mousewheel_event_handlers
      fn d

  register_mousewheel_on: (div) ->
    wheelspeed = wheelspeed or 1000
    div.bind 'mousewheel', (e) =>
      change = e.originalEvent.wheelDelta / wheelspeed
      @mousewheel -change
      do e.preventDefault
      return false

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

