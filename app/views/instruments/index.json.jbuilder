json.array!(@instruments) do |instrument|
  json.extract! instrument, :id, :prefix, :port
  json.url instrument_url(instrument, format: :json)
end
