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
      # See also Spec::DSL::ExampleGroup
      class ExampleGroup < TestCase
        remove_method :default_test if respond_to?(:default_test)
        extend Spec::DSL::ExampleGroupMethods
        include Spec::DSL::ExampleMethods
      end
    end
  end
end
