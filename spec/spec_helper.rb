require 'rspec'

require 'purview'

require 'dotenv'
Dotenv.load('.env.local.test', '.env.test')

require 'support/helpers/raw_connection_helper'

RSpec.configure do |config|
  config.color_enabled = true if config.respond_to?(:color_enabled)
end
