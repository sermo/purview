require 'rspec'

require 'purview'

RSpec.configure do |config|
  config.color_enabled = true if config.respond_to?(:color_enabled)
end
