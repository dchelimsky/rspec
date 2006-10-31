require 'stringio'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'spec'
require File.dirname(__FILE__) + '/../spec/spec/spec_classes'
RSPEC_TESTING = true unless defined? RSPEC_TESTING # This causes the diff extension to not be loaded
require 'spec/expectations/diff'
$context_runner ||= ::Spec::Runner::OptionParser.create_context_runner(['test'], false, STDERR, STDOUT)

class Proc
  def should_fail
    lambda { self.call }.should_raise(Spec::Expectations::ExpectationNotMetError)
  end
  def should_fail_with message
    lambda { self.call }.should_raise(Spec::Expectations::ExpectationNotMetError, message)
  end
  def should_pass
    lambda { self.call }.should_not_raise
  end
end