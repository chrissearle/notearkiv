json.array!(@messages) do |message|
  json.extract! message, :id, :name
  json.url genre_url(message, format: :json)
end
