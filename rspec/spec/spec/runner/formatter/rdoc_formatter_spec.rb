require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Runner
    module Formatter
      describe "RdocFormatter" do
        before(:each) do
          @io = StringIO.new
          @options = Options.new(StringIO.new, @io)
          @formatter = @options.create_formatter(RdocFormatter)
          @options.dry_run = true
          @behaviour = Class.new(::Spec::DSL::ExampleGroup).describe("Some Examples")
        end

        it "should produce no summary" do
          @formatter.dump_summary(nil, nil, nil, nil)
          @io.string.should be_empty
        end

        it "should produce nothing on start dump" do
          @formatter.start_dump
          @io.string.should be_empty
        end

        it "should push out context" do
          @formatter.add_example_group(Spec::DSL::ExampleGroupDescription.new("context"))
          @io.string.should eql("# context\n")
        end

        it "should push out failed spec" do
          @formatter.example_failed(@behaviour.create_example("spec"), 98, nil)
          @io.string.should eql("# * spec [98 - FAILED]\n")
        end

        it "should push out spec" do
          @formatter.example_passed(@behaviour.create_example("spec"))
          @io.string.should eql("# * spec\n")
        end

        it "should push out not pending example" do
          @formatter.example_pending("behaviour", "example", "reason")
          @io.string.should eql("# * behaviour example [PENDING: reason]\n")      
        end

      end
    end
  end
end
