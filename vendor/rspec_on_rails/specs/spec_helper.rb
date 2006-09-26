require File.dirname(__FILE__) + '/../spec/spec_helper'

class Proc
  def should_fail
    should_raise Spec::Expectations::ExpectationNotMetError
  end
end