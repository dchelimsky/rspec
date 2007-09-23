require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Spec::Runner::CommandLine, ".run" do
  it_should_behave_like "Test::Unit io sink"

  before do
    @err = StringIO.new
    @out = StringIO.new
  end

  it "should run directory" do
    file = File.dirname(__FILE__) + '/../../../examples'
    Spec::Runner::CommandLine.run([file], @err, @out)

    @out.rewind
    @out.read.should =~ /\d+ examples, 0 failures, 3 pending/n
  end

  it "should run file" do
    file = File.dirname(__FILE__) + '/../../../failing_examples/predicate_example.rb'
    Spec::Runner::CommandLine.run([file], @err, @out)

    @out.rewind
    @out.read.should =~ /2 examples, 1 failure/n
  end

  it "should raise when file does not exist" do
    file = File.dirname(__FILE__) + '/doesntexist'

    lambda {
      Spec::Runner::CommandLine.run([file], @err, @out)
    }.should raise_error
  end
  
  it "should return true when in --generate-options mode" do
    Spec::Runner::CommandLine.run(['--generate-options', '/dev/null'], @err, @out).should be_true
  end
end
