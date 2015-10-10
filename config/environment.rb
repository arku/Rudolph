# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rudolph::Application.initialize!

if Rails.env == 'production'
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :user_name => ENV['sendgrid_username'],
    :password => ENV['sendgrid_password'],
    :domain => 'itsrudolph.com',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end