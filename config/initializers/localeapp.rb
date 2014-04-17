require 'localeapp/rails'

if ENV.include? 'LOCALEAPP_NOTEARKIV'

  puts "Starting with localeapp key: #{ENV['LOCALEAPP_NOTEARKIV']}"

  Localeapp.configure do |config|
    config.api_key = ENV['LOCALEAPP_NOTEARKIV']
  end
else
  puts 'Localeapp disabled'
end
