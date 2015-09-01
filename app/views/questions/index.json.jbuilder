json.data @questions do |question|
  json.extract! question, :id, :qc, :literal, :topic, :max_x, :max_y, :variables_with_coords
  begin
    json.itopic question.get_topic
  rescue Exception
    json.itopic id: -1, name: 'Error'
  end
  begin
    json.ptopic question.get_parent_topic
  rescue Exception
    json.ptopic id: -1, name: 'Error'
  end
  #json.variables render partial: 'variables.html.erb', locals: {question: question}
  json.actions render partial: 'actions.html.erb', locals: {question: question}
end
