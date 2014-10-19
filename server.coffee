#!./node_modules/.bin/coffee

# Register CoffeeScript loader
#require('coffee-script/register')

express = require("express")
_ = require("underscore")

process.on "uncaughtException", (err) ->
  console.log "Uncaught exception", err.message
  console.log "Uncaught exception", err.stack
  return

env = process.env.NODE_ENV or "development"

app = express()

# Asset pipeline
connect_assets = require("connect-assets")(
  helperContext: app.locals
  buildDir: ((if env is "production" then "public/assets" else false))
)
app.use connect_assets

app.set 'views', 'views'
app.set 'view engine', 'jade'

app.get '/', (req, res) ->
  res.render 'index'

app.get '/:section/:subsection', (req, res) ->
  section = req.param 'section'
  subsection = req.param 'subsection'
  #try
  res.render 'pages/' + section + '/' + subsection
  #catch e
  #  res.render '404'

app.use (req, res, next) ->
  res.status 404
  res.render 'errors/404',
    url: _.escape req.url
  return

port = process.argv[2] or 8080
app.listen port
console.log "Started server on port " + port

# Expose app
exports = module.exports = app
