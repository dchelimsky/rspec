context "An example failing spec" do
  specify "should fail" do
    true.should_be false
  end

  specify "should also fail" do
    false.should_be true
  end
end