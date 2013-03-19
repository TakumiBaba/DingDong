App = window.App

require ["jade!templates/profile"], (view)=>
  class App.View.ProfilePage extends Backbone.View
    el: "#main"
    events:
      "keydown input#like": "addLikeList"
      "click button#submit": "update"
      "blur div.profile input": "update"
      "change div.profile select": "update"
      "change div.profile textarea": "update"
      "click ul.profile-image-list li": "changeProfileImage"

    constructor: (attrs, options)->
      super
      $(@.el).children().remove()
      @.model = new App.Model.Profile
        userid: attrs.id

      _.bindAll @, "render"
      @.model.bind 'change', @.render

    render: ()->
      $("#main").empty()
      console.log '----'
      template = _.template view({profile: @.model.attributes})
      $(@.el).html template()
      $("#profile-image").attr 'src', "/user/#{@.model.userid}/picture"
      # FB.api 'me/photos', (res)=>
      #   $(@.el).find('ul.profile-image-list').empty()
      #   $(@.el).find('ul.profile-image-list').append @.profileImageTemplate("/user/#{App.User.id}/picture")
      #   $(@.el).find('ul.profile-image-list li:first').addClass 'active'

      #   _.each res.data, (album)=>
      #     $(@.el).find('ul.profile-image-list').append @.profileImageTemplate(album.images[0].source)

    _render: ()->
      @.model.fetch()
      @.render()

    profileImageTemplate: (url)->
      return "<li><img src=#{url} /></li>"

    changeProfileImage: (e)->
      source =  $(e.currentTarget).find('img').attr 'src'
      $("ul.profile-image-list li").each ()->
        $(@).removeClass 'active'
      $(e.currentTarget).addClass 'active'
      $("#profile-image").attr 'src', source
      @.update(e)

    addLikeList: (e)->
      if e.keyCode is 13
        text = $(e.currentTarget).val()
        label = $("<span>").addClass('label label-info')
    update: (e)->
      e.preventDefault()
      detail =
        profile_image: $("#profile-image").attr 'src'
        martialHistory: parseInt($("#havingMarried").val())+1
        hasChild: parseInt($("#havingChild").val())+1
        wantMarriage: parseInt($("#wantMarriage").val())+1
        wantChild: parseInt($("#wantChild").val())+1
        address: parseInt($("#address").val())+1
        hometown: parseInt($("#hometown").val())+1
        job: parseInt($("#job").val())+1
        income: $("#income").val()
        bloodType: parseInt($("#bloodType").val())+1
        education: parseInt($("#education").val())+1
        shape: parseInt($("#shape").val())+1
        height: $("#height").val()
        drinking: parseInt($("#drinking").val())+1
        smoking: parseInt($("#smoking").val())+1
        hoby: $("#hoby").val()
        like: $("#like").val()
        message: $("#message").val()
      console.log detail
      @.model.save detail
