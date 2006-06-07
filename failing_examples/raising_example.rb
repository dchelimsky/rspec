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
  
end
