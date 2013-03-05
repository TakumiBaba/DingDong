
#
# Module dependencies.
#

# Include modules
express = require('express')
mongoose = require 'mongoose'
http = require('http')
https = require('https')
path = require('path')
assets = require('connect-assets')()
MongoStore = require('connect-mongo')(express)
config = require('./config.json')
models = require('../models')
global._ = require 'underscore'
fs = require 'fs'
logger = require 'fluent-logger'
logger.configure 'mongo', {host: 'localhost', port:24224}

# Define express application
app = express()

# Configure Application settings.
app.configure ()->
  # Set port number
  app.set 'port', process.env.PORT || 3000
  # Set view environment
  app.set 'views', path.join(__dirname, '../views')
  app.set 'view engine', 'jade'
  # Include user configurations
  app.set k, v for k, v of config
  # some settings...
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session
    'secret': 'ding-dong-secret'
    'store': new MongoStore
      db: 'session'
      host: "localhost"
    'cookie': {maxAge: 60*60*1000}
  app.use app.router
  app.use express.static(path.join(__dirname, '../public'))
  app.use express.static(path.join(__dirname, '../assets/'))
  app.use assets
  # app.use (err, req, res, next)->
  #   # console.log '-------------------------------------'
  #   logger.emit 'test', {hoge: req.params}
  #   next()

# Configure environment for Development
app.configure 'development', ()->
  app.use express.errorHandler()
  app.locals.pretty = true

# Connect to Mongo DB
mongoose.connect app.settings.dbpath, (error) ->
  if error
    console.warn error
    console.error "failed on connecting #{app.settings.dbpath}"
  else
    console.info "MongoDB connected."

# Include routes defines.
require('../routes').setup(app)

# Start HTTP server
# server = http.createServer(app).listen(app.get('port'), ()->
#   console.log "Express server listening on port #{app.get('port')}";
# )

#start secure server
secure_option =
  key: fs.readFileSync("./server.key").toString()
  cert: fs.readFileSync("./server.crt").toString()

secureServer = https.createServer(secure_option, app).listen(app.get('port'), ()->
  console.log "Express secureserver listening on port #{app.get('port')}";
)
