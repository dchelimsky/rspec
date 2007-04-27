require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe Example, " class" do

      def run(example)
        example.run(@reporter, nil, nil, nil, Object.new)
      end

      before do
        @reporter = stub("reporter", :example_started => nil, :example_finished => nil)
        @example_class = Example.dup
        @example_class.stub!(:before_callbacks).and_return([])
        @example_class.stub!(:after_callbacks).and_return([])
      end
      
      it "should have a before_setup callback for all examples" do
        before_called = false
        @example_class.before {before_called = true}

        run(@example_class.new("example") {})

        before_called.should == true
      end

      it "should have before_setup callback report (but not raise) errors" do
        error=Exception.new
        @example_class.before {raise(error)}

        @reporter.should_receive(:example_finished).with("example", error, "setup")

        run(@example_class.new("example") {})
      end

      it "should report errors in example" do
        error = Exception.new
        @reporter.should_receive(:example_finished).with("example", error, "example")

        run(@example_class.new("example") {raise(error)})
      end

      it "should have an after_teardown callback for all examples" do
        after_called = false
        @example_class.after {after_called = true}

        run(@example_class.new("example") {})

        after_called.should == true
      end

      it "should have after_teardown callback add errors to example run" do
        error=Exception.new
        @example_class.after {raise(error)}

        @reporter.should_receive(:example_finished).with("example", error, "teardown")

        run(@example_class.new("example") {})
      end
    end
  end
end
