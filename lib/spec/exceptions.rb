module Spec
  module Exceptions
    class ExpectationNotMetError < StandardError
    end
    
    class MockExpectationError < StandardError
    end
  end
end
