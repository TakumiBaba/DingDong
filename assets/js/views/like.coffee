App = window.App

require ["jade!templates/likelistpage"], (likeView)=>
  class App.View.LikePage extends Backbone.View
    el: "#main"
    constructor: (attrs, options)->
      super
      @.likeList = new App.Collection.LikeList
        userid: attrs.id

      _.bindAll @, "appendItem", "appendAllItem"
      @.likeList.bind 'add', @.appendItem
      @.likeList.bind 'reset', @.appendAllItem
      @.likeList.fetch()

    render: ()=>
      compiledTemplate = _.template(likeView())
      $(@.el).html compiledTemplate()

    appendItem: (model)->
      if model.get('state') is 1
        ul = $("#my-like").find('ul')
      else if model.get('state') is 2
        ul = $("#your-like").find('ul')
      else if model.get('state') is 3
        ul = $("#each-like").find('ul')

      thumb = new App.View.LikeThumbnail
        me: @.likeList.id
        name: model.get('user').name
        profile_image: model.get('user').profile_image_urls[0]
        id: model.get('user').id
        state: model.get('state')
        isSystemMatching: model.get('isSystemMatching')
      ul.append thumb.el

    appendAllItem: (collection)->
      _.each collection.models, (model, num)=>
        @.appendItem(model)

  class App.View.LikeThumbnail extends Backbone.View
    tagName: 'li'

    events:
      "click button.like-action": "buttonClick"
      "click button.close": "toggleRemoveFlag"
      "click a.to-talk": "createTalk"
      "mouseenter div.thumbnail": "focus"
      "mouseleave div.thumbnail": "focus"

    constructor: (attrs)->
      super
      @.removeFlag = false
      @.me = attrs.me
      @.state = attrs.state
      @.isSystemMatching = attrs.isSystemMatching
      text = ""
      switch attrs.state
        when 1 then text = "いいね取り消し"
        when 2 then text = "いいね！"
        when 3 then text = "メッセージ送信"
      options =
        id: attrs.id
        image_url: attrs.profile_image
        name: attrs.name
        text: text
      $(@.el).html _.template(@.template(options))()

    template: (attrs)->
      if location.href.match(/\/user\//)
        return "<div class='thumbnail'><a href='/#/user/#{attrs.id}' class='to-user'><img src=#{attrs.image_url} /><h5>#{attrs.name}</h5></a><button class='like-action btn-block btn btn-primary'>#{attrs.text}</button><a class='to-talk'><span>応援トークをする</span></a></div>"
      else
        return "<div class='thumbnail'><button class='close hide'>&times;</button><a href='/#/user/#{attrs.id}' class='to-user'><img src=#{attrs.image_url} /><h5>#{attrs.name}</h5></a><button class='like-action btn-block btn btn-primary'>#{attrs.text}</button><a class='to-talk'><span>応援トークをする</span></a></div>"
      # return "<div class='thumbnail'><a href='/#/user/#{attrs.id}' class='to-user'><img src=#{attrs.image_url} /><span>#{attrs.name}</span></a><button class='btn btn-danger btn-block'>#{attrs.text}</button><a class='to-talk'><span>応援トークをする</span></a></div>"

    buttonClick: (e)->
      console.log @.state
      if @.removeFlag is true
        nextState = 9
        @.changeState(nextState)
      else if @.state is 1
        nextState = 0
        @.changeState(nextState)
      else if @.state is 2
        nextState = 3
        @.changeState(nextState)
      else if @.state is 3
        console.log 'each'

    toggleRemoveFlag: (e)->
      button = $(e.currentTarget).parent().find('button.like-action')
      if button.hasClass 'btn-primary'
        button.removeClass('btn-primary').addClass('btn-danger').html("消します！")
        setTimeout ()->
          switch @.state
            when 1 then text = "いいね取り消し"
            when 2 then text = "いいね！"
            when 3 then text = "メッセージ送信"
          button.removeClass('btn-danger').addClass('btn-primary').html(text)
        , 10000
      else
        switch @.state
          when 1 then text = "いいね取り消し"
          when 2 then text = "いいね！"
          when 3 then text = "メッセージ送信"
        button.removeClass('btn-danger').addClass('btn-primary').html(text)

    focus: (e)->
      @.removeFlag = if @.removeFlag is false then true else false
      $(e.currentTarget).find('button.close').toggleClass 'hide'

    changeState: (nextState)->
      $.ajax
        type: "PUT"
        url: "/user/#{@.me}/matching/#{@.id}/state"
        data:
          state: nextState
          isSystemMatching: @.isSystemMatching
        success: (data)=>
          $(@.el).remove()
          if nextState is 3
            $("#each-like").find('ul').append @.el
    createTalk: (e)->
      $.ajax
        type: "POST"
        url: "/user/#{@.me}/talk/"
        data:
          candidate_id: @.id
        success: (data)=>
          window.alert('応援団とこの人についてトークしましょう！')