require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Api
    class DuckTypeTest < Test::Unit::TestCase
      
      def test_should_talk_like_something_with_one_message_specified
        duck_type = DuckType.new(:length)
        assert(duck_type.talks_like? [])
      end

      def test_should_talk_like_something_with_two_messages_specified
        duck_type = DuckType.new(:length, :empty?)
        assert(duck_type.talks_like? [])
      end

    end
  end
end