json.extract! @instrument, :id, :prefix, :port, :created_at, :updated_at
json.questions @instrument.questions do |question|
  json.id question.id
  json.qc question.qc
  json.literal question.literal
  json.created_at question.created_at
  json.updated_at question.updated_at
end
