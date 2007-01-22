require 'spec/expectations/matchers/be'
require 'spec/expectations/matchers/be_close'
require 'spec/expectations/matchers/eql'
require 'spec/expectations/matchers/equal'
require 'spec/expectations/matchers/have'
require 'spec/expectations/matchers/include'
require 'spec/expectations/matchers/match'
require 'spec/expectations/matchers/satisfy'

module Spec
  module Expectations
    
    # == Expectation Matchers
    #
    # The Matchers module provides methods called "expectation matchers" that allow you
    # set expectations on objects using <code>should</code> and <code>should_not</code>.
    # For example, if you expect the value of an
    # object to be 37 after some calculation, you could say:
    #
    #   result.should equal(37)
    #   result.should_not equal(35)
    #
    # In this example, <code>should equal(37)</code> is an expectation, with <code>equal(37)</code>
    # being the expectation matcher.
    #
    # == How they work.
    #
    # RSpec adds two methods to Object:
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
    # When <code>should</code> receives a matcher, it calls <code>matches?(self)</code>. If
    # it returns <code>true</code>, the spec passes and execution continues. If it returns
    # <code>false</code>, then <code>should</code> raises an ExpectationNotMetError with
    # the message returned by <code>matcher.failure_message</code>
    #
    # Similarly, when <code>should_not</code> receives a matcher, it calls <code>matches?(self)</code>. If
    # it returns <code>false</code>, the spec passes and execution continues. If it returns
    # <code>true</code>, then <code>should_not</code> raises an ExpectationNotMetError with
    # the message returned by <code>matcher.negative_failure_message</code>
    #
    # == Custom Expectation Matchers
    #
    # A primary goal of RSpec is to provide a more "natural language" feel than you get
    # from standard xUnit tools like Test::Unit. When you find that none of the stock
    # expectation matchers provide a natural feeling expectation, you can very easily
    # write your own.
    #
    # For example, imagine that you are writing a game in which players can
    # be in various zones on a virtual board. To specify that bob should
    # be in zone 4, you could say:
    #
    #   bob.current_zone.should eql(Zone.new("4"))
    #
    # But you might find it more expressive to say:
    #
    #   bob.should be_in_zone("4")
    #
    # and/or
    #
    #   bob.should_not be_in_zone("3")
    #
    # To do this, you would need to write a class like this:
    #
    #   class BeInZone
    #     def initialize(expected)
    #       @expected = expected
    #     end
    #     def matches?(actual)
    #       @actual = actual
    #       bob.current_zone.eql?(Zone.new(@expected))
    #     end
    #     def failure_message
    #       "expected #{@actual.inspect} to be in Zone #{@expected}"
    #     end
    #     def negative_failure_message
    #       "expected #{@actual.inspect} not to be in Zone #{@expected}"
    #     end
    #   end
    #
    # And a with a method like this:
    #
    #   def be_in_zone(expected)
    #     BeInZone.new(expected)
    #   end
    #
    # And then expose the method to your specs. This is normally done
    # by including the method and the class in a module, which is then
    # included in your spec:
    #
    #   module CustomGameMatchers
    #     class BeInZone
    #       ...
    #     end
    #
    #     def be_in_zone(expected)
    #       ...
    #     end
    #   end
    #
    #   context "Player behaviour" do
    #     include CustomGameMatchers
    #     ...
    #   end
    module Matchers
      
      # Passes if actual and expected are the same object (object identity).
      #
      # See http://www.ruby-doc.org/core/classes/Object.html#M001057 for more information about equality in Ruby.
      #
      # == Examples
      #
      #   5.should equal(5) #Fixnums are equal
      #   "5".should_not equal("5") #Strings are not
      def equal(expected)
        Matchers::Equal.new(expected)
      end
      
      # Passes if actual and expected are of equal value, but not necessarily the same object.
      #
      # See http://www.ruby-doc.org/core/classes/Object.html#M001057 for more information about equality in Ruby.
      #
      # == Examples
      #
      #   5.should eql(5)
      #   5.should_not equal(3)
      def eql(expected)
        Matchers::Eql.new(expected)
      end
      
      # Passes if actual == expected +/- delta
      #
      # == Example
      #
      #   result.should be_close(3.0, 0.5)
      def be_close(expected, delta)
        Matchers::BeClose.new(expected, delta)
      end

      # Passes if actual owns a collection
      # which contains n elements
      #
      # == Example
      #
      #   # Passes if team.players.size == 11
      #   team.should have(11).players
      def have(n)
        Matchers::Have.new(n)
      end
      alias :have_exactly :have
    
      # Passes if actual owns a collection
      # which contains at least n elements
      #
      # == Example
      #
      #   # Passes if team.players.size >= 11
      #   team.should have_at_least(11).players
      def have_at_least(n)
        Matchers::Have.new(n, :at_least)
      end
    
      # Passes if actual owns a collection
      # which contains at most n elements
      #
      # == Example
      #
      #   # Passes if team.players.size <= 11
      #   team.should have_at_most(11).players
      def have_at_most(n)
        Matchers::Have.new(n, :at_most)
      end
      
      # Passes if actual includes expected. This works for
      # collections and Strings
      #
      # == Examples
      #
      #   [1,2,3].should include(3)
      #   [1,2,3].should_not include(4)
      #   "spread".should include("read")
      #   "spread".should_not include("red")
      def include(expected)
        Matchers::Include.new(expected)
      end
      
      # Given true, false, or nil, will pass if actual is
      # true, false or nil (respectively).
      #
      # Given a Symbol (:sym, *args), will send a message to actual
      # which is built from appending "?" to the Symbol
      #
      # == Examples 
      #
      #   result.should be(true)
      #   result.should be(false)
      #   result.should be(nil)
      #   result.should_not be(nil)
      #
      #   collection.should be(:empty) #passes if collection.empty?
      #   collection.should be(:old_enough, 16) #passes if collection.old_enough?(16)
      #   collection.should_not be(:empty) #passes unless collection.empty?
      #   collection.should_not be(:old_enough, 16) #passes unless collection.old_enough?(16)
      def be(expected, *args)
        Matchers::Be.new(expected, *args)
      end
      
      # Given a Regexp, passes if actual =~ regexp
      #
      # == Examples
      #
      #   email.should match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
      def match(regexp)
        Matchers::Match.new(regexp)
      end
      
      # Passes if the submitted block returns true. Yields actual to the
      # block.
      #
      # Generally speaking, this should be thought of as a last resort when
      # you can't find any other way to specify the behaviour you wish to
      # specify.
      #
      # If you do find yourself in such a situation, you could always write
      # a custom matcher, which would likely make your specs more expressive.
      #
      # == Examples
      #
      #   5.should satisfy { |n|
      #     n > 3
      #   }
      def satisfy(&block)
        Matchers::Satisfy.new(&block)
      end
      
      def method_missing(sym, *args, &block) # :nodoc:
        if sym.to_s[0..5] == "be_an_"
          remaining_sym = sym.to_s[6..-1].to_sym
          be(remaining_sym, *args)
        elsif sym.to_s[0..4] == "be_a_"
          remaining_sym = sym.to_s[5..-1].to_sym
          be(remaining_sym, *args)
        elsif sym.to_s[0..2] == "be_"
          remaining_sym = sym.to_s[3..-1].to_sym
          be(remaining_sym, *args)
        else
          super
        end
      end

    end
    
    class Matcher
      include Matchers
    end
  end      
end