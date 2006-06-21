module Spec
  module Api
    class ExpectationNotMetError < StandardError
    end
    
    class MockExpectationError < StandardError
    end

    class AmbiguousReturnError < StandardError
    end
  end
end
