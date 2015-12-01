Mapper.Views.Questions ||= {}

class Mapper.Views.Questions.IndexView extends Backbone.View
  template: JST["backbone/templates/questions/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)

  addAll: () =>
    @collection.each(@addOne)

  addOne: (question) =>
    view = new Mapper.Views.Questions.QuestionView({model : question})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(questions: @collection.toJSON() ))
    @addAll()

    return this
