App = window.App

require ["jade!templates/header", "jade!templates/introduction", "jade!templates/sidebar"], (headerView, introductionView, sidebarView)=>
  # console.log headerView({isSupporter: false})
  class App.View.Header extends Backbone.View
    el: "#header"
    className: "row"

    events:
      "click a.introduction": "introduction"

    constructor:(attrs, options)->
      super
      _.bindAll @, "render"
      @.model.bind 'change', @.render

    render: ()->
      ul = $(@.el).find('ul')
      isSupporter = App.User.get('person').isSupporter
      ul.html headerView({isSupporter: isSupporter, following: @.model.get('person').following})
      $(@.el).find('.dropdown-toggle').dropdown()

    introduction: (e)->
      if $('#introduction-modal').length is 0
        introduction = new App.View.Introduction()
        introduction.render()

      $("#introduction-modal").modal
        show: true
        keyboard: true

    appendRequests : (data)->
      console.log data
      $(@.el).find('ul.nav.nav-pills').prepend "<li class='dropdown'><a id='app-requests' class='dropdown-toggle' data-toggle='dropdown'>応援団リクエスト <b class='caret' /></a></li>"
      $("#app-requests").after "<ul id='app-requests-list' class='dropdown-menu'></ul>"
      _.each data, (d)=>
        console.log d.data
        # id = JSON.parse(d.data).id
        id = d.data
        name = d.from.name
        li = @.requestTemplate(id, name)
        $(@.el).find('#app-requests-list').append li
        console.log $(li).find('button')
        $(@.el).find('button#accept').bind 'click', {from: id, request_id: d.id}, @.acceptRequest
        $(@.el).find('button#decline').bind 'click', {from: id, request_id: d.id}, @.declineRequest
      $(@.el).find("#app-requests").dropdown()

    acceptRequest: (e)->
      console.log e.data
      from = App.User.get 'id'
      to = e.data.from
      $.ajax
        type: "POST"
        url: "/follow/#{from}/#{to}/"
        success: (data)=>
          FB.api e.data.request_id, "delete", (res)=>
            console.log res
            $($(e.target).parent()[0]).remove()
          App.Header.model.fetch()
      console.log 'accept'
    declineRequest: (e)->
      console.log 'decline'
      FB.api e.data.request_id, "delete", (res)=>
        console.log res
        $($(e.target).parent()[0]).remove()

    requestTemplate: (id, name)->
      source = "/user/#{id}/picture"
      url = "https://facebook.com/#{id}"
      return "<li id=#{id}><a target='_blank' href=#{url}><img src=#{source} style='heigth: 30px' /><p>#{name}</p></a><button id='accept' class='btn btn-primary'>承認</button><button id='decline' class='btn'>不許可</button></li><li class='divider'></li>"

  class App.View.Introduction extends Backbone.View

    el: "div#introduction-modal"

    events:
      "click button.ok": "matching"

    constructor: ()->
      @.el = introductionView()
      super

    render: ()->
      $('body').append @.el
      @.preCandidateList = new App.View.UserListAndDetailView
        type: "preCandidates"
      @.followingList = new App.View.UserListAndDetailView
        type: "followings"
        child: @.preCandidateList
      console.log @.el

    matching: (e)->
      console.log 'matching!'
      one = $("div.introduction-left-box").find('ul li.active').attr 'id'
      two = $("div.introduction-right-box").find('ul li.active').attr 'id'
      $.ajax
        type: "POST"
        url: "/user/#{one}/#{two}/supportermatching"
        success: (data)->
          console.log data
          window.alert('マッチングさせました！')

  class App.View.UserListAndDetailView extends Backbone.View
    el: 'div'

    events:
      "click li": "changePerson"

    constructor: (attrs, options)->
      if attrs.type is 'followings'
        @.el = "div.introduction-left-box"
        @.child = attrs.child
        console.log attrs
      else
        @.el = "div.introduction-right-box"
      super
      if attrs.type is 'followings'
        @.collection = new App.Collection.Followings
          id: App.User.id
      else
        @.collection = new App.Collection.PreCandidates()
      _.bindAll @, "appendItem", "appendAllItem"
      @.collection.bind 'add', @.appendItem
      @.collection.bind 'reset', @.appendAllItem

      if attrs.type is "followings"
        @.collection.fetch()
      @.type = attrs.type

    appendItem: (model)->
      thumbnail = @.thumbnailTemplate(model.get('profile_image_urls')[0], model.get('id'))
      $(@.el).find('ul').append thumbnail

    appendAllItem: (collection)->
      _.each collection.models, (model, num)=>
        @.appendItem model
      @.setDetail collection.at(0)
      $(@.el).find('ul li:first').addClass 'active'
      if @.type is 'followings'
        id = collection.at(0).get('id')
        @.child.collection.url = "/introduction/#{id}"
        @.child.fetch()

    setDetail: (model)->
      pHeader = $(@.el).find('div.intro-profile-head')
      pHeader.find('img').attr 'src', model.get('profile_image_urls')[0]
      pHeader.find('h3').html model.get('name')
      pBody = $(@.el).find('div.media-body')
      message = model.get('profile').message
      pBody.html "<p>#{message}</p>"

    allRemove: ()->
      $(@.el).find("ul li").remove()
    fetch: ()->
      @.collection.fetch()

    changePerson: (e)->
      console.log $(@.el)
      $(@.el).find('ul li').removeClass 'active'
      $(e.currentTarget).addClass 'active'
      id = $(e.currentTarget).attr 'id'
      if @.type is 'followings'
        @.child.allRemove()
        @.child.collection.url = "/introduction/#{id}"
        @.child.fetch()

      _.each @.collection.models, (model)=>
        if model.get('id') is id
          @.setDetail model

    thumbnailTemplate: (image_url, id)->
      return "<li id=#{id}><img class='f_i_thumbnail' src=#{image_url} /></li>"

  class App.View.Sidebar extends Backbone.View
    el: "#sidebar"
    constructor:(attrs, options)->
      super
      _.bindAll @, 'render'
      @.model.bind 'change', @.render

    events:
      "click ul#menu li a": "onActive"
      "click button#add-dingdong": "sendAppRequest"
      "click button.like": 'like'
      "click a.user-facebook-page": "toFacebookPage"

    render: ()=>
      type = @.model.get('type')
      person = @.model.get('person')
      option =
        name: person.name
        follow: person.follower
      template = @.template(type, option)
      position = if person.isSupporter is true then "応援団" else "婚活者"
      $(@.el).find("div.sidebar-menu").html(template)
      $(@.el).find("img.user").attr 'src', person.profile_image_urls[0]
      if type is "candidate" or type is "supporter"
        $(@.el).find("a:first").attr 'href', "https://facebook.com/#{person.facebook_id}"
      else
        $(@.el).find("a:first").attr 'href', "/#/"
      $(@.el).find("h4.pink").html "#{person.name} (#{position})"
      ul_dong = $(@.el).find("ul#my-dong")
      ul_dong.empty()
      if type is 'user'
        if person.follower.length > 0
          _.each person.follower, (p, num)=>
            facebook_url = "http://facebook.com/#{p.facebook_id}"
            ul_dong.append @.dongTemplate(p.profile_image_urls[0], facebook_url, p.name)
        $(@.el).find('.user-facebook-page').attr 'href', "https://facebook.com/#{person.facebook_id}"
        ul_dong.append "<button id='add-dingdong' class='btn btn-primary btn-block'>応援団を増やす</button>"
      else if type is "supporter"
        $(@.el).find('ul.nav.nav-list li').children().each (num, c)=>
          action = $(c).attr('href').replace("/#/", "")
          $(c).attr 'href', "/#/user/#{person.id}/#{action}"

    template: (type, option)->
      # if type is 'candidate'
      #   compiledTemplate = _.template($("#sidebar-userpage-template").html())
      # else if type is 'supporter'
      #   compiledTemplate = _.template($("#sidebar-supporter-template").html())
      # else
      #   compiledTemplate = _.template($("#sidebar-template").html())
      isCandidate = isSupporter = isMe = false
      if type is 'candidate'
        isCandidate = true
      else if type is 'supporter'
        isSupporter = true
      else
        isMe = true
      compiledTemplate = _.template sidebarView({isMe: isMe, isCandidate: isCandidate, isSupporter: isSupporter})
      return compiledTemplate(option)

    dongTemplate: (source, url, name)->
      return "<li><a href=#{url}><img src=#{source} /></a></li>"
      # return "<li><a href=#{url}><img src=#{source} /><div><p>#{name}さん</p></div></a></li>"

    like: (e)->
      console.log e

    message: (e)->
      console.log e

    toFacebookPage: (e)->
      console.log e

    onActive: (e)->
      $(@.el).find("ul#menu li a").each ()->
        $(@).removeClass 'active'
      $(e.currentTarget).addClass 'active'

    sendAppRequest: (e)->
      # exclude list の対応とかをする。
      FB.ui
        method: "apprequests"
        message: "応援に参加してください！"
        data: App.User.get 'id'

    setModel: (model)->
      @.model = model
      @.model.bind 'change', @.render
      # @.render()

  class App.View.Alert extends Backbone.View

    constructor: (attrs, options)->
      super
      @.className = "alert alert-success"

    render: ()=>
      compiledTemplate = _.template($("#alert-template").html())
      $(@.el).html(compiledTemplate({title: 'hoge', text: 'fuga'}))

