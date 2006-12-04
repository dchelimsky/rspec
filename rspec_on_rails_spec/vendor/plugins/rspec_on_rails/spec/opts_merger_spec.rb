require File.dirname(__FILE__) + '/spec_helper'

context "Given an empty array, an OptsMerger" do
  setup do
    @merger = Spec::Rails::OptsMerger.new([])
  end
  specify "should return an empty hash on 'merge'" do
    @merger.merge(:key).should == {}
  end
end

context "Given a nil array, an OptsMerger" do
  setup do
    @merger = Spec::Rails::OptsMerger.new(nil)
  end
  specify "should create an empty hash on 'merge" do
    @merger.merge(:key).should == {}
  end
end

context "Given an array with only a hash, an OptsMerger" do
  setup do
    @merger = Spec::Rails::OptsMerger.new([{:a => :b, :c => :d}])
  end
  
  specify "should return an equivalent hash" do
    @merger.merge(:key).should == {:a => :b, :c => :d}
  end
end

context "Given an array with only a single String, an OptsMerger" do
  setup do
    @merger = Spec::Rails::OptsMerger.new(["value"])
  end
  
  specify "should return a hash with the submitted key and that String as its value on 'merge" do
    @merger.merge(:key).should == {:key => "value"}
  end
end

context "Given an array with String and a Hash, an OptsMerger" do
  setup do
    @original_array = ["value", {:a => :b}]
    @merger = Spec::Rails::OptsMerger.new(@original_array)
  end
  
  specify "should return the submitted hash with the submitted key added with the String as its value on 'merge" do
    @merger.merge(:key).should == {:key => "value", :a => :b}
  end
  
  specify "should not disturb the original Array as a side effect" do
    @merger.merge(:key)
    @original_array.should == ["value", {:a => :b}]
  end
end
