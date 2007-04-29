module Spec
  module DSL
    class Describable
      attr_reader :description, :described_type
      
      def initialize(*args)
        @options = args.last.is_a?(Hash) ? args.pop : {}
        @described_type = args.first unless args.first.is_a?(String)
        @description = args.shift.to_s
        @description << args.shift.to_s unless args.empty?
      end
  
      def [](key)
        @options[key]
      end
      
      def []=(key, value)
        @options[key] = value
      end
      
      def to_s; @description; end
      
      def ==(value)
        case value
        when Describable
          @description == value.description
        else
          @description == value
        end
      end

    end
  end
end