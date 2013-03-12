models = require '../models'
Utils = require './utils'
User = models.User
Talk = models.Talk
News = models.News
Comment = models.Comment
SupporterMessage = models.SupporterMessage

logger = require 'fluent-logger'
logger.configure 'mongo', {host: 'localhost', port:24224}
# ユーザデータ取得系のAPI
# GET → fetch
# POST → create
# PUT → update

exports.fetch_user = (req, res)->
  console.log 'userid'
  console.log req.session.userid
  id = req.params.id
  User.findOne({id: id}).populate('follower').populate('following').exec (err, person)->
    if err
      throw err
    else
      console.log person
      followerIds = []
      _.each person.follower, (f, num)=>
        followerIds.push f.id.toString()
      console.log followerIds
      type = 0
      console.log person.id
      followerFlag = false
      _.each person.follower, (f, num)=>
        if f.id.toString() is req.session.userid
          followerFlag = true
      if person.id is req.session.userid
        type = "user"
      else if followerFlag is true
        type = "supporter"
      else
        type = "candidate"
      res.json
        type: type
        person: person

exports.fetchNews = (req, res)->
  id = req.params.id
  User.findOne({id: id}).exec (err, person)->
    if err
      throw err
    else
      news = person.news.reverse().splice 0, 5
      console.log news
      res.send news

exports.fetch_like = (req, res)->
  id = req.params.id
  User.findOne({id: id}).populate('candidates.user').exec (err, person)->
    if err
      throw err
    else
      each = _.filter person.candidates, (c, num)->
        return (c.state is 3)
      you = _.filter person.candidates, (c, num)->
        return (c.state is 2)
      me = _.filter person.candidates, (c, num)->
        return (c.state is 1)
      tempList = each.concat you
      list = tempList.concat me
      res.send list
      # res.json
      #   each: each
      #   you: you
      #   me: me

exports.fetchLike = (req, res)->
  id = req.params.id
  type = parseInt req.query.type
  User.findOne({id: id}).populate('candidates.user').exec (err, person)->
    if err
      throw err
    else
      like = _.filter person.candidates, (c, num)->
        return (c.state is type)
      res.send like

exports.fetch_talk = (req, res)->
  id = req.params.id
  User.findOne({id: id}).populate('talks.user').populate('talks.candidate').populate('talks.comments').exec (err, person)->
    if err
      throw err
    else
      Talk.find({user: person._id}).populate('candidate').populate('comments.user').exec (err, talks)->
        if err
          throw err
        else
          res.send talks

exports.create_comment = (req, res)->
  talk_id = req.params.talk_id
  comment_user_id = req.body.me
  text = req.body.text
  User.findOne({id: comment_user_id}).exec (err, person)->
    if err
      throw err
    else
      Talk.findOne({_id: talk_id}).populate('candidate').populate('user').exec (err, talk)=>
        if err
          throw err
        else
          comment = new Comment()
          comment.user = person._id
          comment.text = text
          comment.count = 0
          talk.comments.push comment

          news = new News()
          news.from = person.id
          news.type = "comment"
          news.text = "#{person.name}さんが、#{talk.candidate.name}さんの応援団トークにコメントしました"
          console.log 'talk comment, news'
          console.log news
          talk.user.news.push news
          talk.user.save (err)->
            if err
              throw err
          talk.save (err)->
            if err
              throw err

          res.json
            comment: comment
            name: person.name
            profile_image: person.profile_image_urls[0]

exports.create_talk = (req, res)->
  candidate_id = req.body.candidate_id
  user_id = req.params.user_id
  console.log user_id
  console.log candidate_id
  User.find({id: {$in: [user_id, candidate_id]}}).populate('talks.candidate').exec (err, persons)->
    if err
      throw err
    else
      user = _.find persons, (p)->
        return (p.id is user_id)
      candidate = _.find persons, (p)->
        return (p.id is candidate_id)
      addFlag = true
      _.each user.talks, (t, num)=>
        if t.candidate._id.toString() is candidate._id.toString()
          addFlag = false
      if addFlag is false
        res.json 'already exist'
      else
        talk = new Talk()
        talk.user = user._id
        talk.candidate = candidate._id
        user.talks.push talk
        talk.save (err)->
          if err
            throw err
            res.json
              status: 'missing'
        news = new News()
        news.from = ""
        news.type = "talk"
        news.text = "#{candidate.name}さんについての応援団トークが作られました"
        user.news.push news
        user.save (err)->
          if err
            throw err
            res.json
              status: 'missing'
        res.json
          status: 'create talk'

exports.createSupporterMessage = (req, res)->
  console.log 'create supporter message'
  supporter = req.body.supporter
  user = req.body.userid
  text = req.body.text
  User.find({id: {$in: [user, supporter]}}).exec (err, persons)->
    if err
      throw err
    else
      user = _.find persons, (p)=>
        return (p.id is user)
      supporter = _.find persons, (p)=>
        return (p.id is supporter)
      supporterMessage = new SupporterMessage()
      supporterMessage.supporter = supporter._id
      supporterMessage.message = text
      user.supporter_message.push supporterMessage
      user.save (err)->
        if err
          throw err
      res.json supporterMessage

exports.fetchSupporterMessage = (req, res)->
  user = req.params.user_id
  User.findOne({id: user}).populate('supporter_message.supporter').exec (err, person)->
    if err
      throw err
    else
      console.log person
      supporterMessages = person.supporter_message
      res.send supporterMessages

exports.fetchProfile = (req, res)->
  user = req.params.user_id
  User.findOne({id: user}).exec (err, person)->
    if err
      throw err
    console.log person.profile
    person.profile.birthday_year = person.profile.birthday.getFullYear()
    person.profile.birthday_month = person.profile.birthday.getMonth()+1
    person.profile.birthday_day = person.profile.birthday.getDate()
    console.log person.profile
    res.send person.profile

exports.updateProfile = (req, res)->
  user = req.params.user_id
  profileParams = req.body
  User.findOne({id: user}).exec (err, person)->
    if err
      throw err
    console.log profileParams
    console.log '--------'
    person.profile_image_urls = profileParams.profile_image
    person.profile.address = profileParams.address
    person.profile.bloodType = profileParams.bloodType
    person.profile.drinking = profileParams.drinking
    person.profile.education = profileParams.education
    person.profile.gender = profileParams.gender
    person.profile.hasChild = profileParams.hasChild
    person.profile.martialHistory = profileParams.martialHistory
    person.profile.height = profileParams.height
    person.profile.hoby = profileParams.hoby
    person.profile.hometown = profileParams.hometown
    person.profile.income = profileParams.income
    person.profile.job = profileParams.job
    person.profile.like = profileParams.like
    person.profile.message = profileParams.message
    person.profile.shape = profileParams.shape
    person.profile.smoking = profileParams.smoking
    person.profile.wantChild = profileParams.wantChild
    person.profile.wantMarriage = profileParams.wantMarriage
    person.save (err)->
      if err
        throw err
    res.send person.profile

exports.fetchProfileImage = (req, res)->
  user = req.params.user_id
  User.findOne({id: user}).exec (err, person)->
    if err
      throw err
    res.send person.profile_image_urls

exports.fetchSettings = (req, res)->
  user = req.params.user_id
  User.findOne({id: user}).exec (err, person)->
    if err
      throw err
    res.send person.partner_requirements

exports.updateSettings = (req, res)->
  user = req.params.user_id
  requirements = req.body
  console.log requirements
  User.findOne({id: user}).exec (err, person)->
    if err
      throw err
    p_requirements = person.partner_requirements
    _.each requirements, (value, key)=>
      console.log key, value
      if value? and typeof(value) is 'object' and value.length > 1
        p_requirements[key] = []
        _.each value, (v)=>
          p_requirements[key].push parseInt v
      else
        p_requirements[key] = parseInt value
    person.save (err)->
      if err
        throw err
    res.send requirements


exports.fetchUserProfileImageUrl = (req, res)->
  user = req.params.user_id
  User.findOne({id: user}).exec (err, person)->
    if err
      throw err
    else
      console.log "urls", person
      if person is null or person is undefined
        res.send 'undefined'
      else if person.profile_image_urls? is false
        res.redirect "http://graph.facebook.com/#{person.facebook_id}/picture?type=large"
      else
        res.redirect person.profile_image_urls[0]

exports.createFollow = (req, res)->
  from = req.params.from
  to = req.params.to
  User.find({id: {$in: [from, to]}}).exec (err, persons)->
    console.log persons
    if err
      throw err
    else
      from = _.find persons, (p)=>
        return (p.id is from)
      to = _.find persons, (p)=>
        return (p.id is to)
      from.following.push to._id
      to.follower.push from._id
      from.save (err)->
        if err
          throw err
      to.save (err)->
        if err
          throw err
      res.json 'ok'

# fetchInviteFriendsFlag の間違い？
exports.fetchInfiteFriendsFlag = (req, res)->
  User.findOne({id: req.params.user_id}).exec (err, person)->
    if err
      throw err
    flag = person.inviteFriendsFlag
    res.send flag
    if flag is true
      flag = false
    person.save (err)->
      if err
        throw err

exports.fetchCandidateOfNumbers = (req, res)->
  userid = req.body.id
  console.log req.query
  User.findOne({id: req.params.user_id}).exec (err, person)->
    if err
      throw err
    q = req.query
    p = person.partner_requirements
    ageMin = if q.age is "0" then p.ageMin else 0
    ageMax = if q.age is "0" then p.ageMax else 100
    martialHistory = if !_.include(p.martialHistory, 0) then (if q.martialHistory is "0" then p.martialHistory else [0..3] )else [0..3]
    hasChild = if !_.include(p.hasChild, 0) then (if q.hasChild is "0" then p.hasChild else [0..4] )else [0..4]
    wantMarriage = if !_.include(p.wantMarriage, 0) then (if q.wantMarriage is "0" then p.wantMarriage else [0..5] )else [0..5]
    wantChild = if !_.include(p.wantChild, 0) then (if q.wantChild is "0" then p.wantChild else [0..5] )else [0..5]
    address = if !_.include(p.address, 0) then (if q.address is "0" then p.address else [0..47] )else [0..47]
    hometown = if !_.include(p.hometown, 0) then (if q.hometown is "0" then p.hometown else [0..47] )else [0..47]
    job = if !_.include(p.job, 0) then (if q.job is "0" then p.job else [0..22] )else [0..22]
    income = if q.income is "0" then p.income else 0
    education = if !_.include(p.education, 0) then (if q.education is "0" then p.education else [0..47] )else [0..47]
    bloodtype = if !_.include(p.bloodtype, 0) then (if q.bloodtype is "0" then p.bloodtype else [0..5] )else [0..5]
    height = if q.height is "0" then p.height else 0
    shape = if !_.include(p.shape, 0) then (if q.shape is "0" then p.shape else [0..8] )else [0..8]
    drinking = if !_.include(p.drinking, 0) then (if q.drinking is "0" then p.drinking else [0..6] )else [0..6]
    smoking = if !_.include(p.smoking, 0) then (if q.smoking is "0" then p.smoking else [0..4] )else [0..4]

    User.count({
      'profile.gender': {$ne: person.profile.gender}
      'profile.age': {$gte: ageMin, $lte: ageMax}
      'profile.martialHistory': {$in: martialHistory}
      'profile.hasChild': {$in: hasChild}
      'profile.wantMarriage': {$in:wantMarriage}
      'profile.wantChild': {$in: wantChild}
      'profile.address': {$in: address}
      'profile.hometown': {$in: hometown}
      'profile.job': {$in: job}
      'profile.income': {$gte: income}
      'profile.education': {$in: education}
      'profile.bloodType': {$in: bloodtype}
      'profile.shape': {$in: shape}
      'profile.drinking': {$in: drinking}
      'profile.smoking': {$in: smoking}
    }).exec (err, count)->
      res.json count
      logger.emit "cestimate", req.query