json.data @questions do |question|
  json.extract! question, :id, :qc, :literal
  json.variables render partial: 'variables.html.erb', locals: {question: question}
  json.topic render partial: 'topic.html.erb', locals: {question: question, topics: @topics}
  json.actions render partial: 'actions.html.erb', locals: {question: question}
end
