require 'spec/expectations/matchers/be'
require 'spec/expectations/matchers/be_close'
require 'spec/expectations/matchers/change'
require 'spec/expectations/matchers/eql'
require 'spec/expectations/matchers/equal'
require 'spec/expectations/matchers/has'
require 'spec/expectations/matchers/have'
require 'spec/expectations/matchers/include'
require 'spec/expectations/matchers/match'
require 'spec/expectations/matchers/raise_error'
require 'spec/expectations/matchers/satisfy'
require 'spec/expectations/matchers/throw_symbol'

module Spec
  module Expectations
    
    # == Spec::Expectations::Matchers
    #
    # Spec::Expectations::Matchers provides methods called "expectation matchers" that allow you
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
    # == How Matchers work.
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
    # == Predicates
    #
    # In addition to the methods defined explicitly, RSpec will create custom matchers
    # on the fly for any arbitrary predicate, giving your specs a much more natural
    # language feel. 
    #
    # A Ruby predicate is a method that ends with a "?" and returns true or false.
    # Common examples are <code>empty?</code>, <code>nil?</code>, and <code>instance_of?</code>.
    #
    # All you need to do is write <code>should be_</code> followed by the predicate without
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
      #   "5".should_not equal("5") #Strings that look the same are not the same object
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
      #   5.should_not eql(3)
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
      
      # :call-seq:
      #   be_true
      #   be_false
      #   be_nil
      #   be_arbitrary_predicate(*args)
      #
      # Given true, false, or nil, will pass if actual is
      # true, false or nil (respectively).
      #
      # Predicates are any Ruby method that ends in a "?" and returns true or false.
      # Given be_ followed by arbitrary_predicate (without the "?"), RSpec will match
      # convert that into a query against the target object.
      #
      # The arbitrary_predicate feature will handle any predicate
      # prefixed with "be_an_" (e.g. be_an_instance_of), "be_a_" (e.g. be_a_kind_of)
      # or "be_" (e.g. be_empty), letting you choose the prefix that best suits the predicate.
      #
      # == Examples 
      #
      #   target.should be_true
      #   target.should be_false
      #   target.should be_nil
      #   target.should_not be_nil
      #
      #   collection.should be_empty #passes if target.empty?
      #   "this string".should be_an_intance_of(String)
      #
      #   target.should_not be_empty #passes unless target.empty?
      #   target.should_not be_old_enough(16) #passes unless target.old_enough?(16)
      def be(expected=nil, *args)
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
      
      # :call-seq:
      #   raise_error()
      #   raise_error(NamedError)
      #   raise_error(NamedError, String)
      #   raise_error(NamedError, Regexp)
      #
      # With no args, matches if any error is raised.
      # With a named error, matches only if that specific error is raised.
      # With a named error and messsage specified as a String, matches only if both match.
      # With a named error and messsage specified as a Regexp, matches only if both match.
      #
      # == Examples
      #
      #   lambda { do_something_risky }.should raise_error
      #   lambda { do_something_risky }.should raise_error(PoorRiskDecisionError)
      #   lambda { do_something_risky }.should raise_error(PoorRiskDecisionError, "that was too risky")
      #   lambda { do_something_risky }.should raise_error(PoorRiskDecisionError, /oo ri/)
      #
      #   lambda { do_something_risky }.should_not raise_error
      #   lambda { do_something_risky }.should_not raise_error(PoorRiskDecisionError)
      #   lambda { do_something_risky }.should_not raise_error(PoorRiskDecisionError, "that was too risky")
      #   lambda { do_something_risky }.should_not raise_error(PoorRiskDecisionError, /oo ri/)
      def raise_error(error=Exception, message=nil)
        Matchers::RaiseError.new(error, message)
      end
      
      # :call-seq:
      #   throw_symbol()
      #   throw_symbol(:sym)
      #
      # Given a Symbol argument, matches if a proc throws the specified Symbol.
      #
      # Given no argument, matches if a proc throws any Symbol.
      #
      # == Examples
      #
      #   lambda { do_something_risky }.should throw_symbol
      #   lambda { do_something_risky }.should throw_symbol(:that_was_risky)
      #
      #   lambda { do_something_risky }.should_not throw_symbol
      #   lambda { do_something_risky }.should_not throw_symbol(:that_was_risky)
      def throw_symbol(sym=nil)
        Matchers::ThrowSymbol.new(sym)
      end
      
      # :call-seq:
      #   change(receiver, message, &block)
      #   change(receiver, message, &block).by(value)
      #   change(receiver, message, &block).from(old).to(new)
      #
      # Allows you to specify that a Proc will cause some value to change.
      #
      # == Examples
      #
      #   lambda {
      #     team.add_player(player) 
      #   }.should change(roster, :count)
      #
      #   lambda {
      #     team.add_player(player) 
      #   }.should change(roster, :count).by(1)
      #
      #   string = "string"
      #   lambda {
      #     string.reverse
      #   }.should change{ string }.from("string").to("gnirts")
      #
      #   lambda {
      #     person.happy_birthday
      #   }.should change(person, :birthday).from(32).to(33)
      #       
      #   lambda {
      #     employee.develop_great_new_social_networking_app
      #   }.should change(employee, :title).from("Mail Clerk").to("CEO")
      #
      # Evaluates <code>receiver.message</code> or <code>block</code> before and
      # after it evaluates the c object (generated by the lambdas in the examples above).
      #
      # Then compares the values before and after the <code>receiver.message</code> and
      # evaluates the difference compared to the expected difference.
      def change(target=nil, message=nil, &block)
        Matchers::Change.new(target, message, &block)
      end
      
      def method_missing(sym, *args, &block) # :nodoc:
        prefixes = ["be_an_","be_a_","be_"].each do |prefix|
          return be(make_predicate(prefix, sym), *args) if starts_with(sym, prefix)
        end
        if starts_with(sym, "have_")
          return Matchers::Has.new("#{unprefix(sym, "have_")}", *args)
        end
        super
      end
      
      private
        def starts_with(sym, prefix)
          sym.to_s[0..(prefix.length - 1)] == prefix
        end
      
        def make_predicate(prefix, sym)
          "#{unprefix(sym, prefix)}?".to_sym
        end
        
        def unprefix(str, prefix)
          str.to_s.sub(prefix,"")
        end
    end
    
    class Matcher
      include Matchers
      
      def respond_to?(sym)
        if sym.to_s[0..2] == "be_"
          return true
        else
          super
        end
      end
    end
  end      
end