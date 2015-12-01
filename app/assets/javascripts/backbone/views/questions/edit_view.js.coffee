Mapper.Views.Questions ||= {}

class Mapper.Views.Questions.EditView extends Backbone.View
  template: JST["backbone/templates/questions/edit"]

  events:
    "submit #edit-question": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (question) =>
        @model = question
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
