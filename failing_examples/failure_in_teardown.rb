context "Random context name" do
  
  specify "should be listed as being in teardown" do
  end
  
  teardown do
    NonExistentClass.new
  end
  
end