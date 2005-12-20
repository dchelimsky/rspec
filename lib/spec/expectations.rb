module Spec
  module ExpectationHelperMethods
    def should(message=nil)
      message ||= "Expectation not met."
      if (! yield)
        raise Spec::Exceptions::ExpectationNotMetError.new(message)
      end
    end
    
    def default_message(expectation, expected)
      "<#{self.inspect}:#{self.class}>\n#{expectation}:\n<#{expected.inspect}:#{expected.class}>"
    end
  end
  
  module ObjectExpectations
    include ExpectationHelperMethods

    def should_equal(expected, message=nil)
      message ||= default_message("should be equal to", expected)
      should(message) { self == expected }
    end

    def should_not_equal(expected, message=nil)
      message ||= default_message("should not be equal to", expected)
      should(message) { not self == expected }
    end

    def should_be_same_as(expected, message=nil)
      message ||= default_message("should be same as", expected)
      should(message) { self.equal?(expected) }
    end

    def should_not_be_same_as(expected, message=nil)
      message ||= default_message("should not be same as", expected)
      should(message) { not self.equal?(expected) }
    end

    def should_match(expected, message=nil)
      message ||= default_message("should match", expected)
      should(message) { self =~ expected }
    end

    def should_not_match(expected, message=nil)
      message ||= default_message("should not match", expected)
      should(message) { not self =~ expected }
    end

    def should_be_nil(message=nil)
      message ||= "<#{self}> should be nil"
      should(message) { self.nil? }
    end

    def should_not_be_nil(message=nil)
      message ||= "<#{self}> should not be nil"
      should(message) { not self.nil? }
    end

    def should_be_empty(message=nil)
      message ||= "<#{self.inspect}> should be empty"
      should(message) { self.empty? }
    end

    def should_not_be_empty(message=nil)
      message ||= "<#{self.inspect}> should not be empty"
      should(message) { not self.empty? }
    end

    def should_include(sub, message=nil)
      message ||= "<#{self.inspect}> should include <#{sub.inspect}>"
      should(message) { self.include? sub }
    end

    def should_not_include(sub, message=nil)
      message ||= "<#{self.inspect}> should not include <#{sub.inspect}>"
      should(message) { not self.include? sub }
    end
    
    def should_be_true(message=nil)
      message ||= "<#{self}> should be true"
      should(message) { self }
    end

    def should_be_false(message=nil)
      message ||= "<#{self}> should be false"
      should(message) { not self }
    end
    
    def should_raise(exception=Exception, message=nil)
      message ||= default_message("should raise", exception.class.to_s)
      should(message) do
        begin
          self.call
          false
        rescue exception
          true
        rescue
          false
        end
      end
    end
    
    def should_not_raise(exception=Exception, message=nil)
      message ||= default_message("should not raise", exception.class.to_s)
      should(message) do
        begin
          self.call
          true
        rescue exception
          false
        rescue
          true
        end
      end
    end
    
  end
end


class Object
  include Spec::ObjectExpectations
end
