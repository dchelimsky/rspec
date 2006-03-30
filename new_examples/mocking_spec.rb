require File.dirname(__FILE__) + '/../lib/spec'

context "Mocker" do

  specify "should be able to call mock()" do
    mock = mock("poke me")
    mock.should_receive(:poke)
    mock.poke
  end

  specify "should fail when expected message not received" do
    mock = mock("poke me")
    mock.should_receive(:poke)
  end

end