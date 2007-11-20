module Test
  module Unit
    class TestCase
      # This subclass of the standard Test::Unit::TestCase makes RSpec
      # available from within, so that you can do things like:
      #
      # class MyTest < Test::Unit::TestCase::ExampleGroup
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
      class ExampleGroup < TestCase
        remove_method :default_test if respond_to?(:default_test)
        extend Spec::Example::ExampleGroupMethods
        include Spec::Example::ExampleMethods

        def initialize(example) #:nodoc:
          @_example = example
          @_result = ::Test::Unit::TestResult.new
        end
      end
    end
  end
end
