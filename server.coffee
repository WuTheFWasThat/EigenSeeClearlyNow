#!./node_modules/.bin/coffee

# Register CoffeeScript loader
#require('coffee-script/register')


express = require 'express'
execSync = require 'execSync'
_ = require 'underscore'

execSync.exec 'python scripts/compile_css_template.py assets/css/app.tmpl.sass assets/css/app.css.sass'
execSync.exec 'python scripts/setup_assets_symlinks.py'

process.on 'uncaughtException', (err) ->
  console.log 'Uncaught exception', err.message
  console.log 'Uncaught exception', err.stack
  return

env = process.env.NODE_ENV or 'development'

app = express()

# Asset pipeline
connect_assets = require('connect-assets')(
  helperContext: app.locals
  buildDir: ((if env is 'production' then 'public/assets' else false))
)
app.use connect_assets

# for MathJax to work
app.use express.static(__dirname + '/assets/js/lib/MathJax')

app.set 'views', 'views'
app.set 'view engine', 'jade'

app.get '/', (req, res) ->
  res.render 'index'

app.get '/:chapter/:section', (req, res) ->
  chapter = req.param 'chapter'
  section = req.param 'section'
  #try
  res.render 'pages/' + chapter + '/' + section
  #catch e
  #  res.render '404'

app.use (req, res, next) ->
  res.status 404
  res.render 'errors/404',
    url: _.escape req.url
  return

port = process.argv[2] or 8080
app.listen port
console.log 'Started server on port ' + port

# Expose app
exports = module.exports = app
