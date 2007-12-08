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
        end

        it "should add example name for each failure" do
          example_group_1 = Class.new(ExampleGroup).describe("eg 1")
          example_group_2 = Class.new(example_group_1).describe("eg 2")
          @formatter.add_example_group(example_group_1)
          @formatter.example_failed(example_group_1.it("e 1"), nil, Reporter::Failure.new(nil, RuntimeError.new))
          @formatter.add_example_group(example_group_2)
          @formatter.example_failed(example_group_2.it("e 2"), nil, Reporter::Failure.new(nil, RuntimeError.new))
          @formatter.example_failed(example_group_2.it("e 3"), nil, Reporter::Failure.new(nil, RuntimeError.new))
          @io.string.should eql(<<-EOF
eg 1 e 1
eg 1 : eg 2 e 2
eg 1 : eg 2 e 3
EOF
)
        end
      end
    end
  end
end
