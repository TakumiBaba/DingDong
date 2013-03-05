require.config
  paths:
    text: 'js/libs/text'
    jade: 'js/libs/jade'
    backbone: 'libs/backbone.min'

window.App = {}
window.JST = {}
App = window.App
App.View = {}
App.Model = {}
App.Collection = {}

# require ['backbone'], (backbone)=>
class Router extends Backbone.Router

  constructor: (attrs)->
    super
    @.me = attrs.id
    @.beforeHash = ""
    @.beforeId = ""

  routes:
    "": "me"
    ":action": "me"
    "user/:id": "you"
    "user/:id/:action": "you"

  me: (action)->
    uid = App.User.get('id')
    if App.Sidebar.model.get('id') isnt uid
      App.Sidebar.setModel App.User
      App.Sidebar.render()
    switch action
      when undefined
        index = new App.View.IndexPage()
        index.render()
      when "matching"
        matching = new App.View.MatchingPage
          id: uid
        matching.render()
      when "message"
        message = new App.View.MessagePage
          id: uid
        message.render()
      when "like"
        like = new App.View.LikePage
          id: uid
        like.render()
      when "talk"
        talk = new App.View.TalkPage
          id: uid
        talk.render()
      when "request"
        console.log 'request'
      when "profile"
        profile = new App.View.ProfilePage
          id: uid
      when "settings"
        settings = new App.View.SettingsPage
          id: uid
      when "signup"
        signup = new App.View.SignupPage()


  you: (id, action)->
    if App.Sidebar.model.get('id') isnt id
      user = new App.Model.User
        id: id
      App.Sidebar.setModel user
      user.fetch()
    switch action
      when undefined
        userpage = new App.View.IndexPage
          id: id
        userpage.render()
      when "matching"
        matching = new App.View.MatchingPage
          id: id
        matching.render()
      when "like"
        like = new App.View.LikePage
          id: id
        like.render()
      when "talk"
        talk = new App.View.TalkPage
          id: id
        talk.render()

window.fbAsyncInit = ()->
  initialize = (id)->
    App = window.App
    App.User = new App.Model.User
      id: id
    App.Header = new App.View.Header
      model: App.User

    App.Sidebar = new App.View.Sidebar
      model: App.User

    App.User.fetch()

    router = new Router
      id: id
    Backbone.history.start()

    FB.api 'me/apprequests', (res)=>
      requests = _.filter res.data, (d)=>
        return d.application.id is "381551511881912"
      if requests.length > 0
        App.Header.appendRequests(requests)

  FB.init
    appId: 381551511881912
    channelUrl: '//localhost:3000/'
    status: true
    cookie: true
  FB.ui
    method: "permissions.request"
    perms: "user_photos, user_about_me, user_relationships"

  FB.getLoginStatus (res)=>
    if res.status is 'not_authorized'
      FB.login()
    else if res.status is 'connected'
      console.log 'connected'
    else
      FB.login()
  FB.Event.subscribe 'auth.statusChange', (response)=>
    console.log response
    if response.status is 'connected'
      FB.api 'me', (res)=>
        console.log res
        $.ajax
          type: "POST"
          url: "/session/create"
          data:
            userid: res.id
            name:   res.name
          success: (data)=>
            console.log data
            initialize(data.id)
            # FB.api 'me/friends', (res)->
            #   console.log res