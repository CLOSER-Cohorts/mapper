json.extract! @instrument, :id, :prefix, :port, :created_at, :updated_at
json.questions @instrument.questions do |question|
  json.qc question.qc
  json.literal question.literal
end
