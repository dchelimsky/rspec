require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Api
    class SweetenerTest < Test::Unit::TestCase
      
      def test_should_allow_undersored_shoulds_on_regular_objects
        1.should_equal 1
        lambda { 1.should_not_equal 1 }.should_raise
      end

      def test_should_allow_undersored_shoulds_on_mocks
        sweetened = Mock.new "sweetened"
        sweetened.should_receive :salt
        sweetened.salt
        sweetened.__verify
      end

    end
  end
end