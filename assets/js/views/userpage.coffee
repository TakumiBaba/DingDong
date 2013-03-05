App = window.App

class App.View.UserPage extends Backbone.View
  el: "#main"

  constructor: (attrs, options)->
    super
    user = new App.Model.User
      id: attrs.id
    supporterMessageList = new App.Collection.SupporterMessageList
      userid: attrs.id

    profile = new App.View.ProfileMessageBox
      model: user
    $(@.el).append profile.el
    supporterInformationBox = new App.View.SupporterInfomationBox
      collection: supporterMessageList
    $(@.el).append supporterInformationBox.el

    user.fetch()
    supporterMessageList.fetch()

class App.View.ProfileMessageBox extends Backbone.View
  tagName: "div"
  className: "box-green navbar"

  constructor: (attrs, options)->
    super
    _.bindAll @, "render"
    @.model.bind 'change', @.render
    compiledTemplate = _.template($("#box-template").html())
    $(@.el).html(compiledTemplate({title: "自己紹介" , subTitle: ""}))

  render: ()=>
    profile_message = @.model.attributes.person.profile.message
    p = $("<p>#{profile_message}</p>")
    $(@.el).find('.info').append p

class App.View.SupporterInfomationBox extends Backbone.View
  tagName: "div"
  className: "box-green navbar"

  constructor: (attrs, options)->
    super
    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem
    compiledTemplate = _.template($("#box-template").html())
    $(@.el).html(compiledTemplate({title: "応援団のおすすめ情報" , subTitle: ""}))
    supporterInformation = new App.View.SupporterInfomation()
    $(@.el).append supporterInformation.el
    input = new App.View.SupporterMessageInput
      collection: @.collection
    $(supporterInformation.el).after(input.el)

  render: ()=>


  appendItem: (model)->
    console.log model
    compiledTemplate = _.template($("#supporter-message-template").html())
    $(@.el).find('ul').append(compiledTemplate({text: model.attributes.message}))
    $(@.el).find('ul li:last img').attr 'src', "/image/friends/3.jpg"
  appendAllItem: (collection)->
    if collection.length > 0
      _.each collection.models, (model)=>
        @.appendItem model
    else
      compiledTemplate = _.template($("#no-supporter-message-template").html())
      $(@.el).find('ul').append(compiledTemplate())


class App.View.SupporterInfomation extends Backbone.View
  tagName: "ul"
  className: "media-list supporter-information"

  constructor: (attrs, options)->
    super
  render: ()=>

class App.View.SupporterMessageInput extends Backbone.View
  tagName: "div"
  className: 'supporter-message-input'

  events:
    "keydown textarea": "keydown"
    "click button": "post"

  constructor: (attrs, options)->
    super
    @.textarea = $("<textarea rows='3'></textarea>")
    $(@.el).append @.textarea

    button = $("<button type='button'>投稿する</button>")
    button.addClass 'btn btn-primary pull-right'
    $(@.el).append button

  keydown: (e)->
    text = $(e.currentTarget).val()
    num = text.match(/\r\n|\n/g)
    if num is null
      num = [""]
    if num.length > 2
      $(@.el).find('textarea').attr 'rows', num.length+1

  post: (e)->
    console.log e
    text = @.textarea.val()
    if text.length > 0
      model = new App.Model.SupporterMessage
        userid: @.collection.userid
      detail =
        supporter: App.User.id
        userid: @.collection.userid
        text: text
      model.save detail,
        success: (user)=>
          console.log user
          @.collection.add user