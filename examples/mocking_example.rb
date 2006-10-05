require File.dirname(__FILE__) + '/../lib/spec'

context "A consumer of a mock" do

  specify "should be able to send messages to the mock" do
    mock = mock("poke me")
    mock.should_receive(:poke)
    mock.poke
  end

end
