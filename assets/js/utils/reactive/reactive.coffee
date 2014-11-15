# represents an object which reacts to events and emits other events
class Reactive
  constructor: () ->
      @fns = {}
      return

  emit: (event_type, args...) ->
      for fn in @get_fns event_type
        fn.apply fn, args

  get_fns: (event_type) ->
      if event_type of @fns
          return @fns[event_type]
      return []

  on: (event_type, fn) ->
    fns = @get_fns(event_type)
    if fns.length == 0
      @fns[event_type] = fns
    fns.push fn

