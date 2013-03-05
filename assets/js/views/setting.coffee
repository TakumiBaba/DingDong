App = window.App

require ["jade!templates/settings"], (view)=>
  class App.View.SettingsPage extends Backbone.View
    el: "#main"
    events:
      "click button#submit": "update"
    constructor: (attrs, options)->
      super
      @.settingsModel = new App.Model.Settings
        userid: attrs.id
      console.log 'hogefuga'
      _.bindAll @, "render"
      @.settingsModel.bind 'change', @.render

      @.settingsModel.fetch()
    render: (model)=>
      console.log model
      template = _.template view({partner_requirements: model.attributes})
      $(@.el).html template()
      console.log $("#age_min")
      # $("#age_min").val model.attributes.age_min
      # $("#age_max").val model.attributes.age_max

    update: (e)->
      console.log e
      e.preventDefault()
      detail =
        age_min: $("#range_of_age_min").val()
        age_max: $("#range_of_age_max").val()
        martial_history: $("#martial_history").val()
        hasChild: $("#hasChild").val()
        wantMarriage: $("#wantMarriage").val()
        wantChild: $("#wantChild").val()
        address: $("#address").val()
        hometown: $("#hometown").val()
        job: $("#job").val()
        income: $("#income").val()
        bloodType: $("#bloodType").val()
        education: $("#education").val()
        height: $("#height").val()
        shape: $("#shape").val()
        drinking: $("#drinking").val()
        smoking: $("#smoking").val()
      @.settingsModel.save detail, (e)->
        console.log e
        window.alert("変更しました！");
