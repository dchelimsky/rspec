module Spec
  module Expectations
    module Matchers
      
      class RaiseError #:nodoc:
        def initialize(exception=Exception, message=nil)
          @expected_error = exception
          @expected_message = message
        end
        
        def matches?(proc)
          @raised_expected_error = false
          @raised_other = false
          begin
            proc.call
          rescue @expected_error => @actual_error
            if @expected_message.nil?
              @raised_expected_error = true
            else @expected_message.nil?
              if @actual_error.message == @expected_message
                @raised_expected_error = true
              else
                @raised_other = true
              end
            end
          rescue => @actual_error
            @raised_other = true
          ensure
            return @raised_expected_error
          end
        end
        
        def failure_message
          return "expected #{expected_error}#{actual_error}" if @raised_other || !@raised_expected_error
        end

        def negative_failure_message
          "expected no #{expected_error}#{actual_error}"
        end
        
        private
          def expected_error
            @expected_message.nil? ? @expected_error : "#{@expected_error} with #{@expected_message.inspect}"
          end

          def actual_error
            @actual_error.nil? ? " but nothing was raised" : ", got #{@actual_error.inspect}"
          end
      end
      
    end
  end
end
