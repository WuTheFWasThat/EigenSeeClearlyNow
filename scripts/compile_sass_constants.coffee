
module.exports = (constants) ->
  fs = require 'fs'
  template_file = 'assets/css/constants.tmpl.sass'
  out_file = 'assets/css/constants.sass'

  template = '' + fs.readFileSync template_file

  colors_str = ''
  for name, value of constants.COLORS
    colors_str += '$' + name + ' : ' + value + '\n'
  template.replace '{{{COLORS}}}', colors_str

  fs.writeFileSync out_file, colors_str
