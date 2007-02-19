def deprecated(&block)
  block.call if ENV['RSPEC_DISABLE_DEPRECATED_FEATURES'].nil?
end

require 'spec/version'
require 'spec/callback'
require 'spec/expectations'
require 'spec/mocks'
require 'spec/runner'
require 'spec/translator'
