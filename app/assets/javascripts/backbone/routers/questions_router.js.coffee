class Mapper.Routers.QuestionsRouter extends Backbone.Router
  initialize: (options) ->
    @questions = new Mapper.Collections.QuestionsCollection()
    @questions.reset options.questions

  routes:
    "new"      : "newQuestion"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newQuestion: ->
    @view = new Mapper.Views.Questions.NewView(collection: @questions)
    $("div#questions").html(@view.render().el)

  index: ->
    @view = new Mapper.Views.Questions.IndexView(collection: @questions)
    $("div#questions").html(@view.render().el)

  show: (id) ->
    question = @questions.get(id)

    @view = new Mapper.Views.Questions.ShowView(model: question)
    $("div#questions").html(@view.render().el)

  edit: (id) ->
    question = @questions.get(id)

    @view = new Mapper.Views.Questions.EditView(model: question)
    $("div#questions").html(@view.render().el)
