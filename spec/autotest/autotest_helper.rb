begin
  require 'autotest'
rescue LoadError
  if ENV['DONT_MAKE_ME_USE_RUBYGEMS']
    raise <<-MESSAGE

We need to load autotest, but you've set the
DONT_MAKE_ME_USE_RUBYGEMS environment variable 
and failed to supply a means of loading autotest.
MESSAGE
  end
  require 'rubygems'
  require 'autotest'
end
dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/../spec_helper")
require File.expand_path("#{dir}/../../lib/autotest/rspec")
require File.expand_path("#{dir}/autotest_matchers")
