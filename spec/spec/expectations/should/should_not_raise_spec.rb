require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "should_not_raise" do
  specify "should fail when specific exception is raised" do
    begin
      lambda do
        "".nonexistent_method
      end.should_not_raise(NoMethodError)
    rescue 
      e=$!
    end
    e.message.should_eql("<Proc> should not raise <NoMethodError>")
  end

  specify "should fail when exact exception is raised with message" do
    lambda do
      lambda do
        raise(StandardError.new("abc"))
      end.should_not_raise(StandardError, "abc")
    end.should_raise(Spec::Expectations::ExpectationNotMetError)
  end

  specify "should include actual error in failure message" do
    begin
      lambda do
        "".nonexistent_method
      end.should_not_raise(Exception)
    rescue 
      e=$!
    end
    e.message.should_eql("<Proc> should not raise <Exception> but raised #<NoMethodError: undefined method `nonexistent_method' for \"\":String>")
  end

  specify "should pass when exact exception is raised with wrong message" do
    lambda do
      lambda do
        raise(StandardError.new("abc"))
      end.should_not_raise(StandardError, "xyz")
    end.should_not_raise
  end

  specify "should pass when no exception is raised" do
    lambda do
      lambda do
        "".to_s
      end.should_not_raise(NoMethodError)
    end.should_not_raise
  end

  specify "should pass when other exception is raised" do
    lambda do
      lambda do
        "".nonexistent_method
      end.should_not_raise(SyntaxError)
    end.should_not_raise
  end

  specify "without exception should pass when no exception is raised" do
    lambda do
      lambda do
        "".to_s
      end.should_not_raise
    end.should_not_raise
  end
end
