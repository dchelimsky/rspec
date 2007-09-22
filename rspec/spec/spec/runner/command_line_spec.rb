require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "CommandLine" do
  it_should_behave_like "Test::Unit io sink"
  it "should run directory" do
    file = File.dirname(__FILE__) + '/../../../examples'
    err = StringIO.new
    out = StringIO.new
    Spec::Runner::CommandLine.run([file], err, out, false)

    out.rewind
    out.read.should =~ /\d+ examples, 0 failures, 3 pending/n
  end

  it "should run file" do
    file = File.dirname(__FILE__) + '/../../../failing_examples/predicate_example.rb'
    err = StringIO.new
    out = StringIO.new
    Spec::Runner::CommandLine.run([file], err, out, false)

    out.rewind
    out.read.should =~ /2 examples, 1 failure/n
  end

  it "should raise when file does not exist" do
    file = File.dirname(__FILE__) + '/doesntexist'
    err = StringIO.new
    out = StringIO.new

    lambda {
      Spec::Runner::CommandLine.run([file], err, out, false)
    }.should raise_error
  end
end
