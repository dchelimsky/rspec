require File.dirname(__FILE__) + '/../../../test_helper'
require 'spec/runner/collection_owner'

class ShouldHaveTest < Test::Unit::TestCase

  def setup
    @owner = CollectionOwner.new
  end

  def set_length(number)
    (1..number).each do |n|
      @owner.add_to_collection_with_length_method(n.to_s)
    end
  end
  
  def set_size(number)
    (1..number).each do |n|
      @owner.add_to_collection_with_size_method(n.to_s)
    end
  end
  
  def test_should_have_should_pass_if_responds_to_length_and_has_correct_number
    assert_nothing_raised do
      set_length 3
      @owner.should.have(3).items_in_collection_with_length_method   
    end
  end    
  
  def test_should_have_should_pass_if_responds_to_size_and_has_correct_number
    assert_nothing_raised do
      set_size 7
      @owner.should.have(7).items_in_collection_with_size_method   
    end
  end    
  
  def test_should_have_should_fail_if_responds_to_length_and_has_wrong_number
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      set_length 12
      @owner.should.have(17).items_in_collection_with_length_method   
    end
  end    
  
  def test_should_have_should_fail_if_responds_to_size_and_has_wrong_number
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      set_size 6
      @owner.should.have(2).items_in_collection_with_size_method   
    end
  end    

  # at.least w/ length

  def test_should_have_at_least_should_pass_if_responds_to_length_and_has_exact_number
    assert_nothing_raised do
      set_length 1
      @owner.should.have.at.least(1).items_in_collection_with_length_method   
    end
  end    

  def test_should_have_at_least_should_pass_if_responds_to_length_and_has_higher_number
    assert_nothing_raised do
      set_length 2
      @owner.should.have.at.least(1).items_in_collection_with_length_method   
    end
  end    

  def test_should_have_at_least_should_fail_if_responds_to_length_and_has_lower_number
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      set_length 1
      @owner.should.have.at.least(2).items_in_collection_with_length_method   
    end
  end    

  # at.least w/ size

  def test_should_have_at_least_should_pass_if_responds_to_size_and_has_exact_number
    assert_nothing_raised do
      set_size 1
      @owner.should.have.at.least(1).items_in_collection_with_size_method   
    end
  end    

  def test_should_have_at_least_should_pass_if_responds_to_size_and_has_higher_number
    assert_nothing_raised do
      set_size 2
      @owner.should.have.at.least(1).items_in_collection_with_size_method   
    end
  end    

  def test_should_have_at_least_should_fail_if_responds_to_size_and_has_lower_number
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      set_size 1
      @owner.should.have.at.least(2).items_in_collection_with_size_method   
    end
  end    
  
  # at.most w/ length

  def test_should_have_at_most_should_pass_if_responds_to_length_and_has_exact_number
    assert_nothing_raised do
      set_length 1
      @owner.should.have.at.most(1).items_in_collection_with_length_method   
    end
  end    

  def test_should_have_at_most_should_pass_if_responds_to_length_and_has_lower_number
    assert_nothing_raised do
      set_length 1
      @owner.should.have.at.most(2).items_in_collection_with_length_method   
    end
  end    

  def test_should_have_at_most_should_fail_if_responds_to_length_and_has_higher_number
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      set_length 2
      @owner.should.have.at.most(1).items_in_collection_with_length_method   
    end
  end    

  # at.most w/ size

  def test_should_have_at_most_should_pass_if_responds_to_size_and_has_exact_number
    assert_nothing_raised do
      set_size 1
      @owner.should.have.at.most(1).items_in_collection_with_size_method   
    end
  end    

  def test_should_have_at_most_should_pass_if_responds_to_size_and_has_lower_number
    assert_nothing_raised do
      set_size 1
      @owner.should.have.at.most(2).items_in_collection_with_size_method   
    end
  end    

  def test_should_have_at_most_should_fail_if_responds_to_size_and_has_higher_number
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      set_size 2
      @owner.should.have.at.most(1).items_in_collection_with_size_method   
    end
  end    
  
  def test_should_have_no_items_should_pass_if_has_zero_items
    assert_nothing_raised do
      set_length 0
      @owner.should.have(:no).items_in_collection_with_length_method
    end
  end
  
  def test_should_have_no_items_should_fail_if_has_one_item
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      set_length 1
      @owner.should.have(:no).items_in_collection_with_length_method
    end
  end

end