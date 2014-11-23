( ->
  isClient = (typeof module is "undefined" or typeof module.exports is "undefined")

  ((exports) ->
    stringToColor = (str) ->
      if isClient
        return parseInt('0x' + str)
      else
        return '#' + str

    STRCOLORS = (
      BLACK         : '000000'
      WHITE         : 'FFFFFF'
      RED           : 'FF0000'
      GREEN         : '00FF00'
      BLUE          : '0000FF'
      YELLOW        : 'FFFF00'
      LIGHT_YELLOW  : 'FFFF66'
      LIGHT_RED     : 'FF6699'
      LIGHT_GREEN   : '99FF66'
      LIGHT_BLUE    : '6699FF'
      GRAY          : 'AAAAAA'
      BLUISH_GRAY   : '222244'
      MAGENTA       : 'CC0099'
      DARK_BLUE     : '000030'
      PURPLISH_BLUE : '6600FF'
      PURPLISH_RED  : 'CC0066'
      PURPLE        : '9900CC'
    )

    COLORS = {}
    for name, colorstr of STRCOLORS
      COLORS[name] = stringToColor colorstr
    exports.COLORS = COLORS

    DEFAULT = (
      PARALLELOGRAM: (
        COLOR: COLORS.LIGHT_BLUE
        OPACITY: 0.5
      )
      VECTOR: (
        COLOR: COLORS.MAGENTA
        THICKNESS: 1
        HEAD_WIDTH: 5
        HEAD_LENGTH: 5
      )
      AXIS: (
        COLORS: [COLORS.GRAY, COLORS.GRAY, COLORS.GRAY]
        LENGTH: 200
      )
      GRID: (
        COLOR_CENTER_LINE: COLORS.DARK_BLUE
        COLOR_GRID: COLORS.BLUISH_GRAY
      )
      BACKGROUND: (
        COLOR: COLORS.DARK_BLUE
      )
      CAMERA: (
        WIDTH: 500
        HEIGHT: 500
      )
    )
    exports.DEFAULT = DEFAULT

  ) (if isClient then window else module.exports)
)()
