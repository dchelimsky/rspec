context "This example" do
  
  specify "should show that a NoMethodError is raised but an Exception was expected" do
    proc { ''.nonexistent_method }.should raise_error
  end
  
  specify "should pass" do
    proc { ''.nonexistent_method }.should raise_error(NoMethodError)
  end
  
  specify "should show that a NoMethodError is raised but a SyntaxError was expected" do
    proc { ''.nonexistent_method }.should raise_error(SyntaxError)
  end
  
  specify "should show that nothing is raised when SyntaxError was expected" do
    proc { }.should raise_error(SyntaxError)
  end

  specify "should show that a NoMethodError is raised but a Exception was expected" do
    proc { ''.nonexistent_method }.should_not raise_error
  end
  
  specify "should show that a NoMethodError is raised" do
    proc { ''.nonexistent_method }.should_not raise_error(NoMethodError)
  end
  
  specify "should also pass" do
    proc { ''.nonexistent_method }.should_not raise_error(SyntaxError)
  end
  
  specify "should show that a NoMethodError is raised when nothing expected" do
    proc { ''.nonexistent_method }.should_not raise_error(Exception)
  end
  
  specify "should show that the wrong message was received" do
    proc { raise StandardError.new("what is an enterprise?") }.should raise_error(StandardError, "not this")
  end
  
  specify "should show that the unexpected error/message was thrown" do
    proc { raise StandardError.new("abc") }.should_not raise_error(StandardError, "abc")
  end
  
  specify "should pass too" do
    proc { raise StandardError.new("abc") }.should_not raise_error(StandardError, "xyz")
  end
  
end
