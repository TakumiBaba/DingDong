App = window.App

# こんな感じで、もっとゆるーくしちゃっていい。

require ["jade!templates/signup"], (signup)=>
  class App.View.SignupPage extends Backbone.View
    el: "#main"
    constructor: (attrs, options)->
      super
      @.render()

    events:
      "click button.register": 'registerClicked'
      "click button.cancel": 'cancelClicked'
      "click button#add-dingdong": 'inviteFacebookFriends'

    render: ()=>
      compiledTemplate = _.template(signup())
      $(@.el).html compiledTemplate
        title: "登録フォーム"
        subTitle: ""
      $(@.el).find('button').addClass 'disabled'
      FB.api 'me', (res)=>
        console.log res
        $(@.el).find('button').removeClass 'disabled'
        $(@.el).find('#id').val(res.id)
        $(@.el).find('#name').val(res.name)
        $(@.el).find('#username').val(res.username)
        $(@.el).find('#first_name').val(res.first_name)
        $(@.el).find('#last_name').val(res.last_name)
        $(@.el).find("#gender_#{res.gender}").attr 'checked', 'checked'

    registerClicked: (e)->
      if $(e.currentTarget).hasClass 'disabled'
        e.preventDefault()
      # POST ./singup のページで、Facebookから応援団を招待できるようにする

    cancelClicked: (e)->
      location.href = "/#/"

    inviteFacebookFriends: (e)->
      FB.ui
        method: "apprequests"
        message: "応援に参加してください！"
        data: App.User.get 'id'
      , (res)=>
        console.log res
        console.log $(@.el).find('ul.pre-supporter-list')
        $(@.el).find('ul.pre-supporter-list').append '<li>hogefuga</li>'