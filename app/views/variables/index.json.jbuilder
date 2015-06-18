json.data @variables do |variable|
  json.extract! variable, :name, :label, :var_type
  json.questions render partial: 'questions.html.erb', locals: {variable: variable}
  json.actions render partial: 'actions.html.erb', locals: {variable: variable}
end
