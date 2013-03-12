models = require '../models'

User = models.User
Candidate = models.Candidate
News = models.News
# マッチング系のAPI
# GET → fetch
# POST → create
# PUT → update


exports.fetch_matching = (req, res)->
  id = req.params.user_id
  User.findOne({id: id}).populate('candidates.user').exec (err, person)->
    if err
      throw err
    else
      console.log person
      candidates = _.filter person.candidates, (c, num)->
        return (c.state is 0)
      system = _.filter candidates, (c, num)->
        return (c.isSystemMatching is true)
      if system.length > 9
        system.splice 9
      supporter = _.filter candidates, (c, num)->
        return (c.isSystemMatching is false)
      if supporter.length > 9
        supporter.splice 9
      list = system.concat supporter
      res.send list

exports.fetchSystemMatching = (req, res)->
  id = req.params.id


exports.update_matching = (req, res)->
  user_id = req.params.user_id
  candidate_id = req.params.candidate_id
  state = req.body.state
  isSystemMatching = if req.body.isSystemMatching is "true" then true else false
  User.findOne({id: user_id}).populate('candidates.user').exec (err, person)->
    if err
      throw err
    else
      candidate = {}
      _.each person.candidates, (c, num)=>
        if c.id is candidate_id
          candidate = person.candidates[num]
      if candidate?
        candidate.state = state || candidate.state
        candidate.isSystemMatching = isSystemMatching
        person.save (err)->
          if err
            throw err
        c = undefined
        c_num = undefined
        console.log candidate.user.candidates
        _.each candidate.user.candidates, (u, num)=>
          console.log u.id, user_id
          if u.id is user_id
            c = candidate.user.candidates[num]
            num = c_num
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
        news.from = user_id
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
        res.send 'inai'

exports.fetchFollowingUsers = (req, res)->
  user = req.params.user_id
  User.findOne({id: user}).populate('following').exec (err, person)->
    if err
      throw err
    res.send person.following

exports.fetchFriendsIntroduction = (req, res)->
  user = req.params.user_id
  User.findOne({id: user}).populate('following').exec (err, person)->
    if err
      throw err
    age_min = person.partner_requirements.age_min
    age_max = person.partner_requirements.age_max
    gender = person.profile.gender
    User.find().where('profile.gender').ne(gender).where('profile.age').gt(age_min).lt(age_max).exec (err, persons)=>
      shuffledList = _.shuffle persons
      # shuffledList.splice 9
      console.log shuffledList
      userlist = person.following.concat shuffledList
      res.send userlist

exports.changeSupporterMatching = (req, res)->
  user_one = req.params.one
  user_two = req.params.two

  User.find({id: {$in: [user_one, user_two]}}).populate('candidates.user', 'id').exec (err, persons)=>
    if err
      throw err
    user_one = _.find persons, (p)->
      return (p.id is user_one)
    user_two = _.find persons, (p)->
      return (p.id is user_two)
    users = [user_one, user_two]
    _.each users, (user, num)=>
      one = ""
      two = ""
      if num is 0
        one = users[0]
        two = users[1]
      else if num is 1
        one = users[1]
        two = users[0]
      else
        res.send 'error'

      existFlag = false
      indexNumber = 0
      # console.log one
      _.each one.candidates, (c, num)=>
        if c.toString() is two._id.toString()
          existFlag = true
          indexNumber = num
      if existFlag is true
        candidate = one.candidate[indexNumber]
        candidate.isSystemMatching = false
      else
        candidate = new Candidate()
        candidate.user = two._id
        candidate.isSystemMatching = false
        candidate.state = 0
        one.candidates.push candidate
      one.save (err)->
        if err
          throw err

    res.send "#{} and #{} changes supportermathcing"


