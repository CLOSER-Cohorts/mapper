json.data @variables do |variable|
  json.extract! variable, :id, :name, :label, :var_type
  json.outputs render partial: 'outputs.html.erb', locals: {variable: variable}
  json.sources render partial: 'sources.html.erb', locals: {variable: variable}
  json.topic render partial: 'topic.html.erb', locals: {variable: variable, topics: @topics}
  json.actions render partial: 'actions.html.erb', locals: {variable: variable}
end
