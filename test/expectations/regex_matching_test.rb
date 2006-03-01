require 'test/unit'

require 'spec'

class RegexMatchingTest < Test::Unit::TestCase

# should.match

  def test_should_match_should_not_raise_when_objects_match
    assert_nothing_raised do
      "hi aslak".should.match /aslak/
    end
  end

  def test_should_equal_should_raise_when_objects_do_not_match
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      "hi aslak".should.match /steve/
    end
  end

  # should.not.match

  def test_should_not_match_should_not_raise_when_objects_do_not_match
    assert_nothing_raised do
      "hi aslak".should.not.match /steve/
    end
  end

  def test_should_not_match_should_raise_when_objects_match
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      "hi aslak".should.not.match /aslak/
    end
  end
end
