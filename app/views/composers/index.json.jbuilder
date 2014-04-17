json.array!(@composers) do |composer|
  json.extract! composer, :id, :name
  json.url composer_url(composer, format: :json)
end
