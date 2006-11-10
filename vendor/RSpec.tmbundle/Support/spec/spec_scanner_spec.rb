require 'rubygems'
require 'spec/runner'
require File.join(File.dirname(__FILE__), *%w[../lib/spec_mate])

context "Spec scanner" do
  setup do
    example_spec = <<SPEC
# nothing here
context "Some Context" do
  setup do
    
  end
  
  specify "should have a spec" do  # LINE 7
    
  end
end
SPEC
    @scanner = SpecMate::Scanner.new(example_spec)
  end

  specify "should return full spec name when on the same line as a specify line" do
    @scanner.spec_at_line(7).should == "Some Context should have a spec"
  end

  specify "should return full spec name when on the same line as an end line" do
    @scanner.spec_at_line(9).should == "Some Context should have a spec"
  end
  
  specify "should return context name when inside context but outside specify" do
    @scanner.spec_at_line(2).should == "Some Context"
    @scanner.spec_at_line(3).should == "Some Context"
    @scanner.spec_at_line(4).should == "Some Context"
  end

  specify "should return nil for context at line when there are no context blocks above the current line" do
    @scanner.spec_at_line(1).should_be nil
  end
end