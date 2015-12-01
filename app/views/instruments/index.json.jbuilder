json.array!(@instruments) do |instrument|
  json.extract! instrument, :id, :prefix, :port, :study, :created_at, :updated_at
  json.url instrument_url(instrument, format: :json)
end
