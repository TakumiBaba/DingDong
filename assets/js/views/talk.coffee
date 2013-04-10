App = window.App

class App.View.TalkPage extends Backbone.View
  el: "#main"

  constructor:->
    super
    @.collection = new App.Collection.TalkList
      userid: App.User.get('id')

    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem

  render: =>
    $(@.el).empty()
    $(@.el).append window.JST['talk/page']()
    @.collection.fetch()

  appendItem: (model)->
    talk = new App.View.Talk
      model: model
    $(@.el).find('ul.talk_list').append talk.el

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem

class App.View.Talk extends Backbone.View
  tagName: "li"
  className: 'clearfix talk'

  events:
    "click button.send_comment": "postComment"

  constructor: (attrs, options)->
    super
    @.talkId = attrs.model.get('_id')
    c = attrs.model.get('candidate')
    u = App.User.get('person')
    d = (new Date(attrs.model.get('created_at'))).getTime()
    now = Date.now()
    diff = (now-d)/1000
    last_update = ""
    if diff < 60
      last_update = "#{Math.floor(diff)}秒前"
    else if (60*60) > diff >= 60
      last_update = "#{Math.floor(diff/60)}分前"
    else if (60*60*24) > diff >= (60*60)
      last_update = "#{Math.floor(diff/(60*60))}時間前"
    else if diff >= (60*60*24)
      last_update = "#{Math.floor(diff/(60*60*24))}日前"
    message = c.profile.message # ２０文字以下に切り取り
    attirbutes =
      source: u.profile_image_urls[0]
      like_count: 0
      name: u.name
      candidate_id: c.id
      candidate_source: c.profile_image_urls[0]
      candidate_name: c.name
      candidate_age: c.profile.age
      address: c.profile.address
      height: c.profile.height
      blood: c.profile.bloodType
      last_update: last_update
      profile_message: c.profile.message
    $(@.el).append window.JST['talk/wrapper'](attirbutes)

    @.commentView = new App.View.Comments
      list: attrs.model.get('comments')
      el: $(@.el).find('ul.comments')
    console.log @.commentView.collection
    p = $(@.el).find('div.comments_box ul li').length*250
    console.log p
    $(@.el).find('div.comments_box').animate
      scrollTop: p
    , 'fast'

  postComment: (e)=>
    text = $(@.el).find('textarea.comment_area').val()
    id = App.User.get('id')
    $.ajax
      type: "POST"
      url: "/talk/#{@.talkId}/comment"
      data:
        me: id
        text: text
      success: (data)=>
        console.log data
        # attributes =
        #   source: data.profile_image
        #   message: data.comment.text
        # html = window.JST['talk/comment'](attributes)
        @.commentView.addComment data
        # $(@.el).find('ul.comments').append html
        $(@.el).find('textarea.comment_area').val("")

class App.View.Comments extends Backbone.View
  el: "ul.comments"

  constructor: (attrs, options)->
    super
    console.log attrs
    @.collection = new App.Collection.Comments()
    _.bindAll @, "appendItem", "appendAllItem"
    @.collection.bind 'reset', @.appendAllItem
    @.collection.bind 'add', @.appendItem

    _.each attrs.list, (comment)=>
      @.collection.add comment

    console.log $(@.el)
    $(@.el).animate
      scrollTop: 200
    , 'fast'

  appendItem: (model)->
    d = new Date(model.get('created_at'))
    hours = if d.getHours() < 10 then "0#{d.getHours()}" else d.getHours()
    minutes = if d.getMinutes() < 10 then "0#{d.getMinutes()}" else d.getHours()
    created_at = "#{d.getMonth()+1}月#{d.getDate()}日 #{hours}:#{minutes}"
    attributes =
      source: model.get('user').profile_image_urls[0]
      message: model.get('text')
      created_at: created_at
    html = window.JST['talk/comment'](attributes)
    $(@.el).append html

  appendAllItem: (collection)->
    _.each collection.models, @.appendItem
    # p = $(@.el).find('div.comments_box')
    # console.log 'hoge'
    # $(@.el).find('div.comments_box').animate
    #   scrollTop: 200
    # , 'fast'

  addComment: (model)->
    console.log model
    @.collection.add model

# class App.View.TalkPage extends Backbone.View
#   el: "#main"
#   constructor: (attrs, options)->
#     super
#     @.talkList = new App.Collection.TalkList
#       userid: attrs.id
#     @.talkBox = new App.View.TalkBox
#       collection: @.talkList
#       title: "応援トーク"
#       subTitle: "\"♡ランキング:お気に入りの人について応援団と大いに語ろう！\""

#   render: ()=>

#     $(@.el).html @.talkBox.el
#     @.talkList.fetch()

# class App.View.TalkBox extends Backbone.View
#   tagName: 'div'
#   className: "box-pink navbar"

#   constructor: (attrs)->
#     super
#     compiledTemplate = _.template($("#pink-box-template").html())
#     $(@.el).html(compiledTemplate({title: attrs.title, subTitle: attrs.subTitle}))
#     list = new App.View.TalkList
#       collection: @.collection
#     $(@.el).find('.info').append list.el
#     console.log @.el

# class App.View.TalkList extends Backbone.View
#   tagName: 'ul'
#   className: 'talks'

#   constructor: (attrs, options)->
#     super
#     _.bindAll @, "appendItem", "appendAllItem"
#     @.collection.bind 'add', @.appendItem
#     @.collection.bind 'reset', @.appendAllItem

#   appendItem: (model)->
#     talk = new App.View.Talk
#       me: @.collection.id
#       talk_id: model._id
#       candidate: model.candidate
#       comments: model.comments
#     $(@.el).append talk.el
#   appendAllItem: (data)->
#     _.each data.models, (model, num)=>
#       @.appendItem(model.attributes)

# class App.View.Talk extends Backbone.View
#   tagName: 'div'
#   className: 'container'

#   events:
#     "keydown input": 'keydown'

#   constructor: (attrs, options)->
#     super
#     @.talk_id = attrs.talk_id
#     @.me = attrs.me
#     thumbnail = new App.View.TalkThumbnail
#       image_url: attrs.candidate.profile_image_urls[0]
#       name: attrs.candidate.name
#       id: attrs.candidate.id
#     $(@.el).append thumbnail.el
#     div = $("<div></div>")
#     div.addClass 'span6'
#     $(@.el).append div
#     @.comments = new App.View.CommentList
#       comments: attrs.comments
#     div.html(@.comments.el)
#     input = $("<input></input>")
#     input.addClass "span6"
#     div.append input
#     $(@.el).css 'margin-bottom', "10px"

#   keydown: (e)->
#     if e.keyCode is 13
#       text = $(e.currentTarget).val()
#       $.ajax
#         type: "POST"
#         url: "/talk/#{@.talk_id}/comment/"
#         data:
#           text: text
#           me: App.User.id
#         success:(data)=>
#           model =
#             text: data.comment.text
#             name: data.name
#             image_url: data.profile_image
#           @.comments.appendItem model
#           $(e.currentTarget).val("")
# class App.View.TalkThumbnail extends Backbone.View
#   tagName: 'div'
#   className: 'span2'
#   constructor: (attrs, options)->
#     super
#     compiledTemplate = _.template($("#talk-thumbnail-template").html())
#     $(@.el).html(compiledTemplate({name: attrs.name}))
#     $(@.el).find('img').attr "src", attrs.image_url
#     $(@.el).find('a').attr 'href', "/#/user/#{attrs.id}"

# class App.View.CommentList extends Backbone.View
#   tagName: 'ul'
#   className: 'comment-list scrollable'
#   constructor: (attrs, options)->
#     super
#     if attrs.comments.length is 0
#       noComment = _.template($("#no-comment-template").html())
#       $(@.el).append noComment()
#     else
#       _.each attrs.comments, (c, num)=>
#         model =
#           text: c.text
#           name: c.user.name
#           image_url: c.user.profile_image_urls[0]
#         @.appendItem(model)
#   appendItem: (model)->
#     if $(@.el).find('#no-comment')
#       $(@.el).find('#no-comment').remove()
#     comment = new App.View.Comment
#       text: model.text
#       name: model.name
#       image_url: model.image_url
#     $(@.el).append comment.el
#   appendAllItem: (collection)->
#     _.each collection, (model, num)=>
#       @.appendItem(model)

# class App.View.Comment extends Backbone.View
#   tagName: 'li'
#   className: 'comment'
#   constructor: (attrs, options)->
#     super
#     compiledTemplate = _.template($("#comment-template").html())
#     $(@.el).html(compiledTemplate({name: attrs.name, text: attrs.text}))
#     $(@.el).find('img').attr 'src', attrs.image_url