# Deals with inputs via mouse dragging or wheeling over a div
# Listens to a set of views, rotates/zooms all of them together

class MouseHandler
  constructor: ->
    @listens = {}
    # TODO: mouse wheel
    @mousewheel_fns = []
    @mousedrag_fns = []

  on: (type, fn) ->
    if type == 'mousewheel'
      @mousewheel_fns.push fn
    else if type == 'mousedrag'
      @mousedrag_fns.push fn

  mousedrag: (dx, dy) ->
    for fn in @mousedrag_fns
      fn dx, dy

  listen: (div) ->

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
    while id of @listens
      id += 1
    @listens[id] = div
    return id

  unlisten: (id) ->
    div = @listens[id]
    do div.unbind
    delete @listens[id]

  register_view: (view) ->
    id = @listen view.canvas
    @on 'mousedrag', view.rotate.bind(view)
    return id

