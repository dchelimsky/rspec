module Spec
  module Matchers
    # :call-seq:
    #   should eql(expected)
    #   should_not eql(expected)
    #
    # Passes if actual and expected are of equal value, but not necessarily the same object.
    #
    # See http://www.ruby-doc.org/core/classes/Object.html#M001057 for more information about equality in Ruby.
    #
    # == Examples
    #
    #   5.should eql(5)
    #   5.should_not eql(3)
    def eql(expected)
      Matcher.new :eql, expected do |expected|
        match do |actual|
          actual.eql?(expected)
        end

        failure_message_for_should do |actual|
          <<-MESSAGE

expected #{expected.inspect}
     got #{actual.inspect}

(compared using eql?)
MESSAGE
        end

        failure_message_for_should_not do |actual|
          <<-MESSAGE

expected #{actual.inspect} not to equal #{expected.inspect}

(compared using eql?)
MESSAGE
        end
      end
    end
  end
end
