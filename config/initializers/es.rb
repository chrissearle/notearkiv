if Rails.env.production?
  Elasticsearch::Model.client = Elasticsearch::Client.new url: ENV['SEARCHBOX_SSL_URL']
end

unless Rails.env.production?
  require 'elasticsearch/rails/instrumentation'
end