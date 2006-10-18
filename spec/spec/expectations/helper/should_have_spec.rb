require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Expectations
module Helper
context "ShouldHave" do
    setup do
        @owner = CollectionOwner.new
        (1..3).each do |n|
            @owner.add_to_collection_with_length_method(n)
            @owner.add_to_collection_with_size_method(n)
          
        end
      
    end
    specify "should not raise when expecting actual length" do
        lambda do
            @owner.should_have(3).items_in_collection_with_length_method
            @owner.should_have_exactly(3).items_in_collection_with_length_method
          
        end.should_not_raise
      
    end
    specify "should not raise when expecting actual size" do
        lambda do
            @owner.should_have(3).items_in_collection_with_size_method
            @owner.should_have_exactly(3).items_in_collection_with_size_method
          
        end.should_not_raise
      
    end
    specify "should not raise when expecting actual size with args" do
        lambda do
            @owner.should_have(3).items_for("a")
            @owner.should_have_exactly(3).items_for("a")
            @owner.should_have(1).items_for("b")
            @owner.should_have_exactly(1).items_for("b")
          
        end.should_not_raise
      
    end
    specify "should raise when expecting less than actual length" do
        lambda do
          @owner.should_have(2).items_in_collection_with_length_method
        end.should_fail
      
    end
    specify "should raise when expecting less than actual length with exactly" do
        lambda do
          @owner.should_have_exactly(2).items_in_collection_with_length_method
        end.should_fail
      
    end
    specify "should raise when expecting less than actual size" do
        lambda do
          @owner.should_have(2).items_in_collection_with_size_method
        end.should_fail
      
    end
    specify "should raise when expecting more than actual length" do
        lambda do
          @owner.should_have(4).items_in_collection_with_length_method
        end.should_fail
      
    end
    specify "should raise when expecting more than actual size" do
        lambda do
          @owner.should_have(4).items_in_collection_with_size_method
        end.should_fail
      
    end
  
end
end
end
end