json.data @variables do |variable|
  json.extract! variable, :id, :name, :label, :var_type, :topic
  json.outputs render partial: 'outputs.html.erb', locals: {variable: variable}
  json.sources render partial: 'sources.html.erb', locals: {variable: variable}
  begin
    json.itopic variable.get_topic
  rescue Exception
    json.itopic id: -1, name: 'Error', fixed_points: variable.my_nest[:fixed_points]
  end
  begin
    json.ptopic variable.get_parent_topic
  rescue Exception
    json.ptopic id: -1, name: 'Error', fixed_points: variable.my_nest[:fixed_points]
  end
  json.actions render partial: 'actions.html.erb', locals: {variable: variable}
end
