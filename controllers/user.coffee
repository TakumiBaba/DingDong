models = require '../models'
User = models.User
Talk = models.Talk
Comment = models.Comment
SupporterMessage = models.SupporterMessage
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

exports.fetch_news = (req, res)->
  id = req.params.id
  User.findOne({id: id}).exec (err, person)->
    if err
      throw err
    else
      news = person.news
      res.send news
      res.end()

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
    p = person.profile
    p.address = profileParams.address
    p.age = profileParams.age
    date = new Date("#{profileParams.birthday_year}/#{profileParams.birthday_month}/#{profileParams.birthday_day}")
    p.birthday = date
    p.bloodType = profileParams.bloodType
    p.drinking = profileParams.drinking
    p.education = profileParams.education
    p.gender = profileParams.gender
    p.havingChild = profileParams.havingChild
    p.havingMarried = profileParams.havingMarried
    p.height = profileParams.height
    p.hoby = profileParams.hoby
    p.hometown = profileParams.hometown
    p.income = profileParams.income
    p.job = profileParams.job
    p.like = profileParams.like
    p.message = profileParams.message
    p.shape = profileParams.shape
    p.smoking = profileParams.smoking
    p.wantChild = profileParams.wantChild
    p.wantMarriage = profileParams.wantMarriage
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
    console.log person.partner_requirements
    res.send person.partner_requirements

exports.updateSettings = (req, res)->
  user = req.params.user_id
  requirements = req.body
  console.log requirements
  User.findOne({id: user}).exec (err, person)->
    if err
      throw err
    p_requirements = person.partner_requirements
    _.each requirements, (v, k)=>
      p_requirements[k] = v
    person.save (err)->
      if err
        throw err
    res.send requirements


exports.fetchUserProfileImageUrl = (req, res)->
  user = req.params.user_id
  User.findOne({id: user}).exec (err, person)->
    if err
      throw err
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