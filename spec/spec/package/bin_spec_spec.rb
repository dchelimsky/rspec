require 'spec/spec_helper'
require 'spec/ruby_forker'

describe "The bin/spec script" do
  include RubyForker
  
  it "should have no warnings" do
    output = ruby "-w -S bin/spec --help"
    output.should_not =~ /warning/n
  end
  
  it "should show the help w/ no args" do
    output = ruby "-w -S bin/spec"
    output.should =~ /^Usage: spec/
  end
end
