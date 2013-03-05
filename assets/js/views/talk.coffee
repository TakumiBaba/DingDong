App = window.App

class App.View.TalkPage extends Backbone.View
  el: "#main"
  constructor: (attrs, options)->
    super
    @.talkList = new App.Collection.TalkList
      userid: attrs.id
    @.talkBox = new App.View.TalkBox
      collection: @.talkList
      title: "応援トーク"
      subTitle: "\"♡ランキング:お気に入りの人について応援団と大いに語ろう！\""

  render: ()=>

    $(@.el).html @.talkBox.el
    @.talkList.fetch()

class App.View.TalkBox extends Backbone.View
  tagName: 'div'
  className: "box-pink navbar"

  constructor: (attrs)->
    super
    compiledTemplate = _.template($("#pink-box-template").html())
    $(@.el).html(compiledTemplate({title: attrs.title, subTitle: attrs.subTitle}))
    list = new App.View.TalkList
      collection: @.collection
    $(@.el).find('.info').append list.el
    console.log @.el

class App.View.TalkList extends Backbone.View
  tagName: 'ul'
  className: 'talks'

  constructor: (attrs, options)->
    super
    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

  appendItem: (model)->
    talk = new App.View.Talk
      me: @.collection.id
      talk_id: model._id
      candidate: model.candidate
      comments: model.comments
    $(@.el).append talk.el
  appendAllItem: (data)->
    _.each data.models, (model, num)=>
      @.appendItem(model.attributes)

class App.View.Talk extends Backbone.View
  tagName: 'div'
  className: 'container'

  events:
    "keydown input": 'keydown'

  constructor: (attrs, options)->
    super
    @.talk_id = attrs.talk_id
    @.me = attrs.me
    thumbnail = new App.View.TalkThumbnail
      image_url: attrs.candidate.profile_image_urls[0]
      name: attrs.candidate.name
      id: attrs.candidate.id
    $(@.el).append thumbnail.el
    div = $("<div></div>")
    div.addClass 'span6'
    $(@.el).append div
    @.comments = new App.View.CommentList
      comments: attrs.comments
    div.html(@.comments.el)
    input = $("<input></input>")
    input.addClass "span6"
    div.append input
    $(@.el).css 'margin-bottom', "10px"

  keydown: (e)->
    if e.keyCode is 13
      text = $(e.currentTarget).val()
      $.ajax
        type: "POST"
        url: "/talk/#{@.talk_id}/comment/"
        data:
          text: text
          me: App.User.id
        success:(data)=>
          model =
            text: data.comment.text
            name: data.name
            image_url: data.profile_image
          @.comments.appendItem model
          $(e.currentTarget).val("")
class App.View.TalkThumbnail extends Backbone.View
  tagName: 'div'
  className: 'span2'
  constructor: (attrs, options)->
    super
    compiledTemplate = _.template($("#talk-thumbnail-template").html())
    $(@.el).html(compiledTemplate({name: attrs.name}))
    $(@.el).find('img').attr "src", attrs.image_url
    $(@.el).find('a').attr 'href', "/#/user/#{attrs.id}"

class App.View.CommentList extends Backbone.View
  tagName: 'ul'
  className: 'comment-list scrollable'
  constructor: (attrs, options)->
    super
    if attrs.comments.length is 0
      noComment = _.template($("#no-comment-template").html())
      $(@.el).append noComment()
    else
      _.each attrs.comments, (c, num)=>
        model =
          text: c.text
          name: c.user.name
          image_url: c.user.profile_image_urls[0]
        @.appendItem(model)
  appendItem: (model)->
    if $(@.el).find('#no-comment')
      $(@.el).find('#no-comment').remove()
    comment = new App.View.Comment
      text: model.text
      name: model.name
      image_url: model.image_url
    $(@.el).append comment.el
  appendAllItem: (collection)->
    _.each collection, (model, num)=>
      @.appendItem(model)

class App.View.Comment extends Backbone.View
  tagName: 'li'
  className: 'comment'
  constructor: (attrs, options)->
    super
    compiledTemplate = _.template($("#comment-template").html())
    $(@.el).html(compiledTemplate({name: attrs.name, text: attrs.text}))
    $(@.el).find('img').attr 'src', attrs.image_url