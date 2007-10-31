module Spec
  module DSL
    class ShouldRaiseHandler
      def initialize(file_and_line_number, should_raise)
        @file_and_line_number = file_and_line_number
        @should_raise = should_raise
        @expected_error_class = determine_error_class
        @expected_error_message = determine_error_message
      end
  
      def determine_error_class
        if @should_raise.is_a?(Class)
          return @should_raise
        elsif @should_raise.is_a?(Array)
          return @should_raise[0]
        else
          return Exception
        end
      end
  
      def determine_error_message
        if @should_raise.is_a?(Array)
          return @should_raise[1]
        end
        return nil
      end
  
      def build_message(exception=nil)
        if @expected_error_message
          message = "example block expected #{@expected_error_class.new(@expected_error_message.to_s).inspect}"
        else
          message = "example block expected #{@expected_error_class.to_s}"
        end
        message << " but raised #{exception.inspect}" if exception
        message << " but nothing was raised" unless exception
        message << "\n"
        message << @file_and_line_number
      end
  
      def error_matches?(error)
        return false unless error.kind_of?(@expected_error_class)
        if @expected_error_message
          if @expected_error_message.is_a?(Regexp)
            return false unless error.message =~ @expected_error_message
          else
            return false unless error.message == @expected_error_message
          end
        end
        return true
      end

      def handle(errors)
        error_to_remove = errors.detect do |error|
          error_matches?(error)
        end
        if error_to_remove.nil?
          errors.insert(0,Spec::Expectations::ExpectationNotMetError.new(build_message(errors[0])))
        else
          errors.delete(error_to_remove)
        end
      end
    end
  end
end
