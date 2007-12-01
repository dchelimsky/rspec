require File.dirname(__FILE__) + '/../../../spec_helper'
require 'spec/runner/formatter/failing_examples_formatter'

module Spec
  module Runner
    module Formatter
      describe FailingExamplesFormatter do
        before(:each) do
          @io = StringIO.new
          options = mock('options')
          @formatter = FailingExamplesFormatter.new(options, @io)
          @example_group = Class.new(::Spec::Example::ExampleGroup).describe("Some Examples")
        end

        it "should add example name for each failure" do
          @formatter.add_example_group("b 1")
          @formatter.example_failed(@example_group.it("e 1"), nil, Reporter::Failure.new(nil, RuntimeError.new))
          @formatter.add_example_group("b 2")
          @formatter.example_failed(@example_group.it("e 2"), nil, Reporter::Failure.new(nil, RuntimeError.new))
          @formatter.example_failed(@example_group.it("e 3"), nil, Reporter::Failure.new(nil, RuntimeError.new))
          @io.string.should eql(<<-EOF
b 1 e 1
b 2 e 2
b 2 e 3
EOF
)
        end
      end
    end
  end
end
