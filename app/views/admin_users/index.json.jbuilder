json.array!(@periods) do |period|
  json.extract! period, :id, :name
  json.url genre_url(period, format: :json)
end
