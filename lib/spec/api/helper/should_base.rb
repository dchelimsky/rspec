class TrueClass; def inspect_for_expectation_not_met_error; "<true>" end end
class FalseClass; def inspect_for_expectation_not_met_error; "<false>" end end
class NilClass; def inspect_for_expectation_not_met_error; "nil" end end
class Class; def inspect_for_expectation_not_met_error; "<#{name}>" end end
class Proc; def inspect_for_expectation_not_met_error; "<Proc>" end end
class Array; def inspect_for_expectation_not_met_error; "#{inspect}" end end
class String; def inspect_for_expectation_not_met_error; "#{inspect}" end end
class Object
  def inspect_for_expectation_not_met_error
    return "#{self.class} #{inspect}" if inspect.include? "<"
    return "#{self.class} <#{inspect}>" unless inspect.include? "<"
  end
end

module Spec
  
  class ShouldBase

		def default_message(expectation, expected=:no_expectation_specified)
      message = "#{@target.inspect_for_expectation_not_met_error} #{expectation}"
      if (expected != :no_expectation_specified)
        message << " " << expected.inspect_for_expectation_not_met_error
      end
      message
   	end

		def fail_with_message(message)
			Kernel::raise(Spec::Api::ExpectationNotMetError.new(message))
		end
		
  end
  
end
