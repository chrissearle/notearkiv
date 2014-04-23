if Rails.env.production?
  Elasticsearch::Model.client = Elasticsearch::Client.new url: ENV['SEARCHBOX_SSL_URL']
end