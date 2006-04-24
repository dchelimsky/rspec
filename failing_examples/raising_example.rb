context "This example" do
  
  specify "should show that a NoMethodError is raised but an Exception was expected" do
    proc { ''.nonexistent_method }.should.raise
  end
  
  specify "should pass" do
    proc { ''.nonexistent_method }.should.raise NoMethodError
  end
  
  specify "should show that a NoMethodError is raised but a SyntaxError was expected" do
    proc { ''.nonexistent_method }.should.raise SyntaxError
  end
  
  specify "should show that nothing is raised when SyntaxError was expected" do
    proc { }.should.raise SyntaxError
  end
  


  specify "should show that a NoMethodError is raised but a Exception was expected" do
    proc { ''.nonexistent_method }.should.not.raise
  end
  
  specify "should show that a NoMethodError is raised" do
    proc { ''.nonexistent_method }.should.not.raise NoMethodError
  end
  
  specify "should pass" do
    proc { ''.nonexistent_method }.should.not.raise SyntaxError
  end
  
  specify "should show that a NoMethodError is raised when nothing expected" do
    proc { ''.nonexistent_method }.should.not.raise Exception
  end
  
end
