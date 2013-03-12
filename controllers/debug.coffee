models = require '../models'
User = models.User
Talk = models.Talk
News = models.News
MessageList = models.MessageList

exports.update_matching = (req, res)->
  from = req.params.from
  to = req.params.to
  state = req.params.state
  console.log from, to
  isSystemMatching = if req.params.isSystemMatching is "true" then true else false
  User.findOne({id: from}).populate('candidates.user').exec (err, person)->
    if err
      throw err
    else
      candidate = {}
      _.each person.candidates, (c, num)=>
        if c.id is to
          candidate = person.candidates[num]
      if candidate?
        candidate.state = state || candidate.state
        candidate.isSystemMatching = isSystemMatching
        person.save (err)->
          if err
            throw err
        c = undefined
        c_num = undefined
        _.each candidate.user.candidates, (u, num)=>
          if u.id is from
            c = candidate.user.candidates[num]
            c_num = num
        if c?
          if candidate.state is 1
            candidate.user.candidates[c_num].state = 2
          else if candidate.state is 2
            candidate.user.candidates[c_num].state = 1
          else if candidate.state is 3
            candidate.user.candidates[c_num].state = 3
          else
            candidate.user.candidates[c_num].state = 1
        else
          newCandidate = new Candidate()
          newCandidate.user = person._id
          newCandidate.isSystemMatching = false
          newCandidate.state = 2
          newCandidate.id = person.id
          candidate.user.candidates.push newCandidate
        news = new News()
        news.from = from
        news.type = "like"
        news.text = "#{person.name}さんがあなたにいいね！しました。"
        candidate.user.news.push news
        candidate.user.save (err)->
          if err
            throw err
          else
            console.log candidate
        res.json candidate
      else
        console.log 'inai'

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

exports.deleteAllData = (req, res)->
  User.find().exec (err, docs)->
    if err
      throw err
    else
      _.each docs, (p)->
        p.remove()
  Talk.find().exec (err, docs)->
    if err
      throw err
    else
      _.each docs, (p)->
        p.remove()
  req.session.destroy()
  res.send 'reset'

exports.fetchAllUser = (req, res)->
  User.find().exec (err, docs)->
    res.send docs

exports.deleteMessages = (req, res)->
  User.find().exec (err, persons)->
    if err
      throw err
    _.each persons, (p)->
      p.message_list = []
      p.save (err)->
        if err
          throw err
  MessageList.find().exec (err, lists)->
    if err
      throw err
    _.each lists, (list)->
      list.remove()

  res.send 'ok'