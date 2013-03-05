models = require '../models'

User = models.User
MessageList = models.MessageList
Message = models.Message
# メッセージ系のAPI
# GET → fetch
# POST → create
# PUT → update

exports.fetchMessagingUserList = (req, res)->
  user = req.params.user_id
  User.findOne({id: user}).exec (err, person)=>
    if err
      throw err
    MessageList.find({_id: {$in: person.message_list}}).populate('user', 'id').exec (err, lists)=>
      if err
        throw err
      messageList = []
      console.log lists
      _.each lists, (list)=>
        if list.user[0].id is user
          messageList.push {id: list.user[1].id}
        else
          messageList.push {id: list.user[0].id}
      console.log messageList
      res.json messageList


exports.fetchMessage = (req, res)->
  one_id = req.params.one
  two_id = req.params.two
  User.find({id: {$in: [one_id, two_id]}}).exec (err, persons)=>
    if err
      throw err
    if persons.length is 2
      one = _.find persons, (p)=>
        return (p.id is one_id)
      two = _.find persons, (p)=>
        return (p.id is two_id)
      MessageList.findOne().where('user').all([one._id, two._id]).exec (err, mList)=>
        if err
          throw err
        console.log 'hoge'
        console.log mList
        res.send mList.contents
    else
      res.send 'error'

exports.createMessage = (req, res)->
  from_id = req.params.from
  to_id = req.params.to
  text = req.body.text || req.params.text
  console.log from_id, to_id, text
  User.find({id: {$in: [from_id, to_id]}}).exec (err, persons)=>
    if err
      throw err
    from = _.find persons, (p)=>
      return (p.id is from_id)
    to = _.find persons, (p)=>
      return (p.id is to_id)
    MessageList.findOne().where('user').all([from._id, to._id]).exec (err, mList)=>
      if err
        throw err
      message = new Message()
      if mList?
        console.log 'mlist exist'
        message.text = text
        message.from = from.id
      else
        console.log 'create mlist '
        mList = new MessageList()
        mList.user.push from._id
        mList.user.push to._id
        message.text = text
        message.from = from.id
        from.message_list.push mList
        to.message_list.push mList
        from.save (err)->
          if err
            throw err
        to.save (err)->
          if err
            throw err

      mList.contents.push message
      mList.save (err)->
        if err
          throw err
      res.json mList

