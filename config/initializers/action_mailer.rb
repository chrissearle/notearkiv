ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
    :address  => ENV['MAIL_SERVER'],
    :port  => 587,
    :user_name  => ENV['MAIL_ACCOUNT'],
    :password  => ENV['MAIL_PASSWORD'],
    :domain => ENV['MAIL_DOMAIN'],
    :authentication  => :login
}
