# Load the rails application
require File.expand_path('../application', __FILE__)
require 'gibberish'

# Initialize the rails application
SassRailscrm::Application.initialize!
::KEY = Gibberish::AES.new("awerwrREWdfER1645")

ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['SENDGRID_USERNAME'],
  :password       => ENV['SENDGRID_PASSWORD'],
  :domain         => 'heroku.com',
  :enable_starttls_auto => true
}
