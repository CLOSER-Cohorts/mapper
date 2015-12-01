json.array!(@questions) do |question|
  json.extract! question, :id, :qc, :literal, :max_x, :max_y
  json.topic question.topic
  json.url question_url(question, format: :json)
end
