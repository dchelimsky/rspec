module Spec
  module Expectations
    module Should
      class CollectionHandler
        alias_method :__original_build_message, :build_message
        def build_message(sym, args)
          return __original_build_message(sym, args) unless sym == :errors_on
          error_subject = args[0]
          actual = actual_size_of(collection(sym, args))
          message = "#{@target.class} should have"
          message += " at least" if @at_least
          message += " at most" if @at_most
          message += " #{@expected} errors on :#{error_subject} (has #{actual})\n"
          @target.errors_on(error_subject).each do |error|
            message += "  #{error}\n"
          end unless actual.zero?
          message
        end
      end#CollectionHandler
    end#Should
  end#Expectations
end#Spec