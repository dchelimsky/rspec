module Spec
  module Expectations
    class ShouldBase

      instance_methods.each { |m| undef_method m unless m =~ /^(__|\w)/ }

      def default_message(expectation, expected=:no_expectation_specified)
        message = "#{@target.inspect_for_expectation_not_met_error} #{expectation}"
        if (expected != :no_expectation_specified)
          message << " " << expected.inspect_for_expectation_not_met_error
        end
        message
       end

      def fail_with_message(message)
        Kernel::raise(Spec::Expectations::ExpectationNotMetError.new(message))
      end
    
      def respond_to? sym
        return true if super
        return true if @target.respond_to? "#{sym.to_s}?"
      end
    
      def find_supported_sym(original_sym)
        ["#{original_sym}?", "#{original_sym}s?"].each do |alternate_sym|
          return alternate_sym.to_s if @target.respond_to?(alternate_sym.to_s)
        end
        return original_sym.supported_by_rspec? ? original_sym : "#{original_sym}?"
      end
    end
  end
end
