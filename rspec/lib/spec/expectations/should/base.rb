module Spec
  module Expectations
    module Should
      class Base
        
        #== and =~ will stay after the new syntax
        def ==(expected)
          __delegate_method_missing_to_target "==", "==", expected
        end
        
        def =~(expected)
          __delegate_method_missing_to_target "=~", "=~", expected
        end

        def default_message(expectation, expected=nil)
          return "expected #{expected.inspect}, got #{@target.inspect} (using #{expectation})" if expectation == '=='
          "expected #{expectation} #{expected.inspect}, got #{@target.inspect}" unless expectation == '=='
        end

        def fail_with_message(message, expected=nil, target=nil)
          Spec::Expectations.fail_with(message, expected, target)
        end
    
      end
    end
  end
end
