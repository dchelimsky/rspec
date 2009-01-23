module Spec
  module Example
    class ExampleDescription
      attr_reader :description, :backtrace
      
      def initialize(description, backtrace=nil)
        @description, @backtrace = description, backtrace
      end
      
      def ==(other)
        other.description == description && other.backtrace == backtrace
      end
    end
  end
end
