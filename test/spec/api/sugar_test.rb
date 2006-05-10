require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Api
    class SugarTest < Test::Unit::TestCase
      
      def test_should_allow_underscored_shoulds_on_regular_objects
        1.should_equal 1
        lambda { 1.should_not_equal 1 }.should_raise
      end
      
      def test_should_allow_underscored_shoulds_on_mocks
        sweetener = Mock.new "sweetener"
        sweetener.should_receive(:natural?)
        sweetener.natural?
        sweetener.__verify
      end
      
      def test_should_allow_underscored_ats_on_mocks
        sweetener = Mock.new "sweetener"
        sweetener.should_receive(:natural?).at_least(:once)
        sweetener.natural?
        sweetener.__verify
      end
      
      def test_should_allow_underscored_ands_on_mocks
        sweetener = Mock.new "sweetener"
        sweetener.should_receive(:natural?).at_least(:once).and_return(true)
        natural = sweetener.natural?
        natural.should_be true
        sweetener.__verify
      end
      
      def test_should_allow_underscored_anys_on_mocks
        sweetener = Mock.new "sweetener"
        sweetener.should_receive(:natural?).any_number_of_times
        sweetener.natural?
        sweetener.__verify
      end

      def test_should_allow_underscored_anys_on_mocks
        sweetener = Mock.new "sweetener"
        sweetener.should_receive(:natural?).once_and_return(false)
        natural = sweetener.natural?
        natural.should_be false
        sweetener.__verify
      end

    end
  end
end