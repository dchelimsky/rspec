require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "target.should have(n).items" do
  setup do
    @owner = Spec::Expectations::Helper::CollectionOwner.new
    (1..3).each do |n|
      @owner.add_to_collection_with_length_method(n)
      @owner.add_to_collection_with_size_method(n)
    end
  end

  specify "should pass if target has a collection of items with n members (using length)" do
    @owner.should have(3).items_in_collection_with_length_method
  end

  specify "should pass if target has a collection of items with n members (using size)" do
    @owner.should have(3).items_in_collection_with_size_method
  end

  specify "should fail if target has a collection of items < n members (using length)" do
    lambda {
      @owner.should have(4).items_in_collection_with_length_method
    }.should_fail_with "expected 4 items_in_collection_with_length_method, got 3"
  end

  specify "should fail if target has a collection of items < n members (using size)" do
    lambda {
      @owner.should have(4).items_in_collection_with_size_method
    }.should_fail_with "expected 4 items_in_collection_with_size_method, got 3"
  end

  specify "should fail if target has a collection of items > n members (using length)" do
    lambda {
      @owner.should have(2).items_in_collection_with_length_method
    }.should_fail_with "expected 2 items_in_collection_with_length_method, got 3"
  end

  specify "should fail if target has a collection of items > n members (using size)" do
    lambda {
      @owner.should have(2).items_in_collection_with_size_method
    }.should_fail_with "expected 2 items_in_collection_with_size_method, got 3"
  end
end

context "target.should have_exactly(n).items" do
  setup do
    @owner = Spec::Expectations::Helper::CollectionOwner.new
    (1..3).each do |n|
      @owner.add_to_collection_with_length_method(n)
      @owner.add_to_collection_with_size_method(n)
    end
  end

  specify "should pass if target has a collection of items with n members (using length)" do
    @owner.should have_exactly(3).items_in_collection_with_length_method
  end

  specify "should pass if target has a collection of items with n members (using size)" do
    @owner.should have_exactly(3).items_in_collection_with_size_method
  end

  specify "should fail if target has a collection of items < n members (using length)" do
    lambda {
      @owner.should have_exactly(4).items_in_collection_with_length_method
    }.should_fail_with "expected 4 items_in_collection_with_length_method, got 3"
  end

  specify "should fail if target has a collection of items < n members (using size)" do
    lambda {
      @owner.should have_exactly(4).items_in_collection_with_size_method
    }.should_fail_with "expected 4 items_in_collection_with_size_method, got 3"
  end

  specify "should fail if target has a collection of items > n members (using length)" do
    lambda {
      @owner.should have_exactly(2).items_in_collection_with_length_method
    }.should_fail_with "expected 2 items_in_collection_with_length_method, got 3"
  end

  specify "should fail if target has a collection of items > n members (using size)" do
    lambda {
      @owner.should have_exactly(2).items_in_collection_with_size_method
    }.should_fail_with "expected 2 items_in_collection_with_size_method, got 3"
  end
end

context "target.should have_at_least(n).items" do
  setup do
    @owner = Spec::Expectations::Helper::CollectionOwner.new
    (1..3).each do |n|
      @owner.add_to_collection_with_length_method(n)
      @owner.add_to_collection_with_size_method(n)
    end
  end

  specify "should pass if target has a collection of items with n members (using length)" do
    @owner.should have_at_least(3).items_in_collection_with_length_method
  end

  specify "should pass if target has a collection of items with n members (using size)" do
    @owner.should have_at_least(3).items_in_collection_with_size_method
  end

  specify "should fail if target has a collection of items < n members (using length)" do
    lambda {
      @owner.should have_at_least(4).items_in_collection_with_length_method
    }.should_fail_with "expected at least 4 items_in_collection_with_length_method, got 3"
  end

  specify "should fail if target has a collection of items < n members (using size)" do
    lambda {
      @owner.should have_at_least(4).items_in_collection_with_size_method
    }.should_fail_with "expected at least 4 items_in_collection_with_size_method, got 3"
  end

  specify "should pass if target has a collection of items > n members (using length)" do
    @owner.should have_at_least(2).items_in_collection_with_length_method
  end

  specify "should fail if target has a collection of items > n members (using size)" do
    @owner.should have_at_least(2).items_in_collection_with_size_method
  end
end

context "target.should have_at_most(n).items" do
  setup do
    @owner = Spec::Expectations::Helper::CollectionOwner.new
    (1..3).each do |n|
      @owner.add_to_collection_with_length_method(n)
      @owner.add_to_collection_with_size_method(n)
    end
  end

  specify "should pass if target has a collection of items with n members (using length)" do
    @owner.should have_at_most(3).items_in_collection_with_length_method
  end

  specify "should pass if target has a collection of items with n members (using size)" do
    @owner.should have_at_most(3).items_in_collection_with_size_method
  end

  specify "should pass if target has a collection of items < n members (using length)" do
    @owner.should have_at_most(4).items_in_collection_with_length_method
  end

  specify "should pass if target has a collection of items < n members (using size)" do
    @owner.should have_at_most(4).items_in_collection_with_size_method
  end

  specify "should fail if target has a collection of items > n members (using length)" do
    lambda {
      @owner.should have_at_most(2).items_in_collection_with_length_method
    }.should_fail_with "expected at most 2 items_in_collection_with_length_method, got 3"
  end

  specify "should fail if target has a collection of items > n members (using size)" do
    lambda {
      @owner.should have_at_most(2).items_in_collection_with_size_method
    }.should_fail_with "expected at most 2 items_in_collection_with_size_method, got 3"
  end
end
