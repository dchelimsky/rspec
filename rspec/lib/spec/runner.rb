require 'spec/runner/configuration'
require 'spec/runner/formatter'
require 'spec/runner/behaviour_runner'
require 'spec/runner/option_parser'
require 'spec/runner/command_line'
require 'spec/runner/drb_command_line'
require 'spec/runner/backtrace_tweaker'
require 'spec/runner/reporter'
require 'spec/runner/extensions/object'
require 'spec/runner/extensions/kernel'
require 'spec/runner/spec_parser'

module Spec
  # == Behaviours and Examples
  # 
  # Rather than expressing examples in classes, RSpec uses a custom domain specific language to 
  # describe Behaviours and Examples of those behaviours.
  # 
  # A Behaviour is the equivalent of a fixture in xUnit-speak. It is a metaphor for the context
  # in which you will run your executable example - a set of known objects in a known starting state.
  # We begin be describing
  # 
  #   describe Account do
  # 
  #     setup do
  #       @account = Account.new
  #     end
  # 
  #     it "should have a balance of $0" do
  #       @account.balance.should == Money.new(0, :dollars)
  #     end
  # 
  #   end
  # 
  # We use the setup block to set up the Behaviour (given), and then the #it method to
  # hold the example code that expresses the event (when) and the expected outcome (then).
  # 
  # == Helper Methods
  # 
  # A primary goal of RSpec is to keep the examples clear. We therefore prefer
  # less indirection than you might see in xUnit examples and in well factored, DRY production code. We feel
  # that duplication is OK if removing it makes it harder to understand an example without
  # having to look elsewhere to understand its context.
  # 
  # That said, RSpec does support some level of encapsulating common code in helper
  # methods that can exist within a context or within an included module.
  # 
  # == Setup and Teardown
  # 
  # You can use setup, teardown, context_setup and context_teardown within a context:
  # 
  #   describe "..." do
  #     context_setup do
  #       ...
  #     end
  # 
  #     setup do
  #       ...
  #     end
  # 
  #     it "should do something" do
  #       ...
  #     end
  # 
  #     it "should do something else" do
  #       ...
  #     end
  # 
  #     teardown do
  #       ...
  #     end
  # 
  #     context_teardown do
  #       ...
  #     end
  # 
  #   end
  # 
  # The <tt>setup</tt> block will run before each of the examples, once for each example. Likewise,
  # the <tt>teardown</tt> block will run after each of the examples.
  # 
  # It is also possible to specify a <tt>context_setup</tt> and <tt>context_teardown</tt>
  # block that will run only once for each behaviour, respectively before the first <code>setup</code>
  # and after the last <code>teardown</code>. The use of these is generally discouraged, because it
  # introduces dependencies between the examples. Still, it might prove useful for very expensive operations
  # if you know what you are doing.
  # 
  # == Local helper methods
  # 
  # You can include local helper methods by simply expressing them within a context:
  # 
  #   context "..." do
  #   
  #     specify "..." do
  #       helper_method
  #     end
  # 
  #     def helper_method
  #       ...
  #     end
  # 
  #   end
  # 
  # == Included helper methods
  # 
  # You can include helper methods in multiple contexts by expressing them within
  # a module, and then including that module in your context:
  # 
  #   module AccountExampleHelperMethods
  #     def helper_method
  #       ...
  #     end
  #   end
  # 
  #   describe "A new account" do
  #     include AccountExampleHelperMethods
  #     setup do
  #       @account = Account.new
  #     end
  # 
  #     it "should have a balance of $0" do
  #       helper_method
  #       @account.balance.should eql(Money.new(0, :dollars))
  #     end
  #   end
  module Runner
    class << self
      def configuration
        @configuration ||= Configuration.new
      end
      def configure
        yield configuration
      end
    end
  end
end
