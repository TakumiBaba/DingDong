App = window.App

require ["jade!templates/settings"], (view)=>
  class App.View.SettingsPage extends Backbone.View
    el: "#main"
    events:
      "blur div.settings input": "update"
      "change div.settings select": "update"

    constructor: (attrs, options)->
      super
      @.model = new App.Model.Settings
        userid: attrs.id
      _.bindAll @, "render"
      @.model.bind 'change', @.render

    render: ()=>
      model = @.model.attributes
      template = _.template view({partner_requirements: model})
      $(@.el).html template()

    _render: ()->
      console.log @.model.fetch()
      @.render()

    update: (e)->
      e.preventDefault()
      detail =
        ageMin: $("#ageMin").val()
        ageMax: $("#ageMax").val()
        martialHistory: @.toInt $("#martial_history").val()
        hasChild: @.toInt $("#hasChild").val()
        wantMarriage: @.toInt $("#wantMarriage").val()
        wantChild: @.toInt $("#wantChild").val()
        address: @.toInt $("#address").val()
        hometown: @.toInt $("#hometown").val()
        job: @.toInt $("#job").val()
        income: $("#income").val()
        bloodType: @.toInt $("#bloodType").val()
        education: @.toInt $("#education").val()
        height: $("#height").val()
        shape: @.toInt $("#shape").val()
        drinking: @.toInt $("#drinking").val()
        smoking: @.toInt $("#smoking").val()
      console.log detail
      @.model.save detail

    toInt: (tmpArray)->
      array = _.map tmpArray, (v)->
        return parseInt v
      return array