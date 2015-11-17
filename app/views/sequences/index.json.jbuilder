json.data @sequences do |sequence|
  json.extract! sequence, :id, :name, :parent_id
  json.topic sequence.topic
  json.ptopic sequence.parent_topic
end
