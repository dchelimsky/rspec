require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe Example, " class" do
      setup do
        @reporter = mock("reporter")
        callback_container = Callback::CallbackContainer.new
        @example_class = Example.dup
        @example_class.stub!(:callbacks).and_return {callback_container}
      end

      it "should have a before_setup callback for all examples" do
        @reporter.stub!(:spec_started)
        @reporter.stub!(:spec_finished)

        before_setup_called = false
        @example_class.before_setup {before_setup_called = true}

        example = @example_class.new("example") {}
        example.run(@reporter, nil, nil, nil, Object.new)

        before_setup_called.should == true
      end

      it "should have before_setup callback add errors to example run" do
        error=Exception.new
        @example_class.before_setup do
          raise(error)
        end
        example=@example_class.new("example") {}
        @reporter.should_receive(:spec_started).with("example")
        @reporter.should_receive(:spec_finished).with("example", error, "setup")
        example.run(@reporter, nil, nil, nil, Object.new)
      end

      it "should report exceptions in example" do
        error = Exception.new
        example=@example_class.new("example") do
          raise(error)
        end
        @reporter.should_receive(:spec_started).with("example")
        @reporter.should_receive(:spec_finished).with("example", error, "example")
        example.run(@reporter, nil, nil, nil, Object.new)
      end

      it "should have an after_teardown callback for all examples" do
        @reporter.stub!(:spec_started)
        @reporter.stub!(:spec_finished)

        after_teardown_called = false
        @example_class.after_teardown {after_teardown_called = true}

        example = @example_class.new("example") {}
        example.run(@reporter, nil, nil, nil, Object.new)

        after_teardown_called.should == true
      end

      it "should have after_teardown callback add errors to example run" do
        error=Exception.new
        @example_class.after_teardown do
          raise(error)
        end
        example=@example_class.new("example") {}
        @reporter.should_receive(:spec_started).with("example")
        @reporter.should_receive(:spec_finished).with("example", error, "teardown")
        example.run(@reporter, nil, nil, nil, Object.new)
      end
    end
  end
end
