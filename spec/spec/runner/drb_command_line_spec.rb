require 'stringio'

context "CommandLine" do
  
  specify "should print error when there is no running local server" do
    err = StringIO.new
    out = StringIO.new
    Spec::Runner::DrbCommandLine.run(['--version'], err, out)
    
    err.rewind
    err.read.should =~ /No server is running/
  end

  specify "should run against local server" do
    DRb.start_service("druby://localhost:8989", Spec::Runner::CommandLine)
    
    err = StringIO.new
    out = StringIO.new
    Spec::Runner::DrbCommandLine.run(['--version'], err, out, true)
    
    out.rewind
    out.read.should =~ /RSpec/n
  end

end
