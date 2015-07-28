json.data @questions do |question|
  json.extract! question, :id, :qc, :literal, :topic
  json.itopic question.get_topic
  json.ptopic question.get_parent_topic
  json.variables render partial: 'variables.html.erb', locals: {question: question}
  json.actions render partial: 'actions.html.erb', locals: {question: question}
end
