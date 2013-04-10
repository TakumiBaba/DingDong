App = window.App

class App.Collection.News extends Backbone.Collection
  model: App.Model.News

  constructor: (attrs, options)->
    super
    @.id = attrs.id
    @.url = "/user/#{attrs.id}/news"

class App.Collection.MatchingList extends Backbone.Collection
  model: App.Model.Matching

  constructor: (attrs, options)->
    super
    @.userid = attrs.userid
    @.url = "/user/#{attrs.userid}/matching/"

class App.Collection.LikeList extends Backbone.Collection
  model: App.Model.Like

  constructor: (attrs, options)->
    super
    @.id = attrs.userid
    @.url = "/user/#{attrs.userid}/like/"

class App.Collection.TalkList extends Backbone.Collection
  model: App.Model.Talk

  constructor: (attrs, options)->
    super
    @.userid = attrs.userid
    @.url = "/talk/#{attrs.userid}"

class App.Collection.SupporterMessageList extends Backbone.Collection
  model: App.Model.SupporterMessage

  constructor: (attrs, options)->
    super
    @.userid = attrs.userid
    @.url = "/user/#{attrs.userid}/supportermessage"
    console.log @.url

class App.Collection.PreCandidates extends Backbone.Collection
  model: App.Model.User

  constructor: (attrs, options)->
    super

class App.Collection.Followings extends Backbone.Collection
  model: App.Model.User

  constructor: (attrs, options)->
    super
    @.url = "/user/#{attrs.id}/following"

class App.Collection.Followers extends Backbone.Collection
  model: App.Model.User

  constructor: (attrs, options)->
    super
    @.url = "/user/#{attrs.id}/follower"
  setId: (id)->
    @.url = "/user/#{id}/follower"

class App.Collection.MessageList extends Backbone.Collection
  # model: App.Model.Message

  constructor: (attrs, options)->
    super
    @.url = "/user/#{attrs.userid}/messagelist"

class App.Collection.Messages extends Backbone.Collection
  model: App.Model.Message

  constructor: (attrs, options)->
    super
    @.url = "/"

class App.Collection.Comments extends Backbone.Collection
  model: App.Model.Comment

  constructor:()->
    super