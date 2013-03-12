App = window.App

class App.View.IndexPage extends Backbone.View
  el: "#main"
  constructor: (attrs, options)->
    super
    console.log App.User.get('isFirstLogin')

  render: =>
    $(@.el).empty()
    newsCollection = new App.Collection.News
      id: App.Sidebar.model.get('id')
    newsBox = new App.View.News
      collection: newsCollection
    candidateEsitimateView = new App.View.CEstimateView()
    $(@.el).append newsBox.el
    $(@.el).append candidateEsitimateView.el

class App.View.News extends Backbone.View
  tagName: 'div'
  className: "box box-green navbar"

  constructor: ->
    super
    _.bindAll @, 'appendItem', 'appendAllItem'
    @.collection.bind 'add', @.appendItem
    @.collection.bind 'reset', @.appendAllItem
    @.collection.fetch()
    compiledTemplate = _.template($("#box-template").html())
    $(@.el).html(compiledTemplate({title: "新着情報", subTitle: ""}))

  render: =>
    messageTemplate = _.template(@.template())
    return messageTemplate
      year: 2012
      month : 1
      day: 25
      message: "こんばんわ！"

  appendItem: (model)->
    compiledTemplate = _.template(@.template())
    console.log model
  appendAllItem: (data)->
    console.log data.models
    _.each data.models, (model, num)=>
      compiledTemplate = _.template(@.template())
      date = new Date(model.attributes.created_at)
      $(@.el).find('div.info').append compiledTemplate
        year: date.getFullYear()
        month: date.getMonth()+1
        day : date.getDate()
        message: model.attributes.text

  template: ->
    return "<p><%= year %>年 <%= month %>月 <%= day %>日 <%= message %></p>"

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