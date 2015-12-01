class Mapper.Models.Question extends Backbone.Model
  paramRoot: 'question'

  defaults:
    qc: null
    literal: null
    topic: null
    max_x: null
    max_y: null

class Mapper.Collections.QuestionsCollection extends Backbone.Collection
  model: Mapper.Models.Question
  url: '/questions'
