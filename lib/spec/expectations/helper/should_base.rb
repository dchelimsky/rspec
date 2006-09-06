class TrueClass; def inspect_for_expectation_not_met_error; "<true>" end end
class FalseClass; def inspect_for_expectation_not_met_error; "<false>" end end
class NilClass; def inspect_for_expectation_not_met_error; "nil" end end
class Class; def inspect_for_expectation_not_met_error; "<#{name}>" end end
class Proc; def inspect_for_expectation_not_met_error; "<Proc>" end end
class Array; def inspect_for_expectation_not_met_error; inspect end end
class String; def inspect_for_expectation_not_met_error; inspect end end
class Object
  def inspect_for_expectation_not_met_error
    return "#{self.class} #{inspect}" if inspect.include? "<"
    return "#{self.class} <#{inspect}>" unless inspect.include? "<"
  end
end

module Spec
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
    
    def find_correct_sym(original_sym)
      ["#{original_sym}?", "#{original_sym}s?"].each do |alternate_sym|
        if @target.respond_to?(alternate_sym.to_s)
          return alternate_sym.to_s
        end
      end
      return original_sym
    end
    
  end
end
