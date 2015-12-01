class Mapper.Routers.InstrumentsRouter extends Backbone.Router
  initialize: (options) ->
    @instruments = new Mapper.Collections.InstrumentsCollection()
    @instruments.reset options.instruments

  routes:
    "new"      : "newInstrument"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newInstrument: ->
    @view = new Mapper.Views.Instruments.NewView(collection: @instruments)
    $("#instruments-view").html(@view.render().el)

  index: ->
    @view = new Mapper.Views.Instruments.IndexView(collection: @instruments)
    $("#instruments-view").html(@view.render().el)

  show: (id) ->
    instrument = @instruments.get(id)

    @view = new Mapper.Views.Instruments.ShowView(model: instrument)
    $("#instruments-view").html(@view.render().el)

  edit: (id) ->
    instrument = @instruments.get(id)

    @view = new Mapper.Views.Instruments.EditView(model: instrument)
    $("#instruments-view").html(@view.render().el)
