describe "This example" do
  
  it "should be listed as failing in teardown" do
  end
  
  teardown do
    NonExistentClass.new
  end
  
end