module Spec
  module Rails
    module Matchers
      
      class Render #:nodoc:
      
        def initialize(expected)
          @expected = expected
        end
        
        def failure_message
          "expected #{expected.inspect}, got #{actual.inspect}"
        end
        
        private
          attr_reader :expected
          attr_reader :actual
          
      end

      class RenderTemplate < Render #:nodoc:
        def matches?(response)
          @actual = response.rendered_file(!expected.include?('/'))
          actual == expected
        end
      end
      
      class RenderText < Render  #:nodoc:
        def matches?(response)
          @actual = response.body
          actual == expected
        end
      end
      
    end
  end
end
