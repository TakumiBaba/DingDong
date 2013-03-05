App = window.App

require ["jade!templates/matchingpage"], (view)=>
  class App.View.MatchingPage extends Backbone.View
    el: "#main"
    constructor: (attrs, options)->
      $(@.el).html _.template(view())()
      super
      @.collection = new App.Collection.MatchingList
        userid: attrs.id
      _.bindAll @, "appendItem", "appendAllItem"
      @.collection.bind 'add', @.appendItem
      @.collection.bind 'reset', @.appendAllItem

    render: ()=>
      @.collection.fetch()

    appendItem: (model)->
      if model.get('isSystemMatching')
        ul = $(@.el).find('#matching-system ul')
      else
        ul = $(@.el).find('#matching-supporter ul')
      thumb = new App.View.MatchingThumbnail
        me: @.collection.userid
        name: model.get('user').name
        profile_image: model.get('user').profile_image_urls[0]
        id: model.get('user').id
      ul.append thumb.el

    appendAllItem: (collection)->
      _.each collection.models, (model, num)=>
        @.appendItem(model)

  class App.View.MatchingThumbnail extends Backbone.View
    tagName: 'li'

    events:
      "click button": "stateChange"

    constructor: (attrs)->
      super
      @.me = attrs.me
      options =
        id: attrs.id
        image_url: attrs.profile_image
        name: attrs.name
      compiledTemplate = _.template(@.template(options))
      $(@.el).html(compiledTemplate())
      if location.href.match(/\/user\//)
        $(@.el).find('button').removeClass 'btn-primary'
        $(@.el).find('button').addClass 'btn-success'
    stateChange: (e)->
      data = {}
      if location.href.match(/\/user\//)
        data =
          me: @.me
          you: @.id
          state: 0
          isSystemMatching: false
      else
        data =
          me: @.me
          you: @.id
          state: 1
          isSystemMatching: true
      $.ajax
        type: "PUT"
        url: "/user/#{@.me}/matching/#{@.id}/state"
        data: data
        success:(data)=>
          $(@.el).remove()
          console.log data
          window.alert('追加しました')

    template: (attrs)->
      return "<div class='thumbnail'><a href='/#/user/#{attrs.id}'><img src=#{attrs.image_url} /><h5>#{attrs.name}</h5></a><button class='btn-block btn btn-primary'>いいね！</button>"


