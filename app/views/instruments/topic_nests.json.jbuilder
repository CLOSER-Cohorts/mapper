json.nests @instrument.topic_nests do |nest|
  json.members nest.members do |member|
    json.id member.id
    json.type member.class.name
  end
  json.fixed_points nest.fixed_points do |fp|
    json.id fp.id
    json.type fp.class.name
    json.topic fp.topic
  end
  json.topic nest.topic
  json.good nest.evaluate
end 
