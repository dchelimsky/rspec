begin
  require 'autotest'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  require 'autotest'
end
require 'spec/spec_helper'
require 'autotest/rspec'
require 'spec/autotest/autotest_matchers'
