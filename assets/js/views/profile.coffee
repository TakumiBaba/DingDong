App = window.App

require ["jade!templates/profile"], (view)=>
  class App.View.ProfilePage extends Backbone.View
    el: "#main"
    events:
      "click button#submit": "update"
      "click ul.profile-image-list li": "changeProfileImage"

    constructor: (attrs, options)->
      super
      @.profileModel = new App.Model.Profile
        userid: attrs.id

      _.bindAll @, "render"
      @.profileModel.bind 'change', @.render

      @.profileModel.fetch()
    render: (model)=>
      birthday = model.get('birthday')
      b_year = (new Date(birthday)).getFullYear()
      template = _.template view({profile: model.attributes})
      $(@.el).html template()

      FB.api 'me/photos', (res)=>
        console.log res
        $(@.el).find('ul.profile-image-list').append @.profileImageTemplate("/user/#{App.User.id}/picture")
        _.each res.data, (album)=>
          console.log album.images
          $(@.el).find('ul.profile-image-list').append @.profileImageTemplate(album.images[0].source)
          # _.each album.images, (image)=>


    profileImageTemplate: (url)->
      return "<li><img src=#{url} /></li>"

    changeProfileImage: (e)->
      console.log $(e.currentTarget).find('img').attr 'src'

    update: (e)->
      e.preventDefault()
      detail =
        birthday_year: $("#birthday_year").val()
        birthday_month: $("#birthday_month").val()
        birthday_day: $("#birthday_day").val()
        havingMarried: $("#havingMarried").val()
        havingChild: $("#havingChild").val()
        wantMarriage: $("#wantMarriage").val()
        wantChild: $("#wantChild").val()
        address: $("#address").val()
        hometown: $("#hometown").val()
        job: $("#job").val()
        income: $("#income").val()
        bloodType: $("#bloodType").val()
        education: $("#education").val()
        shape: $("#shape").val()
        height: $("#height").val()
        drinking: $("#drinking").val()
        smoking: $("#smoking").val()
        hoby: $("#hoby").val()
        like: $("#like").val()
        message: $("#message").val()
      @.profileModel.save detail
      window.alert '変更しました。'
