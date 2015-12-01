Mapper.Views.Instruments ||= {}

class Mapper.Views.Instruments.IndexView extends Backbone.View
  template: JST["backbone/templates/instruments/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)

  addAll: () =>
    @collection.each(@addOne)

  addOne: (instrument) =>
    view = new Mapper.Views.Instruments.InstrumentView({model : instrument})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(instruments: @collection.toJSON() ))
    @addAll()

    return this
