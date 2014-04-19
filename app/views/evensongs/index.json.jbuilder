json.array!(@evensongs) do |evensong|
  json.extract! evensong, :id, :name
  json.url evensong_url(evensong, format: :json)
end
