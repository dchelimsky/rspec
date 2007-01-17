require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module HaveSpecHelper
  def create_collection_owner_with(n)
    owner = Spec::Expectations::Helper::CollectionOwner.new
    (1..n).each do |n|
      owner.add_to_collection_with_length_method(n)
      owner.add_to_collection_with_size_method(n)
    end
    owner
  end
end

context "have(n).items" do
  include HaveSpecHelper

  specify "should pass if target has a collection of items with n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have(3).items_in_collection_with_length_method.met_by?(owner).should_be true
    have(3).items_in_collection_with_size_method.met_by?(owner).should_be true
  end

  specify "should handle :no" do
    #given
    owner = create_collection_owner_with(0)
    
    #then
    have(:no).items_in_collection_with_length_method.met_by?(owner).should_be true
    have(:no).items_in_collection_with_size_method.met_by?(owner).should_be true
  end

  specify "should fail if target has a collection of items with < n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have(4).items_in_collection_with_length_method.met_by?(owner).should_be false
    have(4).items_in_collection_with_size_method.met_by?(owner).should_be false
  end
  
  specify "should fail if target has a collection of items with > n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have(2).items_in_collection_with_length_method.met_by?(owner).should_be false
    have(2).items_in_collection_with_size_method.met_by?(owner).should_be false
  end
  
  specify "should provide failure messages" do
    #given
    owner = create_collection_owner_with(3)
    length_matcher = have(4).items_in_collection_with_length_method
    size_matcher = have(4).items_in_collection_with_size_method
    
    #when
    length_matcher.met_by?(owner)
    size_matcher.met_by?(owner)
    
    #then
    length_matcher.failure_message.should == "expected 4 items_in_collection_with_length_method, got 3"
    size_matcher.failure_message.should == "expected 4 items_in_collection_with_size_method, got 3"
  end
  
  specify "should provide negative failure messages" do
    #given
    owner = create_collection_owner_with(3)
    length_matcher = have(3).items_in_collection_with_length_method
    size_matcher = have(3).items_in_collection_with_size_method
    
    #when
    length_matcher.met_by?(owner)
    size_matcher.met_by?(owner)
    
    #then
    length_matcher.negative_failure_message.should == "expected not 3 items_in_collection_with_length_method, got 3"
    size_matcher.negative_failure_message.should == "expected not 3 items_in_collection_with_size_method, got 3"
  end
end

context "have_exactly(n).items" do
  include HaveSpecHelper

  specify "should pass if target has a collection of items with n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have_exactly(3).items_in_collection_with_length_method.met_by?(owner).should_be true
    have_exactly(3).items_in_collection_with_size_method.met_by?(owner).should_be true
  end

  specify "should fail if target has a collection of items with < n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have_exactly(4).items_in_collection_with_length_method.met_by?(owner).should_be false
    have_exactly(4).items_in_collection_with_size_method.met_by?(owner).should_be false
  end
  
  specify "should fail if target has a collection of items with > n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have_exactly(2).items_in_collection_with_length_method.met_by?(owner).should_be false
    have_exactly(2).items_in_collection_with_size_method.met_by?(owner).should_be false
  end
  
  specify "should provide failure messages" do
    #given
    owner = create_collection_owner_with(3)
    length_matcher = have_exactly(4).items_in_collection_with_length_method
    size_matcher = have_exactly(4).items_in_collection_with_size_method
    
    #when
    length_matcher.met_by?(owner)
    size_matcher.met_by?(owner)
    
    #then
    length_matcher.failure_message.should == "expected 4 items_in_collection_with_length_method, got 3"
    size_matcher.failure_message.should == "expected 4 items_in_collection_with_size_method, got 3"
  end
  
  specify "should provide negative failure messages" do
    #given
    owner = create_collection_owner_with(3)
    length_matcher = have_exactly(3).items_in_collection_with_length_method
    size_matcher = have_exactly(3).items_in_collection_with_size_method
    
    #when
    length_matcher.met_by?(owner)
    size_matcher.met_by?(owner)
    
    #then
    length_matcher.negative_failure_message.should == "expected not 3 items_in_collection_with_length_method, got 3"
    size_matcher.negative_failure_message.should == "expected not 3 items_in_collection_with_size_method, got 3"
  end
end

context "have_at_least(n).items" do
  include HaveSpecHelper

  specify "should pass if target has a collection of items with n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have_at_least(3).items_in_collection_with_length_method.met_by?(owner).should_be true
    have_at_least(3).items_in_collection_with_size_method.met_by?(owner).should_be true
  end

  specify "should fail if target has a collection of items with < n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have_at_least(4).items_in_collection_with_length_method.met_by?(owner).should_be false
    have_at_least(4).items_in_collection_with_size_method.met_by?(owner).should_be false
  end
  
  specify "should pass if target has a collection of items with > n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have_at_least(2).items_in_collection_with_length_method.met_by?(owner).should_be true
    have_at_least(2).items_in_collection_with_size_method.met_by?(owner).should_be true
  end
  
  specify "should provide failure messages" do
    #given
    owner = create_collection_owner_with(3)
    length_matcher = have_at_least(4).items_in_collection_with_length_method
    size_matcher = have_at_least(4).items_in_collection_with_size_method
    
    #when
    length_matcher.met_by?(owner)
    size_matcher.met_by?(owner)
    
    #then
    length_matcher.failure_message.should == "expected at least 4 items_in_collection_with_length_method, got 3"
    size_matcher.failure_message.should == "expected at least 4 items_in_collection_with_size_method, got 3"
  end
  
  specify "should provide educational negative failure messages" do
    #given
    owner = create_collection_owner_with(3)
    length_matcher = have_at_least(3).items_in_collection_with_length_method
    size_matcher = have_at_least(3).items_in_collection_with_size_method
    
    #when
    length_matcher.met_by?(owner)
    size_matcher.met_by?(owner)
    
    #then
    length_matcher.negative_failure_message.should == <<-EOF
Isn't life confusing enough?
Instead of having to figure out the meaning of this:
  should_not have_at_least(3).items_in_collection_with_length_method
We recommend that you use this instead:
  should have_at_most(2).items_in_collection_with_length_method
EOF

    size_matcher.negative_failure_message.should == <<-EOF
Isn't life confusing enough?
Instead of having to figure out the meaning of this:
  should_not have_at_least(3).items_in_collection_with_size_method
We recommend that you use this instead:
  should have_at_most(2).items_in_collection_with_size_method
EOF
  end
end

context "have_at_most(n).items" do
  include HaveSpecHelper

  specify "should pass if target has a collection of items with n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have_at_most(3).items_in_collection_with_length_method.met_by?(owner).should_be true
    have_at_most(3).items_in_collection_with_size_method.met_by?(owner).should_be true
  end

  specify "should pass if target has a collection of items with < n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have_at_most(4).items_in_collection_with_length_method.met_by?(owner).should_be true
    have_at_most(4).items_in_collection_with_size_method.met_by?(owner).should_be true
  end
  
  specify "should fail if target has a collection of items with > n members" do
    #given
    owner = create_collection_owner_with(3)
    
    #then
    have_at_most(2).items_in_collection_with_length_method.met_by?(owner).should_be false
    have_at_most(2).items_in_collection_with_size_method.met_by?(owner).should_be false
  end
  
  specify "should provide failure messages" do
    #given
    owner = create_collection_owner_with(3)
    length_matcher = have_at_most(4).items_in_collection_with_length_method
    size_matcher = have_at_most(4).items_in_collection_with_size_method
    
    #when
    length_matcher.met_by?(owner)
    size_matcher.met_by?(owner)
    
    #then
    length_matcher.failure_message.should == "expected at most 4 items_in_collection_with_length_method, got 3"
    size_matcher.failure_message.should == "expected at most 4 items_in_collection_with_size_method, got 3"
  end
  
  specify "should provide educational negative failure messages" do
    #given
    owner = create_collection_owner_with(3)
    length_matcher = have_at_most(3).items_in_collection_with_length_method
    size_matcher = have_at_most(3).items_in_collection_with_size_method
    
    #when
    length_matcher.met_by?(owner)
    size_matcher.met_by?(owner)
    
    #then
    length_matcher.negative_failure_message.should == <<-EOF
Isn't life confusing enough?
Instead of having to figure out the meaning of this:
  should_not have_at_most(3).items_in_collection_with_length_method
We recommend that you use this instead:
  should have_at_least(4).items_in_collection_with_length_method
EOF
    
    size_matcher.negative_failure_message.should == <<-EOF
Isn't life confusing enough?
Instead of having to figure out the meaning of this:
  should_not have_at_most(3).items_in_collection_with_size_method
We recommend that you use this instead:
  should have_at_least(4).items_in_collection_with_size_method
EOF
  end
end
