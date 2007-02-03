module Spec
  module Rails
    module Matchers
      
      class RenderTemplate #:nodoc:
      
        def initialize(expected)
          @expected = expected
        end
        
        def matches?(response)
          @actual = response.rendered_file(!expected.include?('/'))
          actual == expected
        end

        def failure_message
          "expected #{expected.inspect}, got #{actual.inspect}"
        end
        
        private
          attr_reader :expected
          attr_reader :actual
          
      end

    end
  end
end
