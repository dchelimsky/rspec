require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Runner
    module Formatter
      describe "SpecdocFormatter" do
        before(:each) do
          @io = StringIO.new
          @options = Options.new(StringIO.new, @io)
          @formatter = @options.create_formatter(SpecdocFormatter)
          @behaviour = Class.new(::Spec::DSL::ExampleGroup).describe("Some Examples")
        end

        it "should produce standard summary without pending when pending has a 0 count" do
          @formatter.dump_summary(3, 2, 1, 0)
          @io.string.should eql("\nFinished in 3 seconds\n\n2 examples, 1 failure\n")
        end

        it "should produce standard summary" do
          @formatter.dump_summary(3, 2, 1, 4)
          @io.string.should eql("\nFinished in 3 seconds\n\n2 examples, 1 failure, 4 pending\n")
        end

        it "should push context name" do
          @formatter.add_example_group(Spec::DSL::ExampleGroupDescription.new("context"))
          @io.string.should eql("\ncontext\n")
        end

        it "when having an error, should push failing spec name and failure number" do
          @formatter.example_failed(
            @behaviour.create_example("spec"),
            98,
            Reporter::Failure.new("c s", RuntimeError.new)
          )
          @io.string.should eql("- spec (ERROR - 98)\n")
        end

        it "when having an expectation failure, should push failing spec name and failure number" do
          @formatter.example_failed(
            @behaviour.create_example("spec"),
            98,
            Reporter::Failure.new("c s", Spec::Expectations::ExpectationNotMetError.new)
          )
          @io.string.should eql("- spec (FAILED - 98)\n")
        end

        it "should push nothing on start" do
          @formatter.start(5)
          @io.string.should eql("")
        end

        it "should push nothing on start dump" do
          @formatter.start_dump
          @io.string.should eql("")
        end

        it "should push passing spec name" do
          @formatter.example_passed(@behaviour.create_example("spec"))
          @io.string.should eql("- spec\n")
        end

        it "should push pending example name and message" do
          @formatter.example_pending('behaviour', 'example','reason')
          @io.string.should eql("- example (PENDING: reason)\n")
        end

        it "should dump pending" do
          @formatter.example_pending('behaviour', 'example','reason')
          @io.rewind
          @formatter.dump_pending
          @io.string.should =~ /Pending\:\nbehaviour example \(reason\)\n/
        end

      end
    end
  end
end
