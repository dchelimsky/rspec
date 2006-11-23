class Object
  def inspect_for_expectation_not_met_error
    return "#{inspect}" if inspect.include? "<"
    return "<#{inspect}>" unless inspect.include? "<"
  end
end
class TrueClass; def inspect_for_expectation_not_met_error; "true" end end
class FalseClass; def inspect_for_expectation_not_met_error; "false" end end
class NilClass; def inspect_for_expectation_not_met_error; "nil" end end
class Class; def inspect_for_expectation_not_met_error; "<#{name}>" end end
class Proc; def inspect_for_expectation_not_met_error; "<Proc>" end end
class Array; def inspect_for_expectation_not_met_error; inspect end end
class String; def inspect_for_expectation_not_met_error; inspect end end
class Numeric; def inspect_for_expectation_not_met_error; inspect end end
class Hash; def inspect_for_expectation_not_met_error; inspect end end