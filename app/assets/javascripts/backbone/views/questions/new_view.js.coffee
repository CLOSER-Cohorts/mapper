Mapper.Views.Questions ||= {}

class Mapper.Views.Questions.NewView extends Backbone.View
  template: JST["backbone/templates/questions/new"]

  events:
    "submit #new-question": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (question) =>
        @model = question
        window.location.hash = "/#{@model.id}"

      error: (question, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
