module Spec
  module Expectations
    module Should
      class Base

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
    
        def find_supported_sym(original_sym)
          ["#{original_sym}?", "#{original_sym}s?"].each do |alternate_sym|
            return alternate_sym.to_s if @target.respond_to?(alternate_sym.to_s)
          end
          return original_sym.supported_by_rspec? ? original_sym : "#{original_sym}?"
        end

        def method_missing(original_sym, *args, &block)
          if original_sym.to_s =~ /^not_/
            return Negator.new(@target).__send__(original_sym.to_s[4..-1].to_sym, *args, &block)
          end
          if original_sym.to_s =~ /^be_/
            return __send__(original_sym.to_s[3..-1].to_sym, *args, &block)
          end
          if original_sym.to_s =~ /^have_/
            return have.__send__(original_sym.to_s[5..-1].to_sym, *args, &block)
          end
          __delegate_method_missing_to_target original_sym, find_supported_sym(original_sym), *args
        end
      end
    end
  end
end
