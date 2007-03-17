require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe Example, " instance" do
      setup do
        @reporter = mock("reporter")
        Example.send(:current=, nil)
      end

      specify "should add itself to reporter when calling run dry" do
        example=Example.new("example") {}
        @reporter.should_receive(:spec_started).with("example")
        @reporter.should_receive(:spec_finished).with("example")
        example.run(@reporter, nil, nil, true, nil)
      end

      specify "should add itself to reporter when fails" do
        error=RuntimeError.new
        example=Example.new("example") do
          raise(error)
        end
        @reporter.should_receive(:spec_started).with("example")
        @reporter.should_receive(:spec_finished).with("example", error, "example")
        example.run(@reporter, nil, nil, nil, nil)
      end

      specify "should add itself to reporter when passes" do
        example=Example.new("example") {}
        @reporter.should_receive(:spec_started).with("example")
        @reporter.should_receive(:spec_finished).with("example", nil, nil)
        example.run(@reporter, nil, nil, nil, nil)
      end

      specify "should not run example if setup fails" do
        example_ran = false
        example=Example.new("should pass") do
          example_ran = true
        end
        @reporter.stub!(:spec_started)
        @reporter.stub!(:spec_finished)
        setup = proc {raise "Setup error"}
        example.run(@reporter, setup, nil, nil, Object.new)
        example_ran.should == false
        @reporter.__verify
      end

      specify "should run example in scope of execution context" do
        exec_context_class = Class.new
        example=Example.new("should pass") do
          self.instance_of?(Example).should == false
          self.instance_of?(exec_context_class).should == true
        end
        @reporter.should_receive(:spec_started).with("should pass")
        @reporter.should_receive(:spec_finished).with("should pass", nil, nil)
        example.run(@reporter, nil, nil, nil, exec_context_class.new)
        @reporter.__verify
      end

      specify "should run teardown even when main block fails" do
        example=Example.new("example") do
          raise("in body")
        end
        teardown=lambda do
          raise("in teardown")
        end
        @reporter.should_receive(:spec_started).with("example")
        @reporter.should_receive(:spec_finished) do |example, error, location|
          example.should eql("example")
          location.should eql("example")
          error.message.should eql("in body")
        end
        example.run(@reporter, nil, teardown, nil, nil)
      end

      specify "should supply setup as example name if failure in setup" do
        example=Example.new("example") {}
        setup=lambda { raise("in setup") }
        @reporter.should_receive(:spec_started).with("example")
        @reporter.should_receive(:spec_finished) do |name, error, location|
          name.should eql("example")
          error.message.should eql("in setup")
          location.should eql("setup")
        end
        example.run(@reporter, setup, nil, nil, nil)
      end

      specify "should supply teardown as failure location if failure in teardown" do
        example = Example.new("example") {}
        teardown = lambda { raise("in teardown") }
        @reporter.should_receive(:spec_started).with("example")
        @reporter.should_receive(:spec_finished) do |name, error, location|
          name.should eql("example")
          error.message.should eql("in teardown")
          location.should eql("teardown")
        end
        example.run(@reporter, nil, teardown, nil, nil)
      end

      specify "should verify mocks after teardown" do
        example=Example.new("example") do
          mock=Spec::Mocks::Mock.new("a mock")
          mock.should_receive(:poke)
        end
        @reporter.should_receive(:spec_started).with("example")
        @reporter.should_receive(:spec_finished) do |example_name, error|
          example_name.should eql("example")
          error.message.should match(/expected :poke with \(any args\) once, but received it 0 times/)
        end
        example.run(@reporter, nil, nil, nil, Object.new)
      end
      
      specify "should accept an options hash following the example name" do
        example = Example.new("name", :key => 'value')
      end

      specify "should update the current example only when running the example" do
        @reporter.stub!(:spec_started)
        @reporter.stub!(:spec_finished)

        example = Example.new("example") do
          Example.current.should == example
        end

        Example.current.should be_nil
        setup = proc {Example.current.should == example}
        teardown = proc {Example.current.should == example}
        example.run(@reporter, setup, teardown, nil, Object.new)
        Example.current.should be_nil
      end

      specify "should notify before_setup callbacks before setup" do
        example = Example.new("example")
        @reporter.stub!(:spec_started)
        @reporter.stub!(:spec_finished)

        mock = mock("setup mock")
        mock.should_receive(:before_setup).ordered
        mock.should_receive(:setup).ordered

        example.before_setup {mock.before_setup}
        setup = proc {mock.setup}
        example.run(@reporter, setup, nil, nil, Object.new)
      end

      specify "should notify after_teardown callbacks after teardown" do
        example = Example.new("example")
        @reporter.stub!(:spec_started)
        @reporter.stub!(:spec_finished)

        mock = mock("teardown mock")
        mock.should_receive(:teardown).ordered
        mock.should_receive(:after_teardown).ordered

        example.after_teardown {mock.after_teardown}
        teardown = proc {mock.teardown}
        example.run(@reporter, nil, teardown, nil, Object.new)
      end
      
      specify "should report NAME NOT GENERATED when told to use generated description but none is generated" do
        example = Example.new(:__generate_description)
        @reporter.stub!(:spec_started)
        @reporter.should_receive(:spec_finished).with("NAME NOT GENERATED", :anything, :anything)
        example.run(@reporter, nil, nil, nil, Object.new)
      end
      
      specify "should use generated description when told to and it is available" do
        example = Example.new(:__generate_description) {
          5.should == 5
        }
        @reporter.stub!(:spec_started)
        @reporter.should_receive(:spec_finished).with("should == 5", :anything, :anything)
        example.run(@reporter, nil, nil, nil, Object.new)
      end
      
      specify "should unregister description_generated callback (lest a memory leak should build up)" do
        example = Example.new("something")
        @reporter.stub!(:spec_started)
        @reporter.stub!(:spec_finished)
        Spec::Matchers.should_receive(:unregister_callback)
        example.run(@reporter, nil, nil, nil, Object.new)
      end
    end
  end
end
