context "This example" do
  
  specify "should be listed as failing in teardown" do
  end
  
  teardown do
    NonExistentClass.new
  end
  
end