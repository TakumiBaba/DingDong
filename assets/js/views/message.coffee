App = window.App

require ["jade!templates/messagepage"], (view)=>

  class App.View.MessagePage extends Backbone.View
    el: "#main"
    constructor: (attrs, options)->
      super
      messagePageTemplate = _.template view()
      $(@.el).html messagePageTemplate()
      @.userListView = new App.View.MessageUserList()

    render: ()=>
      @.userListView.collection.fetch()


  class App.View.MessageUserList extends Backbone.View
    el: 'ul.user-list'

    events:
      'click li': 'changePerson'

    constructor: (attrs, options)->
      super
      @.collection = new App.Collection.MessageList
        userid: App.User.id

      @.detailView = new App.View.MessageDetailView()

      _.bindAll @, "appendItem", "appendAllItem"
      @.collection.bind 'add', @.appendItem
      @.collection.bind 'reset', @.appendAllItem

    render: ()=>
      # こっちでモデルを変化させて、DetailView側に通知する

    appendItem: (model)->
      console.log model
      li = @.liTemplate(model.get('id'))
      $(@.el).append li

    appendAllItem: (collection)->
      if collection.models.length is 0
        @.noMessage()
        return
      _.each collection.models, (model)=>
        @.appendItem model
      $(@.el).find('li:first').addClass 'active'
      one = App.User.id
      two = $(@.el).find('li:first').attr 'id'
      @.detailView.setModel(one, two)

    changePerson: (e)->
      $(@.el).find('li').each ()->
        $(@).removeClass 'active'
      $(e.currentTarget).addClass 'active'
      one = App.User.id
      two = $(e.currentTarget).attr 'id'
      @.detailView.setModel(one, two)

    liTemplate: (id, image_url)->
      image_url = "/user/#{id}/picture"
      return "<li id=#{id}><img class='img-rounded m_thumbnail' src=#{image_url} /></li>"

  class App.View.MessageDetailView extends Backbone.View
    el: 'ul.messages'

    events:
      'click button': 'postMessage'

    constructor: (attrs, options)->
      super
      @.collection = new App.Collection.Messages()
      _.bindAll @, "appendItem", "appendAllItem"
      @.collection.bind 'add', @.appendItem
      @.collection.bind 'reset', @.appendAllItem

      @.messagePostView = new App.View.MessagePostView
        collection: @.collection

    render: ()=>
      console.log 'render'

    appendItem: (model)->
      console.log model
      li = @.liTemplate(model.get('from'), model.get('text'))
      $(@.el).append li
    appendAllItem: (collection)->
      $(@.el).empty()
      _.each collection.models, (model)=>
        @.appendItem model

    setModel: (one, two)->
      @.collection.url = "/user/#{one}/#{two}/messages"
      @.collection.fetch()

    postMessage: (e)->
      console.log e

    liTemplate: (id, text)->
      url = "/user/#{id}/picture"
      return "<li class='hoge'><img class=' pull-left' src=#{url} />#{text}</li>"

  class App.View.MessagePostView extends Backbone.View
    el: 'div.message-post'
    events:
      'click button': 'postMessage'

    constructor: (attrs, options)->
      super
      @.parentCollection = attrs.collection

    postMessage: (e)->
      console.log e
      text = $(@.el).find('textarea').val()
      model = new App.Model.Message
      detail =
        text: text
        from: App.User.id
      model.set detail
      @.parentCollection.add model
      one = App.User.id
      two = $(".user-list").find('li.active').attr 'id'
      console.log one, two
      model.setParams one, two
      model.save()