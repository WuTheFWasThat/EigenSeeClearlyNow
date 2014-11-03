# Deals with keyboard inputs

class KeyHandler
  constructor: ->
    @views = {}

    # TODO: have general handler for any key, register view does the up/down etc
    $(document).keydown (e) =>
      cancel = () ->
        do e.preventDefault
        return false

      switch e.keyCode
        when 37 # left
          for id, [view, speed] of @views
            view.rotate -speed, 0
          return do cancel
        when 38 # up
          for id, [view, speed] of @views
            view.rotate 0, speed
          return do cancel
        when 39 # right
          for id, [view, speed] of @views
            view.rotate speed, 0
          return do cancel
        when 40 # down
          for id, [view, speed] of @views
            view.rotate 0, -speed
          return do cancel

  register_view: (view, speed = 2) ->
    id = 0
    while id of @views
      id += 1
    @views[id] = [view, speed]
    return id

  unregister_view: (id) ->
    delete @views[id]

