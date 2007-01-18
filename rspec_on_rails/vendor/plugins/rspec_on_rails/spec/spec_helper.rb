$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../../../../rspec/lib')
require File.dirname(__FILE__) + '/../../../../spec/spec_helper'

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
