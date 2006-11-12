context "An example failing spec" do
  specify "should pass" do
    true.should_be true
  end

  specify "should pass too" do
    false.should_be false
  end
end