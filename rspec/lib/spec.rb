def deprecated(&block)
  block.call unless ENV['RSPEC_DISABLE_DEPRECATED_FEATURES'] == 'true'
end

require 'spec/version'
require 'spec/callback'
require 'spec/matchers'
require 'spec/expectations'
require 'spec/mocks'
require 'spec/runner'
require 'spec/translator'
