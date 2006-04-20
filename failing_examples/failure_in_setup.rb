context "Failure in" do
  
  setup do
    NonExistentClass.new
  end
  
  specify "should be listed as being in setup" do
  end
  
end