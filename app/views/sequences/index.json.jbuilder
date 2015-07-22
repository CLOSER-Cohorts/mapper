json.data @sequences do |sequence|
  json.extract! sequence, :id, :name, :parent_id
  json.topic render partial: 'topic.html.erb', locals: {sequence: sequence}
  json.actions render partial: 'actions.html.erb', locals: {sequence: sequence}
end
