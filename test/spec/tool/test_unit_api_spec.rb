require 'spec'

module Spec
  module Tool
    context "TestUnitApi" do

      setup do
        @an_int = 789
      end

      teardown do
      end

      specify "Can be translated to rspec" do
        a_float = 123.45
        a_nil = nil

        @an_int.should_not_be nil
        lambda { true }.should_be true
        lambda do
          true
        end.should_be true
        @an_int.should_equal 789
        a_float.should_be_close 123.5, 0.1
        @an_int.should_be_instance_of Fixnum
        @an_int.should_be_kind_of Numeric
        @an_int.to_s.should_match /789/
        a_nil.should_be nil
        @an_int.to_s.should_not_match /7890/
        @an_int.should_not_equal 780
        @an_int.should_not_be nil
        a_float.should_not_be @an_int
        lambda { foo = 1 }.should_not_raise
        lambda do
          foo = 2
        end.should_not_raise
        lambda { foo = 3 }.should_not_throw
        lambda do
          foo = 4
        end.should_not_throw
        #assert_operator       object1, operator, object2, "a message"
        lambda { raise NotImplementedError }.should_raise NotImplementedError
        lambda do
          raise NotImplementedError
        end.should_raise NotImplementedError
        lambda { raise NotImplementedError }.should_raise NotImplementedError
        lambda do
          raise NotImplementedError
        end.should_raise NotImplementedError
        @an_int.should_respond_to :to_f
        a_float.should_be a_float
        #assert_send send_array, "a message"
        lambda { throw :foo }.should_throw :foo
        lambda do
          throw :foo
        end.should_throw :foo

      end
    end
  end
end