module Spec
  module Example
    class ExampleProxy
      attr_accessor :description
      attr_reader   :options, :backtrace
      alias_method  :location, :backtrace
      
      def initialize(description=nil, options={}, backtrace=nil)
        @description, @options, @backtrace = description, options, backtrace
      end
      
      def update(description)
        @description = description
        self
      end
      
      def ==(other)
        (other.description == description) & (other.backtrace == backtrace)
      end
    end
  end
end
