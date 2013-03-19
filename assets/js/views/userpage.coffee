App = window.App

class App.View.UserPage extends Backbone.View
  el: "div#userpage"

  events:
    "click button.close": "close"
    "click div#userpage-sidebar li": "changeUser"
    "click button.matching-list": "changeMatchigListView"

  constructor: (attrs)->
    _.bindAll @, "appendAllItem"
    @.target = attrs.target
    @.collection = new App.Collection.MatchingList
      userid: App.User.id
    @.collection.bind 'reset', @.appendAllItem
    @.collection.fetch()

  render: ()=>
    html = window.JST['userpage/modal']({isSupporter: true})
    if $('body').find("div#userpage").length > 0
      console.log 'already exist'
    else
      $('body').append html
    $("#userpage").modal()

  close: ()->
    console.log 'close'
    $('body').remove("#userpage")

  changeUser: (e)=>
    $('ul.userpage-sidebar-ul').find('li').each ()->
      if $(@).hasClass('active')
        $(@).removeClass 'active'
    $(e.currentTarget).addClass 'active'
    @.target = e.currentTarget.id
    @.isSupporter = false
    user = _.find @.collection.models, (model)->
      return model.id is e.currentTarget.id
    console.log 'candidate'
    console.log App.User.get('person')
    if ( _.find App.User.get('person').following, (f)=>
          return f.id is @.target)
      $(@.el).find('div.supporter-menu').show(0)
    else
      $(@.el).find('div.supporter-menu').hide(0)
    name = user.get('user').name
    gender = if user.get('user').profile.gender is 'male' then "男性" else "女性"
    age = user.get('user').profile.age
    birthday = new Date(user.get('user').profile.birthday)
    $(@.el).find('div.profile h4').html(name)
    $(@.el).find('div.profile h5').html("#{gender}　#{age}歳　#{birthday.getFullYear()}年#{birthday.getMonth()+1}月#{birthday.getDay()}日生まれ")
    $(@.el).find('div.profile img.profile-image').attr 'src', user.get('user').profile_image_urls[0]
    @.setFollowers(user)
    @.setDetailProfile(user.get('user').profile)

  setDetailProfile: (profile)->
    $(@.el).find('table.table tbody').html window.JST['userpage/detailProfile'](profile);

  setFollowers: (user)->
    id = user.get('user').id
    followers = new App.View.UserPageFollowerList
      id: id
    # followers.fetch()
    # ここでBindさせたりする。
    # めんどくさいから朝起きたらやる
    # console.log followers
    # _.each followers.models, (follower)->
    #   console.log follower.get('name')

  setFollowerMessage: ()->
    console.log '応援団メッセージ'

  changeMatchigListView: (e)->
    console.log 'matching list view'
    matchingListView = new App.View.UserPageMatchingList()
    matchingListView.render()

  # 2カラムにして、応援団メッセージと一覧を統合しても良いかも。
  # メッセージのある人は応援団一覧でも上位に持ってくる。
  #

  appendItem: (model)->
    options =
      source: model.get('user').profile_image_urls[0]
      name: model.get('user').name
      id: model.get('user').id
    li = window.JST['userpage/footerUser'](options)
    $(@.el).find('ul.userpage-sidebar-ul').append li

  appendAllItem: (collection)->
    $(@.el).find('ul.userpage-sidebar-ul').empty()
    _.each collection.models, (model)=>
      @.appendItem model
    _changeUser = @.changeUser
    $(@.el).find('ul.userpage-sidebar-ul li').each (num)->
      $(@).bind 'click', _changeUser
    $(@.el).find("li##{@.target}").click()

class App.View.UserPageFollowerList extends Backbone.View
  el: "ul.follower-list"

  constructor: (attrs)->
    super
    $(@.el).empty()
    _.bindAll @, "render", "getMessages"
    # ここのモデルを、SupporterMessageに変更する
    @.messages = new App.Model.SupporterMessage
      userid: attrs.id
    @.followers = new App.Collection.Followers
      id: attrs.id
    @.followers.bind 'reset', @.render
    @.messages.bind 'change', @.getMessages
    @.messages.fetch()

  getMessages: (model)->
    @.messages = []
    _.each model.attributes, (message, num)=>
      @.messages[num] =
        id: message.supporter
        text: message.message
    @.followers.fetch()

  render: (collection)->
    console.log collection
    _.each collection.models, (model)=>
      message = _.find @.messages, (message)->
        return message.id is model.get('_id')
      options =
        facebook_url: "https://facebook.com/#{model.get('facebook_id')}"
        source: "/user/#{model.get('id')}/picture"
        name: model.get('name')
        text: if message? then message.text else ""
      if options.text is ""
        html = window.JST['userpage/follower'](options)
      else
        html = window.JST['userpage/followerWithMessage'](options)
      $(@.el).append html

class App.View.UserPageMatchingList extends Backbone.View
  el: "div.userpage-main"

  constructor: (attrs)->
    super

  render: ->
    $(@.el).empty()
    html = window.JST['userpage/matchign-list']()
    $(@.el).html(html)

# class App.View.UserPage extends Backbone.View
#   el: "#main"

#   constructor: (attrs, options)->
#     super
#     user = new App.Model.User
#       id: attrs.id
#     supporterMessageList = new App.Collection.SupporterMessageList
#       userid: attrs.id

#     profile = new App.View.ProfileMessageBox
#       model: user
#     $(@.el).append profile.el
#     supporterInformationBox = new App.View.SupporterInfomationBox
#       collection: supporterMessageList
#     $(@.el).append supporterInformationBox.el

#     user.fetch()
#     supporterMessageList.fetch()

# class App.View.ProfileMessageBox extends Backbone.View
#   tagName: "div"
#   className: "box-green navbar"

#   constructor: (attrs, options)->
#     super
#     _.bindAll @, "render"
#     @.model.bind 'change', @.render
#     compiledTemplate = _.template($("#box-template").html())
#     $(@.el).html(compiledTemplate({title: "自己紹介" , subTitle: ""}))

#   render: ()=>
#     profile_message = @.model.attributes.person.profile.message
#     p = $("<p>#{profile_message}</p>")
#     $(@.el).find('.info').append p

# class App.View.SupporterInfomationBox extends Backbone.View
#   tagName: "div"
#   className: "box-green navbar"

#   constructor: (attrs, options)->
#     super
#     _.bindAll @, "appendItem", "appendAllItem"
#     @.collection.bind 'add', @.appendItem
#     @.collection.bind 'reset', @.appendAllItem
#     compiledTemplate = _.template($("#box-template").html())
#     $(@.el).html(compiledTemplate({title: "応援団のおすすめ情報" , subTitle: ""}))
#     supporterInformation = new App.View.SupporterInfomation()
#     $(@.el).append supporterInformation.el
#     input = new App.View.SupporterMessageInput
#       collection: @.collection
#     $(supporterInformation.el).after(input.el)

#   render: ()=>


#   appendItem: (model)->
#     console.log model
#     compiledTemplate = _.template($("#supporter-message-template").html())
#     $(@.el).find('ul').append(compiledTemplate({text: model.attributes.message}))
#     $(@.el).find('ul li:last img').attr 'src', "/image/friends/3.jpg"
#   appendAllItem: (collection)->
#     if collection.length > 0
#       _.each collection.models, (model)=>
#         @.appendItem model
#     else
#       compiledTemplate = _.template($("#no-supporter-message-template").html())
#       $(@.el).find('ul').append(compiledTemplate())


# class App.View.SupporterInfomation extends Backbone.View
#   tagName: "ul"
#   className: "media-list supporter-information"

#   constructor: (attrs, options)->
#     super
#   render: ()=>

# class App.View.SupporterMessageInput extends Backbone.View
#   tagName: "div"
#   className: 'supporter-message-input'

#   events:
#     "keydown textarea": "keydown"
#     "click button": "post"

#   constructor: (attrs, options)->
#     super
#     @.textarea = $("<textarea rows='3'></textarea>")
#     $(@.el).append @.textarea

#     button = $("<button type='button'>投稿する</button>")
#     button.addClass 'btn btn-primary pull-right'
#     $(@.el).append button

#   keydown: (e)->
#     text = $(e.currentTarget).val()
#     num = text.match(/\r\n|\n/g)
#     if num is null
#       num = [""]
#     if num.length > 2
#       $(@.el).find('textarea').attr 'rows', num.length+1

#   post: (e)->
#     console.log e
#     text = @.textarea.val()
#     if text.length > 0
#       model = new App.Model.SupporterMessage
#         userid: @.collection.userid
#       detail =
#         supporter: App.User.id
#         userid: @.collection.userid
#         text: text
#       model.save detail,
#         success: (user)=>
#           console.log user
#           @.collection.add user