App = window.App

class App.View.IndexPage extends Backbone.View
  el: "#main"
  constructor: (attrs, options)->
    super
    console.log App.User.get('isFirstLogin')

  render: =>
    newsCollection = new App.Collection.News
      id: "b08b809483972111e976e85e77ac7527add62ad3"
    newsBox = new App.View.News
      collection: newsCollection
    $(@.el).html newsBox.el

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