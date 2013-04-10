App = window.App

class App.View.MessagePage extends Backbone.View
  el: "div#main"

  events:
    "click li.m_thumbnail_li": "changeModel"
    "click button.send_message": "postMessage"


  constructor: (attrs, options)->
    super
    @.collection = new App.Collection.MessageList
      userid: App.User.get('id')

    _.bindAll @, "appendAllItem"
    @.collection.bind 'reset', @.appendAllItem

    @.detailView = new App.View.Messages()

  render: ->
    $(@.el).empty()
    @.collection.fetch()

  appendAllItem: (collection)->
    console.log collection.models
    options =
      users: collection.models
      source: "/user/#{App.User.get('id')}/picture"
    html = window.JST['message/page'](options)
    $(@.el).html html
    $('ul.message-user-thumbnail li:first').click()

  changeModel: (e)->
    one = App.User.get 'id'
    two = $(e.currentTarget).attr 'id'
    @.detailView.setModel one, two

  postMessage: (e)->
    @.detailView.postMessage(e)

class App.View.Messages extends Backbone.View
  el: "div#message-list-view"

  events:
    "click button.send_message": "postMessage"

  constructor: ->
    @.collection = new App.Collection.Messages()
    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

  appendItem: (model)->
    console.log model
    d = new Date(model.get('created_at'))
    ul = $(@.el).find('div.message-body ul')
    hours = if d.getHours() < 10 then "0#{d.getHours()}" else d.getHours()
    minutes = if d.getMinutes() < 10 then "0#{d.getMinutes()}" else d.getMinutes()
    attributes =
      source: "/user/#{model.get('from')}/picture"
      name: model.get('name')
      text: model.get('text')
      created_at: "#{d.getMonth()+1}月#{d.getDay()}日 #{hours}:#{minutes}"
    li = window.JST['message/body'](attributes)
    ul.append li
    $(@.el).find('div.message-header h5').html("#{model.get('name')}さんとのやりとり")
    # ここで、ul.message-listにliをぶち込む。

  appendAllItem: (collection)->
    console.log 'messages set'
    $(@.el).find('div.message-body ul').empty()
    _.each collection.models, (model)=>
      @.appendItem model

  setModel: (one, two)->
    @.targetId = two
    @.collection.url = "/user/#{one}/#{two}/messages"
    @.collection.fetch()

  postMessage: (e)->
    text = $('textarea.message').val()
    $.ajax
      type: "POST"
      url: "/user/#{App.User.get('id')}/#{@.targetId}/message"
      data:
        text: text
      success: (data)=>
        $('textarea.message').val("")
        @.collection.add data
    console.log text



# require ["jade!templates/messagepage"], (view)=>

#   class App.View.MessagePage extends Backbone.View
#     el: "#main"
#     constructor: (attrs, options)->
#       super
#       messagePageTemplate = _.template view()
#       $(@.el).html messagePageTemplate()
#       @.userListView = new App.View.MessageUserList()

#     render: ()=>
#       @.userListView.collection.fetch()


#   class App.View.MessageUserList extends Backbone.View
#     el: 'ul.user-list'

#     events:
#       'click li': 'changePerson'

#     constructor: (attrs, options)->
#       super
#       @.collection = new App.Collection.MessageList
#         userid: App.User.id

#       @.detailView = new App.View.MessageDetailView()

#       _.bindAll @, "appendItem", "appendAllItem"
#       @.collection.bind 'add', @.appendItem
#       @.collection.bind 'reset', @.appendAllItem

#     render: ()=>
#       # こっちでモデルを変化させて、DetailView側に通知する

#     appendItem: (model)->
#       console.log model
#       li = @.liTemplate(model.get('id'))
#       $(@.el).append li

#     appendAllItem: (collection)->
#       if collection.models.length is 0
#         @.noMessage()
#         return
#       _.each collection.models, (model)=>
#         @.appendItem model
#       $(@.el).find('li:first').addClass 'active'
#       one = App.User.id
#       two = $(@.el).find('li:first').attr 'id'
#       @.detailView.setModel(one, two)

#     changePerson: (e)->
#       $(@.el).find('li').each ()->
#         $(@).removeClass 'active'
#       $(e.currentTarget).addClass 'active'
#       one = App.User.id
#       two = $(e.currentTarget).attr 'id'
#       @.detailView.setModel(one, two)

#     liTemplate: (id, image_url)->
#       image_url = "/user/#{id}/picture"
#       return "<li id=#{id}><img class='img-rounded m_thumbnail' src=#{image_url} /></li>"

#   class App.View.MessageDetailView extends Backbone.View
#     el: 'ul.messages'

#     events:
#       'click button': 'postMessage'

#     constructor: (attrs, options)->
#       super
#       @.collection = new App.Collection.Messages()
#       _.bindAll @, "appendItem", "appendAllItem"
#       @.collection.bind 'add', @.appendItem
#       @.collection.bind 'reset', @.appendAllItem

#       @.messagePostView = new App.View.MessagePostView
#         collection: @.collection

#     render: ()=>
#       console.log 'render'

#     appendItem: (model)->
#       console.log model
#       li = @.liTemplate(model.get('from'), model.get('text'))
#       $(@.el).append li
#     appendAllItem: (collection)->
#       $(@.el).empty()
#       $("h5.user-name").html "hoge"
#       _.each collection.models, (model)=>
#         @.appendItem model

#     setModel: (one, two)->
#       @.collection.url = "/user/#{one}/#{two}/messages"
#       @.collection.fetch()

#     postMessage: (e)->
#       console.log e

#     liTemplate: (id, text)->
#       url = "/user/#{id}/picture"
#       return "<li class='hoge'><img class=' pull-left' src=#{url} />#{text}</li>"

#   class App.View.MessagePostView extends Backbone.View
#     el: 'div.message-post'
#     events:
#       'click button': 'postMessage'

#     constructor: (attrs, options)->
#       super
#       @.parentCollection = attrs.collection

#     postMessage: (e)->
#       console.log e
#       text = $(@.el).find('textarea').val()
#       model = new App.Model.Message
#       detail =
#         text: text
#         from: App.User.id
#       model.set detail
#       @.parentCollection.add model
#       one = App.User.id
#       two = $(".user-list").find('li.active').attr 'id'
#       console.log one, two
#       model.setParams one, two
#       model.save()