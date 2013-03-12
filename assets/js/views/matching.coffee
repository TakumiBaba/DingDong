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
      "click button.like": "stateChange"
      "click button.close": "toggleRemoveFlag"
      "mouseenter div.thumbnail": "focusOn"
      "mouseleave div.thumbnail": "focusOut"

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
        $(@.el).find('button').removeClass('btn-primary').addClass('btn-success')

    toggleRemoveFlag: (e)->
      if $(e.currentTarget).parent().find('button.like').hasClass 'btn-primary'
        $(e.currentTarget).parent().find('button.like').removeClass('btn-primary').addClass('btn-danger').html("消します！")
      else
        $(e.currentTarget).parent().find('button.like').removeClass('btn-danger').addClass('btn-primary').html("いいね！")

    stateChange: (e)->
      data = {}
      if location.href.match(/\/user\//)
        data =
          me: @.me
          you: @.id
          state: 0
          isSystemMatching: false
      else if $(e.currentTarget).hasClass 'btn-danger'
        data =
          me: @.me
          you: @.id
          state: 9
          isSystemMatching: true
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

    focusOn: (e)->
      $(e.currentTarget).find('button.close').removeClass 'hide'

    focusOut: (e)->
      $(e.currentTarget).find('button.close').addClass 'hide'

    template: (attrs)->
      if location.href.match(/\/user\//)
        return "<div class='thumbnail'><a href='/#/user/#{attrs.id}'><img src=#{attrs.image_url} /><h5>#{attrs.name}</h5></a><button class='like btn-block btn btn-primary'>いいね！</button></div>"
      else
        return "<div class='thumbnail'><button class='close hide'>&times;</button><a href='/#/user/#{attrs.id}'><img src=#{attrs.image_url} /><h5>#{attrs.name}</h5></a><button class='like btn-block btn btn-primary'>いいね！</button></div>"


