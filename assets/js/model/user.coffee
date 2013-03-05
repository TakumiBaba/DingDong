App = window.App

class App.Model.User extends Backbone.Model
  urlRoot: '/user'
  constructor: (attrs, options)->
    super

class App.Model.News extends Backbone.Model
  urlRoot: '/news'
  constructor: (attrs, options)->
    super

class App.Model.Matching extends Backbone.Model
  constructor: (attrs, options)->
    super
    @.urlRoot = "/user/#{attrs.userid}/matching"

  defaults:
    name: ""
    profile_image: ""
    id: ""

class App.Model.Like extends Backbone.Model
  constructor: (attrs, options)->
    super
    @.urlRoot = "/user/#{attrs.userid}/like"
  defaults:
    name: ""
    id: ""
    profile_image: ""

class App.Model.Talk extends Backbone.Model
  urlRoot: '/talk'
  constructor: (attrs, options)->
    super

class App.Model.Profile extends Backbone.Model
  urlRoot: '/profile'
  constructor: (attrs, options)->
    super
    @.urlRoot = "/user/#{attrs.userid}/profile"

class App.Model.Settings extends Backbone.Model
  urlRoot: '/profile'
  constructor: (attrs, options)->
    super
    @.urlRoot = "/user/#{attrs.userid}/settings"

class App.Model.SupporterMessage extends Backbone.Model
  urlRoot: '/supportermessage'
  constructor: (attrs, options)->
    super
    @.urlRoot = "/user/#{attrs.userid}/supportermessage"

class App.Model.Signup extends Backbone.Model
  urlRoot: '/signup'

class App.Model.Message extends Backbone.Model
  constructor: (attrs, options)->
    super

  setParams: (one, two)->
    @.urlRoot = "/user/#{one}/#{two}/message"
