require 'spec/matchers/be'
require 'spec/matchers/be_close'
require 'spec/matchers/change'
require 'spec/matchers/eql'
require 'spec/matchers/equal'
require 'spec/matchers/has'
require 'spec/matchers/have'
require 'spec/matchers/include'
require 'spec/matchers/match'
require 'spec/matchers/raise_error'
require 'spec/matchers/respond_to'
require 'spec/matchers/satisfy'
require 'spec/matchers/throw_symbol'

module Spec

  # RSpec ships with a number of useful Expression Matchers. An Expression Matcher
  # is any object that responds to the following methods:
  #
  #   matches?(actual)
  #   failure_message
  #   negative_failure_message
  #
  # See Spec::Expectations and Spec::Mocks for documentation on how these are used in your specs.
  #
  # == Custom Expression Matchers
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
  # ... and a method like this:
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
    
    class << self
      callback_events :description_generated
      def generated_name=(name)
        notify_callbacks(:description_generated, name)
      end
    end

    def method_missing(sym, *args, &block) # :nodoc:
      return Matchers::Be.new(sym, *args) if sym.starts_with?("be_")
      return Matchers::Has.new(sym, *args) if sym.starts_with?("have_")
      super
    end

    deprecated do
      # This supports sugar delegating to Matchers
      class Matcher #:nodoc:
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
end