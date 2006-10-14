require File.dirname(__FILE__) + '/../spec_helper.rb'

context "TestUnitApi" do
    setup do
        @an_int = 789
      
    end
    teardown do
      
    end
    specify "can be translated to rspec" do
        a_float=
        a_float=123.45
        a_nil=nil
        assert_pair(2)
        true.should_be(true)
        @an_int.should_not_be(nil)
        lambda do
          true
        end.should_be(true)
        lambda do
          true
        end.should_be(true)
        @an_int.should_equal(789)
        a_float.should_be_close(123.5, 0.1)
        @an_int.should_be_instance_of(Fixnum)
        @an_int.should_be_kind_of(Numeric)
        @an_int.to_s.should_match(/789/)
        a_nil.should_be(nil)
        @an_int.to_s.should_not_match(/7890/)
        @an_int.should_not_equal(780)
        @an_int.should_not_be(nil)
        a_float.should_not_be(@an_int)
        lambda do
          
            foo=1
          
        end.should_not_raise
        lambda do
          
            bar=2
          
        end.should_not_raise
        [2].each do |a|
          a.should_equal(2)
        end
        [0, 1, 2].each_with_index do |b, c|
          b.should_equal(c)
        end
        lambda do
          
            zip=3
          
        end.should_not_throw
        lambda do
          
            zap=4
          
        end.should_not_throw
        lambda do
          raise(NotImplementedError)
        end.should_raise(NotImplementedError)
        lambda do
          raise(NotImplementedError)
        end.should_raise(NotImplementedError)
        lambda do
          raise(NotImplementedError)
        end.should_raise(NotImplementedError)
        lambda do
          raise(NotImplementedError)
        end.should_raise(NotImplementedError)
        @an_int.should_respond_to(:to_f)
        a_float.should_be(a_float)
        lambda do
          throw(:foo)
        end.should_throw(:foo)
        lambda do
          throw(:foo)
        end.should_throw(:foo)
      
    end
    def assert_pair  (n)
      (n % 2).should_equal(0)
    end
  
end