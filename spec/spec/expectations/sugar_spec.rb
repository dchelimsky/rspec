require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Expectations
    context "Sugar" do
      specify "is a kind of should work when failing" do
        n=10
        lambda do
          n.should_be_a_kind_of(Float)
        end.should_raise(Spec::Expectations::ExpectationNotMetError)
      end
    
      specify "is a kind of should work when passing" do
        n=10
        lambda do
          n.should_be_a_kind_of(Numeric)
        end.should_not_raise
      end

      specify "is an instance of should work when failing" do
        n=10
        lambda do
          n.should_be_an_instance_of(String)
        end.should_raise(Spec::Expectations::ExpectationNotMetError)
      end
    
      specify "is an instance of should work when passing" do
        n=10
        lambda do
          n.should_be_an_instance_of(Fixnum)
        end.should_not_raise
      end
    
      specify "should allow multi word predicates in failing specs" do
        subject=ClassWithMultiWordPredicate.new
        lambda do
          subject.should_not_be_multi_word_predicate
        end.should_raise(ExpectationNotMetError)
      end
    
      specify "should allow multi word predicates in passing specs" do
        subject=ClassWithMultiWordPredicate.new
        lambda do
          subject.should_be_multi_word_predicate
        end.should_not_raise
      end
    
      specify "should allow underscored ands on mocks" do
        sweetener = mock("sweetener")
        sweetener.should_receive(:natural?).at_least(:once).and_return(true)
        natural=sweetener.natural?
        natural.should_be(true)
      end
    
      specify "should allow underscored anys on mocks" do
        sweetener = mock("sweetener")
        sweetener.should_receive(:natural?).once.and_return(false)
        natural=sweetener.natural?
        natural.should_be(false)
      end

      specify "should allow underscored ats on mocks" do
        sweetener = mock("sweetener")
        sweetener.should_receive(:natural?).at_least(:once)
        sweetener.natural?
      end
    
      specify "should allow underscored shoulds on mocks" do
        sweetener = mock("sweetener")
        sweetener.should_receive(:natural?)
        sweetener.natural?
      end

      specify "should allow underscored shoulds on regular objects" do
        1.should_equal(1)
        lambda do
          1.should_not_equal(1)
        end.should_raise
      end
    end
  end
end