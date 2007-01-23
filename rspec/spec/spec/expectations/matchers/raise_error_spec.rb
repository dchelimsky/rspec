require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "proc.should raise_error" do
  specify "should match if anything is raised" do
    block = lambda { raise }
    raise_error.matches?(block).should be(true)
  end
  
  specify "should not match if nothing is raised" do
    block = lambda {}
    raise_error.matches?(block).should be(false)
  end
  
  specify "should provide failure messsage" do
    #given
      block = lambda {}
      matcher = raise_error
      
    #when
      matcher.matches?(block)
      
    #then
      matcher.failure_message.should == "expected Exception but nothing was raised"
  end
  
  specify "should provide negative failure messsage" do
    #given
      block = lambda { raise }
      matcher = raise_error
      
    #when
      matcher.matches?(block)
      
    #then
      matcher.negative_failure_message.should == "expected no Exception, got RuntimeError"
  end
  
end

context "proc.should raise_error(NamedError)" do
  specify "should match if named error is raised" do
    block = lambda { non_existent_method }
    raise_error(NameError).matches?(block).should be(true)
  end
  
  specify "should not match if nothing is raised" do
    block = lambda {}
    raise_error(NameError).matches?(block).should be(false)
  end
  
  specify "should not match if incorrect error is raised" do
    block = lambda { raise }
    raise_error(NameError).matches?(block).should be(false)
  end
  
  specify "should provide failure messsage when no error is raised" do
    #given
    proc = lambda {}
    matcher = raise_error(NameError)
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.failure_message.should == "expected NameError but nothing was raised"
  end
  
  specify "should provide failure messsage when wrong error is raised" do
    #given
    proc = lambda { raise }
    matcher = raise_error(NameError)
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.failure_message.should == "expected NameError, got RuntimeError"
  end
  
  specify "should provide negative failure messsage when precise error is raised" do
    #given
    proc = lambda { non_existent_method }
    matcher = raise_error(NameError)
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.negative_failure_message.should =~ /expected no NameError, got #<NameError: undefined/
  end
  
end

context "proc.should raise_error(NamedError, error_message)" do
  specify "should match if named error is raised with same message" do
    block = lambda { raise "example message" }
    raise_error(RuntimeError, "example message").matches?(block).should be(true)
  end
  
  specify "should not match if nothing is raised" do
    block = lambda {}
    raise_error(RuntimeError, "example message").matches?(block).should be(false)
  end
  
  specify "should not match if incorrect error is raised" do
    block = lambda { raise }
    raise_error(NameError, "example message").matches?(block).should be(false)
  end
  
  specify "should not match if correct error is raised with incorrect message" do
    block = lambda { raise RuntimeError.new("example message") }
    raise_error(RuntimeError, "not the example message").matches?(block).should be(false)
  end
  
  specify "should provide failure messsage when no error is raised" do
    #given
    proc = lambda {}
    matcher = raise_error(RuntimeError, "expected message")
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.failure_message.should == "expected RuntimeError with \"expected message\" but nothing was raised"
  end
  
  specify "should provide failure messsage when wrong error is raised" do
    #given
    proc = lambda { non_existent_method }
    matcher = raise_error(RuntimeError, "expected message")
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.failure_message.should =~ /expected RuntimeError with \"expected message\", got #<NameError: undefined/
  end

  specify "should provide failure messsage when wrong message is raised" do
    #given
    proc = lambda { raise RuntimeError.new("not expected message") }
    matcher = raise_error(RuntimeError, "expected message")
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.failure_message.should =~ /expected RuntimeError with \"expected message\", got #<RuntimeError: not expected message/
  end

  
  specify "should provide negative failure messsage when correct error is raised with correct message" do
    #given
    proc = lambda { raise RuntimeError.new("expected message") }
    matcher = raise_error(RuntimeError, "expected message")
    
    #when
    matcher.matches?(proc)
    
    #then
    matcher.negative_failure_message.should =~ /expected no RuntimeError with \"expected message\", got #<RuntimeError: expected message/
  end
  
end
