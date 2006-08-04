context "This example" do
  
  specify "should show that a NoMethodError is raised but an Exception was expected" do
    proc { ''.nonexistent_method }.should_raise
  end
  
  specify "should pass" do
    proc { ''.nonexistent_method }.should_raise NoMethodError
  end
  
  specify "should show that a NoMethodError is raised but a SyntaxError was expected" do
    proc { ''.nonexistent_method }.should_raise SyntaxError
  end
  
  specify "should show that nothing is raised when SyntaxError was expected" do
    proc { }.should_raise SyntaxError
  end

  specify "should show that a NoMethodError is raised but a Exception was expected" do
    proc { ''.nonexistent_method }.should_not_raise
  end
  
  specify "should show that a NoMethodError is raised" do
    proc { ''.nonexistent_method }.should_not_raise NoMethodError
  end
  
  specify "should pass" do
    proc { ''.nonexistent_method }.should_not_raise SyntaxError
  end
  
  specify "should show that a NoMethodError is raised when nothing expected" do
    proc { ''.nonexistent_method }.should_not_raise Exception
  end
  
  specify "should show that the wrong message was received" do
    proc { raise StandardError.new("what is an enterprise?") }.should_raise StandardError, "not this"
  end
  
  specify "should show that the unexpected error/message was thrown" do
    proc { raise StandardError.new("abc") }.should_not_raise StandardError, "abc"
  end
  
  specify "should pass" do
    proc { raise StandardError.new("abc") }.should_not_raise StandardError, "xyz"
  end
  
end
