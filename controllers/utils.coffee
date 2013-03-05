models = require '../models'
User = models.User
Talk = models.Talk
Comment = models.Comment
Candidate = models.Candidate
News = models.News
Crypto = require 'crypto'

exports.create_dammy_users = (req, res)->
  for i in [1..500]
    exports.create_dammy_user(i)
  res.send 'ok'

exports.fillCandidates = (req, res)->
  id = req.params.id
  console.log id
  User.findOne({id: id}).populate('candidates.user').exec (err, person)->
    if err
      throw err
    else
      system = _.filter person.candidates, (c)->
        return (c.state is 0 and c.isSystemMatching is true)
      exclusionList = _.pluck person.candidates, "id"
      gender = person.profile.gender
      age_min = person.partner_requirements.age_min
      age_max = person.partner_requirements.age_max
      if system.length < 20
        num = 20 - system.length
        exclusionList = _.pluck person.candidates, "id"
        User.find().where('gender').ne(gender).where('id').nin(exclusionList).where('profile.age').gt(age_min).lt(age_max).exec (err, persons)=>
          if err
            throw err
          else
            shuffled_list = _.shuffle persons
            console.log 'shuffled'
            for i in [0..num-1]
              console.log shuffled_list[i]
              candidate = new Candidate()
              candidate.id = shuffled_list[i].id
              candidate.user = shuffled_list[i]._id
              candidate.isSystemMatching = true
              candidate.state = 0
              person.candidates.push candidate
            person.save (err)->
              if err
                throw err
            res.json person
      else
        res.json 'filled'

exports.deleteCandidates = (req, res)->
  id = req.params.id
  User.findOne({id: id}).exec (err, person)->
    if err
      throw err
    else
      person.candidates = []
      person.save (err)->
        if err
          throw err
      res.json 'delete'

exports.create_dammy_user = (i)->
  user = new User()
  sha1_hash = Crypto.createHash 'sha1'
  sha1_hash.update "#{i+10000}"
  user.name = "馬場#{i}世"
  user.username = "baba.takumi"
  user.facebook_id = i+10000
  user.id = sha1_hash.digest 'hex'
  if i%2 is 0
    user.profile.gender = 'male'
  else
    user.profile.gender = 'female'
  age = parseInt (20+(Math.floor(Math.random()*40)))
  user.profile.age = age
  user.isMarried = false
  user.partner_requirements.age_min = parseInt age-5
  user.partner_requirements.age_max = parseInt age+5
  urls = ["/image/friends/#{if i%24 is 0 then 25 else i%24}.jpg"]
  user.profile_image_urls = urls
  user.profile.message = "こんばんわ！#{i}世だよ！"
  user.profile_image_urls.push "https://graph.facebook.com/#{user.id}/picture"
  user.isSupporter = false
  news = new News()
  news.text = "#{i}世さんがDing Dongを始めました！"
  user.news.push news
  user.save (err)->
    if err
      console.log err
    else
      console.log 'ok'
