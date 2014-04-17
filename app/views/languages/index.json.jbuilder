json.array!(@languages) do |language|
  json.extract! language, :id, :name
  json.url genre_url(language, format: :json)
end
