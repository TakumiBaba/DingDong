mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

# Tweet
TweetSchema = new Schema
  message:
    type: String
  user:
    type: ObjectId
    ref: 'User'
  created_at:
    type: Date
    default: Date.now()

CommentSchema = new Schema
  user:
    type:ObjectId
    ref: "User"
  text:
    type: String
  count:
    type: Number
    default: 0
  created_at:
    type: Date
    default: Date.now()

TalkSchema = new Schema
  user:
    type: ObjectId
    ref: "User"
  created_at:
    type: Date
    default: Date.now
  comments:
    type: [CommentSchema]
  candidate:
    type: ObjectId
    ref: "User"

CandidateSchema = new Schema
  id:
    type: String
  user:
    type: ObjectId
    ref: "User"
  created_at:
    type: Date
    default: Date.now
  isSystemMatching:
    type: Boolean
    default: true
  state:
    type: Number
    default: 0
    #0 is いいね前のマッチングリスト表示
    #1 is 自分から申請済み
    #2 is 相手から申請済み
    #3 is お互いに申請済み

#利用者
UserSchema = new Schema
  name:
    type: String
  first_name:
    type: String
  last_name:
    type: String
  facebook_id:
    type: String
  id:
    type: String
  created_at:
    type: Date
    default: Date.now
  username:
    type: String
  profile:
    image_urls:
      type: String
    age:
      type: Number
      default: 22
    gender:
      type: String
      default: ""
    birthday:
      type: Date
    martialHistory:
      type: Number
      default: 1
    hasChild:
      type: Number
      default: 1
    wantMarriage:
      type: Number
      default: 1
    wantChild:
      type: Number
      default: 1
    address:
      type: Number
      default: 1
    hometown:
      type: Number
      default: 1
    job:
      type: Number
      default: 1
    income:
      type: Number
      default: 0
    height:
      type: Number
      default: 0
    education:
      type: Number
      default: 1
    bloodType:
      type: Number
      default: 1
    shape:
      type: Number
      default: 1
    drinking:
      type: Number
      default: 1
    smoking:
      type: Number
      default: 1
    hoby:
      type: String
      default: ""
    like:
      type: [String]
    message:
      type: String
      default: ""
  partner_requirements:
    ageMin:
      type: Number
    ageMax:
      type: Number
    martialHistory:
      type: [Number]
    hasChild:
      type: [Number]
      default: 0
    wantMarriage:
      type: [Number]
      default: 0
    wantChild:
      type: [Number]
      default: 0
    address:
      type: [Number]
      default: 0
    hometown:
      type: [Number]
      default: 0
    job:
      type: [Number]
      default: 0
    income:
      type: Number
      default: 0
    education:
      type: [Number]
      default: 0
    bloodtype:
      type: [Number]
      default: 0
    height:
      type: Number
      default: 0
    shape:
      type: [Number]
      default: 0
    drinking:
      type: [Number]
      default: 0
    smoking:
      type: [Number]
      default: 0
  is_married:
    type: Boolean
  candidates:
    type: [CandidateSchema]
    default: []
  following:
    type: [{type: ObjectId, ref: "User"}]
    default: []
  follower:
    type: [{type: ObjectId, ref: "User"}]
    default: []
  profile_image_urls:
    type: [String]
  profile_message:
    type: String
  talks:
    type: [TalkSchema]
  news:
    type: [NewsSchema]
  isSupporter:
    type: Boolean
  isFirstLogin:
    type: Boolean
    default: true
  message_list: [{type: ObjectId, ref: "MessageList"}]
  supporter_message:
    type: [SupporterMessageSchema]
  inviteFriendsFlag:
    type: Boolean
    default: false

# サポーター
SupporterSchema = new Schema
  id:
    type: String
  name:
    type: String
  support_users:
    type: [String]
  news:
    type: [NewsSchema]

SupporterMessageSchema = new Schema
  supporter:
    type: ObjectId
    ref: "User"
  message:
    type: String
  count:
    type: Number
    default: 0

NewsSchema = new Schema
  created_at:
    type: Date
    default: new Date()
  from:
    type: String
  type:
    type: String
  text:
    type: String

MessageListSchema = new Schema
  created_at:
    type: Date
    default: Date.now
  user: [type: ObjectId, ref: 'User']
  contents: [MessageSchema]

MessageSchema = new Schema
  created_at:
    type: Date
    default: Date.now
  text:
    type: String
  from:
    type: String
  name:
    type: String
    default: "takumi"

UserSchema.statics.findOrCreateByName = (name, callback)->
  this.findOne('name': name, 'name created_at', (error, docs) =>
    user = docs
    unless user
      user = this('name': name)
      user.save()
    callback(error, user)
  )

module.exports =
  UserSchema: UserSchema
  User: mongoose.model 'User', UserSchema
  CandidateSchema: CandidateSchema
  Candidate: mongoose.model 'Candidate', CandidateSchema
  TalkSchema: TalkSchema
  Talk: mongoose.model 'Talk', TalkSchema
  CommentSchema: CommentSchema
  Comment: mongoose.model 'Comment', CommentSchema
  SupporterSchema: SupporterSchema
  Supporter:  mongoose.model 'Supporter', SupporterSchema
  NewsSchema: NewsSchema
  News:  mongoose.model 'News', NewsSchema
  MessageListSchema: MessageListSchema
  MessageList:  mongoose.model 'MessageList', MessageListSchema
  MessageSchema: MessageSchema
  Message:  mongoose.model 'Message', MessageSchema
  SupporterMessageSchema: SupporterMessageSchema
  SupporterMessage:  mongoose.model 'SupporterMessage', SupporterMessageSchema
