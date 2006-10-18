require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "ShouldRaise" do
  specify "should fail when exact exception is raised with wrong message" do
    lambda do
      lambda do
        raise(StandardError.new("chunky bacon"))
      end.should_raise(StandardError, "rotten tomatoes")
    end.should_raise(Spec::Expectations::ExpectationNotMetError)
  end

  specify "should fail when no exception is raised" do
    begin
      lambda {}.should_raise(SyntaxError)
    rescue 
      e=$!
    end
    e.message.should_eql("<Proc> should raise <SyntaxError> but raised nothing")
  end

  specify "should fail when wrong exception is raised" do
    begin
      lambda do
        "".nonexistent_method
      end.should_raise(SyntaxError)
    rescue 
      e=$!
    end
    e.message.should_eql("<Proc> should raise <SyntaxError> but raised #<NoMethodError: undefined method `nonexistent_method' for \"\":String>")
  end

  specify "should pass when exact exception is raised" do
    lambda do
      lambda do
        "".nonexistent_method
      end.should_raise(NoMethodError)
    end.should_not_raise
  end

  specify "should pass when exact exception is raised with message" do
    lambda do
      lambda do
        raise(StandardError.new("this is standard"))
      end.should_raise(StandardError, "this is standard")
    end.should_not_raise
  end

  specify "should pass when subclass exception is raised" do
    lambda do
      lambda do
        "".nonexistent_method
      end.should_raise
    end.should_not_raise
  end
  
end
