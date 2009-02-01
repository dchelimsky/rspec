module Spec
  module Example
    class ExampleDescription
      attr_reader :description, :options, :backtrace
      
      def initialize(description, options={}, backtrace=nil)
        @description, @options, @backtrace = description, options, backtrace
      end
      
      def ==(other)
        (other.description == description) & (other.backtrace == backtrace)
      end
    end
  end
end
