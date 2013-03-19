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
        matching = new App.View.MatchingPage
          id: uid
        matching.render()
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
      when "profile"
        App.Profile._render()
      when "settings"
        App.Settings._render()
      when "signup"
        signup = new App.View.SignupPage()
      else
        location.href = "/#/"


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
      else
        location.href = "/#/"

window.fbAsyncInit = ()->
  initialize = (id)->
    App = window.App
    App.User = new App.Model.User
      id: id
    App.Header = new App.View.Header
      model: App.User

    App.Sidebar = new App.View.Sidebar
      model: App.User

    App.Profile = new App.View.ProfilePage
      id: id
    App.Settings = new App.View.SettingsPage
      id: id

    App.User.fetch()

    router = new Router
      id: id
    Backbone.history.start()

    $.ajax
      type: "GET"
      url: "/user/#{App.User.id}/invitefriendsflag"
      success: (data)->
        if data is true
          window.alert("Facebookの友達の中から応援団を選びましょう！")
          FB.ui
            method: "apprequests"
            message: "応援に参加してください！"
            data: App.User.get 'id'

  FB.init
    appId: 381551511881912
    channelUrl: '//localhost:3000/'
    status: true
    cookie: true

  FB.getLoginStatus (res)=>
    if res.status is 'connected'
      console.log "connected"
    else
      FB.login()
      FB.ui
        method: "permissions.request"
        perms: "user_photos, user_about_me, user_relationships"
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