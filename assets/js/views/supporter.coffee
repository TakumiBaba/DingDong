App = window.App

class App.View.SupporterPage extends Backbone.View
  el: "div#main"

  constructor: ->
    super

  render: ->
    $(@.el).empty()
    html = window.JST['supporter/page']()
    $(@.el).html html

    id = App.User.get('id')

    followings = new App.Collection.Followings
      id: id
    followers  = new App.Collection.Followers
      id: id

    followingsView = new App.View.SupporterList
      collection: followings
      type: "following"
    followersView  = new App.View.SupporterList
      collection: followers
      type: "follower"

class App.View.SupporterList extends Backbone.View

  constructor: (attrs, options)->
    super

    @.el = $("div##{attrs.type}")
    _.bindAll @, "appendItem", "appendAllItem"

    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

    @.collection.fetch()

  appendItem: (model)->
    console.log model
    attributes =
      id: model.get('id')
      type: @.type
      source: model.get('profile_image_urls')[0]
      name: model.get('name')
    li = new App.View.SupporterThumbnail
      el: $(window.JST['supporter/thumbnail'](attributes))
      attributes: attributes
    $(@.el).find('ul.user_list').append li.el

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem

class App.View.SupporterThumbnail extends Backbone.View
  el: "li"

  events:
    "click button": "remove"

  constructor: (attrs, options)->
    super

  remove: (e)->
    console.log e
    if !$(e.currentTarget).hasClass('removeFlag')
      $(e.currentTarget).addClass 'removeFlag'
      $(e.currentTarget).html("本当に取り消す")
    else
      console.log $(e.delegateTarget).remove()
    console.log 'remove'