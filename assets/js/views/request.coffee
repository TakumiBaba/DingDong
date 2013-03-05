App = window.App

require ["jade!templates/requestpage"], (view)=>
  class App.View.RequestPage extends Backbone.View
    el: "#main"
    constructor: (attrs, options)->
      super
      FB.api 'me/apprequests', (response)->
        for res in response
          thumbnail = new App.View.RequestThumbnail()
  #     @.matchingList = new App.Collection.MatchingList
  #       userid: attrs.id
  #     _.bindAll @, "appendItem", "appendAllItem"
  #     @.matchingList.bind 'add', @.appendItem
  #     @.matchingList.bind 'reset', @.appendAllItem

  #   render: ()=>
  #     systemMatchingTemplate = _.template view()
  #     $(@.el).append systemMatchingTemplate()
  #     @.matchingList.fetch()

  #   appendItem: (model)->
  #     if model.get('isSystemMatching')
  #       ul = $("#matching-system").find('ul')
  #     else
  #       ul = $("#matching-supporter").find('ul')
  #     thumb = new App.View.MatchingThumbnail
  #       me: @.matchingList.userid
  #       name: model.get('user').name
  #       profile_image: model.get('user').profile_image_urls[0]
  #       id: model.get('user').id
  #     ul.append thumb.el

  #   appendAllItem: (collection)->
  #     _.each collection.models, (model, num)=>
  #       @.appendItem(model)

  # class App.View.MatchingThumbnail extends Backbone.View
  #   tagName: 'li'

  #   events:
  #     "click button": "stateChange"

  #   constructor: (attrs)->
  #     super
  #     @.me = attrs.me
  #     options =
  #       id: attrs.id
  #       image_url: attrs.profile_image
  #       name: attrs.name
  #     compiledTemplate = _.template(@.template(options))
  #     $(@.el).html(compiledTemplate())
  #     if location.href.match(/\/user\//)
  #       $(@.el).find('button').removeClass 'btn-primary'
  #       $(@.el).find('button').addClass 'btn-success'
  #   stateChange: (e)->
  #     data = {}
  #     if location.href.match(/\/user\//)
  #       data =
  #         me: @.me
  #         you: @.id
  #         state: 0
  #         isSystemMatching: false
  #     else
  #       data =
  #         me: @.me
  #         you: @.id
  #         state: 1
  #         isSystemMatching: true
  #     $.ajax
  #       type: "PUT"
  #       url: "/user/#{@.me}/matching/#{@.id}/state"
  #       data: data
  #       success:(data)=>
  #         $(@.el).remove()
  #         console.log data
  #         window.alert('追加しました')

  #   template: (attrs)->
  #     return "<div class='thumbnail'><a href='/#/user/#{attrs.id}'><img src=#{attrs.image_url} /><h5>#{attrs.name}</h5></a><button class='btn-block btn btn-primary'>いいね！</button>"




# FB.api 'me/apprequests',(response)->
#       for request in response.data
#         console.log request.from.id
#         $.ajax
#           type: "GET"
#           request: request
#           url: "/user/data/#{request.from.id}"
#           success: (data)->
#             #apprequestsから、誰からのリクエストだかがわかる。
#             #承認ユーザリストとか作って、そこから承認するような形にするのが良いかな？
#             #APIを作っておけばよいか。
#             #$.ajax url:"/create/supporter-user" みたいな。
#             request = this.request
#             console.log data
#             li = $("<li>")
#             h4 = $("<h4>")
#             h4.html(request.message)
#             img = $("<img>")
#             img.attr 'src', data.profile_image_urls[0]
#             yes_button = $("<button>")
#             yes_button.html("承認する")
#             yes_button.data = 'hoge'
#             yes_button.bind 'click', {request: request}, (e)->
#               json =
#                 from: request.from
#                 to:   request.to
#               $.ajax
#                 type: "POST"
#                 url: "/add/supporter"
#                 data: json
#                 success: (s_data)->
#                   console.log s_data
#             no_button  = $("<button>")
#             no_button.html("断る！")
#             no_button.bind 'click',{request: request}, (e)->
#               console.log "/#{e.data.request.id}"
#               FB.api "/#{e.data.request.id}", "DELETE", (res)->
#                 if res is true
#                   $(e.target).parent().remove()

#             li.append img
#             li.append h4
#             li.append yes_button
#             li.append no_button
#             $("ul.requests").append li