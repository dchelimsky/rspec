require 'java'
include_class 'java.net.ServerSocket'

context "ServerSocket" do
  specify "should know its own port" do
    server_socket = ServerSocket.new(5678)
    server_socket.localPort.should == 5678
  end
end