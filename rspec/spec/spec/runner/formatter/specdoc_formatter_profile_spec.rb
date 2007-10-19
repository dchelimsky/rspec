require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Runner
    module Formatter
      describe "SpecdocFormatterProfile" do
        before(:each) do
          @io = StringIO.new
          @options = Options.new(StringIO.new, @io)
          @formatter = @options.create_formatter(SpecdocFormatter)
          @options.profile = true
          @behaviour = Class.new(::Spec::DSL::Example).describe("My Behaviour")
          @now = Time.now
        end
        
        it "should push failing spec name and failure number" do
          Time.stub!(:now).and_return(@now)
          @formatter.example_started(mock("example"))
          Time.stub!(:now).and_return(@now + 1.234)
          @formatter.example_failed(@behaviour.create_example_definition("spec"), 98, Reporter::Failure.new("c s", RuntimeError.new))
          @io.string.should eql("- spec (ERROR - 98) (1.234 sec)\n")
        end

        it "should push passing spec name" do
          Time.stub!(:now).and_return(@now)
          @formatter.example_started(mock("example"))
          Time.stub!(:now).and_return(@now + 1.234)
          @formatter.example_passed(@behaviour.create_example_definition("spec"))
          @io.string.should eql("- spec (1.234 sec)\n")
        end
      end
    end
  end
end
