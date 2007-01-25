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
            else
              case @expected_message
              when Regexp
                if @expected_message =~ @actual_error.message
                  @raised_expected_error = true
                else
                  @raised_other = true
                end
              else
                if @actual_error.message == @expected_message
                  @raised_expected_error = true
                else
                  @raised_other = true
                end
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
            case @expected_message
            when nil
              @expected_error
            when Regexp
              "RuntimeError with message matching #{@expected_message.inspect}"
            else
              "#{@expected_error} with #{@expected_message.inspect}"
            end
          end

          def actual_error
            @actual_error.nil? ? " but nothing was raised" : ", got #{@actual_error.inspect}"
          end
      end
      
    end
  end
end
