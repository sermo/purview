require 'rspec'

require 'purview'

# dotenv helps us keep the test db environment settings sorted out
require 'dotenv'
Dotenv.load('.env.test', '.env.local')

RSpec.configure do |config|
  config.color_enabled = true if config.respond_to?(:color_enabled)
end
