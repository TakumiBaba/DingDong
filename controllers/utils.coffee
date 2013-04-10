models = require '../models'
User = models.User
Talk = models.Talk
Comment = models.Comment
Candidate = models.Candidate
News = models.News
Crypto = require 'crypto'
Config = require '../configure/config.json'
http   = require 'http'

exports.create_dammy_users = (req, res)->
  for i in [1..500]
    exports.create_dammy_user(i)
  res.send 'ok'

exports.fillCandidates = (req, res)->
  id = req.params.id
  console.log 'fill candidates'
  console.log id
  User.findOne({id: id}).exec (err, person)->
    if err
      throw err
    else
      console.log person
      system = _.filter person.candidates, (c)->
        return (c.state is 0 and c.isSystemMatching is true)
      exclusionList = _.pluck person.candidates, "id"
      gender = person.profile.gender
      age_min = person.partner_requirements.ageMin || 22
      age_max = person.partner_requirements.ageMax || 60
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
  p = user.profile
  p.birthday = Date.now()
  p.martialHistory = i%4
  p.hasChild = i%5
  p.wantMarriage = i%6
  p.wantChild = i%6
  p.address = i%48
  p.hometown = i%48
  p.job = i%23
  p.income = i*100
  p.height = 160+(i*30)
  p.education = i%7
  p.bloodType = i%5
  p.shape = i%9
  p.drinking = i%7
  p.smoking = i%5
  news = new News()
  news.text = "#{i}世さんがDing Dongを始めました！"
  user.news.push news
  user.save (err)->
    if err
      console.log err
    else
      console.log 'ok'

exports.calculateAge = (b)->
  d = new Date()
  today = d.getFullYear()*10000+(d.getMonth()+1)*100+d.getDate()
  birthday = b.getFullYear()*10000+(b.getMonth()+1)*100+b.getDate()
  return Math.floor((today - birthday)/10000)

exports.updateAge = (req, res)->
  User.find().where('isSupporter').equals(false).exec (err, persons)->
    if err
      throw err

exports.newsNotification = (req, res, id, text)->
  console.log 'notification'
  id = id || "baba.takumi"
  text = text || "hogefuga"
  query = "?href=''&template=#{text}&access_token=#{req.session.accessToken}"
  options =
    host: "https://graph.facebook.com"
    port: 80
    path: "/#{id}/notification"
    method: "POST"

  req = http.request options, (res)->
    res.setEncoding 'utf8'
    res.on 'data', (chunk)->
      console.log chunk
  req.on 'error', (e)->
    console.log e

  # 寝る前のメモ
  # { [Error: getaddrinfo ENOENT] code: 'ENOTFOUND', errno: 'ENOTFOUND', syscall: 'getaddrinfo' }
  # こんなエラーが帰ってきた。
  # アドレス情報が間違ってそう。

  req.write 'data\n'
  req.end()

