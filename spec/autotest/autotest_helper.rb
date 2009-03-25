dir = File.dirname(__FILE__)

require File.expand_path("#{dir}/../../lib/spec/ruby")
Spec::Ruby.require_with_rubygems_fallback 'autotest'
require File.expand_path("#{dir}/../spec_helper")
require File.expand_path("#{dir}/../../lib/autotest/rspec")
require File.expand_path("#{dir}/autotest_matchers")
