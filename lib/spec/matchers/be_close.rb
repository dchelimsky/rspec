module Spec
  module Matchers
    # :call-seq:
    #   should be_close(expected, delta)
    #   should_not be_close(expected, delta)
    #
    # Passes if actual == expected +/- delta
    #
    # == Example
    #
    #   result.should be_close(3.0, 0.5)
    def be_close(expected, delta)
      Matcher.new :be_close, expected, delta do |expected, delta|
        match do |actual|
          (actual - expected).abs < delta
        end

        failure_message_for_should do |actual|
          "expected #{expected} +/- (< #{delta}), got #{actual}"
        end

        failure_message_for_should_not do |actual|
          "expected #{expected} +/- (< #{delta}), got #{actual}"
        end

        description do
          "be close to #{expected} (within +- #{delta})"
        end
      end
    end
  end
end
