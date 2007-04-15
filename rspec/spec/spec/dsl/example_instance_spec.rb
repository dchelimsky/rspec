require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe Example, " instance" do
      # TODO - this should be
      #   predicate_matchers :is_a
      def is_a(error)
        be_is_a(error)
      end
      
      setup do
        @reporter = stub("reporter", :example_finished => nil)
      end

      specify "should report its name for dry run" do
        example=Example.new("example") {}
        @reporter.should_receive(:example_finished).with("example")
        example.run(@reporter, nil, nil, true, nil) #4th arg indicates dry run
      end

      specify "should report success" do
        example=Example.new("example") {}
        @reporter.should_receive(:example_finished).with("example", nil, nil)
        example.run(@reporter, nil, nil, nil, nil)
      end

      specify "should report failure due to failure" do
        example=Example.new("example") do
          (2+2).should == 5
        end
        @reporter.should_receive(:example_finished).with("example", is_a(Spec::Expectations::ExpectationNotMetError), "example")
        example.run(@reporter, nil, nil, nil, nil)
      end

      specify "should report failure due to error" do
        error=RuntimeError.new
        example=Example.new("example") do
          raise(error)
        end
        @reporter.should_receive(:example_finished).with("example", error, "example")
        example.run(@reporter, nil, nil, nil, nil)
      end

      specify "should run example in scope of supplied object" do
        scope_class = Class.new
        example=Example.new("should pass") do
          self.instance_of?(Example).should == false
          self.instance_of?(scope_class).should == true
        end
        @reporter.should_receive(:example_finished).with("should pass", nil, nil)
        example.run(@reporter, nil, nil, nil, scope_class.new)
      end

      specify "should not run example block if setup fails" do
        example_ran = false
        example=Example.new("should pass") {example_ran = true}
        setup = lambda {raise "Setup error"}
        example.run(@reporter, setup, nil, nil, Object.new)
        example_ran.should == false
      end

      specify "should run teardown block if setup fails" do
        teardown_ran = false
        example=Example.new("should pass") {}
        setup = lambda {raise "Setup error"}
        teardown = lambda {teardown_ran = true}
        example.run(@reporter, setup, teardown, nil, Object.new)
        teardown_ran.should == true
      end

      specify "should run teardown block when example fails" do
        example=Example.new("example") do
          raise("in body")
        end
        teardown=lambda do
          raise("in teardown")
        end
        @reporter.should_receive(:example_finished) do |example, error, location|
          example.should eql("example")
          location.should eql("example")
          error.message.should eql("in body")
        end
        example.run(@reporter, nil, teardown, nil, nil)
      end

      specify "should report failure location when in setup" do
        example=Example.new("example") {}
        setup=lambda { raise("in setup") }
        @reporter.should_receive(:example_finished) do |name, error, location|
          name.should eql("example")
          error.message.should eql("in setup")
          location.should eql("setup")
        end
        example.run(@reporter, setup, nil, nil, nil)
      end

      specify "should report failure location when in teardown" do
        example = Example.new("example") {}
        teardown = lambda { raise("in teardown") }
        @reporter.should_receive(:example_finished) do |name, error, location|
          name.should eql("example")
          error.message.should eql("in teardown")
          location.should eql("teardown")
        end
        example.run(@reporter, nil, teardown, nil, nil)
      end

      specify "should accept an options hash following the example name" do
        example = Example.new("name", :key => 'value')
      end

      specify "should notify before_setup callbacks before setup" do
        example = Example.new("example")

        mock = mock("setup mock")
        mock.should_receive(:before_setup).ordered
        mock.should_receive(:setup).ordered

        example.before_setup {mock.before_setup}
        setup = lambda {mock.setup}
        example.run(@reporter, setup, nil, nil, Object.new)
      end

      specify "should notify after_teardown callbacks after teardown" do
        example = Example.new("example")

        mock = mock("teardown mock")
        mock.should_receive(:teardown).ordered
        mock.should_receive(:after_teardown).ordered

        example.after_teardown {mock.after_teardown}
        teardown = proc {mock.teardown}
        example.run(@reporter, nil, teardown, nil, Object.new)
      end
      
      specify "should report NAME NOT GENERATED when told to use generated description but none is generated" do
        example = Example.new(:__generate_description)
        @reporter.should_receive(:example_finished).with("NAME NOT GENERATED", :anything, :anything)
        example.run(@reporter, nil, nil, nil, Object.new)
      end
      
      specify "should report generated description when told to and it is available" do
        example = Example.new(:__generate_description) {
          5.should == 5
        }
        @reporter.should_receive(:example_finished).with("should == 5", :anything, :anything)
        example.run(@reporter, nil, nil, nil, Object.new)
      end
      
      specify "should unregister description_generated callback (lest a memory leak should build up)" do
        example = Example.new("something")
        Spec::Matchers.should_receive(:unregister_callback).with(:description_generated, is_a(Proc))
        example.run(@reporter, nil, nil, nil, Object.new)
      end
    end
  end
end
