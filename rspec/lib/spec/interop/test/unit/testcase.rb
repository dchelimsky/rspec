require 'test/unit/testcase'

module Test
  module Unit
    # This extension of the standard Test::Unit::TestCase makes RSpec
    # available from within, so that you can do things like:
    #
    # require 'test/unit'
    # require 'spec'
    #
    # class MyTest < Test::Unit::TestCase
    #   it "should work with Test::Unit assertions" do
    #     assert_equal 4, 2+1
    #   end
    #
    #   def test_should_work_with_rspec_expectations
    #     (3+1).should == 5
    #   end
    # end
    #
    # See also Spec::Example::ExampleGroup
    class TestCase
      extend Spec::Example::ExampleGroupMethods
      include Spec::Example::ExampleMethods

      class << self
        def suite
          Test::Unit::TestSuiteAdapter.new(self)
        end

        def before_each_parts # :nodoc:
          if @before_each_parts.nil?
            @before_each_parts = []
            @before_each_parts << lambda do
              setup
            end
          end
          @before_each_parts
        end
      end
      
      def initialize(example) #:nodoc:
        @_example = example
        @_result = ::Test::Unit::TestResult.new
      end
      
      def run(ignore_this_argument=nil)
        super()
      end
    end
  end
end
