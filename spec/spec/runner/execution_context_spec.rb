require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
module Runner
context "ExecutionContext" do
    specify "duck type" do
        ec=
        ec=ExecutionContext.new(Spec::Mocks::Mock.new("spec", {
          :null_object => true
        }))
        duck_type=ec.duck_type(:length)
        duck_type.is_a?(Spec::Mocks::DuckTypeArgConstraint).should_be(true)
        duck_type.matches?([]).should_be(true)
      
    end
    specify "violated" do
        lambda do
          ExecutionContext.new(nil).violated
        end.should_raise(Spec::Expectations::ExpectationNotMetError)
      
    end
  
end
end
end