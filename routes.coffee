models = require "./models"
User = models.User

logger = require 'fluent-logger'
logger.configure 'mongo', {host: 'localhost', port:24224}

exports.setup = (app)->
  controllers = {}
  require("fs").readdirSync("./controllers/").forEach((file)->
    controllers[file.replace(/\.coffee$/, '')] = require("./controllers/#{file}")
  )

  app.get '/', (req, res)->
    logger.emit 'test', {hoge: req.params}
    if req.session.userid? is false
      res.redirect '/login'
    else
      User.findOne({id: req.session.userid}).exec (err, person)->
        if err
          throw err
        res.render 'index'
          title: "Ding Dong"
          profile_image: person.profile_image_urls[0]
          name: person.name
          isSupporter: person.isSupporter
  app.post '/', (req, res)->
    if req.session.userid? is false
      res.redirect '/login'
    else
      User.findOne({id: "b08b809483972111e976e85e77ac7527add62ad3"}).exec (err, person)->
        if err
          throw err
        else
          res.render 'index'
            title: "Ding Dong"
            profile_image: person.profile_image_urls[0]
            name: person.name
            isSupporter: person.isSupporter

  app.get '/login', controllers['session'].login
  app.post '/session/create', controllers['session'].create
  app.post '/signup', controllers['session'].createUser

  app.get '/user/:user_id/matching/', controllers['matching'].fetch_matching
  app.put '/user/:user_id/matching/:candidate_id/state', controllers['matching'].update_matching
  app.get '/user/:user_id/picture', controllers['user'].fetchUserProfileImageUrl

  app.get '/user/:id', controllers['user'].fetch_user
  app.get '/user/:id/news', controllers['user'].fetch_news
  app.get '/user/:id/like', controllers['user'].fetch_like
  # app.get '/user/:id/like', controllers['user'].fetchLike
  app.get '/talk/:id', controllers['user'].fetch_talk
  app.get '/user/:user_id/profile', controllers['user'].fetchProfile
  app.post '/user/:user_id/profile', controllers['user'].updateProfile
  app.post '/user/:user_id/profileimage', controllers['user'].fetchProfileImage
  app.get '/user/:user_id/settings', controllers['user'].fetchSettings
  app.post '/user/:user_id/settings', controllers['user'].updateSettings
  app.post '/talk/:talk_id/comment/', controllers['user'].create_comment
  app.post '/user/:user_id/talk/', controllers['user'].create_talk
  app.post '/user/:user_id/supportermessage', controllers['user'].createSupporterMessage
  app.get  '/user/:user_id/supportermessage', controllers['user'].fetchSupporterMessage
  # app.get  '/user/:id/supportermessage/:mid', controllers['user'].fetchSupporterMessage
  app.get '/introduction/:user_id', controllers['matching'].fetchFriendsIntroduction
  app.get '/user/:user_id/following', controllers['matching'].fetchFollowingUsers
  app.post '/user/:one/:two/supportermatching', controllers['matching'].changeSupporterMatching

  app.get '/user/:one/:two/messages', controllers['message'].fetchMessage
  app.get '/user/:user_id/messagelist', controllers['message'].fetchMessagingUserList
  app.post '/user/:from/:to/message', controllers['message'].createMessage

  app.post '/follow/:from/:to', controllers['user'].createFollow

  #debug
  app.get '/debug/:id/candidate/create', controllers['utils'].fillCandidates
  app.get '/debug/:id/candidate/delete', controllers['utils'].deleteCandidates
  app.get '/debug/matching/:from/:to/:state', controllers['debug'].update_matching
  app.get '/debug/follow/:from/:to', controllers['debug'].createFollow
  app.get '/debug/reset/', controllers['debug'].deleteAllData
  app.get '/debug/user/all', controllers['debug'].fetchAllUser
  app.get '/debug/create/dammy', controllers['utils'].create_dammy_users
  app.get '/debug/user/:from/:to/message/:text', controllers['message'].createMessage
  app.get '/debug/messages/reset', controllers['debug'].deleteMessages

