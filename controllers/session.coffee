models = require '../models'
Utils = require './utils'
User = models.User
News = models.News
Crypto = require 'crypto'

exports.login = (req, res)->
  if req.session.userid? is true
    res.redirect "back"
  else
    res.render "login", {title: 'Ding-Dong',back: req.header "Referer"}

exports.create = (req, res)->
  User.findOne {facebook_id: req.body.userid}, (err, person)=>
    if err
      throw err
    if person? is true
      console.log 'userdata is exist'
      req.session.name = person.name
      req.session.userid = person.id
      req.session.image = person.profile_image_urls[0]
      req.session.isSupporter = person.isSupporter
      res.json
        id: person.id
        status: "ok"
    else
      console.log 'userdata is not exist'
      sha1_hash = Crypto.createHash 'sha1'
      sha1_hash.update req.body.userid
      user = new User()
      user.name = req.body.name
      user.facebook_id = req.body.userid
      user.id = sha1_hash.digest 'hex'
      user.profile_image_urls.push "https://graph.facebook.com/#{req.body.userid}/picture?type=large"
      user.isSupporter = true
      user.save (err)->
        if err
          throw err
        console.log 'user save success!'
      req.session.name = req.body .name
      req.session.userid = user.id
      req.session.image = user.profile_image_urls
      req.session.isSupporter = true
      res.json
        status: 'new'
        id: user.id

exports.createUser = (req, res)->
  console.log req.body
  User.findOne({id: req.session.userid}).exec (err, user)->
    if err
      throw err
    else
      if user? is false
        user = new User()
        user.profile_image_urls.push "https://graph.facebook.com/#{req.body.id}/picture"
      sha1_hash = Crypto.createHash 'sha1'
      sha1_hash.update req.body.id
      user.name = req.body.name
      user.username = req.body.username
      user.first_name = req.body.first_name
      user.last_name = req.body.last_name
      user.facebook_id = req.body.id
      user.id = sha1_hash.digest 'hex'
      user.profile.gender = req.body.gender
      d = new Date("#{req.body.birthday_year}/#{req.body.birthday_month}/#{req.body.birthday_day}")
      user.profile.birthday = d
      user.profile.age = Utils.calculateAge(d)
      user.is_married = false
      user.partner_requirements.ageMin = 22
      user.partner_requirements.ageMax = 60
      user.isSupporter = false
      user.isFirstLogin = false
      user.inviteFriendsFlag = false
      news = new News()
      news.text = "#{req.body.name}さんがDing Dongを始めました！"
      user.news.push news
      user.save (err)=>
        if err
          throw err
        else
          req.params.id = user.id
          console.log req.params.id
          Utils.fillCandidates(req, res)
          req.session.isSupporter = false
      console.log user
      res.redirect '/'
