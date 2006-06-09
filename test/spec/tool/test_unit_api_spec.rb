module Spec
  module Tool
    context "TestUnitApi" do
      setup do
        @an_int = 789
      end

      teardown do
        nil
      end

      specify "can be translated to rspec" do
        a_float = 123.45
        a_nil = nil
        true.should_be true
        @an_int.should_not_be nil
        lambda {
          true 
        }.should_be true
        lambda {
          true
        }.should_be true
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
        lambda {
          foo = 1 
        }.should_not_raise
        lambda {
          bar = 2
        }.should_not_raise
        [2].each {|a|
          a.should_equal 2
        }
        [0,1,2].each_with_index {|b, c|
          b.should_equal c
        }
        lambda {
          zip = 3 
        }.should_not_throw
        lambda {
          zap = 4
        }.should_not_throw
        lambda {
          raise(NotImplementedError)
        }.should_raise(NotImplementedError)
        lambda {
          raise(NotImplementedError)
        }.should_raise(NotImplementedError)
        lambda {
          raise(NotImplementedError)
        }.should_raise(NotImplementedError)
        lambda {
          raise(NotImplementedError)
        }.should_raise(NotImplementedError)
        @an_int.should_respond_to :to_f
        a_float.should_be a_float
        lambda {
          throw(:foo) 
        }.should_throw(:foo)
        lambda {
          throw(:foo)
        }.should_throw(:foo)
      end

    end
  end
end