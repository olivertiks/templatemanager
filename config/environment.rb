# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ENV['MONGO_SERVER'] = "127.0.0.1:27017" #local
