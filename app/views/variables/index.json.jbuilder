json.data @variables do |variable|
  json.extract! variable, :id, :name, :label, :var_type, :topic, :out_variables, :src_variables, :questions
  json.type 'Variable'
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
  json.my_nest variable.my_nest
  json.admin current_user.admin?
end
