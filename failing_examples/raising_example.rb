context "This example" do
  
  specify "should show that a NoMethodError is raised" do
    proc { ''.nonexistent_method }.should.not.raise NoMethodError
  end
  
  specify "should show that a NoMethodError is raised but a SyntaxError was expected" do
    proc { ''.nonexistent_method }.should.raise SyntaxError
  end
  
end
