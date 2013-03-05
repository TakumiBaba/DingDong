models = require '../models'
User = models.User
Talk = models.Talk
MessageList = models.MessageList

exports.update_matching = (req, res)->
  from = req.params.from
  to = req.params.to
  state = req.params.state
  console.log from
  isSystemMatching = if req.params.isSystemMatching is "true" then true else false
  User.findOne({id: from}).populate('candidates.user').exec (err, person)->
    if err
      throw err
    else
      candidate = _.find person.candidates, (c)=>
        return (c.id is to)
      if candidate?
        candidate.state = state
        candidate.isSystemMatching = isSystemMatching
        console.log candidate
        person.save (err)->
          if err
            throw err
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