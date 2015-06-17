json.data @questions do |question|
  json.extract! question, :qc, :literal
  json.variables render partial: 'variables.html.erb', locals: {question: question}
  json.actions render partial: 'actions.html.erb', locals: {question: question}
end
