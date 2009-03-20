module Spec
  module Example
    class ExampleDescription
      attr_reader :description, :options, :backtrace, :example_id
      
      def initialize(description, options={}, backtrace=nil, example_id=__id__)
        @description, @options, @backtrace, @example_id = description, options, backtrace, example_id
      end
      
      def ==(other)
        (other.description == description) & (other.backtrace == backtrace)
      end
    end
  end
end
