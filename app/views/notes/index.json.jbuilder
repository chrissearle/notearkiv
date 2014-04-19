json.array!(@notes) do |note|
  json.extract! note, :id, :name
  json.url note_url(note, format: :json)
end
