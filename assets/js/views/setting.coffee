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
      estimateView = new App.View.CEstimateView()
      $(@.el).prepend estimateView.el

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

class App.View.CEstimateView extends Backbone.View
  tagName: 'div'
  className: "box box-green navbar"

  events:
    "click button": "estimate"

  constructor: ()->
    super
    compiledTemplate = _.template($("#box-template").html())
    $(@.el).html compiledTemplate({title: "こだわらない検索", subTitle: ""})
    $(@.el).find('div.info').append @.template()
    $(@.el).find("#candidate-estimate").multiSelect()

  template: ()->
    html = $("<select id='candidate-estimate' size='5' multiple='multiple'></select>")
    # html =
    options =
      age: "年齢"
      martialHistory: "結婚歴"
      hasChild: "子供の有無"
      wantMarriage: "結婚希望時期"
      wantChild:  "子供の希望"
      address: "居住地"
      hometown: "出身地"
      job: "職業"
      income: "年収"
      education: "学歴"
      bloodtype: "血液型"
      height: "身長"
      shape: "体型"
      drinking: "飲酒習慣"
      smoking: "喫煙習慣"
    _.each options, (value, key)->
      html.append $("<option style='border-bottom: 1px solid black; text-decoraation: underline' value=#{key}>#{value}</option>")
    button = $("<button class='btn' type='button'>算出する</button>")
    html.after button
    p = $("<p></p>")
    html.after p
    return html

  estimate: (e)->
    e.preventDefault()
    list = {}
    $(@.el).find('div.ms-selectable ul.ms-list li').each ()->
      key = $(@).attr('id').replace(/_/g, "").replace("-selectable", "")
      if $(@).hasClass 'ms-selected'
        list[key] = 1
      else
        list[key] = 0
    $.ajax
      type: "GET"
      url: "/user/#{App.User.id}/cestimate"
      data: list
      success: (data)=>
        console.log data
        $(@.el).find('p').html data