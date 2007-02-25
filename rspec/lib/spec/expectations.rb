require 'spec/expectations/sugar'
require 'spec/expectations/errors'
require 'spec/expectations/extensions'
require 'spec/expectations/should'
require 'spec/expectations/handler'

module Spec
  
  # Spec::Expectations lets you set expectations on your objects.
  #
  #   result.should == 37
  #   team.should have(11).players_on_the_field
  #
  # == How Expectations work.
  #
  # Spec::Expectations adds two methods to Object:
  #
  #   should(matcher=nil)
  #   should_not(matcher=nil)
  #
  # Both methods take an optional expectation matcher. An expectation matcher is any object
  # that responds to the following methods:
  #
  #   matches?(actual)
  #   failure_message
  #   negative_failure_message
  #
  # When +should+ receives a matcher, it calls <tt>matches?(self)</tt>. If
  # it returns +true+, the spec passes and execution continues. If it returns
  # +false+, then +should+ raises a Spec::Expectations::ExpectationNotMetError with
  # the message returned by <tt>matcher.failure_message</tt>.
  #
  # Similarly, when +should_not+ receives a matcher, it calls <tt>matches?(self)</tt>. If
  # it returns +false+, the spec passes and execution continues. If it returns
  # +true+, then +should_not+ raises an ExpectationNotMetError with
  # the message returned by <tt>matcher.negative_failure_message</tt>.
  #
  # RSpec ships with a standard set of useful matchers, and writing your own
  # matchers is quite simple. See Spec::Matchers for details.
  #
  # == Predicates
  #
  # In addition to the matchers defined explicitly, RSpec will create custom matchers
  # on the fly for any arbitrary predicate, giving your specs a much more natural
  # language feel. 
  #
  # A Ruby predicate is a method that ends with a "?" and returns true or false.
  # Common examples are +empty?+, +nil?+, and +instance_of?+.
  #
  # All you need to do is write +should be_+ followed by the predicate without
  # the question mark, and RSpec will figure it out from there. For example:
  #
  #   [].should be_empty => collection.empty? #passes
  #   [].should_not be_empty => collection.empty? #fails
  #
  # In addtion to prefixing the predicate matchers with "be_", you can also use "be_a_"
  # and "be_an_", making your specs read much more naturally:
  #
  #   "a string".should be_an_instance_of(String) =>"a string".instance_of?(String) #passes
  #
  #   3.should be_a_kind_of(Fixnum) => 3.kind_of?(Numeric) #passes
  #   3.should be_a_kind_of(Numeric) => 3.kind_of?(Numeric) #passes
  #   3.should be_an_instance_of(Fixnum) => 3.instance_of?(Fixnum) #passes
  #   3.should_not be_instance_of(Numeric) => 3.instance_of?(Numeric) #fails
  #
  # RSpec will also create custom matchers for predicates like +has_key?+. To
  # use this feature, just state that the object should have_key(:key) and RSpec will
  # call has_key?(:key) on the target. For example:
  #
  #   {:a => "A"}.should have_key(:a) #passes
  #   {:a => "A"}.should have_key(:b) #fails
  #   [].should have_key(:b) #fails telling you that the target does not respond to has_key?
  #
  # You can use this feature to invoke any predicate that begins with "has", whether it is
  # part of the Ruby libraries (like +Hash#has_key?+) or a method you wrote on your own class.
  #
  module Expectations
    class << self
      attr_accessor :differ

      # raises a Spec::Expectations::ExpectationNotMetError with message
      #
      # When a differ has been assigned and fail_with is passed
      # <code>expected</code> and <code>target</code>, passes them
      # to the differ to append a diff message to the failure message.
      def fail_with(message, expected=nil, target=nil) # :nodoc:
        if Array === message && message.length == 3
          message, expected, target = message[0], message[1], message[2]
        end
        unless (differ.nil? || expected.nil? || target.nil?)
          if expected.is_a?(String)
            message << "\nDiff:" << self.differ.diff_as_string(target.to_s, expected)
          elsif !target.is_a?(Proc)
            message << "\nDiff:" << self.differ.diff_as_object(target, expected)
          end
        end
        Kernel::raise(Spec::Expectations::ExpectationNotMetError.new(message))
      end
    end
  end
end