require 'test/unit'

class TestUnitApiTest < Test::Unit::TestCase

  def setup
    @an_int = 789
  end

  def teardown
  end

  def assert_pair(n)
    assert_equal 0, n%2
  end

  def test_can_be_translated_to_rspec
    a_float = 123.45
    a_nil = nil

    assert_pair(2)

    assert true
    assert_not_nil @an_int
    assert_block { true }
    assert_block do
      true
    end
    assert_equal     789  ,@an_int, "a message"
    assert_in_delta       123.5, a_float, 0.1, "a message"
    assert_instance_of    Fixnum, @an_int, "a message"
    assert_kind_of        Numeric, @an_int, "a message"
    assert_match     /789/  , @an_int.to_s
    assert_nil a_nil
    assert_no_match       /7890/, @an_int.to_s, "a message"
    assert_not_equal 780,      @an_int
    assert_not_nil        @an_int, "a message"
    assert_not_same       @an_int, a_float, "a message"
    assert_nothing_raised { foo = 1 }
    assert_nothing_raised do
      bar = 2
    end
    [2].each do |a|
      assert_equal 2, a
    end
    [0,1,2].each_with_index do |b, c|
      assert_equal c, b
    end
    assert_nothing_thrown { zip = 3 }
    assert_nothing_thrown do
      zap = 4
    end
    #assert_operator       object1, operator, object2, "a message"
    assert_raise(NotImplementedError){ raise NotImplementedError }
    assert_raise(NotImplementedError) do
      raise NotImplementedError
    end
    assert_raises(NotImplementedError){ raise NotImplementedError }
    assert_raises(NotImplementedError) do
      raise NotImplementedError
    end
    assert_respond_to @an_int, :to_f, "a message"
    assert_same             a_float, a_float, "a message"
    #assert_send send_array, "a message"
    assert_throws(:foo, "a message"){ throw :foo }
    assert_throws(:foo, "a message") do
      throw :foo
    end
  end

end
