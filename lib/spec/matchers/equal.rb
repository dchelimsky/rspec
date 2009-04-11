module Spec
  module Matchers

    # :call-seq:
    #   should equal(expected)
    #   should_not equal(expected)
    #
    # Passes if actual and expected are the same object (object identity).
    #
    # See http://www.ruby-doc.org/core/classes/Object.html#M001057 for more information about equality in Ruby.
    #
    # == Examples
    #
    #   5.should equal(5) #Fixnums are equal
    #   "5".should_not equal("5") #Strings that look the same are not the same object
    def equal(expected)
      Matcher.new :equal, expected do |expected|
        match do |actual|
          actual.equal?(expected)
        end
        
        failure_message_for_should do |actual|
          <<-MESSAGE

expected #{expected.inspect}
     got #{actual.inspect}
     
(compared using equal?)
MESSAGE
        end

        failure_message_for_should_not do |actual|
          <<-MESSAGE

expected #{actual.inspect} not to equal #{expected.inspect}

(compared using equal?)
MESSAGE
        end
      end
    end
  end
end
