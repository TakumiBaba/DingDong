App = window.App

class App.View.MatchingPage extends Backbone.View
  el: "div#main"

  constructor: ->
    super

  render: ->
    $(@.el).empty()
    $(@.el).html window.JST['matching/userlist']()
    system = new App.View.MatchingUserList
      el: "div.system_matching"
    supporter = new App.View.MatchingUserList
      el: "div.supporter_matching"

# ユーザリスト+詳細のViewを対象とするクラスにする。
class App.View.MatchingUserList extends Backbone.View
  el: "div"
  events:
    "click ul li.user-thumbnail": "changeModel"
    "click ul li.scrollup": "scrollUp"
    "click ul li.scrolldown": "scrollDown"

  constructor: (attrs)->
    super
    _.bindAll @, "appendItem", "appendAllItem", "setFollower"
    @.collection = new App.Collection.MatchingList
      userid: App.User.get('id')

    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem
    @.collection.fetch()

    @.followers = new App.Collection.Followers
      id: null
    @.followers.bind 'reset', @.setFollower

  appendItem: (model)->
    options =
      id: model.get('user').id
      source: model.get('user').profile_image_urls[0]
    html = window.JST['matching/user_thumbnail'](options)
    $(@.el).find('ul.matching_side').append html
  appendAllItem: (collection)->
    _.each collection.models, @.appendItem
    # _.each collection.models, (model, num)=>
    #   if num < 5
    #     @.appendItem model
    # $(@.el).find('ul.matching_side').append window.JST['matching/reload_list_icon']()
    $(@.el).find('li:first').click()

  changeModel: (e)->
    $(@.el).find('li').each ()->
      if $(@).hasClass 'active'
        $(@).removeClass 'active'
    $(e.currentTarget).addClass 'active'
    model = @.collection.where({id: $(e.currentTarget).attr('id')})[0]
    @.changeDetail(model)
  changeDetail: (model)->
    console.log model
    user = model.get('user')
    gender = if user.profile.gender is 'male' then "男性" else "女性"
    birthday = new Date(user.profile.birthday)
    $(@.el).find('img.profile_image').attr('src', user.profile_image_urls[0])
    $(@.el).find('h5.simple_profile').html("#{gender}　#{user.profile.age}歳　#{birthday.getFullYear()}年#{birthday.getMonth()+1}月#{birthday.getDay()}日生まれ")
    $(@.el).find('h4.name').html "#{user.name}さん"
    @.followers = new App.Collection.Followers
      id: user.id
    @.followers.bind 'reset', @.setFollower
    @.followers.fetch()
    @.setProfile user.profile

  setProfile: (profile)->
    html = window.JST['userpage/detailProfile'](profile)
    $(@.el).find('table.table').html(html)

  setFollower: (followers)->
    $(@.el).find('ul.follower-list').empty()
    _.each followers.models, (f)=>
      console.log f
      options =
        facebook_url: "https://facebook.com/#{f.facebook_id}"
        source: "/user/#{f.id}/picture/#{Date.now()}"
        name: "#{f.get('name')}さん"
      html = window.JST['matching/follower'](options)
      $(@.el).find('ul.follower-list').append html

  scrollUp:(e)->
    console.log 'スクロールアップ'

  scrollDown: (e)->
    console.log 'スクロールダウン'

# App = window.App

# require ["jade!templates/matchingpage"], (view)=>
#   class App.View.MatchingPage extends Backbone.View
#     el: "#main"
#     constructor: (attrs, options)->
#       $(@.el).html _.template(view())()
#       super
#       @.collection = new App.Collection.MatchingList
#         userid: attrs.id
#       _.bindAll @, "appendItem", "appendAllItem"
#       @.collection.bind 'add', @.appendItem
#       @.collection.bind 'reset', @.appendAllItem

#     render: ()=>
#       @.collection.fetch()

#     appendItem: (model)->
#       if model.get('isSystemMatching')
#         ul = $(@.el).find('#matching-system ul')
#       else
#         ul = $(@.el).find('#matching-supporter ul')
#       thumb = new App.View.MatchingThumbnail
#         me: @.collection.userid
#         name: model.get('user').name
#         profile_image: model.get('user').profile_image_urls[0]
#         id: model.get('user').id
#       ul.append thumb.el

#     appendAllItem: (collection)->
#       _.each collection.models, (model, num)=>
#         @.appendItem(model)

#   class App.View.MatchingThumbnail extends Backbone.View
#     tagName: 'li'

#     events:
#       "click a": "popover"
#       "click button.like": "stateChange"
#       "click button.close": "toggleRemoveFlag"
#       "mouseenter div.thumbnail": "focusOn"
#       "mouseleave div.thumbnail": "focusOut"

#     constructor: (attrs)->
#       super
#       @.me = attrs.me
#       options =
#         id: attrs.id
#         image_url: attrs.profile_image
#         name: attrs.name
#       compiledTemplate = _.template(@.template(options))
#       $(@.el).html(compiledTemplate())
#       if location.href.match(/\/user\//)
#         $(@.el).find('button').removeClass('btn-primary').addClass('btn-success')

#     toggleRemoveFlag: (e)->
#       if $(e.currentTarget).parent().find('button.like').hasClass 'btn-primary'
#         $(e.currentTarget).parent().find('button.like').removeClass('btn-primary').addClass('btn-danger').html("消します！")
#       else
#         $(e.currentTarget).parent().find('button.like').removeClass('btn-danger').addClass('btn-primary').html("いいね！")

#     stateChange: (e)->
#       data = {}
#       if location.href.match(/\/user\//)
#         data =
#           me: @.me
#           you: @.id
#           state: 0
#           isSystemMatching: false
#       else if $(e.currentTarget).hasClass 'btn-danger'
#         data =
#           me: @.me
#           you: @.id
#           state: 9
#           isSystemMatching: true
#       else
#         data =
#           me: @.me
#           you: @.id
#           state: 1
#           isSystemMatching: true
#       $.ajax
#         type: "PUT"
#         url: "/user/#{@.me}/matching/#{@.id}/state"
#         data: data
#         success:(data)=>
#           $(@.el).remove()
#           console.log data
#           window.alert('いいねリストに追加しました！')

#     focusOn: (e)->
#       $(e.currentTarget).find('button.close').removeClass 'hide'

#     focusOut: (e)->
#       $(e.currentTarget).find('button.close').addClass 'hide'

#     template: (attrs)->
#       if location.href.match(/\/user\//)
#         return "<div class='thumbnail'><a href='/#/user/#{attrs.id}'><img src=#{attrs.image_url} /><h5>#{attrs.name}</h5></a><button class='like btn-block btn btn-primary'>いいね！</button></div>"
#       else
#         return "<div class='thumbnail'><button class='close hide'>&times;</button><a href='/#/user/#{attrs.id}'><img src=#{attrs.image_url} /><h5>#{attrs.name}</h5></a><button class='like btn-block btn btn-primary'>いいね！</button></div>"

#     popover: (e)->
#       console.log e
#       e.preventDefault()
#       console.log e.currentTarget.hash
#       # users = new App.Collection.MatchingList
#       #   userid: @.me
#       id = e.currentTarget.hash.replace("#/user/", "")
#       userpage = new App.View.UserPage
#         target: id
#       userpage.render()

