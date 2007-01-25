module Spec
  module Expectations
    module Matchers
      
      class ThrowSymbol #:nodoc:
        def initialize(expected=nil)
          @expected = expected
        end
        
        def matches?(proc)
          begin
            proc.call
          rescue NameError => e
            @actual = extract_sym_from_name_error(e)
          ensure
            if @expected.nil?
              return @actual.nil? ? false : true
            else
              return @actual == @expected
            end
          end
        end

        def failure_message
          if @actual
            "expected #{expected} thrown, got #{@actual.inspect}"
          else
            "expected #{expected} thrown but nothing was thrown"
          end
        end
        
        def negative_failure_message
          if @expected
            "expected #{expected} to not be thrown, but it was"
          else
            "expected no Symbol thrown, got :#{@actual}"
          end
        end
        
        private
        
          def expected
            @expected.nil? ? "a Symbol" : @expected.inspect
          end
        
          def extract_sym_from_name_error(error)
            return :"#{error.message.split("`").last.split("'").first}"
          end
      end
   
    end
  end
end
        
